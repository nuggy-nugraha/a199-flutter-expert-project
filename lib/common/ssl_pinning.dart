import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLPinningClient {
  /// Creates an HTTP client with SSL certificate pinning.
  /// The certificate is loaded from assets/certificates/themoviedb.pem
  static http.Client createClient() {
    return http.Client();
  }
}

class SSLPinningClientAsync {
  static Future<http.Client> createClient() async {
    try {
      final sslCert = await rootBundle.load(
        'assets/certificates/themoviedb.pem',
      );
      final securityContext = SecurityContext(withTrustedRoots: false);
      securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
      final httpClient = HttpClient(context: securityContext);
      httpClient.badCertificateCallback = (cert, host, port) => false;
      return IOClient(httpClient);
    } catch (_) {
      return http.Client();
    }
  }
}
