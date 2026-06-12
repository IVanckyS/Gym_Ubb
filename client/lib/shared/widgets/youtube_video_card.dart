import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/theme/app_theme.dart';

/// Tarjeta de video de YouTube con reproducción inline.
///
/// Muestra la miniatura del video (16:9) con botón de play; al tocar carga el
/// reproductor embebido dentro de la app (WebView). Si la URL no es de
/// YouTube o estamos en web, ofrece abrir el enlace externamente.
class YoutubeVideoCard extends StatefulWidget {
  final String videoUrl;

  const YoutubeVideoCard({required this.videoUrl, super.key});

  /// Extrae el ID de YouTube de URLs watch / youtu.be / shorts / embed.
  static String? extractVideoId(String url) {
    final patterns = [
      RegExp(r'[?&]v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'shorts/([a-zA-Z0-9_-]{11})'),
    ];
    for (final re in patterns) {
      final m = re.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  @override
  State<YoutubeVideoCard> createState() => _YoutubeVideoCardState();
}

class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
  WebViewController? _controller;
  bool _playing = false;

  String? get _videoId => YoutubeVideoCard.extractVideoId(widget.videoUrl);

  Future<void> _openExternal() async {
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null) return;
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw Exception('launch failed');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el video')),
        );
      }
    }
  }

  void _startPlayback() {
    final id = _videoId;
    if (id == null) return;
    // HTML propio en vez de loadRequest(embed): el iframe responsive llena el
    // viewport y el baseUrl de youtube.com evita el "Video no disponible" de
    // los embeds que restringen por origen.
    final html = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>html,body{margin:0;padding:0;background:#000;height:100%;overflow:hidden}
iframe{position:absolute;top:0;left:0;width:100%;height:100%;border:0}</style>
</head>
<body>
<iframe src="https://www.youtube.com/embed/$id?autoplay=1&playsinline=1&rel=0&modestbranding=1"
 allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe>
</body>
</html>''';
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(html, baseUrl: 'https://www.youtube.com');
    setState(() => _playing = true);
  }

  @override
  Widget build(BuildContext context) {
    final id = _videoId;

    // Sin ID de YouTube (Drive, etc.) o en Flutter web: solo enlace externo.
    if (id == null || kIsWeb) {
      return _ExternalLinkCard(url: widget.videoUrl, onTap: _openExternal);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _playing && _controller != null
            ? WebViewWidget(controller: _controller!)
            : _Thumbnail(
                videoId: id,
                onPlay: _startPlayback,
                onOpenExternal: _openExternal,
              ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String videoId;
  final VoidCallback onPlay;
  final VoidCallback onOpenExternal;

  const _Thumbnail({
    required this.videoId,
    required this.onPlay,
    required this.onOpenExternal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            fit: BoxFit.cover,
            placeholder: (_, _) => Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.accentPrimary),
              ),
            ),
            errorWidget: (_, _, _) => Container(
              color: Colors.black,
              child: const Icon(Icons.ondemand_video_rounded,
                  color: AppColors.textMuted, size: 40),
            ),
          ),
          // Oscurecer para que el botón de play resalte
          Container(color: Colors.black.withValues(alpha: 0.25)),
          Center(
            child: Container(
              width: 64,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Colors.white, size: 34),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onOpenExternal,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new_rounded,
                          color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text('YouTube',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExternalLinkCard extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  const _ExternalLinkCard({required this.url, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colorBgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.accentPrimary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentSecondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.play_circle_outline_rounded,
                  color: AppColors.accentSecondary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ver video',
                      style: TextStyle(
                          color: context.colorTextPrimary,
                          fontWeight: FontWeight.w600)),
                  Text(url,
                      style: TextStyle(
                          color: context.colorTextMuted, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded,
                color: context.colorTextMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
