import 'package:shelf/shelf.dart';
import '../services/jwt_service.dart';
import '../database/redis_client.dart';
import '../utils/response.dart';

/// Extrae el Bearer token del header Authorization.
/// Retorna null si no está presente o tiene formato incorrecto.
String? _extractBearer(Request request) {
  final header = request.headers['authorization'] ?? '';
  if (!header.startsWith('Bearer ')) return null;
  return header.substring(7).trim();
}

/// Clave Redis para tokens en blacklist (logout).
String _blacklistKey(String jti) => 'bl:$jti';

/// Lanza [UnauthorizedException] si el token no es válido o está en blacklist.
/// Añade los claims del token como context['claims'] al request.
///
/// Uso en handlers:
/// ```dart
/// final claims = await requireAuth(request);
/// final userId = claims['sub'] as String;
/// ```
Future<Map<String, dynamic>> requireAuth(Request request) async {
  final token = _extractBearer(request);
  if (token == null) {
    throw UnauthorizedException('Token de acceso requerido');
  }

  Map<String, dynamic> claims;
  try {
    claims = verifyToken(token);
  } catch (e) {
    throw UnauthorizedException('Token inválido o expirado');
  }

  // Verificar que sea un access token (no un refresh token usado como acceso)
  if (claims['type'] != 'access') {
    throw UnauthorizedException('Tipo de token incorrecto');
  }

  // Verificar que no esté en la blacklist (logout activo)
  final jti = claims['jti'] as String?;
  if (jti != null) {
    final blacklisted = await redisGet(_blacklistKey(jti));
    if (blacklisted != null) {
      throw UnauthorizedException('Token revocado. Inicia sesión nuevamente');
    }
  }

  return claims;
}

/// Verifica autenticación Y que el usuario tenga el rol requerido.
///
/// [allowedRoles] puede ser un único string o una lista de strings.
///
/// Uso:
/// ```dart
/// final claims = await requireRole(request, 'admin');
/// ```
Future<Map<String, dynamic>> requireRole(
  Request request,
  dynamic allowedRoles,
) async {
  final claims = await requireAuth(request);
  final userRole = claims['role'] as String?;

  final roles = allowedRoles is List<String>
      ? allowedRoles
      : [allowedRoles as String];

  if (userRole == null || !roles.contains(userRole)) {
    throw ForbiddenException(
      'Rol requerido: ${roles.join(' o ')}. Tu rol: ${userRole ?? 'desconocido'}',
    );
  }

  return claims;
}

/// Agrega un access token a la blacklist Redis hasta que expire.
/// [expiresAt] es el Unix timestamp de expiración del token.
Future<void> blacklistToken(String jti, int expiresAt) async {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final ttl = expiresAt - now;
  if (ttl > 0) {
    await redisSet(_blacklistKey(jti), '1', ttlSeconds: ttl);
  }
}

// ── Excepciones tipadas ──────────────────────────────────────────────────────

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException(this.message);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Middleware Shelf que captura [UnauthorizedException] y [ForbiddenException]
/// y los convierte en respuestas HTTP 401/403 apropiadas.
///
/// Usar en el Pipeline antes de los handlers:
/// ```dart
/// Pipeline().addMiddleware(authExceptionMiddleware())
/// ```
Middleware authExceptionMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      try {
        return await inner(request);
      } on UnauthorizedException catch (e) {
        return unauthorized(e.message);
      } on ForbiddenException catch (e) {
        return forbidden(e.message);
      }
    };
  };
}
