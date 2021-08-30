import 'dart:developer';

import 'package:custommarkdowneditor/markdown-editor/custom-text-controller.dart';
import 'package:flutter/material.dart';

// GITHUB/samarsheikh001 (Private res)
// TODO: Exception Handling and Null Safety.
// TODO: Migrate to package.

// git 6.0 (redo 17)

class CustomTextField extends StatefulWidget {
  final Key key;
  final FocusNode focusNode;
  final CustomTextController controller;

  const CustomTextField({this.focusNode, this.controller, this.key});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // These fields needed to be compared with past behaviours
  // such as cut paste and backkey inputs
  String pastText = '';
  int pastBaseOffset = 0;
  int pastExtentOffset = 0;

  @override
  void initState() {
    super.initState();
    final _controller = widget.controller;

    _controller.addListener(() {
      // // Returns value of cursor position
      // // Note: only works for "without selection" cursor position change
      // int cursorPosition = _controller.selection.baseOffset - pastBaseOffset;

      // // Returns true if text changes
      // bool textChanged = _controller.text != pastText;

      // // Returns true if user pressed backkey i.e delete char
      // bool pressedBackkey = cursorPosition == -1 && textChanged;

      // // Removes boldchar on pressing backkey
      // // TODO: make it more efficient by checking other cases (priority 2|3) (solved)
      // if (pressedBackkey) {
      //   _controller.boldChars.remove(_controller.selection.baseOffset);
      //   _controller.italicChars.remove(_controller.selection.baseOffset);
      //   _controller.underlinedChars.remove(_controller.selection.baseOffset);
      // }

      // // Adjusting [boldChars], [italicChars] etc. position based on text change
      // if (cursorPosition != 0 && textChanged) {
      //   _controller.boldChars = _controller.boldChars.map((e) {
      //     if (e >= pastBaseOffset) return e + cursorPosition;
      //     return e;
      //   }).toList();
      //   _controller.italicChars = _controller.italicChars.map((e) {
      //     if (e >= pastBaseOffset) return e + cursorPosition;
      //     return e;
      //   }).toList();
      //   _controller.underlinedChars = _controller.underlinedChars.map((e) {
      //     if (e >= pastBaseOffset) return e + cursorPosition;
      //     return e;
      //   }).toList();
      // }

      // // HANDLE CUT & PASTE

      // // NOTE: CUT and BACKSPACE couldn't be handled in same scope due to [ BaseOffset ] update on selecting text hence behaves and outputs different result.

      // // Note: This cursor position change only works in case of selection (not on backkey or adding chars).
      // int selectionCursorPositionChange = pastBaseOffset - pastExtentOffset;

      // // TODO: Add test cases (if needed).

      // // *** WARNING: DO NOT REMOVE ***
      // // print('BaseOffset: ${_controller.selection.baseOffset}');
      // // print('PastExtentOffset: $pastExtentOffset');
      // // print(selectionCursorPositionChange);
      // // print('BoldChars: ${_controller.boldChars}');

      // // TODO: Use [ExtendOffset] instead of [BaseOffset]. (priority 1)
      // // [pastBaseOffset - pastExtentOffset] difference between previous selection.

      // // Returns true if text is being cut (Doesnt work in case of removing text using BACKSPACE)
      // bool cutText = (selectionCursorPositionChange) < 0 && textChanged;

      // if (cutText) {
      //   // Remove [boldChars] and [italicChars] of given text that has been CUT
      //   for (int i = pastBaseOffset; i < pastExtentOffset; i++) {
      //     _controller.boldChars.remove(i);
      //     _controller.italicChars.remove(i);
      //     _controller.underlinedChars.remove(i);
      //   }

      //   // Maps [boldChars] and [italicChars] to the new position
      //   _controller.boldChars = _controller.boldChars.map((e) {
      //     if (e > pastExtentOffset) return (e + selectionCursorPositionChange);
      //     return e;
      //   }).toList();
      //   _controller.italicChars = _controller.italicChars.map((e) {
      //     if (e > pastExtentOffset) return (e + selectionCursorPositionChange);
      //     return e;
      //   }).toList();
      //   _controller.underlinedChars = _controller.underlinedChars.map((e) {
      //     if (e > pastExtentOffset) return (e + selectionCursorPositionChange);
      //     return e;
      //   }).toList();
      // }

      // pastText = _controller.text;
      // pastBaseOffset = _controller.selection.baseOffset;
      // pastExtentOffset = _controller.selection.extentOffset;
    });
  }

  // @override
  // void dispose() {
  //   widget.controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      maxLines: null, // Set multiline nulls so it increased \r as demanded
      decoration: InputDecoration.collapsed(hintText: 'Answer'),
    );
  }
}
