import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../services/careers_service.dart';

/// Campo de selección de carrera con bottom sheet de búsqueda.
///
/// Muestra un toque que parece un input; al tocarlo abre un ModalBottomSheet
/// con buscador y lista filtrada de carreras desde la API.
class CareerPickerField extends StatelessWidget {
  const CareerPickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Carrera (opcional)',
    this.hint = 'Selecciona tu carrera',
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;
  final String hint;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorBgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _CareerPickerSheet(current: value),
    );

    // showModalBottomSheet retorna null tanto si el usuario cierra el sheet
    // como si elige "Sin carrera". Distinguimos usando un centinela especial.
    if (selected == _CareerPickerSheet.kClear) {
      onChanged(null);
    } else if (selected != null) {
      onChanged(selected);
    }
    // Si selected == null sin centinela (dismiss por tap fuera), no tocamos el valor.
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: context.colorBgTertiary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.school_outlined, color: context.colorTextMuted, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    hasValue ? value! : hint,
                    style: TextStyle(
                      color: hasValue
                          ? context.colorTextPrimary
                          : context.colorTextSecondary,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (hasValue)
              GestureDetector(
                onTap: () => onChanged(null),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.close, color: context.colorTextMuted, size: 18),
                ),
              )
            else
              Icon(Icons.expand_more, color: context.colorTextMuted, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet interno ──────────────────────────────────────────────────────

class _CareerPickerSheet extends StatefulWidget {
  const _CareerPickerSheet({this.current});

  final String? current;

  /// Valor centinela devuelto cuando el usuario elige "Sin carrera".
  static const kClear = '__clear__';

  @override
  State<_CareerPickerSheet> createState() => _CareerPickerSheetState();
}

class _CareerPickerSheetState extends State<_CareerPickerSheet> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _all = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_filter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final careers = await CareersService().listCareers();
      if (!mounted) return;
      setState(() {
        _all = careers;
        _filtered = careers;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudieron cargar las carreras. Intenta de nuevo.';
        _loading = false;
      });
    }
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _all
          .where((c) => (c['name'] as String).toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (ctx, scrollCtrl) => Column(
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Seleccionar carrera',
                  style: TextStyle(
                    color: context.colorTextPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: Icon(Icons.close, color: context.colorTextSecondary),
                ),
              ],
            ),
          ),

          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(color: context.colorTextPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar carrera...',
                hintStyle: TextStyle(color: context.colorTextMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: context.colorTextMuted, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Contenido principal
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accentPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          style: TextStyle(color: context.colorTextSecondary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : _filtered.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Sin resultados para "${_searchCtrl.text}"',
                              style: TextStyle(
                                  color: context.colorTextSecondary, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            controller: scrollCtrl,
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) {
                              final career = _filtered[i];
                              final name = career['name'] as String;
                              final isSelected = name == widget.current;
                              return ListTile(
                                title: Text(
                                  name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.accentPrimary
                                        : context.colorTextPrimary,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded,
                                        color: AppColors.accentPrimary, size: 18)
                                    : null,
                                onTap: () => Navigator.pop(ctx, name),
                              );
                            },
                          ),
          ),

          // Botón "Sin carrera"
          Padding(
            padding: EdgeInsets.fromLTRB(
              16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pop(ctx, _CareerPickerSheet.kClear),
                icon: Icon(Icons.clear, color: context.colorTextSecondary, size: 16),
                label: Text(
                  'Sin carrera',
                  style: TextStyle(color: context.colorTextSecondary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.colorBorder),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
