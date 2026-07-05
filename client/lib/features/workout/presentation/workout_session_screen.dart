import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/weight_utils.dart';
import '../../../features/profile/providers/weight_unit_notifier.dart';
import '../../../shared/services/exercises_service.dart';
import '../../../shared/services/workout_service.dart';
import '../../../shared/widgets/youtube_video_card.dart';

class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({
    super.key,
    this.routineId,
    this.routineDayId,
    this.routineName,
    this.dayLabel,
  });

  final String? routineId;
  final String? routineDayId;
  final String? routineName;
  final String? dayLabel;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  final _service = WorkoutService();

  Map<String, dynamic>? _session;
  bool _loading = true;
  String? _error;

  // Timer general de la sesión
  late Timer _sessionTimer;
  Duration _elapsed = Duration.zero;

  // Timer de descanso
  Timer? _restTimer;
  int _restRemaining = 0;
  bool _restActive = false;
  int _restTotal = 90;

  // Sonidos countdown — una instancia por reproducción, dispose al terminar
  // (ReleaseMode compartido deja el MediaPlayer de Android en STOPPED y falla al reiniciar)

  // Estado de inputs por set: key = "$exerciseId-$setNumber"
  final Map<String, TextEditingController> _weightControllers = {};
  final Map<String, TextEditingController> _repsControllers = {};  // también usado para duración en isométricos
  final Map<String, bool> _setCompleted = {};
  final Map<String, bool> _setLoading = {};

  // Objetivo planeado por set (en kg / reps), key = "$exerciseId-$setNumber"
  final Map<String, double?> _targetWeightKg = {};
  final Map<String, int?> _targetReps = {};

  // Tipo de ejercicio por exerciseId: 'dinamico' | 'isometrico'
  final Map<String, String> _exerciseTypes = {};

  // Unidad de peso del usuario (leída una vez al iniciar)
  WeightUnit _unit = WeightUnit.kg;

  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    _unit = context.read<WeightUnitNotifier>().unit;
    _initSession();
  }

  @override
  void dispose() {
    _sessionTimer.cancel();
    _restTimer?.cancel();
    for (final c in _weightControllers.values) c.dispose();
    for (final c in _repsControllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _initSession() async {
    setState(() { _loading = true; _error = null; });
    try {
      final session = await _service.startSession(
        routineId: widget.routineId,
        routineDayId: widget.routineDayId,
      );
      _loadSession(session);
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _loadSession(Map<String, dynamic> session) {
    _session = session;

    // Calcular tiempo transcurrido desde startedAt
    final startedAt = DateTime.tryParse(session['startedAt'] as String? ?? '')?.toLocal();
    if (startedAt != null) {
      _elapsed = DateTime.now().difference(startedAt);
    }

    // Inicializar estado de sets desde los ya registrados
    final exercises = (session['exercises'] as List? ?? []).cast<Map<String, dynamic>>();
    for (final ex in exercises) {
      final exerciseId = ex['exerciseId'] as String;
      final exerciseType = ex['exerciseType'] as String? ?? 'dinamico';
      final isIsometric = exerciseType == 'isometrico';
      _exerciseTypes[exerciseId] = exerciseType;

      final targetSets = ex['targetSets'] as int? ?? 3;
      final targetDuration = (ex['targetDurationSeconds'] as num?)?.toInt();
      final sets = (ex['sets'] as List? ?? []).cast<Map<String, dynamic>>();

      final suggestion = ex['suggestion'] as Map<String, dynamic>?;
      final suggWeightKg = (suggestion?['weightKg'] as num?)?.toDouble();
      final suggReps = suggestion?['reps'] as int?;

      for (int i = 1; i <= targetSets; i++) {
        final key = '$exerciseId-$i';
        final existing = sets.where((s) => s['setNumber'] == i).firstOrNull;

        // Peso: convertir de kg a unidad preferida si hay valor existente
        final rawKg = (existing?['weightKg'] as num?)?.toDouble();
        final existingTargetWeightKg = (existing?['targetWeightKg'] as num?)?.toDouble();
        final existingTargetReps = existing?['targetReps'] as int?;

        // El objetivo queda "congelado" en el primer valor conocido: lo que ya
        // se guardó en un intento previo, o si no, la sugerencia vigente.
        final effectiveTargetWeightKg =
            existingTargetWeightKg ?? (isIsometric ? null : suggWeightKg);
        final effectiveTargetReps =
            existingTargetReps ?? (isIsometric ? null : suggReps);
        _targetWeightKg[key] = effectiveTargetWeightKg;
        _targetReps[key] = effectiveTargetReps;

        final weightText = rawKg != null
            ? toDisplayUnit(rawKg, _unit).toStringAsFixed(1)
            : (effectiveTargetWeightKg != null
                ? toDisplayUnit(effectiveTargetWeightKg, _unit).toStringAsFixed(1)
                : '');

        // Segunda columna: reps para dinámicos, duración para isométricos
        // Para isométricos, si no hay set previo, pre-llenar con el target de la rutina
        final secondText = isIsometric
            ? (existing?['durationSeconds'] != null
                ? existing!['durationSeconds'].toString()
                : (targetDuration != null ? targetDuration.toString() : ''))
            : (existing?['reps'] != null
                ? existing!['reps'].toString()
                : (effectiveTargetReps != null ? effectiveTargetReps.toString() : ''));

        _weightControllers.putIfAbsent(key, () => TextEditingController(text: weightText));
        _repsControllers.putIfAbsent(key, () => TextEditingController(text: secondText));
        _setCompleted[key] = existing?['completed'] as bool? ?? false;
        _setLoading[key] = false;
      }
    }

    // Arrancar timer de sesión
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });

    setState(() { _loading = false; });
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _restActive = true;
      _restRemaining = seconds;
      _restTotal = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      // Actualizar estado (síncrono — sin llamadas async aquí)
      setState(() {
        if (_restRemaining > 0) {
          _restRemaining--;
          if (_restRemaining == 0) {
            _restActive = false;
            t.cancel();
          }
        } else {
          _restActive = false;
          t.cancel();
        }
      });
      // Sonidos FUERA de setState para evitar race conditions
      if (_restRemaining > 0 && _restRemaining <= 5) {
        _playCountdownBeep();
      } else if (_restRemaining == 0) {
        _playFinishSound();
      }
    });
  }

  void _stopRestTimer() {
    _restTimer?.cancel();
    setState(() { _restActive = false; _restRemaining = 0; });
  }

  Future<void> _playCountdownBeep() async {
    final p = AudioPlayer();
    try {
      await p.play(AssetSource('sounds/loop.mp3'));
      p.onPlayerComplete.first.then((_) => p.dispose());
    } catch (_) {
      p.dispose();
    }
  }

  Future<void> _playFinishSound() async {
    final p = AudioPlayer();
    try {
      await p.play(AssetSource('sounds/final.mp3'));
      p.onPlayerComplete.first.then((_) => p.dispose());
    } catch (_) {
      p.dispose();
    }
  }

  Future<void> _toggleSet(String exerciseId, int setNumber, int restSeconds) async {
    final key = '$exerciseId-$setNumber';
    if (_setLoading[key] == true) return;

    final sessionId = _session!['id'] as String;
    final weightText = _weightControllers[key]?.text.trim() ?? '';
    final secondText = _repsControllers[key]?.text.trim() ?? '';
    final wasCompleted = _setCompleted[key] ?? false;
    final nowCompleted = !wasCompleted;
    final isIsometric = _exerciseTypes[exerciseId] == 'isometrico';

    // Convertir peso de unidad preferida a kg para la API
    final displayWeight = double.tryParse(weightText);
    final weightKg = displayWeight != null ? fromDisplayUnit(displayWeight, _unit) : null;

    setState(() => _setLoading[key] = true);
    try {
      await _service.logSet(
        sessionId: sessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weightKg: isIsometric ? null : weightKg,
        reps: isIsometric ? null : int.tryParse(secondText),
        durationSeconds: isIsometric ? int.tryParse(secondText) : null,
        completed: nowCompleted,
        targetWeightKg: isIsometric ? null : _targetWeightKg[key],
        targetReps: isIsometric ? null : _targetReps[key],
      );
      setState(() {
        _setCompleted[key] = nowCompleted;
        _setLoading[key] = false;
      });

      if (nowCompleted) {
        _startRestTimer(restSeconds);
      } else if (_restActive) {
        _stopRestTimer();
      }
    } catch (_) {
      setState(() => _setLoading[key] = false);
    }
  }

  bool _isSessionComplete() {
    final exercises = (_session?['exercises'] as List? ?? []).cast<Map<String, dynamic>>();
    if (exercises.isEmpty) return false;
    for (final ex in exercises) {
      final targetSets = ex['targetSets'] as int? ?? 0;
      if (targetSets == 0) continue;
      for (int i = 1; i <= targetSets; i++) {
        final key = '${ex['exerciseId']}-$i';
        if (_setCompleted[key] != true) return false;
      }
    }
    return true;
  }

  Future<void> _finish() async {
    final isComplete = _isSessionComplete();
    if (isComplete) {
      await _doFinish(status: 'completed');
    } else {
      await _showExitDialog();
    }
  }

  Future<void> _doFinish({
    required String status,
    String? earlyFinishReason,
  }) async {
    setState(() => _finishing = true);
    try {
      _sessionTimer.cancel();
      _restTimer?.cancel();
      final sessionId = _session!['id'] as String;
      final finished = await _service.finishSession(
        sessionId,
        status: status,
        earlyFinishReason: earlyFinishReason,
      );
      if (!mounted) return;
      context.pushReplacement('/workout/summary', extra: finished);
    } catch (e) {
      if (!mounted) return;
      setState(() => _finishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.accentSecondary),
      );
    }
  }

  Future<void> _doCancel() async {
    try {
      final sessionId = _session?['id'] as String?;
      if (sessionId != null) await _service.cancelSession(sessionId);
    } catch (_) {}
    if (!mounted) return;
    context.pop();
  }

  Future<void> _showExitDialog() async {
    if (_session == null) { context.pop(); return; }
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ExitSessionDialog(
        onContinue: () => Navigator.of(ctx).pop(),
        onDiscard: () async {
          Navigator.of(ctx).pop();
          await _doCancel();
        },
        onPartial: (reason) async {
          Navigator.of(ctx).pop();
          await _doFinish(status: 'partial', earlyFinishReason: reason);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _session != null && !_finishing) _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: context.colorBgPrimary,
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.accentPrimary))
            : _error != null
                ? _buildError()
                : _buildSession(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.accentSecondary, size: 48),
            SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center,
                style: TextStyle(color: context.colorTextSecondary)),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.accentPrimary),
              onPressed: _initSession,
              child: const Text('Reintentar'),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Volver', style: TextStyle(color: context.colorTextSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSession() {
    final session = _session!;
    final exercises = (session['exercises'] as List? ?? []).cast<Map<String, dynamic>>();
    final routineName = widget.routineName ?? session['routineName'] as String?;
    final dayLabel = widget.dayLabel ?? session['dayLabel'] as String?;

    return Column(
      children: [
        // ── Header fijo ──
        _SessionHeader(
          elapsed: _elapsed,
          routineName: routineName,
          dayLabel: dayLabel,
          onFinish: _finishing ? null : _finish,
          onCancel: _finishing ? null : _showExitDialog,
          finishing: _finishing,
        ),

        // ── Banner de descanso ──
        if (_restActive) _RestBanner(
          remaining: _restRemaining,
          total: _restTotal,
          onSkip: _stopRestTimer,
        ),

        // ── Lista de ejercicios ──
        Expanded(
          child: exercises.isEmpty
              ? Center(
                  child: Text(
                    'No hay ejercicios en este día',
                    style: TextStyle(color: context.colorTextSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 32),
                  itemCount: exercises.length,
                  itemBuilder: (context, i) {
                    final ex = exercises[i];
                    final exId = ex['exerciseId'] as String;
                    final isIsometric = _exerciseTypes[exId] == 'isometrico';
                    final isCalistenia = _exerciseTypes[exId] == 'calistenia';
                    return _ExerciseCard(
                      exercise: ex,
                      weightControllers: _weightControllers,
                      repsControllers: _repsControllers,
                      setCompleted: _setCompleted,
                      setLoading: _setLoading,
                      onToggleSet: _toggleSet,
                      isIsometric: isIsometric,
                      isCalistenia: isCalistenia,
                      weightUnitLabel: _unit == WeightUnit.lbs ? 'LBS' : 'KG',
                      unit: _unit,
                      targetWeightKg: _targetWeightKg,
                      targetReps: _targetReps,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ── Widgets internos ──────────────────────────────────────────────────────────

class _SessionHeader extends StatelessWidget {
  const _SessionHeader({
    required this.elapsed,
    required this.routineName,
    required this.dayLabel,
    required this.onFinish,
    required this.onCancel,
    required this.finishing,
  });

  final Duration elapsed;
  final String? routineName;
  final String? dayLabel;
  final VoidCallback? onFinish;
  final VoidCallback? onCancel;
  final bool finishing;

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorBgSecondary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: context.colorTextSecondary),
                onPressed: onCancel,
                tooltip: 'Cancelar sesión',
              ),
              const Spacer(),
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: context.colorBgTertiary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.accentPrimary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _formatDuration(elapsed),
                      style: const TextStyle(
                        color: AppColors.accentPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              finishing
                  ? const SizedBox(
                      width: 36, height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accentPrimary,
                      ),
                    )
                  : FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accentPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onFinish,
                      child: const Text('Finalizar', style: TextStyle(fontSize: 13)),
                    ),
            ],
          ),
          if (routineName != null || dayLabel != null) ...[
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                [if (routineName != null) routineName, if (dayLabel != null) dayLabel]
                    .join(' · '),
                style: TextStyle(color: context.colorTextSecondary, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RestBanner extends StatelessWidget {
  const _RestBanner({
    required this.remaining,
    required this.total,
    required this.onSkip,
  });

  final int remaining;
  final int total;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? remaining / total : 0.0;
    final isWarning = remaining <= 10;

    return Container(
      color: context.colorBgTertiary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_bottom_rounded,
            color: isWarning ? AppColors.accentSecondary : AppColors.accentGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Descanso: ${remaining}s',
                      style: TextStyle(
                        color: isWarning ? AppColors.accentSecondary : AppColors.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onSkip,
                      child: Text(
                        'Omitir',
                        style: TextStyle(
                          color: context.colorTextSecondary,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: context.colorBgSecondary,
                  valueColor: AlwaysStoppedAnimation(
                    isWarning ? AppColors.accentSecondary : AppColors.accentGreen,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatefulWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.weightControllers,
    required this.repsControllers,
    required this.setCompleted,
    required this.setLoading,
    required this.onToggleSet,
    this.isIsometric = false,
    this.isCalistenia = false,
    this.weightUnitLabel = 'KG',
    this.unit = WeightUnit.kg,
    this.targetWeightKg = const {},
    this.targetReps = const {},
  });

  final Map<String, dynamic> exercise;
  final Map<String, TextEditingController> weightControllers;
  final Map<String, TextEditingController> repsControllers;
  final Map<String, bool> setCompleted;
  final Map<String, bool> setLoading;
  final Future<void> Function(String exerciseId, int setNumber, int restSeconds) onToggleSet;
  final bool isIsometric;
  final bool isCalistenia;
  final String weightUnitLabel;
  final WeightUnit unit;
  final Map<String, double?> targetWeightKg;
  final Map<String, int?> targetReps;

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _expanded = true;

  void _showInfo(BuildContext context) {
    final exerciseId = widget.exercise['exerciseId'] as String;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ExerciseInfoSheet(exerciseId: exerciseId),
    );
  }

  static const _muscleColors = {
    'pecho': Color(0xFF3b82f6),
    'espalda': Color(0xFF8b5cf6),
    'piernas': Color(0xFF22c55e),
    'hombros': Color(0xFFf97316),
    'brazos': Color(0xFFec4899),
    'core': Color(0xFFeab308),
    'gluteos': Color(0xFFef4444),
  };

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final exerciseId = ex['exerciseId'] as String;
    final name = ex['exerciseName'] as String? ?? '';
    final muscleGroup = ex['muscleGroup'] as String? ?? '';
    final targetSets = ex['targetSets'] as int? ?? 3;
    final targetReps = ex['targetReps'] as String? ?? '8-12';
    final restSeconds = ex['restSeconds'] as int? ?? 90;
    final muscleColor = _muscleColors[muscleGroup] ?? AppColors.accentPrimary;

    final completedSets = List.generate(targetSets, (i) {
      final key = '$exerciseId-${i + 1}';
      return widget.setCompleted[key] ?? false;
    }).where((c) => c).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        children: [
          // ── Encabezado ejercicio ──
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: muscleColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: context.colorTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$targetSets series × $targetReps reps · ${restSeconds}s descanso',
                          style: TextStyle(
                            color: context.colorTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                        if (ex['suggestion'] != null && (ex['suggestion'] as Map)['weightKg'] != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            _suggestionLabel(ex['suggestion'] as Map<String, dynamic>, widget.unit),
                            style: const TextStyle(
                              color: AppColors.accentPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón info
                  GestureDetector(
                    onTap: () => _showInfo(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Icon(Icons.info_outline, color: context.colorTextMuted, size: 18),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Progreso series
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: completedSets == targetSets
                          ? AppColors.accentGreen.withValues(alpha: 0.15)
                          : context.colorBgTertiary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$completedSets/$targetSets',
                      style: TextStyle(
                        color: completedSets == targetSets
                            ? AppColors.accentGreen
                            : context.colorTextSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: context.colorTextMuted,
                  ),
                ],
              ),
            ),
          ),

          // ── Sets ──
          if (_expanded)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: Column(
                children: [
                  // Cabecera columnas
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const SizedBox(width: 32),
                        if (!widget.isIsometric) ...[
                          Expanded(
                            child: Text(
                              widget.isCalistenia
                                  ? 'LASTRE'
                                  : widget.weightUnitLabel,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: context.colorTextMuted, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            widget.isIsometric ? 'SEG' : 'REPS',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: context.colorTextMuted, fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 44),
                      ],
                    ),
                  ),
                  ...List.generate(targetSets, (i) {
                    final setNumber = i + 1;
                    final key = '$exerciseId-$setNumber';
                    final completed = widget.setCompleted[key] ?? false;
                    final loading = widget.setLoading[key] ?? false;
                    final targetKg = widget.targetWeightKg[key];

                    return _SetRow(
                      setNumber: setNumber,
                      weightController: widget.weightControllers[key]!,
                      repsController: widget.repsControllers[key]!,
                      completed: completed,
                      loading: loading,
                      isIsometric: widget.isIsometric,
                      onToggle: () => widget.onToggleSet(exerciseId, setNumber, restSeconds),
                      targetWeightKg: widget.isIsometric ? null : targetKg,
                      targetReps: widget.isIsometric ? null : widget.targetReps[key],
                      unit: widget.unit,
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.setNumber,
    required this.weightController,
    required this.repsController,
    required this.completed,
    required this.loading,
    required this.onToggle,
    this.isIsometric = false,
    this.targetWeightKg,
    this.targetReps,
    this.unit = WeightUnit.kg,
  });

  final int setNumber;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final bool completed;
  final bool loading;
  final VoidCallback onToggle;
  final bool isIsometric;
  final double? targetWeightKg;
  final int? targetReps;
  final WeightUnit unit;

  /// null = sin objetivo que comparar; true = cumplió o superó; false = por debajo.
  ///
  /// La comparación se hace en kg (no en la unidad mostrada): el campo de texto
  /// contiene el valor en la unidad preferida del usuario, redondeado a 1
  /// decimal al pre-llenarse, así que se reconvierte a kg antes de comparar
  /// contra el objetivo (que ya está en kg, sin redondeos de conversión).
  bool? get _meetsTarget {
    if (!completed) return null;
    if (targetWeightKg == null && targetReps == null) return null;
    final displayValue = double.tryParse(weightController.text.trim());
    final w = displayValue != null ? fromDisplayUnit(displayValue, unit) : null;
    final r = int.tryParse(repsController.text.trim());
    final weightOk = targetWeightKg == null ||
        (w != null && w >= targetWeightKg! - 0.05);
    final repsOk = targetReps == null || (r != null && r >= targetReps!);
    return weightOk && repsOk;
  }

  @override
  Widget build(BuildContext context) {
    final meets = _meetsTarget;
    final statusColor = meets == false ? AppColors.diffIntermedio : AppColors.accentGreen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: completed
            ? statusColor.withValues(alpha: 0.08)
            : context.colorBgTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: completed ? statusColor.withValues(alpha: 0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          // Número de serie
          SizedBox(
            width: 24,
            child: Text(
              '$setNumber',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: completed ? statusColor : context.colorTextMuted,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Campo KG/LBS (oculto en isométricos)
          if (!isIsometric) ...[
            Expanded(
              child: _NumberField(
                controller: weightController,
                hint: '0',
                enabled: !completed,
                decimal: true,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Campo Reps / Duración
          Expanded(
            child: _NumberField(
              controller: repsController,
              hint: '0',
              enabled: !completed,
              decimal: false,
            ),
          ),
          const SizedBox(width: 8),

          // Botón completar
          SizedBox(
            width: 36,
            height: 36,
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentPrimary,
                    ),
                  )
                : InkWell(
                    onTap: onToggle,
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: completed ? statusColor : context.colorBgSecondary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: completed ? statusColor : context.colorBorder,
                        ),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 18,
                        color: completed ? Colors.white : context.colorTextMuted,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

String _suggestionLabel(Map<String, dynamic> suggestion, WeightUnit unit) {
  final weightKg = (suggestion['weightKg'] as num).toDouble();
  final reps = suggestion['reps'] as int?;
  final source = suggestion['source'] as String? ?? 'estimado';
  final unitLabel = unit == WeightUnit.lbs ? 'lbs' : 'kg';
  final display = toDisplayUnit(weightKg, unit).toStringAsFixed(1);
  final base = '⚡ Sugerido: $display $unitLabel${reps != null ? ' × $reps' : ''}';

  switch (source) {
    case 'rutina':
      return '$base · Peso de tu rutina';
    case 'historial':
      final last = suggestion['lastSession'] as Map<String, dynamic>?;
      final lastWeightKg = (last?['weightKg'] as num?)?.toDouble();
      if (lastWeightKg == null) return base;
      final lastDisplay = toDisplayUnit(lastWeightKg, unit).toStringAsFixed(1);
      return '$base · Último: $lastDisplay $unitLabel';
    case 'pr':
      return '$base · Estimado desde tu récord';
    default:
      return '$base · Estimado para tu nivel';
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.hint,
    required this.enabled,
    required this.decimal,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      style: TextStyle(
        color: context.colorTextPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.colorTextMuted, fontSize: 14),
        filled: true,
        fillColor: context.colorBgPrimary,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ── Dialog de salida de sesión ────────────────────────────────────────────────

class _ExitSessionDialog extends StatefulWidget {
  const _ExitSessionDialog({
    required this.onContinue,
    required this.onDiscard,
    required this.onPartial,
  });

  final VoidCallback onContinue;
  final VoidCallback onDiscard;
  final void Function(String reason) onPartial;

  @override
  State<_ExitSessionDialog> createState() => _ExitSessionDialogState();
}

class _ExitSessionDialogState extends State<_ExitSessionDialog> {
  // 0 = pantalla principal, 1 = seleccionar motivo de pausa
  int _step = 0;
  String? _selectedReason;
  final _otherCtrl = TextEditingController();

  static const _reasons = [
    'Poco tiempo',
    'Cansancio / fatiga',
    'Molestia o dolor',
    'Otro',
  ];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  void _confirmPartial() {
    final reason = _selectedReason == 'Otro'
        ? _otherCtrl.text.trim()
        : _selectedReason ?? '';
    widget.onPartial(reason);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colorBgSecondary,
      title: Text(
        _step == 0 ? '¿Qué deseas hacer?' : 'Motivo para terminar',
        style: TextStyle(color: context.colorTextPrimary, fontSize: 17),
      ),
      content: _step == 0 ? _buildMainStep(context) : _buildReasonStep(context),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: _step == 0
          ? [
              TextButton(
                onPressed: widget.onContinue,
                child: Text('Seguir con la rutina',
                    style: TextStyle(color: AppColors.accentPrimary)),
              ),
            ]
          : [
              TextButton(
                onPressed: () => setState(() => _step = 0),
                child: Text('Atrás',
                    style: TextStyle(color: context.colorTextSecondary)),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB347)),
                onPressed: _selectedReason == null
                    ? null
                    : _confirmPartial,
                child: const Text('Terminar aquí',
                    style: TextStyle(color: Colors.black87)),
              ),
            ],
    );
  }

  Widget _buildMainStep(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'No has completado todos los ejercicios de tu rutina.',
          style: TextStyle(color: context.colorTextSecondary, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _OptionTile(
          icon: Icons.fitness_center_rounded,
          iconColor: AppColors.accentPrimary,
          title: 'Seguir con la rutina',
          subtitle: 'Vuelvo a entrenar',
          onTap: widget.onContinue,
        ),
        const SizedBox(height: 8),
        _OptionTile(
          icon: Icons.delete_outline_rounded,
          iconColor: AppColors.accentSecondary,
          title: 'No disputar la rutina',
          subtitle: 'Elimina todo el progreso de esta sesión',
          onTap: widget.onDiscard,
        ),
        const SizedBox(height: 8),
        _OptionTile(
          icon: Icons.flag_outlined,
          iconColor: const Color(0xFFFFB347),
          title: 'Terminar aquí',
          subtitle: 'Guarda el progreso parcial',
          onTap: () => setState(() => _step = 1),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildReasonStep(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _reasons.map((r) {
            final selected = _selectedReason == r;
            return GestureDetector(
              onTap: () => setState(() => _selectedReason = r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.accentPrimary.withValues(alpha: 0.15)
                      : context.colorBgTertiary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? AppColors.accentPrimary : context.colorBorder,
                  ),
                ),
                child: Text(r,
                    style: TextStyle(
                      color: selected
                          ? AppColors.accentPrimary
                          : context.colorTextSecondary,
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    )),
              ),
            );
          }).toList(),
        ),
        if (_selectedReason == 'Otro') ...[
          const SizedBox(height: 8),
          TextField(
            controller: _otherCtrl,
            style: TextStyle(color: context.colorTextPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Describe el motivo...',
              hintStyle:
                  TextStyle(color: context.colorTextMuted, fontSize: 13),
              isDense: true,
              filled: true,
              fillColor: context.colorBgTertiary,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.colorBgTertiary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colorBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: context.colorTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                  Text(subtitle,
                      style: TextStyle(
                          color: context.colorTextSecondary, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: context.colorTextMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Exercise Info Bottom Sheet ────────────────────────────────────────────────

class _ExerciseInfoSheet extends StatefulWidget {
  const _ExerciseInfoSheet({required this.exerciseId});
  final String exerciseId;

  @override
  State<_ExerciseInfoSheet> createState() => _ExerciseInfoSheetState();
}

class _ExerciseInfoSheetState extends State<_ExerciseInfoSheet> {
  final _service = ExercisesService();
  Map<String, dynamic>? _exercise;
  bool _loading = true;

  static const _muscleColors = {
    'pecho': Color(0xFF3b82f6),
    'espalda': Color(0xFF8b5cf6),
    'piernas': Color(0xFF22c55e),
    'hombros': Color(0xFFf97316),
    'brazos': Color(0xFFec4899),
    'core': Color(0xFFeab308),
    'gluteos': Color(0xFFef4444),
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _service.getExercise(widget.exerciseId);
      if (mounted) setState(() { _exercise = data; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorBgSecondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 4),
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: context.colorTextMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              if (_loading)
                const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.accentPrimary)))
              else if (_exercise == null)
                Expanded(child: Center(child: Text('No se pudo cargar la info', style: TextStyle(color: context.colorTextMuted))))
              else
                Expanded(child: _buildContent(controller)),
            ],
          ),
        );
      },
    );
  }

  void _openFullImage(String url) {
    final fullUrl = url.startsWith('http') ? url : '${ApiConstants.baseUrl}$url';
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: fullUrl,
                    fit: BoxFit.contain,
                    errorWidget: (ctx, url, err) => const Icon(Icons.broken_image, color: Colors.white54, size: 48),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ScrollController controller) {
    final e = _exercise!;
    final name = e['name'] as String? ?? '';
    final muscleGroup = e['muscleGroup'] as String? ?? '';
    final difficulty = e['difficulty'] as String? ?? '';
    final equipment = e['equipment'] as String?;
    final description = e['description'] as String?;
    final muscles = (e['muscles'] as List?)?.cast<String>() ?? [];
    final instructions = (e['instructions'] as List?)?.cast<String>() ?? [];
    final stepImages = (e['stepImages'] as List?)?.cast<String>() ?? [];
    final imageUrl = e['imageUrl'] as String?;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final videoUrl = e['videoUrl'] as String?;
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
    final muscleColor = _muscleColors[muscleGroup] ?? AppColors.accentPrimary;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        // Header image (tappable)
        if (hasImage)
          GestureDetector(
            onTap: () => _openFullImage(imageUrl),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: imageUrl.startsWith('http') ? imageUrl : '${ApiConstants.baseUrl}$imageUrl',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (ctx, url, err) => const SizedBox.shrink(),
              ),
            ),
          ),
        if (hasImage) const SizedBox(height: 14),

        // Name
        Text(name, style: TextStyle(color: context.colorTextPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),

        // Badges
        Wrap(
          spacing: 8, runSpacing: 6,
          children: [
            _InfoBadge(label: _muscleLabel(muscleGroup), color: muscleColor),
            _InfoBadge(label: _difficultyLabel(difficulty), color: _difficultyColor(difficulty)),
            if (equipment != null && equipment.isNotEmpty)
              _InfoBadge(label: equipment, color: context.colorTextMuted, icon: Icons.fitness_center),
          ],
        ),

        // Description
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Descripción', style: TextStyle(color: context.colorTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(description, style: TextStyle(color: context.colorTextSecondary, fontSize: 13, height: 1.5)),
        ],

        // Muscles
        if (muscles.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Músculos trabajados', style: TextStyle(color: context.colorTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6, runSpacing: 6,
            children: muscles.map((m) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: muscleColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: muscleColor.withValues(alpha: 0.35)),
              ),
              child: Text(m, style: TextStyle(color: muscleColor, fontSize: 12, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ],

        // Instructions
        if (instructions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Cómo hacerlo', style: TextStyle(color: context.colorTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...instructions.asMap().entries.map((entry) {
            final idx = entry.key;
            final imgUrl = idx < stepImages.length ? stepImages[idx] : '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26, height: 26,
                    margin: const EdgeInsets.only(right: 10, top: 1),
                    decoration: BoxDecoration(
                      color: muscleColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: muscleColor.withValues(alpha: 0.4)),
                    ),
                    child: Center(child: Text('${idx + 1}', style: TextStyle(color: muscleColor, fontSize: 12, fontWeight: FontWeight.w700))),
                  ),
                  Expanded(
                    child: Text(entry.value, style: TextStyle(color: context.colorTextSecondary, fontSize: 13, height: 1.4)),
                  ),
                  if (imgUrl.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _openFullImage(imgUrl),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: imgUrl.startsWith('http') ? imgUrl : '${ApiConstants.baseUrl}$imgUrl',
                          width: 52, height: 52, fit: BoxFit.cover,
                          errorWidget: (ctx, url, err) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],

        // Video tutorial inline (YouTube se reproduce dentro de la app)
        if (hasVideo) ...[
          const SizedBox(height: 16),
          YoutubeVideoCard(videoUrl: videoUrl),
        ],
      ],
    );
  }

  static String _muscleLabel(String g) => const {
    'pecho': 'Pecho', 'espalda': 'Espalda', 'piernas': 'Piernas',
    'hombros': 'Hombros', 'brazos': 'Brazos', 'core': 'Core', 'gluteos': 'Glúteos',
  }[g] ?? g;

  static String _difficultyLabel(String d) => const {
    'principiante': 'Principiante', 'intermedio': 'Intermedio', 'avanzado': 'Avanzado',
  }[d] ?? d;

  static Color _difficultyColor(String d) {
    switch (d) {
      case 'principiante': return const Color(0xFF4ECDC4);
      case 'intermedio':   return const Color(0xFFFFB347);
      case 'avanzado':     return const Color(0xFFFF6B6B);
      default:             return const Color(0xFF4A4A5E);
    }
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label, required this.color, this.icon});
  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 12),
            const SizedBox(width: 4),
          ],
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}


