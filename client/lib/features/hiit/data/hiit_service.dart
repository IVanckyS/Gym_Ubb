import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../shared/services/auth_service.dart';
import 'hiit_models.dart';

class HiitService {
  final _auth = AuthService();

  Future<Map<String, String>> _headers() async {
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
    throw Exception(error?['message'] as String? ?? 'Error desconocido');
  }

  String get _base => ApiConstants.baseUrl;

  Future<List<HiitWorkout>> listWorkouts({bool onlyPublic = false}) async {
    final suffix = onlyPublic ? '?public=true' : '';
    final res = await http.get(
      Uri.parse('$_base/api/v1/hiit/workouts$suffix'),
      headers: await _headers(),
    );
    final data = _unwrap(res);
    final list = data['workouts'] as List<dynamic>? ?? [];
    return list
        .map((e) => HiitWorkout.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<HiitWorkout> createWorkout({
    required String name,
    required HiitConfig config,
    bool isPublic = false,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/api/v1/hiit/workouts'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'mode': config.mode.apiValue,
        'config': config.toJson(),
        'isPublic': isPublic,
      }),
    );
    return HiitWorkout.fromJson(_unwrap(res));
  }

  Future<void> saveSession({
    required String name,
    required HiitConfig config,
    required int totalDurationSeconds,
    required int roundsCompleted,
    required DateTime startedAt,
    required DateTime endedAt,
    String? hiitWorkoutId,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'mode': config.mode.apiValue,
      'config': config.toJson(),
      'totalDurationSeconds': totalDurationSeconds,
      'roundsCompleted': roundsCompleted,
      'startedAt': startedAt.toUtc().toIso8601String(),
      'endedAt': endedAt.toUtc().toIso8601String(),
    };
    if (hiitWorkoutId != null) body['hiitWorkoutId'] = hiitWorkoutId;

    await http.post(
      Uri.parse('$_base/api/v1/hiit/sessions'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  Future<List<HiitSession>> listSessions({
    int limit = 20,
    int offset = 0,
  }) async {
    final res = await http.get(
      Uri.parse('$_base/api/v1/hiit/sessions?limit=$limit&offset=$offset'),
      headers: await _headers(),
    );
    final data = _unwrap(res);
    final list = data['sessions'] as List<dynamic>? ?? [];
    return list
        .map((e) => HiitSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── hiit_lists ───────────────────────────────────────────────────────────

  Future<List<HiitList>> listHiitLists() async {
    final res = await http.get(
      Uri.parse('$_base/api/v1/hiit-lists'),
      headers: await _headers(),
    );
    final data = _unwrap(res);
    final list = data['lists'] as List<dynamic>? ?? [];
    return list
        .map((e) => HiitList.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<HiitList> createHiitList(String name) async {
    final res = await http.post(
      Uri.parse('$_base/api/v1/hiit-lists'),
      headers: await _headers(),
      body: jsonEncode({'name': name}),
    );
    return HiitList.fromJson(_unwrap(res));
  }

  Future<HiitList> getHiitList(String listId) async {
    final res = await http.get(
      Uri.parse('$_base/api/v1/hiit-lists/$listId'),
      headers: await _headers(),
    );
    return HiitList.fromJson(_unwrap(res));
  }

  Future<void> renameHiitList(String listId, String name) async {
    final res = await http.patch(
      Uri.parse('$_base/api/v1/hiit-lists/$listId'),
      headers: await _headers(),
      body: jsonEncode({'name': name}),
    );
    _unwrap(res);
  }

  Future<void> deleteHiitList(String listId) async {
    final res = await http.delete(
      Uri.parse('$_base/api/v1/hiit-lists/$listId'),
      headers: await _headers(),
    );
    _unwrap(res);
  }

  Future<void> addExerciseToList(String listId, HiitExerciseRef exercise) async {
    final res = await http.post(
      Uri.parse('$_base/api/v1/hiit-lists/$listId/exercises'),
      headers: await _headers(),
      body: jsonEncode({
        'exerciseId': exercise.exerciseId,
        'name': exercise.name,
        if (exercise.imageUrl != null) 'imageUrl': exercise.imageUrl,
      }),
    );
    _unwrap(res);
  }

  Future<void> removeExerciseFromList(String listId, String exerciseId) async {
    final res = await http.delete(
      Uri.parse('$_base/api/v1/hiit-lists/$listId/exercises/$exerciseId'),
      headers: await _headers(),
    );
    _unwrap(res);
  }
}

final hiitService = HiitService();
