import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';

/// Campo de ubicación con búsqueda de direcciones reales.
///
/// Busca lugares vía Nominatim (OpenStreetMap — gratis, sin API key) con
/// resultados priorizados en Chile, y permite verificar la dirección elegida
/// en Google Maps. El texto seleccionado queda en [controller].
class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const LocationSearchField({
    required this.controller,
    this.label = 'Lugar (opcional)',
    this.hint = 'Buscar dirección o lugar…',
    super.key,
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  Timer? _debounce;
  List<String> _results = [];
  bool _searching = false;
  // Evita re-buscar cuando el cambio de texto viene de elegir un resultado
  bool _suppressSearch = false;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String q) {
    if (_suppressSearch) {
      _suppressSearch = false;
      return;
    }
    _debounce?.cancel();
    if (q.trim().length < 3) {
      setState(() {
        _results = [];
        _searching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () => _search(q));
  }

  Future<void> _search(String q) async {
    if (!mounted) return;
    setState(() => _searching = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': q.trim(),
        'format': 'json',
        'limit': '6',
        'countrycodes': 'cl',
        'accept-language': 'es',
      });
      // Nominatim exige identificar la app en el User-Agent
      final res = await http.get(uri, headers: {
        'User-Agent': 'GymUBB-app-tesis/1.0 (contacto: gimnasio UBB)',
      }).timeout(const Duration(seconds: 8));
      if (!mounted) return;
      if (res.statusCode != 200) {
        setState(() => _searching = false);
        return;
      }
      final list = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
      setState(() {
        _results = list
            .map((r) => _shorten(r['display_name'] as String? ?? ''))
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList();
        _searching = false;
      });
    } catch (_) {
      if (mounted) setState(() => _searching = false);
    }
  }

  /// Nominatim devuelve direcciones muy largas; nos quedamos con las
  /// primeras partes relevantes (lugar, calle, comuna/ciudad).
  static String _shorten(String displayName) {
    final parts = displayName.split(',').map((p) => p.trim()).toList();
    return parts.take(4).join(', ');
  }

  void _select(String value) {
    _suppressSearch = true;
    widget.controller.text = value;
    setState(() => _results = []);
    FocusScope.of(context).unfocus();
  }

  Future<void> _openInMaps() async {
    final q = widget.controller.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Escribe o busca primero el lugar del evento')),
      );
      return;
    }
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(q)}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          onChanged: _onChanged,
          style: TextStyle(color: context.colorTextPrimary),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.accentPrimary),
                    ),
                  )
                : const Icon(Icons.location_on_outlined),
            suffixIcon: Tooltip(
              message: 'Verificar en Google Maps',
              child: IconButton(
                icon: const Icon(Icons.map_outlined,
                    color: AppColors.accentPrimary),
                onPressed: _openInMaps,
              ),
            ),
          ),
        ),
        if (_results.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: context.colorBgTertiary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.colorBorder),
            ),
            child: Column(
              children: _results
                  .map((r) => InkWell(
                        onTap: () => _select(r),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.place_rounded,
                                  size: 16, color: AppColors.accentPrimary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  r,
                                  style: TextStyle(
                                      color: context.colorTextPrimary,
                                      fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        if (_results.isEmpty && !_searching)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'Escribe al menos 3 letras para buscar la dirección exacta',
              style: TextStyle(color: context.colorTextMuted, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
