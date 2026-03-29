import 'dart:io';
import 'package:shelf/shelf.dart';

/// Middleware que agrega headers de seguridad a todas las respuestas.
/// Referencia: OWASP Secure Headers Project
Middleware securityHeadersMiddleware() {
  final isProduction = Platform.environment['RUNMODE'] == 'production';

  return (Handler inner) {
    return (Request request) async {
      final response = await inner(request);

      final secHeaders = <String, String>{
        // Evita que el navegador infiera el tipo MIME
        'X-Content-Type-Options': 'nosniff',
        // Previene clickjacking
        'X-Frame-Options': 'DENY',
        // Deshabilita XSS auditor legacy (reemplazado por CSP)
        'X-XSS-Protection': '0',
        // No enviar Referer a otros dominios
        'Referrer-Policy': 'strict-origin-when-cross-origin',
        // Sin cache para respuestas de la API
        'Cache-Control': 'no-store',
        // Solo HTTPS en producción
        if (isProduction)
          'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
        // Restricción de funcionalidades del navegador
        'Permissions-Policy': 'geolocation=(), camera=(), microphone=()',
      };

      return response.change(headers: {...response.headers, ...secHeaders});
    };
  };
}
