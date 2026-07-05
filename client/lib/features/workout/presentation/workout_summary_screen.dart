import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

/// Pantalla de resumen que se muestra al finalizar una sesión.
/// Recibe el mapa de la sesión finalizada como `extra` en GoRouter.
class WorkoutSummaryScreen extends StatelessWidget {
  const WorkoutSummaryScreen({super.key, required this.session});
  final Map<String, dynamic> session;

  String _formatDuration(int? minutes) {
    if (minutes == null) return '--';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}min';
    return '${m}min';
  }

  String _formatVolume(dynamic v) {
    if (v == null) return '0 kg';
    final d = double.tryParse(v.toString()) ?? 0;
    return '${d.toStringAsFixed(1)} kg';
  }

  @override
  Widget build(BuildContext context) {
    final exercises = (session['exercises'] as List? ?? []).cast<Map<String, dynamic>>();
    final totalSets = exercises.fold<int>(0, (sum, ex) {
      final target = ex['targetSets'] as int?;
      if (target != null) return sum + target;
      return sum + ((ex['sets'] as List?)?.length ?? 0);
    });
    final completedSets = exercises.fold<int>(0, (sum, ex) {
      final sets = (ex['sets'] as List? ?? []).cast<Map<String, dynamic>>();
      return sum + sets.where((s) => s['completed'] == true).length;
    });

    final setsWithTarget = <Map<String, dynamic>>[];
    for (final ex in exercises) {
      final sets = (ex['sets'] as List? ?? []).cast<Map<String, dynamic>>();
      setsWithTarget.addAll(sets.where((s) =>
          s['completed'] == true &&
          (s['targetWeightKg'] != null ||
              s['targetReps'] != null ||
              s['targetDurationSeconds'] != null)));
    }
    final metTarget = setsWithTarget.where((s) {
      final targetW = (s['targetWeightKg'] as num?)?.toDouble();
      final targetR = s['targetReps'] as int?;
      final targetD = s['targetDurationSeconds'] as int?;
      final actualW = (s['weightKg'] as num?)?.toDouble();
      final actualR = s['reps'] as int?;
      final actualD = s['durationSeconds'] as int?;
      final weightOk = targetW == null || (actualW != null && actualW >= targetW - 0.01);
      final repsOk = targetR == null || (actualR != null && actualR >= targetR);
      final durationOk = targetD == null || (actualD != null && actualD >= targetD);
      return weightOk && repsOk && durationOk;
    }).length;
    final compliancePct = setsWithTarget.isNotEmpty
        ? ((metTarget / setsWithTarget.length) * 100).round()
        : null;

    final routineName = session['routineName'] as String?;
    final dayLabel = session['dayLabel'] as String?;

    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // ── Icono de éxito ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accentGreen,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¡Entrenamiento completado!',
                style: TextStyle(
                  color: context.colorTextPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (routineName != null || dayLabel != null) ...[
                SizedBox(height: 6),
                Text(
                  [if (routineName != null) routineName, if (dayLabel != null) dayLabel]
                      .join(' · '),
                  style: TextStyle(color: context.colorTextSecondary, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 32),

              // ── Stats ──
              Row(
                children: [
                  _StatCard(
                    icon: Icons.timer_outlined,
                    label: 'Duración',
                    value: _formatDuration(session['durationMinutes'] as int?),
                    color: AppColors.accentPrimary,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.fitness_center,
                    label: 'Volumen',
                    value: _formatVolume(session['totalVolumeKg']),
                    color: AppColors.accentSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatCard(
                    icon: Icons.sports_gymnastics,
                    label: 'Ejercicios',
                    value: '${exercises.length}',
                    color: const Color(0xFF8b5cf6),
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.check_box_rounded,
                    label: 'Series',
                    value: '$completedSets / $totalSets',
                    color: AppColors.accentGreen,
                  ),
                ],
              ),
              if (compliancePct != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    _StatCard(
                      icon: Icons.track_changes_rounded,
                      label: 'Cumplimiento del plan',
                      value: '$compliancePct%',
                      color: compliancePct >= 100
                          ? AppColors.accentGreen
                          : const Color(0xFFFFB347),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // ── Resumen por ejercicio ──
              if (exercises.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Resumen por ejercicio',
                    style: TextStyle(
                      color: context.colorTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...exercises.map((ex) => _ExerciseSummaryRow(exercise: ex)),
              ],

              const SizedBox(height: 40),

              // ── Botones ──
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accentPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Volver al inicio', style: TextStyle(fontSize: 15)),
                  onPressed: () => context.go('/home'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colorTextSecondary,
                    side: BorderSide(color: context.colorBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.history_rounded, size: 18),
                  label: const Text('Ver historial'),
                  onPressed: () => context.go('/workout/history'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colorBgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(label, style: TextStyle(color: context.colorTextSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSummaryRow extends StatelessWidget {
  const _ExerciseSummaryRow({required this.exercise});
  final Map<String, dynamic> exercise;

  @override
  Widget build(BuildContext context) {
    final name = exercise['exerciseName'] as String? ?? '';
    final sets = (exercise['sets'] as List? ?? []).cast<Map<String, dynamic>>();
    final completedSets = sets.where((s) => s['completed'] == true).toList();

    if (completedSets.isEmpty) return const SizedBox.shrink();

    final targetSets = exercise['targetSets'] as int?;
    final planWeight = completedSets
        .map((s) => (s['targetWeightKg'] as num?)?.toDouble())
        .firstWhere((w) => w != null, orElse: () => null);
    final planReps = completedSets
        .map((s) => s['targetReps'] as int?)
        .firstWhere((r) => r != null, orElse: () => null);
    final planDuration = completedSets
        .map((s) => s['targetDurationSeconds'] as int?)
        .firstWhere((d) => d != null, orElse: () => null);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              color: context.colorTextPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          if (targetSets != null && (planWeight != null || planReps != null || planDuration != null)) ...[
            SizedBox(height: 2),
            Text(
              planDuration != null
                  ? 'Plan: $targetSets×${planDuration}s'
                  : 'Plan: $targetSets×${planReps ?? '-'}'
                    '${planWeight != null ? ' @ ${planWeight.toStringAsFixed(1)} kg' : ''}',
              style: TextStyle(color: context.colorTextSecondary, fontSize: 12),
            ),
          ],
          SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: completedSets.asMap().entries.map((entry) {
              final i = entry.key + 1;
              final s = entry.value;
              final kg = s['weightKg'];
              final reps = s['reps'];
              final duration = s['durationSeconds'];
              final label = duration != null
                  ? '${duration}s'
                  : [
                      if (kg != null) '${kg}kg',
                      if (reps != null) '× $reps',
                    ].join(' ');

              final targetW = (s['targetWeightKg'] as num?)?.toDouble();
              final targetR = s['targetReps'] as int?;
              final targetD = s['targetDurationSeconds'] as int?;
              String indicator = '';
              Color chipColor = context.colorBgTertiary;
              if (targetW != null || targetR != null || targetD != null) {
                final actualW = (s['weightKg'] as num?)?.toDouble();
                final actualR = s['reps'] as int?;
                final actualD = s['durationSeconds'] as int?;
                final weightOk = targetW == null || (actualW != null && actualW >= targetW - 0.01);
                final repsOk = targetR == null || (actualR != null && actualR >= targetR);
                final durationOk = targetD == null || (actualD != null && actualD >= targetD);
                final met = weightOk && repsOk && durationOk;
                indicator = met ? ' ✓' : ' ▼';
                chipColor = (met ? AppColors.accentGreen : const Color(0xFFFFB347)).withValues(alpha: 0.15);
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'S$i: ${label.isEmpty ? '✓' : label}$indicator',
                  style: TextStyle(color: context.colorTextSecondary, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}



