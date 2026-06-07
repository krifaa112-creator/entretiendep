// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:typed_data';

Future<void> savePdfBytes(List<int> bytes, String fileName) async {
  final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download = fileName
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> openEmailDraft({
  required String to,
  required String subject,
  required String body,
}) async {
  final uri = Uri(
    scheme: 'mailto',
    path: to,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );
  html.window.open(uri.toString(), '_blank');
}
