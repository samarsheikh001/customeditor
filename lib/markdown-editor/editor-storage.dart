import 'dart:io';

import 'package:path_provider/path_provider.dart';

class EditorStorage {
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> localFile(String key) async {
    final path = await _localPath;
    return File('$path/$key');
  }

  Future<File> writeToFileAsString(String key, String content) async {
    final file = await localFile(key);
    return file.writeAsString(content);
  }

  Future<String> readFileAsString(String key) async {
    try {
      final file = await localFile(key);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }
}
