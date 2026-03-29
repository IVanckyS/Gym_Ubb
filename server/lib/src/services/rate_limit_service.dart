import '../database/redis_client.dart';

/// Ventana de tiempo para el rate limiting de auth: 15 minutos.
const _windowSeconds = 15 * 60; // 900 segundos

/// Máximo de intentos fallidos por IP en la ventana de tiempo.
const _maxAttempts = 5;

/// Prefijo de clave Redis para contadores de intentos fallidos.
const _prefix = 'rl:auth:';

/// Clave Redis para intentos fallidos de un IP específico.
String _key(String ip) => '$_prefix$ip';

/// Registra un intento fallido para la IP dada.
///
/// Retorna el número total de intentos fallidos en la ventana actual.
Future<int> recordFailedAttempt(String ip) async {
  final key = _key(ip);
  final count = await redisIncr(key);

  // Solo establecer TTL en el primer intento (para que la ventana
  // comience desde el primer fallo y no se renueve con cada intento).
  if (count == 1) {
    await redisExpire(key, _windowSeconds);
  }

  return count;
}

/// Verifica si la IP está bloqueada por exceso de intentos fallidos.
///
/// Retorna true si la IP debe ser rechazada (≥ _maxAttempts).
Future<bool> isRateLimited(String ip) async {
  final val = await redisGet(_key(ip));
  if (val == null) return false;
  final count = int.tryParse(val) ?? 0;
  return count >= _maxAttempts;
}

/// Elimina el contador de intentos fallidos para la IP (al hacer login exitoso).
Future<void> clearAttempts(String ip) async {
  await redisDel(_key(ip));
}

/// Retorna cuántos segundos quedan en el bloqueo de la IP.
/// Retorna 0 si no hay bloqueo activo.
Future<int> getBlockTtl(String ip) async {
  final result = await redis.send_object(['TTL', _key(ip)]);
  final ttl = result as int;
  return ttl < 0 ? 0 : ttl;
}
