// ignore_for_file: do_not_use_environment

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080',
  );

  static const String apiPrefix = '/api/v1';

  // Auth
  static const String login = '$apiPrefix/auth/login';
  static const String register = '$apiPrefix/auth/register';
  static const String logout = '$apiPrefix/auth/logout';
  static const String refresh = '$apiPrefix/auth/refresh';
  static const String me = '$apiPrefix/auth/me';
}
