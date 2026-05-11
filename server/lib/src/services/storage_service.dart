import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Sube archivos a Cloudflare R2 (S3-compatible) usando AWS Signature V4.
/// Si las variables de entorno R2_* no están configuradas, guarda en /uploads/ local.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  String? get _accountId => Platform.environment['R2_ACCOUNT_ID'];
  String? get _accessKey => Platform.environment['R2_ACCESS_KEY_ID'];
  String? get _secretKey => Platform.environment['R2_SECRET_ACCESS_KEY'];
  String? get _bucket => Platform.environment['R2_BUCKET_NAME'];
  String? get _publicUrl => Platform.environment['R2_PUBLIC_URL'];

  bool get isConfigured {
    final vars = [_accountId, _accessKey, _secretKey, _bucket, _publicUrl];
    return vars.every((v) => v != null && v!.isNotEmpty);
  }

  /// Sube [bytes] con la clave [key] y retorna la URL pública.
  /// [key] ejemplo: "exercises/<exerciseId>/<fileId>.jpg"
  Future<String> upload(String key, List<int> bytes, String contentType) async {
    if (isConfigured) {
      return _uploadToR2(key, Uint8List.fromList(bytes), contentType);
    }
    return _saveLocally(key, bytes);
  }

  // ── R2 upload via AWS Signature V4 ───────────────────────────────────────

  Future<String> _uploadToR2(
      String key, Uint8List bytes, String contentType) async {
    final host = '$_accountId.r2.cloudflarestorage.com';

    final now = DateTime.now().toUtc();
    final dateStr = _yyyymmdd(now);
    final dateTimeStr = '${dateStr}T${_hhmmss(now)}Z';

    final payloadHex = _hex(sha256.convert(bytes).bytes);

    // Canonical headers — orden lexicográfico
    final canonicalHeaders = 'content-type:$contentType\n'
        'host:$host\n'
        'x-amz-content-sha256:$payloadHex\n'
        'x-amz-date:$dateTimeStr\n';
    const signedHeaders = 'content-type;host;x-amz-content-sha256;x-amz-date';

    final canonicalUri = '/$_bucket/$key';
    final canonicalRequest =
        'PUT\n$canonicalUri\n\n$canonicalHeaders\n$signedHeaders\n$payloadHex';

    final scope = '$dateStr/auto/s3/aws4_request';
    final stringToSign = 'AWS4-HMAC-SHA256\n$dateTimeStr\n$scope\n'
        '${_hex(sha256.convert(utf8.encode(canonicalRequest)).bytes)}';

    final signingKey = _deriveSigningKey(_secretKey!, dateStr);
    final signature =
        _hex(Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).bytes);

    final authorization = 'AWS4-HMAC-SHA256 '
        'Credential=$_accessKey/$scope, '
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    final client = HttpClient();
    try {
      final req = await client
          .putUrl(Uri.parse('https://$host/$_bucket/$key'));
      req.headers.set('Authorization', authorization);
      req.headers.set('Content-Type', contentType);
      req.headers.set('x-amz-content-sha256', payloadHex);
      req.headers.set('x-amz-date', dateTimeStr);
      req.contentLength = bytes.length;
      req.add(bytes);
      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();
      if (res.statusCode != 200) {
        throw Exception('R2 upload failed (${res.statusCode}): $body');
      }
    } finally {
      client.close();
    }

    final base = _publicUrl!.replaceAll(RegExp(r'/$'), '');
    return '$base/$key';
  }

  // ── Fallback local ────────────────────────────────────────────────────────

  Future<String> _saveLocally(String key, List<int> bytes) async {
    final file = File('/uploads/$key');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes);
    return '/uploads/$key';
  }

  // ── AWS SigV4 helpers ─────────────────────────────────────────────────────

  List<int> _deriveSigningKey(String secret, String date) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$secret'))
        .convert(utf8.encode(date))
        .bytes;
    final kRegion =
        Hmac(sha256, kDate).convert(utf8.encode('auto')).bytes;
    final kService =
        Hmac(sha256, kRegion).convert(utf8.encode('s3')).bytes;
    return Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
  }

  String _yyyymmdd(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}'
      '${dt.month.toString().padLeft(2, '0')}'
      '${dt.day.toString().padLeft(2, '0')}';

  String _hhmmss(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}'
      '${dt.minute.toString().padLeft(2, '0')}'
      '${dt.second.toString().padLeft(2, '0')}';

  String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
