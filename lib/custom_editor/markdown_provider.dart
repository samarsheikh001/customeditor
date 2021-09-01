import 'package:flutter/cupertino.dart';

import 'custom_markdown_provider.dart';

class MarkDownProvider extends ChangeNotifier {
  MarkDownProvider(this.pages) {
    for (int i = 0; i <= pages; i++) {
      markDownEditors.add(MarkdownEditor('fileKey+$i', notifyListeners));
    }
  }
  int pages;

  List<MarkdownEditor> markDownEditors = [];
}
