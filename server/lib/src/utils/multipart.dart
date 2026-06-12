/// Parser multipart/form-data compartido (campos de texto + archivos).
/// Usado por los endpoints de subida de imágenes (ejercicios, artículos).
library;

/// Parsea un multipart/form-data muy básico (campos de texto e imagen).
List<Map<String, dynamic>> parseMultipart(
    String bodyStr, List<int> bodyBytes, String boundary) {
  final parts = <Map<String, dynamic>>[];
  final delimiter = '--$boundary';
  final sections = bodyStr.split(delimiter);

  for (final section in sections) {
    if (section.trim().isEmpty || section.trim() == '--') continue;

    final headerEnd = section.indexOf('\r\n\r\n');
    if (headerEnd == -1) continue;

    final headers = section.substring(0, headerEnd);
    final nameMatch = RegExp(r'name="([^"]+)"').firstMatch(headers);
    final filenameMatch = RegExp(r'filename="([^"]+)"').firstMatch(headers);

    if (nameMatch == null) continue;
    final name = nameMatch.group(1)!;
    final filename = filenameMatch?.group(1);

    if (filename != null) {
      // Es un archivo binario — buscar los bytes en el buffer original
      final headerMarker = '--$boundary${section.substring(0, headerEnd + 4)}';
      final startIdx = bodyStr.indexOf(headerMarker);
      if (startIdx != -1) {
        final dataStart = startIdx + headerMarker.length;
        final endMarker = '\r\n--$boundary';
        final dataEnd = bodyStr.indexOf(endMarker, dataStart);
        if (dataEnd != -1) {
          final fileBytes = bodyBytes.sublist(dataStart, dataEnd);
          parts.add({'name': name, 'filename': filename, 'bytes': fileBytes});
        }
      }
    } else {
      // Campo de texto
      final value =
          section.substring(headerEnd + 4).replaceAll(RegExp(r'\r\n$'), '');
      parts.add({'name': name, 'value': value});
    }
  }
  return parts;
}

/// Extensiones de imagen soportadas → MIME type.
const kImageMimeTypes = {
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'gif': 'image/gif',
  'webp': 'image/webp',
};
