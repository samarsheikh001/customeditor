import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class EditorStorage {
  static Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> localFile(String key) async {
    final path = await _localPath;
    return File('$path/$key');
  }

  static Future<File> writeToFileAsString(String key, String content) async {
    final file = await localFile(key);
    return file.writeAsString(content);
  }

  static Future<int> getFileLength(String fileKey) async {
    final file = await localFile(fileKey);
    if (!await file.exists()) return 1;
    final content = await file.readAsString();
    return int.parse(content);
  }

  static void setFileLength(String fileKey, int length) async {
    final file = await localFile(fileKey);
    await file.writeAsString(length.toString());
  }

  static Future<String> readFileAsString(String key) async {
    try {
      final file = await localFile(key);
      if (await file.exists()) {
        final contents = await file.readAsString();
        // print('debug'*30);
        // print(contents);
        return contents;
      } else {
        Map _map = {
          'imageSrcs': [],
          'textFields': [''],
          'boldChars': [[]],
          'italicChars': [[]]
        };
        // print('debug'*30);
        // print(_map);
        return json.encode(_map);
      }
    } catch (e) {
      throw Error();
    }
  }
}
