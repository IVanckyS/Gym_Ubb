import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  // ── Tokens ──────────────────────────────────────────────────────────────────

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
  }

  // ── Login ────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final body = jsonDecode(res.body) as Map<String, dynamic>;

    if (res.statusCode == 200) {
      // El servidor puede devolver { data: { accessToken, refreshToken, user } }
      // o en formato plano { accessToken, refreshToken, user }
      final data = (body['data'] ?? body) as Map<String, dynamic>;
      await _saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return data['user'] as Map<String, dynamic>;
    }

    final error = body['error'] as Map<String, dynamic>?;
    throw AuthException(
      code: error?['code'] as String? ?? 'unknown',
      message: error?['message'] as String? ?? 'Error desconocido',
    );
  }

  // ── Logout ───────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final token = await getAccessToken();
    if (token != null) {
      await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }
    await clearTokens();
  }

  // ── Refresh ──────────────────────────────────────────────────────────────────

  Future<bool> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.refresh}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      await _saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return true;
    }

    await clearTokens();
    return false;
  }

  // ── Me ───────────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getMe() async {
    final token = await getAccessToken();
    if (token == null) return null;

    final res = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.me}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body['data']['user'] as Map<String, dynamic>;
    }

    if (res.statusCode == 401) {
      final refreshed = await refreshAccessToken();
      if (refreshed) return getMe();
    }

    return null;
  }

  // ── Validación email UBB ─────────────────────────────────────────────────────

  static bool isValidUbbEmail(String email) {
    final lower = email.toLowerCase().trim();
    return lower.endsWith('@alumnos.ubiobio.cl') ||
        lower.endsWith('@ubiobio.cl');
  }
}

class AuthException implements Exception {
  final String code;
  final String message;

  const AuthException({required this.code, required this.message});

  @override
  String toString() => message;
}
