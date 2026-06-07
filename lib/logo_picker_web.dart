// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<String?> pickTransparentPngLogo() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/png'
    ..multiple = false;
  input.click();

  final completer = Completer<String?>();
  input.onChange.first.then((_) {
    final file = input.files?.isEmpty ?? true ? null : input.files!.first;
    if (file == null || file.type != 'image/png') {
      completer.complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.onLoadEnd.first.then((_) {
      final result = reader.result;
      if (result is Uint8List) {
        completer.complete(base64Encode(result));
      } else if (result is ByteBuffer) {
        completer.complete(base64Encode(Uint8List.view(result)));
      } else {
        completer.complete(null);
      }
    });
    reader.readAsArrayBuffer(file);
  });

  return completer.future;
}
