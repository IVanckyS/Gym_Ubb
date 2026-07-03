import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import 'package:postgres/postgres.dart';
import '../database/connection.dart';
import '../middleware/auth_middleware.dart';
import '../utils/response.dart';

final _uuid = Uuid();

final _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);

bool _isValidUuid(String id) => _uuidRegExp.hasMatch(id);

Router get roleRequestsHandler {
  final router = Router();

  // POST /api/v1/role-requests — staff solicita rol professor
  router.post('/', _create);
  // GET /api/v1/role-requests/mine — última solicitud propia
  // (ruta estática ANTES que /<id>/... para evitar conflicto de ruteo)
  router.get('/mine', _mine);
  // GET /api/v1/role-requests?status= — listar (admin)
  router.get('/', _list);
  // POST /api/v1/role-requests/<id>/approve — admin
  router.post('/<id>/approve', _approve);
  // POST /api/v1/role-requests/<id>/reject — admin
  router.post('/<id>/reject', _reject);

  return router;
}

// ── Helpers ──────────────────────────────────────────────────────────────────

Map<String, dynamic> _requestToMap(Map<String, dynamic> r) => {
      'id': r['id'],
      'userId': r['user_id'],
      'userName': r['user_name'],
      'userEmail': r['user_email'],
      'justification': r['justification'],
      'status': r['status'],
      'reviewedBy': r['reviewed_by'],
      'reviewerName': r['reviewer_name'],
      'reviewComment': r['review_comment'],
      'createdAt': r['created_at']?.toString(),
      'reviewedAt': r['reviewed_at']?.toString(),
    };

const _selectBase = 'SELECT rr.*, u.name AS user_name, u.email AS user_email, '
    'rv.name AS reviewer_name '
    'FROM role_requests rr '
    'JOIN users u ON u.id = rr.user_id '
    'LEFT JOIN users rv ON rv.id = rr.reviewed_by ';

Future<Response> _fetchOne(String id) async {
  final result = await db.execute("$_selectBase WHERE rr.id = '$id'::uuid");
  if (result.isEmpty) return notFound('Solicitud no encontrada');
  return jsonOk({'request': _requestToMap(result.first.toColumnMap())});
}

/// Audit log de cambio de rol (nunca falla el request por un error de log).
Future<void> _auditRoleChanged({
  required String targetUserId,
  required String reviewerId,
}) async {
  try {
    await db.execute(
      Sql.named(
        'INSERT INTO security_audit_log (id, user_id, action, details) '
        "VALUES (@id, @userId, 'role_changed'::audit_action, @details::jsonb)",
      ),
      parameters: {
        'id': _uuid.v4(),
        'userId': targetUserId,
        'details': jsonEncode({
          'newRole': 'professor',
          'approvedBy': reviewerId,
          'via': 'role_request',
        }),
      },
    );
  } catch (e) {
    print('[AUDIT] Error registrando role_changed: $e');
  }
}

// ── Handlers ─────────────────────────────────────────────────────────────────

/// POST / — staff solicita el rol professor
Future<Response> _create(Request request) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;
  final role = claims['role'] as String? ?? 'student';

  if (role != 'staff') {
    return forbidden('Solo usuarios con rol Funcionario pueden solicitar el rol de profesor');
  }

  final body = await parseBody(request);
  final justification = (body['justification'] as String? ?? '').trim();
  if (justification.isEmpty) {
    return badRequest('La justificación es requerida');
  }

  final pending = await db.execute(
    "SELECT id FROM role_requests WHERE user_id = '$userId'::uuid AND status = 'pending'",
  );
  if (pending.isNotEmpty) {
    return conflict(
      'Ya tienes una solicitud pendiente de revisión',
      code: 'REQUEST_PENDING',
    );
  }

  final id = _uuid.v4();
  final justEsc = justification.replaceAll("'", "''");
  await db.execute(
    'INSERT INTO role_requests (id, user_id, justification) '
    "VALUES ('$id'::uuid, '$userId'::uuid, '$justEsc')",
  );

  final result = await db.execute("$_selectBase WHERE rr.id = '$id'::uuid");
  return jsonCreated({'request': _requestToMap(result.first.toColumnMap())});
}

/// GET /mine — última solicitud del usuario autenticado
Future<Response> _mine(Request request) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final result = await db.execute(
    "$_selectBase WHERE rr.user_id = '$userId'::uuid "
    'ORDER BY rr.created_at DESC LIMIT 1',
  );
  if (result.isEmpty) return jsonOk({'request': null});
  return jsonOk({'request': _requestToMap(result.first.toColumnMap())});
}

/// GET /?status= — listar solicitudes (admin)
Future<Response> _list(Request request) async {
  await requireRole(request, 'admin');

  final status = request.url.queryParameters['status'];
  final where =
      (status != null && ['pending', 'approved', 'rejected'].contains(status))
          ? "WHERE rr.status = '$status'"
          : '';

  final result = await db.execute(
    '$_selectBase $where ORDER BY rr.created_at DESC LIMIT 100',
  );
  final requests =
      result.map((r) => _requestToMap(r.toColumnMap())).toList();
  return jsonOk({'requests': requests});
}

/// POST /<id>/approve — admin: aprueba y promueve a professor
Future<Response> _approve(Request request, String id) async {
  final claims = await requireRole(request, 'admin');
  if (!_isValidUuid(id)) return badRequest('ID inválido');
  final reviewerId = claims['sub'] as String;

  final check = await db.execute(
    "SELECT user_id FROM role_requests WHERE id = '$id'::uuid AND status = 'pending'",
  );
  if (check.isEmpty) {
    return conflict(
      'Solicitud no encontrada o ya revisada',
      code: 'NOT_PENDING',
    );
  }
  final targetUserId = check.first.toColumnMap()['user_id'] as String;

  await db.execute(
    "UPDATE role_requests SET status = 'approved', "
    "reviewed_by = '$reviewerId'::uuid, reviewed_at = NOW() "
    "WHERE id = '$id'::uuid",
  );
  await db.execute(
    "UPDATE users SET role = 'professor'::user_role WHERE id = '$targetUserId'::uuid",
  );
  await _auditRoleChanged(targetUserId: targetUserId, reviewerId: reviewerId);

  return _fetchOne(id);
}

/// POST /<id>/reject — admin: rechaza con comentario opcional
Future<Response> _reject(Request request, String id) async {
  final claims = await requireRole(request, 'admin');
  if (!_isValidUuid(id)) return badRequest('ID inválido');
  final reviewerId = claims['sub'] as String;

  final body = await parseBody(request);
  final comment = (body['reviewComment'] as String? ?? '').trim();

  final check = await db.execute(
    "SELECT id FROM role_requests WHERE id = '$id'::uuid AND status = 'pending'",
  );
  if (check.isEmpty) {
    return conflict(
      'Solicitud no encontrada o ya revisada',
      code: 'NOT_PENDING',
    );
  }

  final commentSql =
      comment.isEmpty ? 'NULL' : "'${comment.replaceAll("'", "''")}'";
  await db.execute(
    "UPDATE role_requests SET status = 'rejected', "
    "reviewed_by = '$reviewerId'::uuid, reviewed_at = NOW(), "
    'review_comment = $commentSql '
    "WHERE id = '$id'::uuid",
  );

  return _fetchOne(id);
}
