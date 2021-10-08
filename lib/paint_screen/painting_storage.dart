import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PaintingStorage {
  static Future<String> get _localPath async {
    final dir = await getExternalStorageDirectory();
    return dir!.path;
  }

  static Future<File> localFile(String key) async {
    final path = await _localPath;
    return File('$path/$key.jpeg');
  }

  static Future<File> setImage(String fileName, ui.Image image) async {
    final file = await localFile(fileName);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Uint8List pngBytes = byteData!.buffer.asUint8List();
    file.writeAsBytes(byteData!.buffer.asInt8List(),flush: true);
    Uint8List _imgData = await file.readAsBytes();
    Image _image = Image.memory(_imgData);
    return file;
  }

  static Future<Image> getImage(String fileName) async {
    final file = await localFile(fileName);
    Uint8List _imgData = await file.readAsBytes();
    Image _image = Image.memory(_imgData);
    return _image;
  }

  static Future<String?> readFileAsString(String key) async {
    final file = await localFile(key);
    if (await file.exists()) {
      final contents = await file.readAsString();
      return contents;
    }
  }
}
