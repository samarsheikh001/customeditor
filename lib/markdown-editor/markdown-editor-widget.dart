import 'package:custommarkdowneditor/markdown-editor/markdown-provider.dart';
import 'package:custommarkdowneditor/markdown-editor/markdown-toolbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Contraints provided by parent

class CustomMarkdownEditor extends StatefulWidget {
  const CustomMarkdownEditor({Key key}) : super(key: key);

  @override
  _CustomMarkdownEditorState createState() => _CustomMarkdownEditorState();
}

class _CustomMarkdownEditorState extends State<CustomMarkdownEditor> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarkdownProvider(),
      builder: (context, _) {
        return Consumer<MarkdownProvider>(builder: (context, state, __) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: state.length,
                    itemBuilder: (context, index) =>
                        state.editorWidgets.elementAt(index),
                  ),
                ),
              ),
              PreferredSize(
                child: MarkdownToolbar(),
                preferredSize: const Size.fromHeight(56.0),
              )
            ],
          );
        });
      },
    );
  }
}
