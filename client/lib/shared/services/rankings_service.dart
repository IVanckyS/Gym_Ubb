import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/utils/error_messages.dart';
import 'auth_service.dart';

class RankingsException implements AppException {
  @override
  final String message;
  RankingsException(this.message);
  @override
  String toString() => message;
}

class RankingsService {
  final AuthService _auth = AuthService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _auth.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _unwrap(http.Response res) {
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return (body['data'] ?? body) as Map<String, dynamic>;
    }
    final error = body['error'] as Map<String, dynamic>?;
    throw RankingsException(error?['message'] as String? ?? 'Error desconocido');
  }

  /// Ejercicios disponibles para ver rankings.
  Future<List<Map<String, dynamic>>> getExercises() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rankingsExercises}');
    final res = await http.get(uri, headers: await _authHeaders());
    final data = _unwrap(res);
    return (data['exercises'] as List).cast<Map<String, dynamic>>();
  }

  /// Tabla de líderes para un ejercicio y número de reps.
  Future<Map<String, dynamic>> getLeaderboard(
    String exerciseId, {
    int reps = 1,
    int limit = 50,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.rankingsLeaderboard(exerciseId)}',
    ).replace(queryParameters: {'reps': '$reps', 'limit': '$limit'});
    final res = await http.get(uri, headers: await _authHeaders());
    return _unwrap(res);
  }

  /// PRs pendientes de validación (admin).
  Future<List<Map<String, dynamic>>> getPending() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rankingsPending}');
    final res = await http.get(uri, headers: await _authHeaders());
    final data = _unwrap(res);
    return (data['records'] as List).cast<Map<String, dynamic>>();
  }

  /// Valida un PR (admin).
  Future<void> validateRecord(String recordId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rankingsValidate(recordId)}');
    final res = await http.post(uri, headers: await _authHeaders());
    _unwrap(res);
  }

  /// Rechaza y elimina un PR (admin).
  Future<void> rejectRecord(String recordId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.rankingsReject(recordId)}');
    final res = await http.delete(uri, headers: await _authHeaders());
    _unwrap(res);
  }

  /// Calcula puntos DOTS localmente — el estándar moderno de powerlifting
  /// (reemplazó a Wilks; usado por USPA, WRPF y OpenPowerlifting).
  /// [lifted] = total SBD en kg. [isMale] true = fórmula masculina.
  static double dots({
    required double lifted,
    required double bodyWeight,
    required bool isMale,
  }) {
    double a, b, c, d, e;

    if (isMale) {
      a = -0.0000010930;
      b = 0.0007391293;
      c = -0.1918759221;
      d = 24.0900756;
      e = -307.75076;
    } else {
      a = -0.0000010706;
      b = 0.0005158568;
      c = -0.1126655495;
      d = 13.6175032;
      e = -57.96288;
    }

    final bw = bodyWeight;
    final denom =
        a * bw * bw * bw * bw + b * bw * bw * bw + c * bw * bw + d * bw + e;

    if (denom <= 0) return 0;
    return lifted * 500 / denom;
  }
}
