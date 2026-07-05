import '../database/connection.dart';

/// Sugerencia de peso/reps para un ejercicio dinámico al iniciar una sesión.
class WeightSuggestion {
  const WeightSuggestion({
    required this.weightKg,
    required this.reps,
    required this.source,
    this.lastSession,
  });

  /// Peso sugerido en kg. Puede ser null si no hay suficiente información
  /// (sin historial, sin PR, sin peso corporal y equipamiento desconocido).
  final double? weightKg;

  /// Repeticiones sugeridas (siempre el piso del rango de la rutina).
  final int? reps;

  /// 'rutina' | 'historial' | 'pr' | 'estimado'
  final String source;

  /// Presente solo cuando source == 'historial'.
  final Map<String, dynamic>? lastSession;

  Map<String, dynamic> toMap() => {
        'weightKg': weightKg,
        'reps': reps,
        'source': source,
        if (lastSession != null) 'lastSession': lastSession,
      };
}

/// Set completado de una sesión previa, usado para la progresión doble.
class CompletedSet {
  const CompletedSet({required this.completed, this.weightKg, this.reps});
  final bool completed;
  final double? weightKg;
  final int? reps;
}

/// Convierte el string de reps de una rutina ("8-12", "10") en (piso, techo).
(int, int) parseRepsRange(String reps) {
  final trimmed = reps.trim();
  if (trimmed.contains('-')) {
    final parts = trimmed.split('-');
    final lo = int.tryParse(parts[0].trim()) ?? 8;
    final hi = parts.length > 1 ? (int.tryParse(parts[1].trim()) ?? lo) : lo;
    return (lo, hi);
  }
  final n = int.tryParse(trimmed) ?? 8;
  return (n, n);
}

/// Fórmula de Epley: 1RM estimado a partir de un peso levantado a N reps.
double epley1RM(double weight, int reps) => weight * (1 + reps / 30);

/// Inversa de Epley: peso de trabajo para lograr N reps dado un 1RM.
double weightForReps(double oneRm, int reps) => oneRm / (1 + reps / 30);

/// Redondea al incremento de disco/mancuerna más cercano (nunca negativo).
double roundToIncrement(double weight, double increment) {
  if (weight <= 0) return 0;
  return (weight / increment).round() * increment;
}

int _levelIndex(String fitnessLevel) {
  switch (fitnessLevel) {
    case 'intermedio':
      return 1;
    case 'avanzado':
      return 2;
    default:
      return 0;
  }
}

/// Ratios 1RM/peso-corporal por nivel para los compuestos con nombre conocido.
/// [principiante, intermedio, avanzado]. Basado en estándares de fuerza
/// tipo strengthlevel.com / Rippetoe, usados solo como arranque en frío.
const _compoundRatios = {
  'press de banca': [0.50, 0.80, 1.10],
  'press militar': [0.35, 0.55, 0.75],
  'peso muerto': [1.00, 1.50, 2.00],
  'sentadilla': [0.75, 1.25, 1.75],
};

/// Fallback por grupo muscular cuando el nombre no matchea un compuesto
/// conocido (ejercicios accesorios). Ratios más bajos que los compuestos.
const _muscleGroupRatios = {
  'pecho': [0.25, 0.40, 0.55],
  'espalda': [0.30, 0.45, 0.65],
  'piernas': [0.30, 0.50, 0.70],
  'hombros': [0.15, 0.25, 0.35],
  'brazos': [0.12, 0.20, 0.30],
  'core': [0.10, 0.18, 0.25],
  'gluteos': [0.35, 0.55, 0.75],
};

double? _ratioFor(String exerciseName, String muscleGroup, String fitnessLevel) {
  final lvl = _levelIndex(fitnessLevel);
  final lowerName = exerciseName.toLowerCase();
  for (final entry in _compoundRatios.entries) {
    if (lowerName.contains(entry.key)) return entry.value[lvl];
  }
  final group = _muscleGroupRatios[muscleGroup];
  return group?[lvl];
}

/// Incremento de carga real disponible según el implemento.
double incrementFor(String? equipment) {
  final eq = (equipment ?? '').toLowerCase();
  if (eq.contains('mancuerna')) return 2.0;
  return 2.5;
}

double? _baseWeightForEquipment(String? equipment) {
  final eq = (equipment ?? '').toLowerCase();
  if (eq.contains('barra')) return 20.0;
  if (eq.contains('mancuerna')) return 4.0;
  return null;
}

/// Cascada de decisión pura (sin DB) para sugerir peso y reps.
/// Orden: peso fijado en la rutina > progresión doble sobre la última sesión
/// > 1RM estimado desde el PR > estimado por nivel y peso corporal.
///
/// [isBodyweight] es para ejercicios de calistenia: el "peso" es lastre
/// adicional sobre el peso corporal, así que el escalón final de estimación
/// (ratios de compuesto / peso base de barra-mancuerna) no aplica — sin
/// rutina, historial ni PR, el lastre por defecto es 0 (solo peso corporal).
WeightSuggestion computeSuggestion({
  required String exerciseName,
  required String muscleGroup,
  String? equipment,
  required String repsRange,
  double? routineTargetWeightKg,
  List<CompletedSet> lastSessionSets = const [],
  double? prWeightKg,
  int? prReps,
  double? userWeightKg,
  required String fitnessLevel,
  bool isBodyweight = false,
}) {
  final (loReps, hiReps) = parseRepsRange(repsRange);
  final increment = incrementFor(equipment);

  if (routineTargetWeightKg != null && routineTargetWeightKg > 0) {
    return WeightSuggestion(
      weightKg: roundToIncrement(routineTargetWeightKg, increment),
      reps: loReps,
      source: 'rutina',
    );
  }

  final completed = lastSessionSets
      .where((s) =>
          s.completed &&
          s.weightKg != null &&
          s.weightKg! > 0 &&
          s.reps != null &&
          s.reps! > 0)
      .toList();
  if (completed.isNotEmpty) {
    final lastWeight = completed.map((s) => s.weightKg!).reduce((a, b) => a > b ? a : b);
    final allAtOrAboveHi = completed.every((s) => s.reps! >= hiReps);
    final nextWeight = allAtOrAboveHi ? lastWeight + increment : lastWeight;
    return WeightSuggestion(
      weightKg: roundToIncrement(nextWeight, increment),
      reps: loReps,
      source: 'historial',
      lastSession: {
        'weightKg': lastWeight,
        'reps': completed.map((s) => s.reps).toList(),
      },
    );
  }

  if (prWeightKg != null && prWeightKg > 0 && prReps != null && prReps > 0) {
    final oneRm = epley1RM(prWeightKg, prReps);
    return WeightSuggestion(
      weightKg: roundToIncrement(weightForReps(oneRm, loReps), increment),
      reps: loReps,
      source: 'pr',
    );
  }

  if (isBodyweight) {
    return WeightSuggestion(weightKg: 0, reps: loReps, source: 'estimado');
  }

  final ratio = _ratioFor(exerciseName, muscleGroup, fitnessLevel);
  if (ratio != null && userWeightKg != null && userWeightKg > 0) {
    return WeightSuggestion(
      weightKg: roundToIncrement(userWeightKg * ratio, increment),
      reps: loReps,
      source: 'estimado',
    );
  }

  return WeightSuggestion(
    weightKg: _baseWeightForEquipment(equipment),
    reps: loReps,
    source: 'estimado',
  );
}

/// Wrapper async: consulta la última sesión finalizada y el mejor PR del
/// usuario para este ejercicio, y delega el cálculo a [computeSuggestion].
Future<WeightSuggestion> suggestFor({
  required String userId,
  required String exerciseId,
  required String exerciseName,
  required String muscleGroup,
  String? equipment,
  required String repsRange,
  double? routineTargetWeightKg,
  double? userWeightKg,
  required String fitnessLevel,
  bool isBodyweight = false,
}) async {
  var lastSessionSets = <CompletedSet>[];
  final lastSessionRes = await db.execute(
    "SELECT ws.id FROM workout_sessions ws "
    "JOIN workout_sets wset ON wset.session_id = ws.id "
    "WHERE ws.user_id = '$userId'::uuid AND wset.exercise_id = '$exerciseId'::uuid "
    "AND ws.ended_at IS NOT NULL "
    "ORDER BY ws.started_at DESC LIMIT 1",
  );
  if (lastSessionRes.isNotEmpty) {
    final sessionId = lastSessionRes.first.toColumnMap()['id'] as String;
    final setsRes = await db.execute(
      "SELECT weight_kg, reps, completed FROM workout_sets "
      "WHERE session_id = '$sessionId'::uuid AND exercise_id = '$exerciseId'::uuid",
    );
    lastSessionSets = setsRes.map((r) {
      final m = r.toColumnMap();
      return CompletedSet(
        completed: m['completed'] as bool? ?? false,
        weightKg: m['weight_kg'] != null ? double.tryParse(m['weight_kg'].toString()) : null,
        reps: m['reps'] as int?,
      );
    }).toList();
  }

  double? prWeightKg;
  int? prReps;
  var bestOneRm = 0.0;
  final prRes = await db.execute(
    "SELECT weight_kg, reps FROM personal_records "
    "WHERE user_id = '$userId'::uuid AND exercise_id = '$exerciseId'::uuid",
  );
  for (final row in prRes) {
    final m = row.toColumnMap();
    final w = double.tryParse(m['weight_kg']?.toString() ?? '0') ?? 0;
    final r = m['reps'] as int? ?? 0;
    if (w > 0 && r > 0) {
      final oneRm = epley1RM(w, r);
      if (oneRm > bestOneRm) {
        bestOneRm = oneRm;
        prWeightKg = w;
        prReps = r;
      }
    }
  }

  return computeSuggestion(
    exerciseName: exerciseName,
    muscleGroup: muscleGroup,
    equipment: equipment,
    repsRange: repsRange,
    routineTargetWeightKg: routineTargetWeightKg,
    lastSessionSets: lastSessionSets,
    prWeightKg: prWeightKg,
    prReps: prReps,
    userWeightKg: userWeightKg,
    fitnessLevel: fitnessLevel,
    isBodyweight: isBodyweight,
  );
}

/// Sugerencia de duración (segundos) para un ejercicio isométrico.
class DurationSuggestion {
  const DurationSuggestion({
    required this.durationSeconds,
    required this.source,
    this.lastSession,
  });

  /// Duración sugerida en segundos. Siempre presente (hay un piso por nivel).
  final int? durationSeconds;

  /// 'rutina' | 'historial' | 'pr' | 'estimado'
  final String source;

  /// Presente solo cuando source == 'historial'.
  final Map<String, dynamic>? lastSession;

  Map<String, dynamic> toMap() => {
        'durationSeconds': durationSeconds,
        'source': source,
        if (lastSession != null) 'lastSession': lastSession,
      };
}

/// Hold completado de una sesión previa, usado para la progresión de duración.
class CompletedHold {
  const CompletedHold({required this.completed, this.durationSeconds});
  final bool completed;
  final int? durationSeconds;
}

/// Piso de duración por nivel cuando no hay rutina, historial ni PR.
const _durationEstimateByLevel = {
  'principiante': 20,
  'intermedio': 30,
  'avanzado': 45,
};

/// Cuánto sumar a la última duración aguantada cuando se progresa (segundos).
const _durationProgressionStep = 5;

/// Cascada de decisión pura (sin DB) para sugerir duración de un hold isométrico.
/// Orden: duración fijada en la rutina > progresión sobre la última sesión
/// (+5s si se completó el hold) > mejor PR de duración > piso estimado por nivel.
DurationSuggestion computeDurationSuggestion({
  int? routineTargetDurationSeconds,
  List<CompletedHold> lastSessionHolds = const [],
  int? prDurationSeconds,
  required String fitnessLevel,
}) {
  if (routineTargetDurationSeconds != null && routineTargetDurationSeconds > 0) {
    return DurationSuggestion(
      durationSeconds: routineTargetDurationSeconds,
      source: 'rutina',
    );
  }

  final completed = lastSessionHolds
      .where((h) => h.completed && h.durationSeconds != null && h.durationSeconds! > 0)
      .toList();
  if (completed.isNotEmpty) {
    final lastDuration = completed.map((h) => h.durationSeconds!).reduce((a, b) => a > b ? a : b);
    return DurationSuggestion(
      durationSeconds: lastDuration + _durationProgressionStep,
      source: 'historial',
      lastSession: {'durationSeconds': lastDuration},
    );
  }

  if (prDurationSeconds != null && prDurationSeconds > 0) {
    return DurationSuggestion(durationSeconds: prDurationSeconds, source: 'pr');
  }

  return DurationSuggestion(
    durationSeconds: _durationEstimateByLevel[fitnessLevel] ?? _durationEstimateByLevel['principiante'],
    source: 'estimado',
  );
}

/// Wrapper async: consulta la última sesión finalizada y el mejor PR de
/// duración del usuario para este ejercicio, y delega a [computeDurationSuggestion].
Future<DurationSuggestion> suggestDurationFor({
  required String userId,
  required String exerciseId,
  int? routineTargetDurationSeconds,
  required String fitnessLevel,
}) async {
  var lastSessionHolds = <CompletedHold>[];
  final lastSessionRes = await db.execute(
    "SELECT ws.id FROM workout_sessions ws "
    "JOIN workout_sets wset ON wset.session_id = ws.id "
    "WHERE ws.user_id = '$userId'::uuid AND wset.exercise_id = '$exerciseId'::uuid "
    "AND ws.ended_at IS NOT NULL "
    "ORDER BY ws.started_at DESC LIMIT 1",
  );
  if (lastSessionRes.isNotEmpty) {
    final sessionId = lastSessionRes.first.toColumnMap()['id'] as String;
    final setsRes = await db.execute(
      "SELECT duration_seconds, completed FROM workout_sets "
      "WHERE session_id = '$sessionId'::uuid AND exercise_id = '$exerciseId'::uuid",
    );
    lastSessionHolds = setsRes.map((r) {
      final m = r.toColumnMap();
      return CompletedHold(
        completed: m['completed'] as bool? ?? false,
        durationSeconds: m['duration_seconds'] as int?,
      );
    }).toList();
  }

  int? prDurationSeconds;
  final prRes = await db.execute(
    "SELECT duration_seconds FROM personal_records "
    "WHERE user_id = '$userId'::uuid AND exercise_id = '$exerciseId'::uuid "
    "AND duration_seconds IS NOT NULL ORDER BY duration_seconds DESC LIMIT 1",
  );
  if (prRes.isNotEmpty) {
    prDurationSeconds = prRes.first.toColumnMap()['duration_seconds'] as int?;
  }

  return computeDurationSuggestion(
    routineTargetDurationSeconds: routineTargetDurationSeconds,
    lastSessionHolds: lastSessionHolds,
    prDurationSeconds: prDurationSeconds,
    fitnessLevel: fitnessLevel,
  );
}
