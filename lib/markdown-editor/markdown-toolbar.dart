import 'package:custommarkdowneditor/markdown-editor/markdown-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkdownToolbar extends StatefulWidget {
  const MarkdownToolbar({Key key}) : super(key: key);

  @override
  _MarkdownToolbarState createState() => _MarkdownToolbarState();
}

class _MarkdownToolbarState extends State<MarkdownToolbar>
    with WidgetsBindingObserver {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final _bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newVal = _bottomInset > 0.0;
    if (newVal != _keyboardVisible)
      setState(() {
        _keyboardVisible = newVal;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkdownProvider>(builder: (context, state, __) {
      // return _keyboardVisible
      return true
          ? Material(
              elevation: 4.0,
              color: Colors.white,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                      Widget>[
                IconButton(
                  onPressed: state.makeBold,
                  icon: Icon(Icons.format_bold_outlined),
                ),
                IconButton(
                  onPressed: state.makeItalic,
                  icon: Icon(Icons.format_italic_outlined),
                ),
                IconButton(
                  onPressed: state.makeUnderline,
                  icon: Icon(Icons.format_underline_outlined),
                ),
                IconButton(
                  onPressed: state.addImage,
                  icon: Icon(Icons.image),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: state.openSavedFile,
                      child: Text('Load'),
                    ),
                    TextButton(
                      onPressed: state.saveFile,
                      child: Text('Save'),
                    ),
                  ],
                )
              ]) // this widget goes to the builder's child property. Made for better performance.
              )
          : Container();
    });
  }
}
