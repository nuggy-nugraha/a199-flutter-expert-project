import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Provide a fake AssetManifest so that google_fonts doesn't throw
  // when checking local assets in the test environment.
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        if (message == null) return null;
        final String key = utf8.decode(message.buffer.asUint8List());
        if (key == 'AssetManifest.json') {
          final encoded = utf8.encode(json.encode(<String, dynamic>{}));
          return ByteData.sublistView(Uint8List.fromList(encoded));
        }
        if (key == 'AssetManifest.bin') {
          // Return a StandardMessageCodec-encoded empty map (not ByteData(0))
          const StandardMessageCodec codec = StandardMessageCodec();
          return codec.encodeMessage(<String, dynamic>{});
        }
        return null;
      });

  await testMain();
}
