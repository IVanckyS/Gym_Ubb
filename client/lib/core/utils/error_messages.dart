import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Base común para excepciones de negocio cuyo [message] ya viene listo
/// para mostrarse al usuario (típicamente el mensaje que retorna el backend).
abstract class AppException implements Exception {
  String get message;
}

/// Excepción genérica de API para código que aún no tiene una excepción
/// tipada propia (p. ej. servicios pequeños que hacían `throw Exception(...)`).
class ApiException implements AppException {
  @override
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

final _random = Random();

String _pick(List<String> pool) => pool[_random.nextInt(pool.length)];

const _coachPrefixes = [
  'El coach dice:',
  'Aviso desde recepción:',
  'Palabras del entrenador:',
  'Desde la sala de máquinas:',
];

const _serverDownMessages = [
  'El admin olvidó su cinturón y el servidor no quiso levantar hoy. Intenta de nuevo en un momento.',
  'El servidor se fue por agua entre series. Vuelve a intentarlo en un rato.',
  'El servidor está en su descanso entre series. Dale unos segundos y reintenta.',
  'Parece que el servidor se saltó el calentamiento. Estamos en eso, intenta más tarde.',
];

const _noInternetMessages = [
  'Tu conexión no llegó a la última repetición. Revisa tu internet y vuelve a intentar.',
  'Tu señal se quedó sin energía a mitad de la serie. Revisa tu conexión e intenta de nuevo.',
];

const _fallbackMessages = [
  'Se nos cayó la barra con este error. Intenta de nuevo.',
  'Algo falló la técnica en esta repetición. Vuelve a intentarlo.',
];

/// true si [e] representa un error de red o de servidor caído/no alcanzable.
///
/// No importa dart:io (para mantener compatibilidad con Flutter Web); en su
/// lugar reconoce los mismos casos por el texto de [Object.toString].
bool isConnectionError(Object e) {
  if (e is http.ClientException || e is TimeoutException) return true;
  final s = e.toString();
  return s.contains('SocketException') ||
      s.contains('HandshakeException') ||
      s.contains('Connection refused') ||
      s.contains('Connection reset') ||
      s.contains('Failed host lookup') ||
      s.contains('Network is unreachable') ||
      s.contains('Connection timed out');
}

/// Convierte cualquier error en un mensaje apto para mostrar al usuario.
/// Nunca retorna texto técnico (stack traces, nombres de excepción, etc).
String humanizeError(Object e) {
  if (kDebugMode) debugPrint('[API error] $e');

  if (e is AppException) {
    return '${_pick(_coachPrefixes)} ${e.message}';
  }

  if (isConnectionError(e)) {
    final s = e.toString();
    if (s.contains('Connection refused') || s.contains('Connection reset')) {
      return _pick(_serverDownMessages);
    }
    if (s.contains('Failed host lookup') ||
        s.contains('Network is unreachable') ||
        s.contains('No address associated')) {
      return _pick(_noInternetMessages);
    }
    if (e is TimeoutException || s.contains('timed out')) {
      return 'El servidor está tardando más que una serie de peso muerto. Intenta de nuevo.';
    }
    return 'La conexión falló el levantamiento. Intenta de nuevo en un momento.';
  }

  if (e is FormatException) {
    // El server devolvió HTML (p. ej. un 502) en vez de JSON.
    return _pick(_serverDownMessages);
  }

  return _pick(_fallbackMessages);
}
