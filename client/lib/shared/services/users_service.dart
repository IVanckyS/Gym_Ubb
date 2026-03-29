import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'auth_service.dart';

class UsersService {
  final AuthService _auth = AuthService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _auth.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response res) async {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return (body['data'] ?? body) as Map<String, dynamic>;
    }
    final error = body['error'] as Map<String, dynamic>?;
    throw UsersException(error?['message'] as String? ?? 'Error desconocido');
  }

  Future<List<Map<String, dynamic>>> listUsers({
    String search = '',
    String role = '',
    bool? active,
  }) async {
    final params = <String, String>{};
    if (search.isNotEmpty) params['search'] = search;
    if (role.isNotEmpty) params['role'] = role;
    if (active != null) params['active'] = active.toString();

    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/users/listUsers')
        .replace(queryParameters: params.isEmpty ? null : params);

    final res = await http.get(uri, headers: await _authHeaders());
    final data = await _handleResponse(res);
    return (data['users'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createUser({
    required String email,
    required String name,
    required String password,
    required String role,
    String? career,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/users/createUser'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
        'role': role,
        if (career != null && career.isNotEmpty) 'career': career,
      }),
    );
    final data = await _handleResponse(res);
    return data['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateUser(
    String id, {
    String? name,
    String? career,
    String? role,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    body['career'] = career; // siempre enviado, null limpia la carrera
    if (role != null) body['role'] = role;

    final res = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/users/updateUser/$id'),
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );
    final data = await _handleResponse(res);
    return data['user'] as Map<String, dynamic>;
  }

  Future<void> setActive(String id, {required bool active}) async {
    final res = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/users/deactivateUser/$id'),
      headers: await _authHeaders(),
      body: jsonEncode({'isActive': active}),
    );
    await _handleResponse(res);
  }

  Future<void> resetPassword(String id, String newPassword) async {
    final res = await http.patch(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/users/resetPassword/$id'),
      headers: await _authHeaders(),
      body: jsonEncode({'newPassword': newPassword}),
    );
    await _handleResponse(res);
  }
}

class UsersException implements Exception {
  final String message;
  const UsersException(this.message);
  @override
  String toString() => message;
}
