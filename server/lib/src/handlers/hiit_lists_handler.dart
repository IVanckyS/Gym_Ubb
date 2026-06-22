import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:uuid/uuid.dart';
import '../database/connection.dart';
import '../middleware/auth_middleware.dart';
import '../utils/response.dart';

final _uuid = Uuid();

Router get hiitListsHandler {
  final router = Router();

  router.get('/', _listLists);
  router.post('/', _createList);
  router.get('/<id>', _getList);
  router.patch('/<id>', _updateList);
  router.delete('/<id>', _deleteList);
  router.post('/<id>/exercises', _addExercise);
  router.delete('/<id>/exercises/<exId>', _removeExercise);

  return router;
}

// ── GET / ─────────────────────────────────────────────────────────────────────
Future<Response> _listLists(Request request) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final result = await db.execute(
    'SELECT id, name, exercises, created_at '
    'FROM hiit_lists '
    "WHERE user_id = '$userId'::uuid AND is_active = true "
    'ORDER BY created_at DESC',
  );

  final lists = result.map((r) {
    final m = r.toColumnMap();
    return {
      'id': m['id'].toString(),
      'name': m['name'],
      'exercises': m['exercises'],
      'createdAt': m['created_at']?.toString(),
    };
  }).toList();

  return jsonOk({'lists': lists});
}

// ── POST / ───────────────────────────────────────────────────────────────────
Future<Response> _createList(Request request) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;
  final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

  final name = body['name'] as String?;
  if (name == null || name.trim().isEmpty) return badRequest('name requerido');

  final exercises = body['exercises'] as List<dynamic>? ?? [];
  final id = _uuid.v4();
  final exercisesJson = jsonEncode(exercises);

  await db.execute(
    "INSERT INTO hiit_lists (id, user_id, name, exercises) "
    "VALUES ('$id'::uuid, '$userId'::uuid, \$1, \$2::jsonb)",
    parameters: [name.trim(), exercisesJson],
  );

  return jsonCreated({
    'id': id,
    'name': name.trim(),
    'exercises': exercises,
    'createdAt': DateTime.now().toUtc().toIso8601String(),
  });
}

// ── GET /:id ──────────────────────────────────────────────────────────────────
Future<Response> _getList(Request request, String id) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final result = await db.execute(
    'SELECT id, name, exercises, created_at '
    'FROM hiit_lists '
    "WHERE id = '$id'::uuid AND user_id = '$userId'::uuid AND is_active = true",
  );
  if (result.isEmpty) return notFound('Lista no encontrada');

  final m = result.first.toColumnMap();
  return jsonOk({
    'id': m['id'].toString(),
    'name': m['name'],
    'exercises': m['exercises'],
    'createdAt': m['created_at']?.toString(),
  });
}

// ── PATCH /:id ────────────────────────────────────────────────────────────────
Future<Response> _updateList(Request request, String id) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final ownerCheck = await db.execute(
    "SELECT id FROM hiit_lists "
    "WHERE id = '$id'::uuid AND user_id = '$userId'::uuid AND is_active = true",
  );
  if (ownerCheck.isEmpty) return notFound('Lista no encontrada');

  final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
  final sets = <String>[];
  final params = <dynamic>[];
  var i = 1;

  if (body.containsKey('name')) {
    final n = (body['name'] as String? ?? '').trim();
    if (n.isEmpty) return badRequest('name no puede estar vacío');
    sets.add('name = \$$i'); params.add(n); i++;
  }
  if (body.containsKey('exercises')) {
    sets.add('exercises = \$$i::jsonb');
    params.add(jsonEncode(body['exercises']));
    i++;
  }
  if (sets.isEmpty) return badRequest('Sin campos para actualizar');

  await db.execute(
    "UPDATE hiit_lists SET ${sets.join(', ')} WHERE id = '$id'::uuid",
    parameters: params,
  );

  return jsonOk({'updated': true});
}

// ── DELETE /:id ───────────────────────────────────────────────────────────────
Future<Response> _deleteList(Request request, String id) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final ownerCheck = await db.execute(
    "SELECT id FROM hiit_lists "
    "WHERE id = '$id'::uuid AND user_id = '$userId'::uuid AND is_active = true",
  );
  if (ownerCheck.isEmpty) return notFound('Lista no encontrada');

  await db.execute(
    "UPDATE hiit_lists SET is_active = false WHERE id = '$id'::uuid",
  );
  return jsonOk({'deleted': true});
}

// ── POST /:id/exercises ───────────────────────────────────────────────────────
Future<Response> _addExercise(Request request, String id) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;
  final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;

  final exerciseId = body['exerciseId'] as String?;
  final name = body['name'] as String?;
  final imageUrl = body['imageUrl'] as String?;

  if (exerciseId == null || name == null || name.trim().isEmpty) {
    return badRequest('exerciseId y name son requeridos');
  }

  final ownerCheck = await db.execute(
    "SELECT exercises FROM hiit_lists "
    "WHERE id = '$id'::uuid AND user_id = '$userId'::uuid AND is_active = true",
  );
  if (ownerCheck.isEmpty) return notFound('Lista no encontrada');

  final current = ownerCheck.first.toColumnMap()['exercises'];
  final exercises = (current is List ? List<dynamic>.from(current) : <dynamic>[]);

  final alreadyIn = exercises.any(
    (e) => e is Map && e['exerciseId'] == exerciseId,
  );
  if (alreadyIn) {
    return jsonOk({'added': false, 'message': 'Ya está en la lista', 'exercises': exercises});
  }

  exercises.add({
    'exerciseId': exerciseId,
    'name': name.trim(),
    if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
  });

  await db.execute(
    "UPDATE hiit_lists SET exercises = \$1::jsonb WHERE id = '$id'::uuid",
    parameters: [jsonEncode(exercises)],
  );

  return jsonOk({'added': true, 'exercises': exercises});
}

// ── DELETE /:id/exercises/:exId ───────────────────────────────────────────────
Future<Response> _removeExercise(
  Request request,
  String id,
  String exId,
) async {
  final claims = await requireAuth(request);
  final userId = claims['sub'] as String;

  final ownerCheck = await db.execute(
    "SELECT exercises FROM hiit_lists "
    "WHERE id = '$id'::uuid AND user_id = '$userId'::uuid AND is_active = true",
  );
  if (ownerCheck.isEmpty) return notFound('Lista no encontrada');

  final current = ownerCheck.first.toColumnMap()['exercises'];
  final exercises = (current is List ? List<dynamic>.from(current) : <dynamic>[]);
  final updated =
      exercises.where((e) => !(e is Map && e['exerciseId'] == exId)).toList();

  await db.execute(
    "UPDATE hiit_lists SET exercises = \$1::jsonb WHERE id = '$id'::uuid",
    parameters: [jsonEncode(updated)],
  );

  return jsonOk({'removed': true, 'exercises': updated});
}
