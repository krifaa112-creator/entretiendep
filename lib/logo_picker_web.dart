// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

Future<String?> pickTransparentPngLogo() async {
  final input = html.FileUploadInputElement()
    ..accept = 'image/png,.png'
    ..multiple = false;
  final completer = Completer<String?>();

  void finish(String? value) {
    if (!completer.isCompleted) {
      completer.complete(value);
    }
    input.remove();
  }

  input.onChange.first.then((_) {
    final file = input.files?.isEmpty ?? true ? null : input.files!.first;
    final fileName = file?.name.toLowerCase() ?? '';
    final fileType = file?.type.toLowerCase() ?? '';
    final isPng = fileName.endsWith('.png') || fileType == 'image/png';
    if (file == null || !isPng) {
      finish(null);
      return;
    }

    final reader = html.FileReader();
    reader.onLoadEnd.first.then((_) {
      final result = reader.result;
      if (result is String && result.startsWith('data:')) {
        const marker = 'base64,';
        final base64Start = result.indexOf(marker);
        finish(base64Start == -1
            ? null
            : result.substring(base64Start + marker.length));
      } else if (result is Uint8List) {
        finish(base64Encode(result));
      } else if (result is ByteBuffer) {
        finish(base64Encode(Uint8List.view(result)));
      } else {
        finish(null);
      }
    });
    reader.onError.first.then((_) => finish(null));
    reader.readAsDataUrl(file);
  }, onError: (_) => finish(null));

  html.document.body?.append(input);
  input.click();

  return completer.future.timeout(const Duration(seconds: 30), onTimeout: () {
    finish(null);
    return null;
  });
}
