// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

const _storageKey = 'entretien_chaudiere_clients_v1';

String? loadAppData() => html.window.localStorage[_storageKey];

void saveAppData(String value) {
  html.window.localStorage[_storageKey] = value;
}
