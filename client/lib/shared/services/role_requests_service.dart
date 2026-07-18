import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/utils/error_messages.dart';
import 'auth_service.dart';

class RoleRequestsService {
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
    throw RoleRequestsException(
        error?['message'] as String? ?? 'Error desconocido');
  }

  String get _base =>
      '${ApiConstants.baseUrl}${ApiConstants.apiPrefix}/role-requests';

  /// Crea una solicitud de rol professor (solo staff).
  Future<Map<String, dynamic>> create(String justification) async {
    final res = await http.post(
      Uri.parse(_base),
      headers: await _authHeaders(),
      body: jsonEncode({'justification': justification}),
    );
    final data = await _handleResponse(res);
    return data['request'] as Map<String, dynamic>;
  }

  /// Última solicitud del usuario autenticado (null si nunca ha solicitado).
  Future<Map<String, dynamic>?> mine() async {
    final res =
        await http.get(Uri.parse('$_base/mine'), headers: await _authHeaders());
    final data = await _handleResponse(res);
    return data['request'] as Map<String, dynamic>?;
  }

  /// Lista solicitudes por estado (admin).
  Future<List<Map<String, dynamic>>> list({String status = 'pending'}) async {
    final uri = Uri.parse(_base).replace(queryParameters: {'status': status});
    final res = await http.get(uri, headers: await _authHeaders());
    final data = await _handleResponse(res);
    return (data['requests'] as List).cast<Map<String, dynamic>>();
  }

  /// Aprueba una solicitud (admin): promueve al usuario a professor.
  Future<Map<String, dynamic>> approve(String id) async {
    final res = await http.post(
      Uri.parse('$_base/$id/approve'),
      headers: await _authHeaders(),
    );
    final data = await _handleResponse(res);
    return data['request'] as Map<String, dynamic>;
  }

  /// Rechaza una solicitud (admin) con comentario opcional.
  Future<Map<String, dynamic>> reject(String id, {String? comment}) async {
    final res = await http.post(
      Uri.parse('$_base/$id/reject'),
      headers: await _authHeaders(),
      body: jsonEncode({
        if (comment != null && comment.isNotEmpty) 'reviewComment': comment,
      }),
    );
    final data = await _handleResponse(res);
    return data['request'] as Map<String, dynamic>;
  }
}

class RoleRequestsException implements AppException {
  @override
  final String message;
  const RoleRequestsException(this.message);
  @override
  String toString() => message;
}
