import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/body_map_data.dart';

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback? onTap;
  final bool compact;

  const ExerciseCard({
    required this.exercise,
    this.onTap,
    this.compact = false,
    super.key,
  });

  static Color _difficultyColor(String? difficulty) {
    switch (difficulty) {
      case 'principiante':
        return const Color(0xFF4ECDC4);
      case 'intermedio':
        return const Color(0xFFFFB347);
      case 'avanzado':
        return const Color(0xFFFF6B6B);
      default:
        return AppColors.textMuted;
    }
  }

  static Color _muscleGroupColor(String? group) {
    final displayName = BodyMapData.muscleGroupDisplayName[group] ?? group ?? '';
    return BodyMapData.muscleColors[displayName] ?? AppColors.accentPrimary;
  }

  static String _muscleGroupLabel(String? group) =>
      BodyMapData.muscleGroupDisplayName[group] ?? group ?? '';

  static String _muscleEmoji(String? group) {
    switch (group) {
      case 'pecho':    return '💪';
      case 'espalda':  return '🏋️';
      case 'piernas':  return '🦵';
      case 'hombros':  return '🔝';
      case 'brazos':   return '💪';
      case 'core':     return '⚡';
      case 'gluteos':  return '🍑';
      default:         return '🏃';
    }
  }

  static String _difficultyLabel(String? difficulty) {
    switch (difficulty) {
      case 'principiante':
        return 'Principiante';
      case 'intermedio':
        return 'Intermedio';
      case 'avanzado':
        return 'Avanzado';
      default:
        return difficulty ?? '';
    }
  }

  static const _isometricColor = Color(0xFF818cf8);
  static const _calisteniaColor = Color(0xFF4ECDC4);

  @override
  Widget build(BuildContext context) {
    final name = exercise['name'] as String? ?? '';
    final muscleGroup = exercise['muscleGroup'] as String?;
    final difficulty = exercise['difficulty'] as String?;
    final equipment = exercise['equipment'] as String?;
    final exerciseType = exercise['exerciseType'] as String? ?? 'dinamico';
    final isIsometric = exerciseType == 'isometrico';
    final isCalistenia = exerciseType == 'calistenia';

    final muscleColor = _muscleGroupColor(muscleGroup);
    final difficultyColor = _difficultyColor(difficulty);

    if (compact) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colorBgSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Colored accent bar
              Container(
                width: 4,
                height: 40,
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
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: _Badge(
                            label: _muscleGroupLabel(muscleGroup),
                            color: muscleColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: _Badge(
                            label: _difficultyLabel(difficulty),
                            color: difficultyColor,
                          ),
                        ),
                        if (isIsometric) ...[
                          const SizedBox(width: 6),
                          const Flexible(
                            child: _Badge(label: 'Isométrico', color: _isometricColor),
                          ),
                        ],
                        if (isCalistenia) ...[
                          const SizedBox(width: 6),
                          const Flexible(
                            child: _Badge(label: 'Calistenia', color: _calisteniaColor),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      );
    }

    final muscleEmoji = _muscleEmoji(muscleGroup);
    final imageUrl = exercise['imageUrl'] as String?;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    // Full card
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: context.colorBgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top colored bar by muscle group
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: muscleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            // Exercise image or muscle group emoji fallback
            SizedBox(
              height: 56,
              width: double.infinity,
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _EmojiPlaceholder(
                        emoji: muscleEmoji,
                        color: muscleColor,
                      ),
                      errorWidget: (_, __, ___) => _EmojiPlaceholder(
                        emoji: muscleEmoji,
                        color: muscleColor,
                      ),
                    )
                  : _EmojiPlaceholder(emoji: muscleEmoji, color: muscleColor),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row
                  Row(
                    children: [
                      Expanded(
                        child: _Badge(
                          label: _muscleGroupLabel(muscleGroup),
                          color: muscleColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _Badge(
                          label: _difficultyLabel(difficulty),
                          color: difficultyColor,
                        ),
                      ),
                      if (isIsometric) ...[
                        const SizedBox(width: 4),
                        const Expanded(
                          child: _Badge(label: 'Isométrico', color: _isometricColor),
                        ),
                      ],
                      if (isCalistenia) ...[
                        const SizedBox(width: 4),
                        const Expanded(
                          child: _Badge(label: 'Calistenia', color: _calisteniaColor),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Name
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (equipment != null && equipment.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.fitness_center,
                            size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            equipment,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiPlaceholder extends StatelessWidget {
  final String emoji;
  final Color color;

  const _EmojiPlaceholder({required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: color.withAlpha(18),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 28)),
        ),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

