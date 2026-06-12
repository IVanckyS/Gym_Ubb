import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/events_service.dart';
import '../../../shared/widgets/location_search_field.dart';

Color _typeColor(String type) => switch (type.toLowerCase()) {
      'competencia' || 'torneo' => const Color(0xFFFF6B6B),
      'charla' || 'conferencia' => const Color(0xFF3B82F6),
      'taller' || 'workshop' => const Color(0xFF22C55E),
      'jornada' => const Color(0xFFF97316),
      _ => AppColors.accentPrimary,
    };

String _formatEventDate(String? dateStr, String? timeStr) {
  if (dateStr == null) return '';
  try {
    final date = DateTime.parse(dateStr);
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    final months = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    final day = days[date.weekday - 1];
    final time = timeStr != null ? ' a las ${timeStr.substring(0, 5)}' : '';
    return '$day ${date.day} de ${months[date.month]} de ${date.year}$time';
  } catch (_) {
    return dateStr;
  }
}

class EventDetailScreen extends StatefulWidget {
  final String id;
  const EventDetailScreen({super.key, required this.id});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _service = EventsService();
  Map<String, dynamic>? _event;
  bool _loading = true;
  String _error = '';
  bool _togglingInterest = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final event = await _service.getEvent(widget.id);
      if (mounted) setState(() { _event = event; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _toggleInterest() async {
    if (_togglingInterest || _event == null) return;
    setState(() => _togglingInterest = true);
    try {
      final result = await _service.toggleInterest(widget.id);
      if (mounted) {
        setState(() {
          _event!['isInterested'] = result['isInterested'];
          _event!['interestCount'] = result['interestCount'];
          _togglingInterest = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _togglingInterest = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.accentSecondary,
          ),
        );
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    // No usar canLaunchUrl como guard: en Android 11+ devuelve false si el
    // manifest no declara el intent y el botón falla en silencio.
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw Exception('launch failed');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace')),
        );
      }
    }
  }

  Future<void> _openMaps(String location) async {
    final encoded = Uri.encodeComponent(location);
    // URL oficial de Google Maps (abre la app en Android si está instalada)
    await _openUrl('https://www.google.com/maps/search/?api=1&query=$encoded');
  }

  Future<void> _deactivate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Desactivar evento',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'El evento dejará de ser visible para los usuarios. ¿Continuar?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Desactivar',
                style: TextStyle(color: AppColors.accentSecondary)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      await _service.deactivateEvent(widget.id);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppColors.accentSecondary),
        );
      }
    }
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditEventSheet(
        event: _event!,
        service: _service,
        onSaved: (updated) => setState(() => _event = {..._event!, ...updated}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.colorBgPrimary,
        appBar: _simpleAppBar(context),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentPrimary),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        backgroundColor: context.colorBgPrimary,
        appBar: _simpleAppBar(context),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.accentSecondary),
              SizedBox(height: 12),
              Text(_error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colorTextSecondary)),
              const SizedBox(height: 16),
              TextButton(onPressed: _load, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }

    final event = _event!;
    final type = event['type'] as String? ?? '';
    final color = _typeColor(type);
    final isInterested = event['isInterested'] as bool? ?? false;
    final interestCount = event['interestCount'] as int? ?? 0;
    final maxP = event['maxParticipants'] as int?;
    final regUrl = event['registrationUrl'] as String?;
    final location = event['location'] as String?;
    final dateStr = _formatEventDate(
      event['eventDate'] as String?,
      event['eventTime'] as String?,
    );

    final authUser = context.read<AuthProvider>().user;
    final role = authUser?['role'] as String? ?? '';
    final userId = authUser?['id'] as String? ?? '';
    final creatorId = event['creatorId'] as String? ?? '';
    final canEdit = role == 'admin' || userId == creatorId;
    final canDeactivate = role == 'admin';

    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: event['imageUrl'] != null ? 200 : 110,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (canEdit)
                IconButton(
                  icon: Icon(Icons.edit_rounded, color: context.colorTextSecondary),
                  onPressed: _showEditSheet,
                ),
              if (canDeactivate)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppColors.accentSecondary),
                  onPressed: _deactivate,
                ),
              IconButton(
                icon: _togglingInterest
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFEAB308),
                        ),
                      )
                    : Icon(
                        isInterested ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isInterested
                            ? const Color(0xFFEAB308)
                            : context.colorTextSecondary,
                      ),
                onPressed: _toggleInterest,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: event['imageUrl'] != null
                  ? Image.network(
                      event['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _Banner(color: color),
                    )
                  : _Banner(color: color),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withAlpha(80)),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    event['title'] as String? ?? '',
                    style: TextStyle(
                      color: context.colorTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info cards
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    color: AppColors.accentPrimary,
                    label: 'Fecha',
                    value: dateStr.isNotEmpty ? dateStr : 'Por confirmar',
                  ),
                  if (location != null) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      color: AppColors.accentSecondary,
                      label: 'Lugar',
                      value: location,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 48),
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.accentPrimary,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 28),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _openMaps(location),
                        icon: const Icon(Icons.open_in_new_rounded, size: 13),
                        label: const Text('Abrir en Google Maps',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.people_outline_rounded,
                    color: AppColors.accentGreen,
                    label: 'Interesados',
                    value: maxP != null
                        ? '$interestCount de $maxP cupos'
                        : '$interestCount personas interesadas',
                  ),

                  if (event['description'] != null) ...[
                    const SizedBox(height: 24),
                    Divider(color: context.colorBorder),
                    const SizedBox(height: 16),
                    Text(
                      'Descripción',
                      style: TextStyle(
                        color: context.colorTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      event['description'] as String,
                      style: TextStyle(
                        color: context.colorTextSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],

                  const SizedBox(height: 28),

                  // Interest button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _togglingInterest ? null : _toggleInterest,
                      icon: Icon(
                        isInterested ? Icons.star_rounded : Icons.star_border_rounded,
                        color: isInterested
                            ? const Color(0xFFEAB308)
                            : context.colorTextSecondary,
                      ),
                      label: Text(
                        isInterested ? 'Ya me interesa' : 'Me interesa',
                        style: TextStyle(
                          color: isInterested
                              ? const Color(0xFFEAB308)
                              : context.colorTextSecondary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isInterested
                              ? const Color(0xFFEAB308)
                              : context.colorBorder,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Registration button
                  if (regUrl != null && regUrl.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openUrl(regUrl),
                        icon: const Icon(Icons.open_in_new_rounded, size: 18),
                        label: const Text('Inscribirse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _simpleAppBar(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      );
}

// ── Static widgets ────────────────────────────────────────────────────────────

class _Banner extends StatelessWidget {
  final Color color;
  const _Banner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withAlpha(40),
      alignment: Alignment.center,
      child: Icon(Icons.event_rounded, size: 52, color: color),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: context.colorTextMuted,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: context.colorTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Edit sheet ────────────────────────────────────────────────────────────────

class _EditEventSheet extends StatefulWidget {
  final Map<String, dynamic> event;
  final EventsService service;
  final void Function(Map<String, dynamic>) onSaved;
  const _EditEventSheet({
    required this.event,
    required this.service,
    required this.onSaved,
  });

  @override
  State<_EditEventSheet> createState() => _EditEventSheetState();
}

class _EditEventSheetState extends State<_EditEventSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _maxParticipantsCtrl;
  late final TextEditingController _regUrlCtrl;
  late String _type;
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _saving = false;

  static const _types = [
    'competencia',
    'torneo',
    'charla',
    'conferencia',
    'taller',
    'jornada',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.event;
    _titleCtrl = TextEditingController(text: e['title'] as String? ?? '');
    _locationCtrl = TextEditingController(text: e['location'] as String? ?? '');
    _descriptionCtrl =
        TextEditingController(text: e['description'] as String? ?? '');
    _maxParticipantsCtrl = TextEditingController(
      text: e['maxParticipants'] != null ? '${e['maxParticipants']}' : '',
    );
    _regUrlCtrl =
        TextEditingController(text: e['registrationUrl'] as String? ?? '');
    final rawType = ((e['type'] as String?) ?? 'charla').toLowerCase();
    _type = _types.contains(rawType) ? rawType : 'charla';
    final dateStr = e['eventDate'] as String?;
    if (dateStr != null) {
      try {
        _selectedDate = DateTime.parse(dateStr);
      } catch (_) {}
    }
    final timeStr = e['eventTime'] as String?;
    if (timeStr != null && timeStr.length >= 5) {
      _selectedTime = timeStr.substring(0, 5);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _maxParticipantsCtrl.dispose();
    _regUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.accentPrimary,
            surface: AppColors.bgSecondary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    TimeOfDay? initial;
    if (_selectedTime != null) {
      final parts = _selectedTime!.split(':');
      initial = TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: initial ?? TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.dark(
            primary: AppColors.accentPrimary,
            surface: AppColors.bgSecondary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El título es obligatorio'),
          backgroundColor: AppColors.accentSecondary,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final updated = await widget.service.updateEvent(
        widget.event['id'] as String,
        title: _titleCtrl.text.trim(),
        type: _type,
        eventDate: _selectedDate != null
            ? '${_selectedDate!.year}-'
                '${_selectedDate!.month.toString().padLeft(2, '0')}-'
                '${_selectedDate!.day.toString().padLeft(2, '0')}'
            : null,
        eventTime: _selectedTime,
        location: _locationCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        maxParticipants: int.tryParse(_maxParticipantsCtrl.text.trim()),
        registrationUrl: _regUrlCtrl.text.trim(),
      );
      widget.onSaved(updated);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.accentSecondary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      '', 'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    final dateLabel = _selectedDate != null
        ? '${_selectedDate!.day} ${months[_selectedDate!.month]} ${_selectedDate!.year}'
        : 'Seleccionar fecha';
    final timeLabel = _selectedTime ?? 'Seleccionar hora (opcional)';

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: context.colorBgSecondary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorTextMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Editar evento',
                      style: TextStyle(
                        color: context.colorTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (_saving)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.accentPrimary),
                    )
                  else
                    TextButton(
                      onPressed: _save,
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                            color: AppColors.accentPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  _SheetLabel('Título'),
                  _SheetField(controller: _titleCtrl, hint: 'Título del evento'),
                  const SizedBox(height: 16),
                  _SheetLabel('Tipo'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorBgTertiary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.colorBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _type,
                        isExpanded: true,
                        dropdownColor: context.colorBgSecondary,
                        style: TextStyle(
                            color: context.colorTextPrimary, fontSize: 14),
                        onChanged: (v) => setState(() => _type = v!),
                        items: _types
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(
                                    t[0].toUpperCase() + t.substring(1),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Fecha'),
                  _PickerButton(
                    icon: Icons.calendar_today_rounded,
                    label: dateLabel,
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  _SheetLabel('Hora'),
                  Row(
                    children: [
                      Expanded(
                        child: _PickerButton(
                          icon: Icons.access_time_rounded,
                          label: timeLabel,
                          onTap: _pickTime,
                        ),
                      ),
                      if (_selectedTime != null) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: context.colorTextMuted, size: 20),
                          onPressed: () => setState(() => _selectedTime = null),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Lugar'),
                  // Búsqueda de dirección exacta (OSM) + verificación en Maps
                  LocationSearchField(
                    controller: _locationCtrl,
                    label: 'Lugar',
                    hint: 'ej: Gimnasio UBB, Concepción',
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Descripción (opcional)'),
                  _SheetField(
                    controller: _descriptionCtrl,
                    hint: 'Detalles del evento...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Cupos máximos (opcional)'),
                  _SheetField(
                    controller: _maxParticipantsCtrl,
                    hint: 'ej: 50',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('URL de inscripción (opcional)'),
                  _SheetField(
                    controller: _regUrlCtrl,
                    hint: 'https://...',
                    keyboardType: TextInputType.url,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sheet helpers (file-private) ──────────────────────────────────────────────

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: TextStyle(
            color: context.colorTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  const _SheetField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(color: context.colorTextPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: context.colorTextMuted, fontSize: 14),
          filled: true,
          fillColor: context.colorBgTertiary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.colorBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: context.colorBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.accentPrimary),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      );
}

class _PickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: context.colorBgTertiary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.colorBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: context.colorTextMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: context.colorTextPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
