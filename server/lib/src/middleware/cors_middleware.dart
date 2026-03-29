import 'dart:io';
import 'package:shelf/shelf.dart';

/// Middleware CORS.
/// En producción solo permite el origen configurado en ALLOWED_ORIGIN.
/// En desarrollo permite cualquier origen (*).
Middleware corsMiddleware() {
  final allowedOrigin = Platform.environment['ALLOWED_ORIGIN'] ?? '*';
  final isProduction = Platform.environment['RUNMODE'] == 'production';

  final headers = {
    'Access-Control-Allow-Origin': isProduction ? allowedOrigin : '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Request-ID',
    'Access-Control-Max-Age': '86400', // caché preflight 24h
  };

  return (Handler inner) {
    return (Request request) async {
      // Preflight OPTIONS — responder directamente sin pasar al handler
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: headers);
      }

      final response = await inner(request);
      return response.change(headers: {...response.headers, ...headers});
    };
  };
}
