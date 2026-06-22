import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/hiit_models.dart';
import '../data/hiit_service.dart';

class HiitListScreen extends StatefulWidget {
  const HiitListScreen({super.key});

  @override
  State<HiitListScreen> createState() => _HiitListScreenState();
}

class _HiitListScreenState extends State<HiitListScreen> {
  List<HiitSession> _sessions = [];
  List<HiitList> _lists = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        hiitService.listSessions(limit: 5),
        hiitService.listHiitLists(),
      ]);
      if (mounted) {
        setState(() {
          _sessions = results[0] as List<HiitSession>;
          _lists = results[1] as List<HiitList>;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createList() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.colorBgSecondary,
        title: const Text('Nueva lista HIIT'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Nombre de la lista'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Crear'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (name == null || name.isEmpty || !mounted) return;
    try {
      final list = await hiitService.createHiitList(name);
      if (mounted) {
        setState(() => _lists = [list, ..._lists]);
        context.push('/hiit/lists/${list.id}');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo crear la lista')),
        );
      }
    }
  }

  static Color _modeColor(HiitMode mode) => switch (mode) {
        HiitMode.tabata => const Color(0xFFFF6B6B),
        HiitMode.emom => const Color(0xFF6C63FF),
        HiitMode.amrap => const Color(0xFF4ECDC4),
        HiitMode.forTime => const Color(0xFFFFB347),
        HiitMode.mix => const Color(0xFFEC4899),
      };

  static IconData _modeIcon(HiitMode mode) => switch (mode) {
        HiitMode.tabata => Icons.repeat_rounded,
        HiitMode.emom => Icons.schedule_rounded,
        HiitMode.amrap => Icons.loop_rounded,
        HiitMode.forTime => Icons.speed_rounded,
        HiitMode.mix => Icons.tune_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      appBar: AppBar(
        backgroundColor: context.colorBgPrimary,
        title: Text('HIIT Timer', style: Theme.of(context).textTheme.titleLarge),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Modos ──────────────────────────────────────────────────────
            Text(
              'Elige un modo',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: context.colorTextSecondary),
            ),
            const SizedBox(height: 12),
            ...HiitMode.values.map((mode) => _ModeCard(
                  mode: mode,
                  color: _modeColor(mode),
                  icon: _modeIcon(mode),
                  onTap: () => context.push('/hiit/config', extra: mode),
                )),

            const SizedBox(height: 24),

            // ── Mis Listas ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis Listas',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: context.colorTextSecondary),
                ),
                TextButton.icon(
                  onPressed: _createList,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nueva lista'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_lists.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No tienes listas aún.\nCrea una con el botón + o desde el detalle de un ejercicio.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: context.colorTextMuted),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ..._lists.map((list) => _ListCard(
                    list: list,
                    onTap: () async {
                      await context.push('/hiit/lists/${list.id}');
                      _load();
                    },
                  )),

            // ── Sesiones recientes ─────────────────────────────────────────
            if (!_loading && _sessions.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Sesiones recientes',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: context.colorTextSecondary),
              ),
              const SizedBox(height: 8),
              ..._sessions.map((s) => _SessionTile(session: s)),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Mode card ─────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final HiitMode mode;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeCard({
    required this.mode,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.colorBgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colorBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.label,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mode.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colorTextSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colorTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}

// ── List card ─────────────────────────────────────────────────────────────────

class _ListCard extends StatelessWidget {
  final HiitList list;
  final VoidCallback onTap;

  const _ListCard({required this.list, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = list.exercises.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: context.colorBgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.colorBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.playlist_play_rounded,
                  color: AppColors.accentPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$count ejercicio${count != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colorTextSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: context.colorTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Session tile ──────────────────────────────────────────────────────────────

class _SessionTile extends StatelessWidget {
  final HiitSession session;

  const _SessionTile({required this.session});

  String _fmt(int? secs) {
    if (secs == null) return '—';
    final m = secs ~/ 60;
    final s = secs % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colorBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.name,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  '${session.mode.label} · ${session.roundsCompleted} rondas · ${_fmt(session.totalDurationSeconds)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.colorTextSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
