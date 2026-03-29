import 'dart:convert';
import 'package:shelf/shelf.dart';

const _jsonHeaders = {'Content-Type': 'application/json; charset=utf-8'};

/// 200 OK con datos
Response jsonOk(dynamic data) => Response.ok(
  jsonEncode({'data': data, 'error': null}),
  headers: _jsonHeaders,
);

/// 201 Created con datos
Response jsonCreated(dynamic data) => Response(
  201,
  body: jsonEncode({'data': data, 'error': null}),
  headers: _jsonHeaders,
);

/// Error con código de estado HTTP personalizado
Response jsonError(int statusCode, String code, String message) => Response(
  statusCode,
  body: jsonEncode({
    'data': null,
    'error': {'code': code, 'message': message},
  }),
  headers: _jsonHeaders,
);

/// 400 Bad Request
Response badRequest(String message, {String code = 'BAD_REQUEST'}) =>
    jsonError(400, code, message);

/// 401 Unauthorized
Response unauthorized([String message = 'No autenticado']) =>
    jsonError(401, 'UNAUTHORIZED', message);

/// 403 Forbidden
Response forbidden([String message = 'Sin permisos para esta acción']) =>
    jsonError(403, 'FORBIDDEN', message);

/// 404 Not Found
Response notFound([String message = 'Recurso no encontrado']) =>
    jsonError(404, 'NOT_FOUND', message);

/// 409 Conflict
Response conflict(String message, {String code = 'CONFLICT'}) =>
    jsonError(409, code, message);

/// 429 Too Many Requests
Response tooManyRequests([String message = 'Demasiados intentos. Intenta más tarde.']) =>
    jsonError(429, 'RATE_LIMITED', message);

/// 500 Internal Server Error (sin exponer detalles en producción)
Response serverError([String message = 'Error interno del servidor']) =>
    jsonError(500, 'INTERNAL_ERROR', message);

/// Parsear body JSON de una request. Lanza FormatException si no es JSON válido.
Future<Map<String, dynamic>> parseBody(Request request) async {
  final body = await request.readAsString();
  if (body.isEmpty) return {};
  return jsonDecode(body) as Map<String, dynamic>;
}

/// Obtener campo requerido del body. Retorna null si no existe o está vacío.
T? getField<T>(Map<String, dynamic> body, String key) {
  final value = body[key];
  if (value == null) return null;
  if (value is T) return value;
  return null;
}
