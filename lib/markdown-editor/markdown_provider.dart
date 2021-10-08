import 'package:decks_app/markdown-editor/editor_storage.dart';
import 'package:flutter/material.dart';
import 'markdown_editor.dart';

class MarkdownProvider extends ChangeNotifier {
  String fileKey = '';

  void setFileKey(String key) {
    fileKey = key;
    markDownEditors = [];
    markDownEditors
        .add(MarkdownEditor('$fileKey+1', notifyListeners)..openSavedFile());
    getFileLength();
  }

  int get length => markDownEditors.length;

  List<MarkdownEditor> markDownEditors = [];

  void addEditor() {
    markDownEditors
        .add(MarkdownEditor('$fileKey+${length + 1}', notifyListeners));
    notifyListeners();
  }

  void removeEditorAt(int index) {
    markDownEditors.removeAt(index);
    for (int i = (index + 1); i < length; i++) {
      markDownEditors.elementAt(i).editorKey =
          '$fileKey+$i';
    }
    notifyListeners();
  }

  void setFileLength() {
    EditorStorage.setFileLength(fileKey, length);
  }

  void getFileLength() {
    EditorStorage.getFileLength(fileKey).then((value) {
      for (int i = 2; i <= value; i++) {
        markDownEditors.add(
            MarkdownEditor('$fileKey+$i', notifyListeners)..openSavedFile());
      }
    });
    notifyListeners();
  }
}
