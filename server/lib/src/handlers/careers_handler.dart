import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/connection.dart';
import '../middleware/auth_middleware.dart';
import '../utils/response.dart';

Router get careersHandler {
  final router = Router();

  // GET  /api/v1/careers/listCareers   — lista carreras (autenticado)
  router.get('/listCareers', _listCareers);

  // POST /api/v1/careers/createCareer  — crear carrera (admin)
  router.post('/createCareer', _createCareer);

  // PATCH /api/v1/careers/updateCareer/<id> — renombrar (admin)
  router.patch('/updateCareer/<id>', _updateCareer);

  // DELETE /api/v1/careers/deleteCareer/<id> — desactivar (admin)
  router.delete('/deleteCareer/<id>', _deleteCareer);

  return router;
}

Map<String, dynamic> _careerToMap(Map<String, dynamic> row) => {
      'id': row['id'],
      'name': row['name'],
      'isActive': row['is_active'],
      'createdAt': row['created_at']?.toString(),
    };

Future<Response> _listCareers(Request request) async {
  await requireAuth(request);

  final onlyActive = request.url.queryParameters['active'] != 'false';
  final where = onlyActive ? 'WHERE is_active = true' : '';

  final result = await db.execute(
    'SELECT id, name, is_active, created_at FROM careers $where ORDER BY name ASC',
  );

  final careers = result.map((r) => _careerToMap(r.toColumnMap())).toList();
  return jsonOk({'careers': careers});
}

Future<Response> _createCareer(Request request) async {
  await requireRole(request, 'admin');

  final body = await parseBody(request);
  final name = (body['name'] as String? ?? '').trim();

  if (name.isEmpty) return badRequest('El nombre de la carrera es requerido');

  final existing = await db.execute(
    'SELECT id FROM careers WHERE LOWER(name) = LOWER(\$1)',
    parameters: [name],
  );
  if (existing.isNotEmpty) return conflict('Ya existe una carrera con ese nombre');

  final result = await db.execute(
    'INSERT INTO careers (name) VALUES (\$1) RETURNING id, name, is_active, created_at',
    parameters: [name],
  );

  return jsonCreated({'career': _careerToMap(result.first.toColumnMap())});
}

Future<Response> _updateCareer(Request request, String id) async {
  await requireRole(request, 'admin');

  final body = await parseBody(request);
  final name = (body['name'] as String? ?? '').trim();

  if (name.isEmpty) return badRequest('El nombre no puede estar vacío');

  final existing = await db.execute(
    "SELECT id FROM careers WHERE LOWER(name) = LOWER(\$1) AND id != '$id'::uuid",
    parameters: [name],
  );
  if (existing.isNotEmpty) return conflict('Ya existe una carrera con ese nombre');

  final result = await db.execute(
    "UPDATE careers SET name = \$1 WHERE id = '$id'::uuid "
    'RETURNING id, name, is_active, created_at',
    parameters: [name],
  );

  if (result.isEmpty) return notFound('Carrera no encontrada');
  return jsonOk({'career': _careerToMap(result.first.toColumnMap())});
}

Future<Response> _deleteCareer(Request request, String id) async {
  await requireRole(request, 'admin');

  // Desactivar en lugar de borrar para mantener integridad histórica
  final result = await db.execute(
    "UPDATE careers SET is_active = NOT is_active WHERE id = '$id'::uuid "
    'RETURNING id, name, is_active',
  );

  if (result.isEmpty) return notFound('Carrera no encontrada');

  final row = result.first.toColumnMap();
  final isActive = row['is_active'] as bool;
  return jsonOk({
    'career': _careerToMap(row),
    'message': isActive ? 'Carrera activada' : 'Carrera desactivada',
  });
}
