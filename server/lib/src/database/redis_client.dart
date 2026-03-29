import 'dart:io';
import 'package:redis/redis.dart';

RedisConnection? _conn;
Command? _command;

/// Retorna el comando Redis activo.
/// Lanza [StateError] si no se llamó [initRedis] primero.
Command get redis {
  if (_command == null) {
    throw StateError('Redis no inicializado. Llama initRedis() primero.');
  }
  return _command!;
}

/// Inicializa la conexión a Redis usando variables de entorno.
/// Debe llamarse una vez al arrancar el servidor.
Future<void> initRedis() async {
  final host = Platform.environment['REDIS_HOST'] ?? 'localhost';
  final port = int.tryParse(Platform.environment['REDIS_PORT'] ?? '6379') ?? 6379;
  final password = Platform.environment['REDIS_PASSWORD'];

  _conn = RedisConnection();
  _command = await _conn!.connect(host, port);

  // Autenticar si hay contraseña configurada
  if (password != null && password.isNotEmpty) {
    final response = await _command!.send_object(['AUTH', password]);
    if (response != 'OK') {
      throw Exception('[Redis] Error de autenticación');
    }
  }

  // Verificar conexión
  final pong = await _command!.send_object(['PING']);
  if (pong != 'PONG') {
    throw Exception('[Redis] PING falló: $pong');
  }

  print('[Redis] Conectado a $host:$port');
}

/// Cierra la conexión Redis.
Future<void> closeRedis() async {
  await _conn?.close();
  _conn = null;
  _command = null;
  print('[Redis] Conexión cerrada');
}

// ---------------------------------------------------------------
// Helpers de alto nivel (se amplían en el módulo de auth)
// ---------------------------------------------------------------

/// Guarda un valor con TTL en segundos.
Future<void> redisSet(String key, String value, {int? ttlSeconds}) async {
  if (ttlSeconds != null) {
    await redis.send_object(['SET', key, value, 'EX', ttlSeconds]);
  } else {
    await redis.send_object(['SET', key, value]);
  }
}

/// Obtiene un valor. Retorna null si no existe o expiró.
Future<String?> redisGet(String key) async {
  final result = await redis.send_object(['GET', key]);
  return result as String?;
}

/// Elimina una clave.
Future<void> redisDel(String key) async {
  await redis.send_object(['DEL', key]);
}

/// Incrementa un contador. Útil para rate limiting.
/// Retorna el valor actual después del incremento.
Future<int> redisIncr(String key) async {
  final result = await redis.send_object(['INCR', key]);
  return result as int;
}

/// Establece el TTL de una clave existente (segundos).
Future<void> redisExpire(String key, int seconds) async {
  await redis.send_object(['EXPIRE', key, seconds]);
}
