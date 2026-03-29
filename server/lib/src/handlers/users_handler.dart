import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import '../database/connection.dart';
import '../middleware/auth_middleware.dart';
import '../utils/response.dart';

final _uuid = Uuid();

Router get usersHandler {
  final router = Router();

  // GET /api/v1/users/listUsers — lista todos los usuarios (solo admin)
  router.get('/listUsers', _listUsers);

  // GET /api/v1/users/getUser/<id> — detalle de un usuario (solo admin)
  router.get('/getUser/<id>', _getUser);

  // POST /api/v1/users/createUser — crear usuario (solo admin)
  router.post('/createUser', _createUser);

  // PATCH /api/v1/users/updateUser/<id> — editar nombre, rol, carrera (solo admin)
  router.patch('/updateUser/<id>', _updateUser);

  // PATCH /api/v1/users/deactivateUser/<id> — activar/desactivar (solo admin)
  router.patch('/deactivateUser/<id>', _deactivateUser);

  // PATCH /api/v1/users/resetPassword/<id> — resetear contraseña (solo admin)
  router.patch('/resetPassword/<id>', _resetPassword);

  return router;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Campos públicos de un usuario (nunca retornar password_hash)
Map<String, dynamic> _userToMap(Map<String, dynamic> row) => {
      'id': row['id'],
      'email': row['email'],
      'name': row['name'],
      'career': row['career'],
      'role': row['role'],
      'isActive': row['is_active'],
      'memberSince': row['member_since']?.toString(),
      'lastLoginAt': row['last_login_at']?.toString(),
      'createdAt': row['created_at']?.toString(),
    };

// ── Handlers ─────────────────────────────────────────────────────────────────

Future<Response> _listUsers(Request request) async {
  await requireRole(request, 'admin');

  final queryParams = request.url.queryParameters;
  final search = queryParams['search']?.trim() ?? '';
  final roleFilter = queryParams['role']?.trim() ?? '';
  final activeFilter = queryParams['active'];

  final conditions = <String>[];
  final params = <Object?>[];
  var paramIdx = 1;

  if (search.isNotEmpty) {
    conditions.add(
      '(LOWER(name) LIKE \$${paramIdx} OR LOWER(email) LIKE \$${paramIdx})',
    );
    params.add('%${search.toLowerCase()}%');
    paramIdx++;
  }

  if (roleFilter.isNotEmpty) {
    conditions.add('role::text = \$$paramIdx');
    params.add(roleFilter);
    paramIdx++;
  }

  if (activeFilter != null) {
    conditions.add('is_active = \$$paramIdx');
    params.add(activeFilter == 'true');
    paramIdx++;
  }

  final where = conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

  final result = await db.execute(
    'SELECT id, email, name, career, role::text AS role, '
    'is_active, member_since, last_login_at, created_at '
    'FROM users $where ORDER BY created_at DESC',
    parameters: params,
  );

  final users = result.map((row) => _userToMap(row.toColumnMap())).toList();
  return jsonOk({'users': users, 'total': users.length});
}

Future<Response> _getUser(Request request, String id) async {
  await requireRole(request, 'admin');

  final result = await db.execute(
    'SELECT id, email, name, career, role::text AS role, '
    'weight_kg, height_cm, body_fat_pct, units, '
    'notifications_enabled, private_profile, '
    'is_active, member_since, last_login_at, created_at '
    "FROM users WHERE id = '$id'::uuid",
  );

  if (result.isEmpty) return notFound('Usuario no encontrado');

  return jsonOk({'user': _userToMap(result.first.toColumnMap())});
}

Future<Response> _createUser(Request request) async {
  await requireRole(request, 'admin');

  final body = await parseBody(request);
  final email = (body['email'] as String? ?? '').trim().toLowerCase();
  final name = (body['name'] as String? ?? '').trim();
  final password = body['password'] as String? ?? '';
  final role = (body['role'] as String? ?? 'student').trim();
  final career = (body['career'] as String? ?? '').trim();

  if (email.isEmpty) return badRequest('El email es requerido');
  if (!email.endsWith('@alumnos.ubiobio.cl') && !email.endsWith('@ubiobio.cl')) {
    return badRequest('Solo se permiten correos @alumnos.ubiobio.cl o @ubiobio.cl');
  }
  if (name.isEmpty) return badRequest('El nombre es requerido');
  if (password.length < 6) return badRequest('La contraseña debe tener al menos 6 caracteres');

  final validRoles = ['student', 'professor', 'staff', 'admin'];
  if (!validRoles.contains(role)) {
    return badRequest('Rol inválido. Válidos: ${validRoles.join(', ')}');
  }

  // Verificar email único
  final existing = await db.execute(
    'SELECT id FROM users WHERE email = \$1',
    parameters: [email],
  );
  if (existing.isNotEmpty) return conflict('Ya existe un usuario con ese email');

  final hash = BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 12));
  final id = _uuid.v4();
  final careerVal = career.isEmpty ? 'NULL' : "'$career'";

  await db.execute(
    "INSERT INTO users (id, email, password_hash, name, career, role) "
    "VALUES ('$id'::uuid, \$1, \$2, \$3, $careerVal, '$role'::user_role)",
    parameters: [email, hash, name],
  );

  final created = await db.execute(
    'SELECT id, email, name, career, role::text AS role, '
    "is_active, member_since, created_at FROM users WHERE id = '$id'::uuid",
  );

  return jsonCreated({'user': _userToMap(created.first.toColumnMap())});
}

Future<Response> _updateUser(Request request, String id) async {
  await requireRole(request, 'admin');

  final body = await parseBody(request);

  if (!body.containsKey('name') && !body.containsKey('career') && !body.containsKey('role')) {
    return badRequest('No hay campos para actualizar');
  }

  // Construir SET clauses con valores embebidos para evitar bugs de postgres v3
  // name y career son input del usuario → siempre parametrizados
  // role es validado en el servidor → se puede embeber de forma segura
  final setClauses = <String>[];
  final params = <Object?>[];
  var idx = 1;

  if (body.containsKey('name')) {
    final name = (body['name'] as String? ?? '').trim();
    if (name.isEmpty) return badRequest('El nombre no puede estar vacío');
    setClauses.add('name = \$$idx');
    params.add(name);
    idx++;
  }

  if (body.containsKey('career')) {
    final career = body['career'];
    if (career == null) {
      setClauses.add('career = NULL');
    } else {
      setClauses.add('career = \$$idx');
      params.add(career.toString());
      idx++;
    }
  }

  if (body.containsKey('role')) {
    final role = (body['role'] as String? ?? '').trim();
    final validRoles = ['student', 'professor', 'staff', 'admin'];
    if (!validRoles.contains(role)) return badRequest('Rol inválido');
    setClauses.add("role = '$role'::user_role");
  }

  await db.execute(
    "UPDATE users SET ${setClauses.join(', ')}, updated_at = NOW() "
    "WHERE id = '$id'::uuid",
    parameters: params.isEmpty ? null : params,
  );

  final updated = await db.execute(
    'SELECT id, email, name, career, role::text AS role, '
    "is_active, member_since, last_login_at, created_at FROM users WHERE id = '$id'::uuid",
  );

  if (updated.isEmpty) return notFound('Usuario no encontrado');
  return jsonOk({'user': _userToMap(updated.first.toColumnMap())});
}

Future<Response> _deactivateUser(Request request, String id) async {
  final claims = await requireRole(request, 'admin');

  // No puede desactivarse a sí mismo
  if (claims['sub'] == id) {
    return badRequest('No puedes desactivarte a ti mismo');
  }

  final body = await parseBody(request);
  final active = body['isActive'] as bool? ?? false;

  await db.execute(
    "UPDATE users SET is_active = \$1, updated_at = NOW() WHERE id = '$id'::uuid",
    parameters: [active],
  );

  return jsonOk({'message': active ? 'Usuario activado' : 'Usuario desactivado'});
}

Future<Response> _resetPassword(Request request, String id) async {
  await requireRole(request, 'admin');

  final body = await parseBody(request);
  final newPassword = body['newPassword'] as String? ?? '';

  if (newPassword.length < 6) {
    return badRequest('La contraseña debe tener al menos 6 caracteres');
  }

  final hash = BCrypt.hashpw(newPassword, BCrypt.gensalt(logRounds: 12));

  await db.execute(
    "UPDATE users SET password_hash = \$1, updated_at = NOW() WHERE id = '$id'::uuid",
    parameters: [hash],
  );

  return jsonOk({'message': 'Contraseña actualizada'});
}
