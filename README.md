# GymUBB

App móvil institucional para el gimnasio de la Universidad del Bío-Bío. Permite a estudiantes, profesores y funcionarios gestionar rutinas, registrar sesiones de entrenamiento, consultar rankings, acceder a contenido educativo y mucho más.

Proyecto de titulación — Ingeniería en Ejecución en Computación e Informática, UBB.

---

## Tecnologías

| Capa | Tecnología | Versión |
|---|---|---|
| App móvil | Flutter (Android + iOS) | SDK ^3.11 |
| Backend API | Dart + Shelf | ^1.4.1 |
| Enrutamiento backend | shelf_router | ^1.1.4 |
| Base de datos | PostgreSQL | 16 |
| Caché / Blacklist / OTP | Redis | 7 |
| Storage de archivos | Cloudflare R2 | — |
| Contenedores | Docker + Docker Compose | — |
| Reverse proxy (prod) | Nginx | — |

---

## Arquitectura

### Estructura de carpetas

```
gym_ubb/
├── docker-compose.yml          ← Despliegue con .env (datos pre-cargados) — `docker compose up -d`
├── docker-compose.dev.yml      ← Desarrollo local (código en vivo)
├── docker-compose.prod.yml     ← Producción (Nginx + HTTPS)
├── .env.example                ← Plantilla de variables de entorno
│
├── server/
│   ├── bin/main.dart
│   └── lib/src/
│       ├── handlers/
│       │   ├── auth_handler.dart             ← login, logout, refresh, me, register OTP
│       │   ├── users_handler.dart            ← CRUD + /me + /me/stats + /me/preferences
│       │   ├── careers_handler.dart
│       │   ├── exercises_handler.dart        ← catálogo, filtros, subida de imagen
│       │   ├── routines_handler.dart         ← CRUD + días + copyRoutine + setDefault
│       │   ├── joint_exercises_handler.dart
│       │   ├── workout_handler.dart          ← sesión activa, logSet, finish, week-status, calendar
│       │   ├── history_handler.dart          ← progreso, récords, medidas corporales
│       │   ├── rankings_handler.dart         ← leaderboard, validación PRs
│       │   ├── articles_handler.dart         ← catálogo, favoritos, CRUD
│       │   ├── events_handler.dart           ← eventos, intereses, CRUD
│       │   ├── notifications_handler.dart    ← sistema, unread, marcar leída
│       │   ├── lift_submissions_handler.dart ← postulaciones, aprobar/rechazar
│       │   ├── role_requests_handler.dart    ← solicitudes de rol professor (staff → aprobación admin)
│       │   └── hiit_handler.dart             ← plantillas HIIT + sesiones completadas
│       ├── middleware/
│       │   ├── auth_middleware.dart
│       │   ├── cors_middleware.dart
│       │   └── security_headers_middleware.dart
│       ├── services/
│       │   ├── jwt_service.dart
│       │   ├── email_service.dart            ← envío OTP por SMTP (fallback a logs en dev)
│       │   ├── storage_service.dart          ← subida a Cloudflare R2 (fallback local /uploads)
│       │   ├── rate_limit_service.dart
│       │   └── recommendation_service.dart   ← sugerencia de peso/duración al iniciar sesión (con tests unitarios)
│       ├── database/
│       │   ├── connection.dart
│       │   ├── redis_client.dart
│       │   ├── schema.dart
│       │   └── seed.dart                     ← siembra inicial idempotente; preserva datos de usuario entre reinicios
│       ├── db/init/                          ← .sql que PostgreSQL carga en el primer arranque (datos del sistema)
│       └── utils/response.dart
│
└── client/
    └── lib/
        ├── core/
        │   ├── theme/app_theme.dart
        │   ├── router/app_router.dart
        │   ├── constants/
        │   └── widgets/                      ← FadeSlide, GymIcon, SectionBanner
        ├── shared/
        │   ├── providers/
        │   ├── services/
        │   └── widgets/main_shell.dart
        └── features/
            ├── auth/           ← login · register · verify_email
            ├── onboarding/     ← terms · notifications
            ├── home/
            ├── exercises/
            ├── routines/
            ├── workout/
            ├── hiit/           ← data · engine · presentation (5 modos)
            ├── history/
            ├── rankings/
            ├── education/
            ├── events/
            ├── notifications/
            ├── profile/
            └── admin/
```

---

## Flujo JWT y registro

- **accessToken** HS256: expira en 15 minutos
- **refreshToken** rotativo: expira en 30 días, almacenado en PostgreSQL
- **Logout**: jti añadido a blacklist Redis (TTL = tiempo restante del token)
- **Rate limiting**: 5 intentos login por IP cada 15 min (Redis)
- **OTP registro**: clave `reg:<email>` en Redis, TTL 600s, máximo 5 intentos

Flujo de registro:
1. POST `/auth/register/request` con email institucional (@ubiobio.cl / @alumnos.ubiobio.cl) → envía OTP al correo
2. POST `/auth/register/verify` con código 6 dígitos → crea usuario y retorna tokens JWT
3. Auto-login: el cliente guarda los tokens y navega directo al home

---

## Schema de base de datos

| Tabla | Descripción |
|---|---|
| `users` | Perfil, rol, datos físicos (peso, altura, nivel de entrenamiento), preferencias |
| `careers` | Carreras UBB (soft delete) |
| `refresh_tokens` | Rotación + cadena replaced_by |
| `exercises` | Catálogo muscular: grupo, dificultad, tipo (dinámico/isométrico/calistenia), is_rankeable |
| `routines` | Rutinas personales y públicas |
| `routine_days` | Días de una rutina |
| `routine_day_exercises` | Ejercicios por día con sets/reps/descanso + duration_seconds (isométricos) + target_weight_kg (peso objetivo) |
| `joint_exercises` | Ejercicios de articulaciones (8 familias) |
| `workout_sessions` | Sesiones activas e historial |
| `workout_sets` | Series completadas + objetivo planeado por serie (target_weight_kg / target_reps / target_duration_seconds) |
| `personal_records` | PR por usuario+ejercicio+reps + duration_seconds (isométricos) |
| `body_measurements` | Medidas corporales por fecha |
| `articles` | Artículos educativos con tags, image_url, bibliography, resources JSONB |
| `article_favorites` | Favoritos por usuario |
| `events` | Eventos UBB con image_url y end_date |
| `event_interests` | Intereses de usuarios en eventos |
| `app_notifications` | Notificaciones del sistema |
| `notification_reads` | Registro de lectura |
| `lift_submissions` | Postulaciones de récords (video, weight, reps, status) |
| `lift_submission_images` | Imágenes adicionales de postulaciones |
| `security_audit_log` | Auditoría de acciones sensibles |
| `hiit_workouts` | Plantillas HIIT (modo, config JSONB, owner) |
| `hiit_sessions` | Sesiones HIIT completadas (modo, rondas, duración) |
| `role_requests` | Solicitudes de rol professor de usuarios staff (justificación, status, revisor) |

---

## Roles y permisos

| Rol | Permisos |
|---|---|
| `student` | Catálogo, rutinas personales, sesiones, rankings, artículos, eventos |
| `professor` | Todo lo anterior + crear ejercicios, rutinas públicas, artículos y eventos. Se obtiene por solicitud aprobada por un admin |
| `staff` | Funcionario — igual que student; puede solicitar el rol professor |
| `admin` | Acceso total: usuarios, carreras, validación de récords y contenido |

---

## Módulos implementados

| Módulo | Backend | App |
|---|---|---|
| Autenticación: login, logout, refresh, /me | ✅ | ✅ |
| Registro con verificación OTP por email institucional | ✅ | ✅ |
| Onboarding legal (términos + notificaciones) | ✅ | ✅ |
| Admin: gestión de usuarios (CRUD + roles) | ✅ | ✅ |
| Admin: gestión de carreras | ✅ | ✅ |
| Catálogo ejercicios con filtros múltiples OR | ✅ | ✅ |
| Ejercicios: crear/editar con imagen y pasos | ✅ | ✅ |
| Ejercicios isométricos (badge, input duración seg) | ✅ | ✅ |
| Ejercicios de peso corporal / calistenia (badge teal, columna lastre) | ✅ | ✅ |
| Mapa corporal SVG interactivo (muscular + articular, 4 vistas) | — | ✅ |
| Ejercicios de articulaciones (8 familias) | ✅ | ✅ |
| Home / Dashboard (stats reales + mis marcas pinned) | ✅ | ✅ |
| Rutinas CRUD + wizard 3 pasos | ✅ | ✅ |
| Rutinas: copiar pública al espacio personal | ✅ | ✅ |
| Rutinas: marcar como por defecto | ✅ | ✅ |
| Rutinas: week-status (días completados/parciales) | ✅ | ✅ |
| Rutinas: adelantar / recuperar día | — | ✅ |
| Sesión activa (timer, series, timer descanso) | ✅ | ✅ |
| Sesión: sonidos countdown + columna lastre calistenia | — | ✅ |
| Resumen post-sesión | ✅ | ✅ |
| Historial de sesiones (paginado, lazy load) | ✅ | ✅ |
| Historial: gráfico progreso por ejercicio | ✅ | ✅ |
| Historial: medidas corporales CRUD | ✅ | ✅ |
| Historial: récords personales (mejor PR) | ✅ | ✅ |
| Historial: calendario mensual (completado/parcial/perdido/libre) | ✅ | ✅ |
| Exportar historial PDF (récords + medidas, respeta kg/lbs) | — | ✅ |
| Rankings: leaderboard por ejercicio/reps | ✅ | ✅ |
| Rankings: calculadora DOTS (total SBD) | — | ✅ |
| Rankings: postular levantamiento con video | ✅ | ✅ |
| Rankings: validación admin (aprobar/rechazar) | ✅ | ✅ |
| Educación: catálogo artículos, favoritos, crear | ✅ | ✅ |
| Eventos: listado, detalle, toggle interés, crear | ✅ | ✅ |
| Notificaciones: sistema + eventos + artículos (últimos 14 días) | ✅ | ✅ |
| Perfil: editar datos + preferencias | ✅ | ✅ |
| Perfil: tema claro/oscuro en tiempo real | — | ✅ |
| Perfil: unidades kg/lbs global | — | ✅ |
| Perfil: marcas pinned en inicio (hasta 4) | — | ✅ |
| **HIIT Timer: 5 modos (Tabata, EMOM, AMRAP, ForTime, MIX)** | ✅ | ✅ |
| HIIT: motor timer background-safe, ring con dots, colores por fase | — | ✅ |
| HIIT: catálogo de ejercicios con búsqueda y thumbnails en config | — | ✅ |
| HIIT: ForTime con avance manual + restBetweenRounds | — | ✅ |
| HIIT: guardar sesión automáticamente al completar | ✅ | ✅ |
| HIIT: pre-cargar ejercicio desde catálogo con botón "Agregar a HIIT" | — | ✅ |
| Roles: registro @ubiobio.cl como staff + solicitud de rol professor con aprobación admin | ✅ | ✅ |
| Perfil: nivel de entrenamiento (principiante/intermedio/avanzado) | ✅ | ✅ |
| Rutinas: peso objetivo editable por ejercicio en el wizard | ✅ | ✅ |
| Recomendación de peso/duración al iniciar sesión (rutina → historial → PR → estimado por nivel) | ✅ | ✅ |
| Sesión: objetivo esperado por serie + comparación esperado vs. real (✓/▼) | ✅ | ✅ |
| Resumen de sesión: % de cumplimiento del plan | ✅ | ✅ |
| Récords de calistenia (lastre) e isométrico (tiempo) en historial, home y perfil | ✅ | ✅ |
| Inicio: pull-to-refresh para recargar datos | — | ✅ |

---

## Puesta en marcha (desarrollo local)

### Requisitos previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) — incluye Docker Compose
- [Flutter SDK ≥ 3.11](https://docs.flutter.dev/get-started/install)
- Android Studio con un emulador configurado, **o** dispositivo físico Android con USB Debugging activo

---

### 1. Clonar el repositorio

```bash
git clone https://github.com/IVanckyS/Gym_Ubb.git
cd Gym_Ubb
```

---

### 2. Variables de entorno (`.env` requerido)

Copia la plantilla y complétala con tus valores:

```bash
cp .env.example .env
# Editar .env con tus valores (o reutilizar un .env existente)
```

El comando `docker compose up -d` **requiere** el archivo `.env`. Si falta, el arranque falla a propósito.

| Variable | Ejemplo / default | Necesaria para |
|---|---|---|
| `DB_*` | `gym_ubb_dev` / `gym_ubb_user` / `devpassword123` | Credenciales de PostgreSQL |
| `JWT_SECRET` | mínimo 32 chars | Firma de tokens (usar uno propio) |
| `RUNMODE` | `development` | Modo de ejecución |
| `SMTP_*` | vacío | Envío real de emails OTP (sin esto, el código va a los logs) |
| `R2_*` | vacío | Subir imágenes nuevas a Cloudflare (las imágenes ya cargadas se sirven desde URLs públicas, no requieren credenciales) |

> **Sin SMTP configurado:** el código OTP se imprime en los logs del servidor en lugar de enviarse por correo. Ver sección de logs más abajo.

---

### 3. Levantar todo con un comando

```bash
docker compose up -d
```

Esto levanta PostgreSQL, Redis y la API. **La primera vez** la base de datos se
pre-carga automáticamente con los datos del sistema (usuario administrador,
catálogo de ejercicios con imágenes, rankings e historial de ejemplo) desde
`server/db/init/`.

Verifica que el servidor esté listo:

```bash
curl http://localhost:8080/health
# Respuesta esperada: {"data":{"status":"ok",...}}
```

La primera vez tarda unos minutos en compilar la imagen del servidor. Los siguientes arranques son casi instantáneos.

> **Variantes de compose:**
> - `docker compose up -d` → despliegue estándar con `.env` (datos pre-cargados). **Usar este para la mayoría de los casos.**
> - `docker compose -f docker-compose.dev.yml up -d` → desarrollo con código en vivo (recarga al reiniciar el contenedor).
> - `docker compose -f docker-compose.prod.yml up -d` → producción tras Nginx + HTTPS.

---

### 4. Correr la app Flutter

#### Opción A — Emulador Android (Android Studio)

```bash
cd client
flutter run --dart-define=API_URL=http://10.0.2.2:8080
```

#### Opción B — Dispositivo físico por cable (USB)

```bash
cd client
adb reverse tcp:8080 tcp:8080
flutter run --dart-define=API_URL=http://localhost:8080
```

#### Opción C — Dispositivo físico por WiFi (Wireless Debugging)

> Requiere Android 11+ y que el teléfono esté en la misma red WiFi que el PC.

```bash
# 1. Agregar platform-tools al PATH (solo necesario en la sesión actual)
export PATH=$PATH:$HOME/Android/Sdk/platform-tools
# En Windows PowerShell:
# $env:PATH += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"

# 2. En el teléfono: Ajustes → Opciones del desarrollador → Wireless Debugging
#    → "Emparejar dispositivo con código" → anota IP:puerto y código PIN

adb pair 192.168.X.X:XXXXX   # ingresar el código PIN cuando lo pida

# 3. Conectar al puerto de depuración (distinto al de emparejamiento)
adb connect 192.168.X.X:YYYYY

# 4. Tunelizar el puerto del servidor al teléfono
adb -s 192.168.X.X:YYYYY reverse tcp:8080 tcp:8080

# 5. Correr la app
cd client
flutter run --dart-define=API_URL=http://localhost:8080 -d 192.168.X.X:YYYYY
```

---

### 5. Iniciar sesión

La base de datos viene pre-cargada con el catálogo de ejercicios (con imágenes),
rankings e historial de ejemplo, y usuarios de prueba. El administrador:

| Campo | Valor |
|---|---|
| Email | `admin@ubiobio.cl` |
| Contraseña | `Admin1234` |
| Rol | `admin` |

---

## Variables de entorno

Ver `.env.example` para la referencia completa con instrucciones de configuración SMTP (Gmail / Mailtrap).

---

## Comandos útiles

```bash
# Ver logs del servidor (útil para ver el código OTP cuando no hay SMTP)
docker compose logs -f server

# Reconstruir servidor tras cambios en el código
docker compose build --no-cache server
docker compose up -d server

# Reiniciar la base de datos desde cero (borra todo y vuelve a cargar los datos de server/db/init/)
docker compose down -v
docker compose up -d

# Consola PostgreSQL
docker exec -it gym_ubb-postgres-1 psql -U gym_ubb_user -d gym_ubb_dev
```

---

## Solución de problemas comunes

| Problema | Causa probable | Solución |
|---|---|---|
| `curl /health` no responde | Servidor aún iniciando | Esperar ~2 min la primera vez; ver logs |
| App no conecta en emulador | URL incorrecta | Usar `http://10.0.2.2:8080`, no `localhost` |
| App no conecta en dispositivo físico | Puerto no tunelizado | Ejecutar `adb reverse tcp:8080 tcp:8080` antes de `flutter run` |
| "Error de conexión" en login | Backend caído o Redis no listo | `docker compose -f docker-compose.dev.yml up -d` |
| Código OTP no llega al correo | SMTP no configurado | Normal — buscar el código en los logs del servidor |
| Imágenes de ejercicios no cargan | R2 no configurado | Normal — las imágenes usan almacenamiento local en `/uploads/` |

---

## API — Referencia rápida

Todas las respuestas: `{ "data": ..., "error": null }` o `{ "data": null, "error": { "code", "message" } }`

| Módulo | Endpoints principales |
|---|---|
| Auth | POST register/request · register/verify · login · logout · refresh · GET me |
| Usuarios | GET me/stats · PATCH me · me/preferences · CRUD admin |
| Ejercicios | GET listExercises · getExercise · byMuscleGroup · search · POST create · PATCH update · uploadImage |
| Articulaciones | GET list · get/:id · POST create · PATCH update · deactivate |
| Rutinas | GET listRoutines · myDefault · getRoutine · POST create · copyRoutine · PATCH setDefault · update · DELETE |
| Workout | POST start · logSet · PATCH finish · DELETE cancel · GET active · history · session · week-status · calendar |
| Historial | GET records · progress/:id · measurements · POST measurements · DELETE measurements/:id |
| Rankings | GET exercises · leaderboard/:id · pending · POST validate/:id · DELETE reject/:id |
| Artículos | GET list · favorites · get/:id · POST create · PATCH update · deactivate · POST :id/favorite |
| Eventos | GET list · my-interests · get/:id · POST create · PATCH update · deactivate · POST :id/interest |
| Notificaciones | GET list · unreadCount · PATCH read/:id · readAll · POST create |
| Lift submissions | POST / · GET / · /:id · POST /:id/approve · /:id/reject · GET rankings · records |
| Solicitudes de rol | POST / · GET mine · GET ?status= · POST /:id/approve · /:id/reject |
| **HIIT** | GET workouts · POST workouts · GET workouts/:id · PATCH workouts/:id · DELETE workouts/:id · POST sessions · GET sessions |

---

## Rutas Flutter

```
Sin shell (full-screen):
  /login  /register  /register/verify
  /onboarding/terms  /onboarding/notifications
  /workout/session  /workout/summary
  /hiit/session

Con shell (NavigationBar 5 tabs):
  /home
  /exercises  /exercises/:id
  /routines  /routines/create  /routines/:id  /routines/:id/edit
  /hiit  /hiit/config
  /workout/history
  /history
  /rankings  /rankings/postulate  /rankings/submission/:id
  /education  /education/:id
  /events  /events/:id
  /notifications
  /profile
  /admin/users  /admin/careers  /admin/role-requests   (guard: admin)
```

---

## Dependencias Flutter principales

| Paquete | Uso |
|---|---|
| `go_router` | Navegación declarativa + ShellRoute |
| `provider` | Estado global (Auth, Theme, WeightUnit, DefaultRoutine) |
| `flutter_secure_storage` | Tokens JWT |
| `flutter_svg` | Mapa corporal SVG interactivo |
| `webview_flutter` | Videos YouTube embed |
| `fl_chart` | Gráficos de progreso |
| `image_picker` | Subida de imágenes |
| `audioplayers` | Sonidos countdown timer |
| `wakelock_plus` | Pantalla encendida durante sesión HIIT |
| `cached_network_image` | Caché de imágenes de ejercicios |
| `pdf` + `printing` | Exportar historial PDF |
| `shared_preferences` | Onboarding, tema, unidades, pinned exercises |

---

## Seguridad

- JWT HS256: blacklist por `jti` en Redis al hacer logout
- OTP registro: 6 dígitos, TTL 600s, máx 5 intentos (Redis)
- Rotación refresh tokens + detección de reutilización
- Rate limiting login: 5 intentos/15 min por IP
- bcrypt cost 12 · Queries parametrizadas · Headers OWASP
- Audit log en `security_audit_log`
