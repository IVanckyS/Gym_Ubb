import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart' as du;
import '../../../shared/services/role_requests_service.dart';

class RoleRequestsScreen extends StatefulWidget {
  const RoleRequestsScreen({super.key});

  @override
  State<RoleRequestsScreen> createState() => _RoleRequestsScreenState();
}

class _RoleRequestsScreenState extends State<RoleRequestsScreen> {
  final _service = RoleRequestsService();
  List<Map<String, dynamic>> _requests = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final requests = await _service.list(status: 'pending');
      if (!mounted) return;
      setState(() {
        _requests = requests;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _approve(Map<String, dynamic> req) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Aprobar solicitud'),
        content: Text(
            '${req['userName']} pasará a tener rol Profesor y podrá crear ejercicios y contenido. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await _service.approve(req['id'] as String);
      messenger.showSnackBar(
        SnackBar(content: Text('${req['userName']} ahora es Profesor')),
      );
      _load();
    } on RoleRequestsException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      _load();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      _load();
    }
  }

  Future<void> _reject(Map<String, dynamic> req) async {
    final ctrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rechazar solicitud'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rechazar la solicitud de ${req['userName']}.'),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Comentario (opcional)',
                hintText: 'Motivo del rechazo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentSecondary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      ctrl.dispose();
      return;
    }

    final comment = ctrl.text.trim();
    ctrl.dispose();

    final messenger = ScaffoldMessenger.of(context);
    try {
      await _service.reject(req['id'] as String, comment: comment);
      messenger.showSnackBar(const SnackBar(content: Text('Solicitud rechazada')));
      _load();
    } on RoleRequestsException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      _load();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      appBar: AppBar(
        title: const Text('Solicitudes de rol'),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Inicio',
          onPressed: () => context.go('/home'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Icon(Icons.error_outline, size: 48, color: context.colorTextMuted),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'No se pudieron cargar las solicitudes',
              style: TextStyle(color: context.colorTextSecondary),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: _load,
              child: const Text('Reintentar'),
            ),
          ),
        ],
      );
    }
    if (_requests.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Icon(Icons.inbox_outlined,
              size: 48, color: context.colorTextMuted),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'No hay solicitudes pendientes',
              style: TextStyle(color: context.colorTextSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _requests.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _RequestCard(
        request: _requests[i],
        onApprove: () => _approve(_requests[i]),
        onReject: () => _reject(_requests[i]),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final Map<String, dynamic> request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final createdAt = request['createdAt'] as String?;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorBgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request['userName'] as String? ?? '',
            style: TextStyle(
              color: context.colorTextPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            request['userEmail'] as String? ?? '',
            style: TextStyle(color: context.colorTextMuted, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            request['justification'] as String? ?? '',
            style:
                TextStyle(color: context.colorTextSecondary, fontSize: 14),
          ),
          if (createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              du.formatDate(createdAt),
              style: TextStyle(color: context.colorTextMuted, fontSize: 12),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentSecondary,
                    side: BorderSide(
                        color:
                            AppColors.accentSecondary.withValues(alpha: 0.5)),
                  ),
                  onPressed: onReject,
                  child: const Text('Rechazar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accentGreen),
                  onPressed: onApprove,
                  child: const Text('Aprobar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
