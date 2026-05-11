import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../shared/services/articles_service.dart';

Color _categoryColor(String key) => switch (key) {
      'biomecanica' => const Color(0xFF3B82F6),
      'nutricion' => const Color(0xFF22C55E),
      'prevencion' => const Color(0xFFF97316),
      'pausas_activas' => const Color(0xFF4ECDC4),
      'recuperacion' => const Color(0xFF8B5CF6),
      'salud_mental' => const Color(0xFFEC4899),
      _ => AppColors.accentPrimary,
    };

String _categoryLabel(String key) => switch (key) {
      'biomecanica' => 'Biomecánica',
      'nutricion' => 'Nutrición',
      'prevencion' => 'Prevención',
      'pausas_activas' => 'Pausas activas',
      'recuperacion' => 'Recuperación',
      'salud_mental' => 'Salud mental',
      _ => key,
    };

class ArticleDetailScreen extends StatefulWidget {
  final String id;
  const ArticleDetailScreen({super.key, required this.id});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final _service = ArticlesService();
  Map<String, dynamic>? _article;
  bool _loading = true;
  String _error = '';
  bool _togglingFav = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = ''; });
    try {
      final article = await _service.getArticle(widget.id);
      if (mounted) setState(() { _article = article; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_togglingFav || _article == null) return;
    setState(() => _togglingFav = true);
    try {
      final isFav = await _service.toggleFavorite(widget.id);
      if (mounted) {
        setState(() {
          _article!['isFavorite'] = isFav;
          _togglingFav = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _togglingFav = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accentSecondary),
        );
      }
    }
  }

  Future<void> _deactivate() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        title: const Text('Desactivar artículo',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'El artículo dejará de ser visible para los usuarios. ¿Continuar?',
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
      await _service.deactivateArticle(widget.id);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.accentSecondary),
        );
      }
    }
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditArticleSheet(
        article: _article!,
        service: _service,
        onSaved: (updated) => setState(() => _article = {..._article!, ...updated}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.colorBgPrimary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentPrimary),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        backgroundColor: context.colorBgPrimary,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
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
              SizedBox(height: 16),
              TextButton(onPressed: _load, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }

    final article = _article!;
    final category = article['category'] as String? ?? '';
    final color = _categoryColor(category);
    final isFav = article['isFavorite'] as bool? ?? false;
    final readTime = article['readTimeMinutes'] as int?;
    final author = article['author'] as Map<String, dynamic>?;
    final tags = (article['tags'] as List?)?.cast<String>() ?? [];
    final bibliography = article['bibliography'] as String?;

    final authUser = context.read<AuthProvider>().user;
    final role = authUser?['role'] as String? ?? '';
    final userId = authUser?['id'] as String? ?? '';
    final authorId = author?['id'] as String? ?? '';
    final canEdit = role == 'admin' || userId == authorId;
    final canDeactivate = role == 'admin';

    return Scaffold(
      backgroundColor: context.colorBgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: article['imageUrl'] != null ? 220 : 120,
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
                icon: _togglingFav
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentPrimary,
                        ),
                      )
                    : Icon(
                        isFav ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isFav ? AppColors.accentPrimary : context.colorTextSecondary,
                      ),
                onPressed: _toggleFavorite,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: article['imageUrl'] != null
                  ? Image.network(
                      article['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _HeaderBanner(color: color),
                    )
                  : _HeaderBanner(color: color),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withAlpha(80)),
                    ),
                    child: Text(
                      _categoryLabel(category),
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    article['title'] as String? ?? '',
                    style: TextStyle(
                      color: context.colorTextPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Meta row
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      if (author != null)
                        _MetaChip(
                          icon: Icons.person_outline_rounded,
                          label: author['name'] as String? ?? '',
                        ),
                      if (author?['faculty'] != null)
                        _MetaChip(
                          icon: Icons.school_rounded,
                          label: author!['faculty'] as String,
                        ),
                      if (readTime != null)
                        _MetaChip(
                          icon: Icons.schedule_rounded,
                          label: '$readTime min de lectura',
                        ),
                    ],
                  ),

                  // Tags
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: tags
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.colorBgTertiary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: context.colorBorder),
                              ),
                              child: Text(
                                '#$t',
                                style: TextStyle(
                                  color: context.colorTextSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Divider(color: context.colorBorder),
                  const SizedBox(height: 20),

                  // Content
                  if (article['content'] != null)
                    Text(
                      article['content'] as String,
                      style: TextStyle(
                        color: context.colorTextPrimary,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),

                  // Bibliography
                  if (bibliography != null && bibliography.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Divider(color: context.colorBorder),
                    const SizedBox(height: 16),
                    Text(
                      'Bibliografía',
                      style: TextStyle(
                        color: context.colorTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bibliography,
                      style: TextStyle(
                        color: context.colorTextSecondary,
                        fontSize: 13,
                        height: 1.6,
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
}

// ── Static widgets ──────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  final Color color;
  const _HeaderBanner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withAlpha(40),
      alignment: Alignment.center,
      child: Icon(Icons.article_rounded, size: 56, color: color),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.colorTextMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: context.colorTextMuted, fontSize: 13),
        ),
      ],
    );
  }
}

// ── Edit sheet ───────────────────────────────────────────────────────────────

class _EditArticleSheet extends StatefulWidget {
  final Map<String, dynamic> article;
  final ArticlesService service;
  final void Function(Map<String, dynamic>) onSaved;
  const _EditArticleSheet({
    required this.article,
    required this.service,
    required this.onSaved,
  });

  @override
  State<_EditArticleSheet> createState() => _EditArticleSheetState();
}

class _EditArticleSheetState extends State<_EditArticleSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _excerptCtrl;
  late final TextEditingController _contentCtrl;
  late final TextEditingController _tagsCtrl;
  late final TextEditingController _bibliographyCtrl;
  late String _category;
  late bool _publish;
  bool _saving = false;

  static const _categories = [
    ('biomecanica', 'Biomecánica'),
    ('nutricion', 'Nutrición'),
    ('prevencion', 'Prevención'),
    ('pausas_activas', 'Pausas activas'),
    ('recuperacion', 'Recuperación'),
    ('salud_mental', 'Salud mental'),
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.article;
    _titleCtrl = TextEditingController(text: a['title'] as String? ?? '');
    _excerptCtrl = TextEditingController(text: a['excerpt'] as String? ?? '');
    _contentCtrl = TextEditingController(text: a['content'] as String? ?? '');
    final tags = (a['tags'] as List?)?.cast<String>() ?? [];
    _tagsCtrl = TextEditingController(text: tags.join(', '));
    _bibliographyCtrl = TextEditingController(text: a['bibliography'] as String? ?? '');
    final rawCat = (a['category'] as String? ?? 'biomecanica').toLowerCase();
    const validCats = ['biomecanica', 'nutricion', 'prevencion', 'pausas_activas', 'recuperacion', 'salud_mental'];
    _category = validCats.contains(rawCat) ? rawCat : 'biomecanica';
    _publish = a['isPublished'] as bool? ?? false;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _excerptCtrl.dispose();
    _contentCtrl.dispose();
    _tagsCtrl.dispose();
    _bibliographyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty || _contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Título y contenido son obligatorios'),
          backgroundColor: AppColors.accentSecondary,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final tags = _tagsCtrl.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      final updated = await widget.service.updateArticle(
        widget.article['id'] as String,
        title: _titleCtrl.text.trim(),
        category: _category,
        content: _contentCtrl.text.trim(),
        excerpt: _excerptCtrl.text.trim(),
        tags: tags,
        bibliography: _bibliographyCtrl.text.trim(),
        publish: _publish,
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
                      'Editar artículo',
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
                  _SheetField(controller: _titleCtrl, hint: 'Título del artículo'),
                  const SizedBox(height: 16),
                  _SheetLabel('Categoría'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.colorBgTertiary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: context.colorBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _category,
                        isExpanded: true,
                        dropdownColor: context.colorBgSecondary,
                        style: TextStyle(
                            color: context.colorTextPrimary, fontSize: 14),
                        onChanged: (v) => setState(() => _category = v!),
                        items: _categories
                            .map((c) => DropdownMenuItem(
                                  value: c.$1,
                                  child: Text(c.$2),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Extracto (opcional)'),
                  _SheetField(
                    controller: _excerptCtrl,
                    hint: 'Breve resumen del artículo',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Contenido'),
                  _SheetField(
                    controller: _contentCtrl,
                    hint: 'Contenido completo...',
                    maxLines: 10,
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Etiquetas (separadas por coma)'),
                  _SheetField(
                    controller: _tagsCtrl,
                    hint: 'ej: espalda, postura, biomecánica',
                  ),
                  const SizedBox(height: 16),
                  _SheetLabel('Bibliografía (opcional)'),
                  _SheetField(
                    controller: _bibliographyCtrl,
                    hint: 'Referencias y fuentes...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Publicado',
                          style: TextStyle(
                              color: context.colorTextPrimary, fontSize: 14),
                        ),
                      ),
                      Switch(
                        value: _publish,
                        onChanged: (v) => setState(() => _publish = v),
                        activeThumbColor: AppColors.accentPrimary,
                      ),
                    ],
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

// ── Sheet helpers (file-private) ─────────────────────────────────────────────

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
  const _SheetField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        maxLines: maxLines,
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
