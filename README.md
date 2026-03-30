# GymUBB

App móvil institucional para el gimnasio de la Universidad del Bío-Bío. Permite a estudiantes, profesores y funcionarios acceder al catálogo de ejercicios, gestionar rutinas de entrenamiento, registrar sesiones, consultar rankings y más.

Proyecto de titulación — Ingeniería en Ejecución en Computación e Informática, UBB.

---

## Tecnologías

| Capa | Tecnología | Versión |
|---|---|---|
| App móvil | Flutter (Android + iOS) | SDK ^3.11 |
| Backend API | Dart + Shelf | Shelf ^1.4.1 |
| Enrutamiento | shelf_router | ^1.1.4 |
| Base de datos | PostgreSQL | 16 |
| Caché / Blacklist tokens | Redis | 7 |
| Storage de archivos | Cloudflare R2 | — |
| Contenedores | Docker + Docker Compose | — |
| Reverse proxy (prod) | Nginx | — |

---

## Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                          │
│         (Android · iOS · potencialmente Web)            │
│                                                         │
│  features/auth  │  features/exercises  │  features/...  │
│        └──────────── HTTP + JWT ──────────────┘         │
└──────────────────────────┬──────────────────────────────┘
                           │ HTTPS (producción)
                           │ HTTP  (desarrollo local)
                    ┌──────▼──────┐
                    │    Nginx    │  ← reverse proxy (solo prod)
                    └──────┬──────┘
                           │
                    ┌──────▼──────────────────────┐
                    │   Dart / Shelf API           │
                    │   puerto 8080                │
                    │                              │
                    │  Pipeline de middleware:     │
                    │   CORS → Security Headers    │
                    │   → Auth exceptions → Router │
                    │                              │
                    │  /api/v1/auth                │
                    │  /api/v1/users               │
                    │  /api/v1/careers             │
                    │  /api/v1/exercises           │
                    │  /health                     │
                    └────┬──────────────┬──────────┘
                         │              │
              ┌──────────▼───┐   ┌──────▼──────┐
              │  PostgreSQL  │   │    Redis     │
              │  puerto 5432 │   │  puerto 6379 │
              │              │   │              │
              │  usuarios    │   │  blacklist   │
              │  ejercicios  │   │  JWT logout  │
              │  rutinas     │   │  rate limit  │
              │  sesiones    │   │  login       │
              │  rankings    │   └─────────────┘
              └──────────────┘
```

### Estructura de carpetas

```
gym_ubb/
├── docker-compose.yml          ← Producción
├── docker-compose.dev.yml      ← Desarrollo local
├── .env.example                ← Plantilla de variables de entorno
│
├── server/                     ← API Dart + Shelf
│   ├── bin/main.dart           ← Punto de entrada
│   ├── lib/src/
│   │   ├── handlers/           ← Un handler por módulo (auth, users, exercises…)
│   │   ├── middleware/         ← CORS, security headers, auth exceptions
│   │   ├── services/           ← jwt_service, rate_limit_service
│   │   ├── database/           ← connection.dart · schema.dart · seed.dart · redis_client.dart
│   │   └── utils/              ← response.dart (jsonOk / jsonError / jsonCreated)
│   └── migrations/             ← SQL por versión (001_init.sql, 002_seed_dev.sql…)
│
└── client/                     ← App Flutter
    └── lib/
        ├── core/
        │   ├── theme/          ← AppColors + AppTheme (tema oscuro)
        │   ├── router/         ← GoRouter + guards de autenticación
        │   └── constants/      ← api_constants.dart
        ├── shared/
        │   ├── providers/      ← AuthProvider (estado global)
        │   └── services/       ← Un service por módulo (HTTP client + JWT refresh)
        └── features/           ← Feature-first: una carpeta por módulo
            ├── auth/
            ├── admin/          ← users_screen · careers_screen
            └── exercises/      ← body_map · exercise_card · exercises_screen · detail
```

---

## Flujo de trabajo del stack

### 1. Autenticación

```
Flutter                        API                         Redis / PG
  │                             │                              │
  │── POST /api/v1/auth/login ──▶│                              │
  │   { email, password }       │── check rate limit ─────────▶│
  │                             │◀─ ok / blocked ──────────────│
  │                             │── verify bcrypt hash ────────▶│ (PG)
  │                             │◀─ user row ──────────────────│
  │                             │── store refresh token ───────▶│ (PG)
  │◀── { accessToken,           │                              │
  │      refreshToken, user } ──│                              │
  │                             │                              │
  │  (guarda tokens en          │                              │
  │   flutter_secure_storage)   │                              │
```

- **accessToken** JWT: expira en 15 minutos, firmado con HS256.
- **refreshToken** rotativo: expira en 30 días, hash almacenado en PostgreSQL.
- **Logout**: el refreshToken se revoca en PG y el accessToken se añade a la blacklist en Redis hasta su expiración.
- **Rate limiting**: máximo 5 intentos de login por IP cada 15 minutos (contador en Redis).

### 2. Request autenticado

```
Flutter                        API Middleware                  Handler
  │                             │                              │
  │── GET /api/v1/exercises ────▶│                              │
  │   Authorization: Bearer ... │                              │
  │                             │── verifica JWT               │
  │                             │── revocado en Redis?         │
  │                             │── rol suficiente?            │
  │                             │── inyecta userId en request ▶│
  │                             │                              │── SELECT PG
  │◀── { data: [...], error: null } ◀────────────────────────────│
```

### 3. Expiración y renovación de token

```
Flutter                        API
  │                             │
  │── cualquier request ────────▶│
  │◀── 401 Unauthorized ────────│  (accessToken expirado)
  │                             │
  │── POST /api/v1/auth/refresh ▶│
  │   { refreshToken }          │── valida en PG, rota token
  │◀── { accessToken,           │
  │      refreshToken } ────────│
  │                             │
  │── reintenta request original▶│
```

El `ApiService` del cliente maneja esto de forma transparente: intercepta el 401, refresca el token y reintenta la llamada original sin que el usuario lo note.

---

## Modelo de datos principal

```
users
 ├── id, email, password_hash, name, career
 ├── role: student | professor | staff | admin
 └── weight_kg, height_cm, body_fat_pct, units

exercises
 ├── id, name, muscle_group, difficulty
 ├── muscles[], instructions[], safety_notes, variations[]
 ├── video_url, equipment
 └── default_sets, default_reps, default_rest_seconds

refresh_tokens
 └── user_id, token_hash, expires_at, is_revoked, replaced_by

careers
 └── id, name, is_active
```

---

## Roles y permisos

| Rol | Permisos |
|---|---|
| `student` | Catálogo de ejercicios, rutinas personales, sesiones, rankings |
| `professor` | Todo lo anterior + crear rutinas generales y contenido educativo |
| `staff` | Mismo nivel que student |
| `admin` | Acceso total: gestión de usuarios, carreras, ejercicios y validación de récords |

---

## Módulos implementados

| Módulo | Backend | App |
|---|---|---|
| Autenticación (login, logout, refresh, /me) | ✅ | ✅ |
| Gestión de usuarios (CRUD + roles) | ✅ | ✅ |
| Gestión de carreras | ✅ | ✅ |
| Catálogo de ejercicios (filtros por grupo muscular y dificultad) | ✅ | ✅ |
| Mapa corporal interactivo | — | ✅ |
| Home / Dashboard | 🔲 | 🔲 |
| Rutinas de entrenamiento | 🔲 | 🔲 |
| Sesión activa (workout en vivo) | 🔲 | 🔲 |
| Historial y gráficos de progreso | 🔲 | 🔲 |
| Rankings y marcas personales | 🔲 | 🔲 |
| Perfil de usuario | 🔲 | 🔲 |

---

## Puesta en marcha (desarrollo local)

### Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.11)

### 1. Clonar y configurar variables de entorno

```bash
git clone https://github.com/IVanckyS/Gym_Ubb.git
cd Gym_Ubb
cp .env.example .env
# Editar .env si se desea cambiar las credenciales de desarrollo
```

### 2. Levantar backend (PostgreSQL + Redis + API)

```bash
docker compose -f docker-compose.dev.yml up -d
```

El servidor arranca en `http://localhost:8080` y crea el schema y los datos de prueba automáticamente.

Verificar que todo esté activo:

```bash
curl http://localhost:8080/health
```

### 3. Correr la app Flutter

```bash
cd client
flutter pub get
flutter run -d <device> --dart-define=API_URL=http://localhost:8080
```

Reemplazar `<device>` con el ID del emulador o dispositivo (`flutter devices` para listar).

### Credenciales de desarrollo

| Campo | Valor |
|---|---|
| Email | `admin@ubiobio.cl` |
| Contraseña | `Admin1234` |
| Rol | `admin` |

---

## Comandos útiles

```bash
# Ver logs del servidor en tiempo real
docker compose -f docker-compose.dev.yml logs -f server

# Reconstruir el servidor tras cambios en pubspec.yaml
docker compose -f docker-compose.dev.yml build --no-cache server
docker compose -f docker-compose.dev.yml up -d server

# Reiniciar la base de datos desde cero (borra todos los datos)
docker compose -f docker-compose.dev.yml down -v
docker compose -f docker-compose.dev.yml up -d

# Acceder a PostgreSQL directamente
docker exec -it gym_ubb-postgres-1 psql -U gym_ubb_user -d gym_ubb_dev

# Formato y análisis de código Dart
cd server && dart format . && dart analyze
cd client && dart format . && dart analyze
```


