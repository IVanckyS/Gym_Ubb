import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import 'auth_service.dart';

class CareersService {
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
    throw CareersException(error?['message'] as String? ?? 'Error desconocido');
  }

  String get _base => '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/careers';

  Future<List<Map<String, dynamic>>> listCareers({bool onlyActive = true}) async {
    final uri = Uri.parse('$_base/listCareers')
        .replace(queryParameters: onlyActive ? null : {'active': 'false'});
    final res = await http.get(uri, headers: await _authHeaders());
    final data = await _handleResponse(res);
    return (data['careers'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createCareer(String name) async {
    final res = await http.post(
      Uri.parse('$_base/createCareer'),
      headers: await _authHeaders(),
      body: jsonEncode({'name': name}),
    );
    final data = await _handleResponse(res);
    return data['career'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateCareer(String id, String name) async {
    final res = await http.patch(
      Uri.parse('$_base/updateCareer/$id'),
      headers: await _authHeaders(),
      body: jsonEncode({'name': name}),
    );
    final data = await _handleResponse(res);
    return data['career'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleCareer(String id) async {
    final res = await http.delete(
      Uri.parse('$_base/deleteCareer/$id'),
      headers: await _authHeaders(),
    );
    return await _handleResponse(res);
  }
}

class CareersException implements Exception {
  final String message;
  const CareersException(this.message);
  @override
  String toString() => message;
}
