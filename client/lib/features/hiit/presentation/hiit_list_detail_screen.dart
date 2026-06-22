import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/hiit_models.dart';
import '../data/hiit_service.dart';
import 'hiit_config_screen.dart';

class HiitListDetailScreen extends StatefulWidget {
  final String id;

  const HiitListDetailScreen({required this.id, super.key});

  @override
  State<HiitListDetailScreen> createState() => _HiitListDetailScreenState();
}

class _HiitListDetailScreenState extends State<HiitListDetailScreen> {
  HiitList? _list;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await hiitService.getHiitList(widget.id);
      if (mounted) setState(() { _list = list; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _renameDialog() async {
    final ctrl = TextEditingController(text: _list?.name ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colorBgSecondary,
        title: const Text('Renombrar lista'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (result == null || result.isEmpty || !mounted) return;
    await hiitService.renameHiitList(widget.id, result);
    if (mounted) {
      setState(() => _list = HiitList(
            id: _list!.id,
            name: result,
            exercises: _list!.exercises,
            createdAt: _list!.createdAt,
          ));
    }
  }

  Future<void> _deleteDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colorBgSecondary,
        title: const Text('Eliminar lista'),
        content: Text(
          '¿Eliminar "${_list?.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFFF6B6B)),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await hiitService.deleteHiitList(widget.id);
    if (mounted) context.pop();
  }

  Future<void> _addExercise() async {
    final exercise = await showModalBottomSheet<HiitExerciseRef>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const ExercisePickerSheet(),
    );
    if (exercise == null || !mounted) return;
    await hiitService.addExerciseToList(widget.id, exercise);
    await _load();
  }

  Future<void> _removeExercise(HiitExerciseRef ex) async {
    if (ex.exerciseId == null) return;
    await hiitService.removeExerciseFromList(widget.id, ex.exerciseId!);
    await _load();
  }

  void _trainWithList() {
    if (_list == null || _list!.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ejercicio a la lista')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ModePickerSheet(exercises: _list!.exercises),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      appBar: AppBar(
        backgroundColor: context.colorBgPrimary,
        title: Text(
          _list?.name ?? 'Cargando...',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          if (_list != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _renameDialog,
              tooltip: 'Renombrar',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFFFF6B6B)),
              onPressed: _deleteDialog,
              tooltip: 'Eliminar lista',
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _list == null
              ? Center(
                  child: Text(
                    'No se pudo cargar la lista',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_list!.exercises.length} ejercicio${_list!.exercises.length != 1 ? 's' : ''}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: context.colorTextSecondary),
                          ),
                          TextButton.icon(
                            onPressed: _addExercise,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Agregar ejercicio'),
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.accentPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_list!.exercises.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: Text(
                              'Sin ejercicios.\nAgrega uno con el botón de arriba.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: context.colorTextMuted),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ..._list!.exercises.map(
                        (ex) => _ExerciseListTile(
                          exercise: ex,
                          onRemove: () => _removeExercise(ex),
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _trainWithList,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Entrenar con esta lista'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accentPrimary,
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }
}

// ── Exercise tile ─────────────────────────────────────────────────────────────

class _ExerciseListTile extends StatelessWidget {
  final HiitExerciseRef exercise;
  final VoidCallback onRemove;

  const _ExerciseListTile({required this.exercise, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colorBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: exercise.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: exercise.imageUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const _Placeholder(),
                    errorWidget: (context, url, error) => const _Placeholder(),
                  )
                : const _Placeholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              exercise.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Color(0xFFFF6B6B)),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        color: context.colorBgTertiary,
        child: Icon(
          Icons.fitness_center_rounded,
          color: context.colorTextMuted,
          size: 20,
        ),
      );
}

// ── Mode picker bottom sheet ──────────────────────────────────────────────────

class _ModePickerSheet extends StatelessWidget {
  final List<HiitExerciseRef> exercises;

  const _ModePickerSheet({required this.exercises});

  static Color _color(HiitMode mode) => switch (mode) {
        HiitMode.tabata => const Color(0xFFFF6B6B),
        HiitMode.emom => const Color(0xFF6C63FF),
        HiitMode.amrap => const Color(0xFF4ECDC4),
        HiitMode.forTime => const Color(0xFFFFB347),
        HiitMode.mix => const Color(0xFFEC4899),
      };

  static IconData _icon(HiitMode mode) => switch (mode) {
        HiitMode.tabata => Icons.repeat_rounded,
        HiitMode.emom => Icons.schedule_rounded,
        HiitMode.amrap => Icons.loop_rounded,
        HiitMode.forTime => Icons.speed_rounded,
        HiitMode.mix => Icons.tune_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Elige un modo', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...HiitMode.values.map(
            (mode) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _color(mode).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon(mode), color: _color(mode), size: 20),
              ),
              title: Text(
                mode.label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                mode.description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: context.colorTextSecondary),
              ),
              onTap: () {
                Navigator.pop(context);
                context.push('/hiit/config', extra: {
                  'mode': mode,
                  'exercises': exercises,
                });
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
