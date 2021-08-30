import 'dart:convert';
import 'dart:io';

import 'package:custommarkdowneditor/markdown-editor/custom-text-controller.dart';
import 'package:custommarkdowneditor/markdown-editor/custom-text-field.dart';
import 'package:custommarkdowneditor/markdown-editor/editor-storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MarkdownProvider extends ChangeNotifier {
  List<FocusNode> _nodes = [];
  List<CustomTextController> _controllers = [];
  List<Widget> _editorWidgets = [];
  List<String> _imageSource = [];

  // File Key to get specific file
  String _fileKey = 'textTest';

  // Getters
  List<FocusNode> get nodes => _nodes;
  List<CustomTextController> get controllers => _controllers;
  List<Widget> get editorWidgets => _editorWidgets;
  int get length => _editorWidgets.length;
  int get focus => _nodes.indexWhere((node) => node.hasFocus);

  CustomTextController get _focusedController => _controllers.elementAt(focus);

  CustomTextController get getController => _controllers.first;

  void setFileKey(String key) {
    _fileKey = key;
    notifyListeners();
  }

  // Class Initialisation.
  // Note: Initialisation is necessary for listener to work.
  MarkdownProvider() {
    insertTextField(index: 0);
  }

  void clearEditor() {
    _nodes = [];
    _controllers = [];
    _editorWidgets = [];
    _imageSource = [];
  }

  void openSavedFile() async {
    clearEditor();
    // Getting storage  
    final _editorStorage = EditorStorage();
    final text = await _editorStorage.readFileAsString(_fileKey);
    Map savedMarkdownFile = jsonDecode(text);
    List<String> _textFieldsText =
        savedMarkdownFile['textFields'].cast<String>();
    List<String> _imgSources = savedMarkdownFile['imageSrcs'].cast<String>();
    List<dynamic> _boldCharsOfTextfields = savedMarkdownFile['boldChars'];
    // print('saved boldchars : $_boldCharsOfTextfields');
    for (int i = 0; i < _textFieldsText.length; i++) {
      List<int> _tempBoldChars =
          _boldCharsOfTextfields.elementAt(i).cast<int>();
      // print('saved boldchars after : $_tempBoldChars');
      // if (_textFieldsText.length > 1)
      //   _tempBoldChars = _tempBoldChars.map((e) => e + (1)).toList();
      insertTextField(
          index: i,
          text: _textFieldsText.elementAt(i),
          presetBoldchars: _tempBoldChars);
      if (i < (_textFieldsText.length - 1))
        preSetImage(_imgSources.elementAt(i));
    }
    // print('debug' * 20);
    // print(_controllers.length);
  }

  void saveFile() async {
    List<String> _textFields = _controllers.map((e) => e.text).toList();
    List<List<int>> _boldChars = _controllers.map((e) => e.boldChars).toList();
    print('BOLDCHARS ${_boldChars}');
    Map _map = {
      'textFields': _textFields,
      'boldChars': _boldChars,
      'imageSrcs': _imageSource
    };
    final _editorStorage = EditorStorage();
    File file =
        await _editorStorage.writeToFileAsString(_fileKey, jsonEncode(_map));
  }

  void makeBold() {
    _focusedController.setSelectedBold();
    _focusedController.selection = TextSelection.collapsed(
        offset: _focusedController.selection.extentOffset);
  }

  void makeItalic() {
    _focusedController.setSelectedItalic();
    _focusedController.selection = TextSelection.collapsed(
        offset: _focusedController.selection.extentOffset);
  }

  void makeUnderline() {
    _focusedController.setSelectedUnderlined();
    _focusedController.selection = TextSelection.collapsed(
        offset: _focusedController.selection.extentOffset);
  }

  // Get elements on index params.
  FocusNode nodeOfIndex(int index) => _nodes.elementAt(index);
  CustomTextController controllerOfIndex(int index) =>
      _controllers.elementAt(index);

  void addImage() async {
    final int index = _controllers.length;
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    final imagePath = await image.path;
    editorWidgets.add(Padding(
      padding: const EdgeInsets.all(18.0),
      child: Image.file(
        File(imagePath),
      ),
    ));
    _imageSource.add(imagePath);
    insertTextField(index: index, text: '');
    notifyListeners();
  }

  void preSetImage(String src) {
    editorWidgets.add(Padding(
      padding: const EdgeInsets.all(18.0),
      child: Image.file(
        File(src),
      ),
    ));
    _imageSource.add(src);
  }

  void insertTextField({int index, String text, List<int> presetBoldchars}) {
    if (text != null) {
      text = text.replaceAll('\u200B', '');
    }
    // \u200B is Zero Width Space
    final CustomTextController _controller = CustomTextController(
        text: (index == 0 ? '' : '\u200B') +
            (text ?? '')); // Experimental/Testing (priority 1)
    // final CustomTextController _controller =
    //     CustomTextController(text: '\u200B' + (text ?? ''));
    // Handles removing and adding of controller.
    //TEST CODE
    String pastText = '';
    int pastBaseOffset = 0;
    int pastExtentOffset = 0;
    //TEST CODE
    void _listener() {
      print(
          'Bold chars : ${_controller.boldChars} \n Controller text ${_controller.text.length}');

      if (!_controller.text.startsWith('\u200B')) {
        final int index = _controllers.indexOf(_controller);
        if (index > 0) {
          final _previousController = controllerOfIndex(index - 1);
          // Repositioning boldchars with other controller
          _controller.boldChars
              .map((e) => _previousController.boldChars
                  .add(e + _previousController.text.length - 1))
              .toList();
          _controller.italicChars
              .map((e) => _previousController.italicChars
                  .add(e + _previousController.text.length - 1))
              .toList();
          _controller.underlinedChars
              .map((e) => _previousController.underlinedChars
                  .add(e + _previousController.text.length - 1))
              .toList();
          _previousController.text += _controller.text;
          _previousController.selection = TextSelection.fromPosition(
            TextPosition(
                offset:
                    _previousController.text.length - _controller.text.length),
          );
          nodeOfIndex(index - 1).requestFocus();
          _controllers.removeAt(index);
          _nodes.removeAt(index);
          //TODO: Improvements needed.
          _editorWidgets.removeAt(index * 2);
          _editorWidgets.removeAt((index * 2) - 1);
          // notifyListeners();
        }
      }
      // TEST CODE
      // Returns value of cursor position
      // Note: only works for "without selection" cursor position change
      int cursorPosition = _controller.selection.baseOffset - pastBaseOffset;

      // Returns true if text changes
      bool textChanged = _controller.text != pastText;

      // Returns true if user pressed backkey i.e delete char
      bool pressedBackkey = cursorPosition == -1 &&
          textChanged &&
          nodes.elementAt(index).hasFocus; // Experimental

      // Removes boldchar on pressing backkey
      // TODO: make it more efficient by checking other cases (priority 2|3) (solved)
      if (pressedBackkey) {
        _controller.boldChars.remove(_controller.selection.baseOffset);
        _controller.italicChars.remove(_controller.selection.baseOffset);
        _controller.underlinedChars.remove(_controller.selection.baseOffset);
      }

      // Adjusting [boldChars], [italicChars] etc. position based on text change
      if (cursorPosition != 0 && textChanged && nodeOfIndex(index).hasFocus) {
        _controller.boldChars = _controller.boldChars.map((e) {
          if (e >= pastBaseOffset) return e + cursorPosition;
          return e;
        }).toList();
        _controller.italicChars = _controller.italicChars.map((e) {
          if (e >= pastBaseOffset) return e + cursorPosition;
          return e;
        }).toList();
        _controller.underlinedChars = _controller.underlinedChars.map((e) {
          if (e >= pastBaseOffset) return e + cursorPosition;
          return e;
        }).toList();
      }

      // HANDLE CUT & PASTE

      // NOTE: CUT and BACKSPACE couldn't be handled in same scope due to [ BaseOffset ] update on selecting text hence behaves and outputs different result.

      // Note: This cursor position change only works in case of selection (not on backkey or adding chars).
      int selectionCursorPositionChange = pastBaseOffset - pastExtentOffset;

      // TODO: Add test cases (if needed).

      // *** WARNING: DO NOT REMOVE ***
      // print('BaseOffset: ${_controller.selection.baseOffset}');
      // print('PastExtentOffset: $pastExtentOffset');
      // print(selectionCursorPositionChange);
      // print('BoldChars: ${_controller.boldChars}');

      // TODO: Use [ExtendOffset] instead of [BaseOffset]. (priority 1)
      // [pastBaseOffset - pastExtentOffset] difference between previous selection.

      // Returns true if text is being cut (Doesnt work in case of removing text using BACKSPACE)
      bool cutText = (selectionCursorPositionChange) < 0 &&
          textChanged &&
          nodeOfIndex(index).hasFocus;

      if (cutText) {
        // Remove [boldChars] and [italicChars] of given text that has been CUT
        print('CURRENT DEBUG ${_controller.boldChars}');
        for (int i = pastBaseOffset; i < pastExtentOffset; i++) {
          _controller.boldChars.remove(i);
          _controller.italicChars.remove(i);
          _controller.underlinedChars.remove(i);
        }
        print('CURRENT DEBUG ${_controller.boldChars}');
        print('selectionCursorPositionChange : $selectionCursorPositionChange');

        // Maps [boldChars] and [italicChars] to the new position
        print('BEFORE ITERATE ${_controller.boldChars}');
        print('PAST EXTENT OFFSET $pastExtentOffset');
        _controller.boldChars = _controller.boldChars.map((e) {
          if (e >= pastExtentOffset) return (e + selectionCursorPositionChange);
          return e;
        }).toList();
        print('AFTER ITERATE ${_controller.boldChars}');
        _controller.italicChars = _controller.italicChars.map((e) {
          if (e >= pastExtentOffset) return (e + selectionCursorPositionChange);
          return e;
        }).toList();
        _controller.underlinedChars = _controller.underlinedChars.map((e) {
          if (e >= pastExtentOffset) return (e + selectionCursorPositionChange);
          return e;
        }).toList();
      }

      pastText = _controller.text;
      pastBaseOffset = _controller.selection.baseOffset;
      pastExtentOffset = _controller.selection.extentOffset;

      notifyListeners();
      // TEST CODE
    }

    // Adding listener to newly created controller [CustomTextController].
    _controller.addListener(_listener);

    // Inserting [Controller] and [FocusNode] with respective [CustomTextField]
    _controllers.insert(index, _controller);
    _nodes.insert(index, FocusNode());
    _editorWidgets.add(CustomTextField(
      // Passing key is too important to avoid weird behavior of keystroking
      key: UniqueKey(),
      controller: controllerOfIndex(index),
      focusNode: nodeOfIndex(index),
    ));

    // Focus on last added [CustomTextField]
    _nodes.last.requestFocus();
    // Delay is necessary to set controller's text before adding bold
    Future.delayed(Duration(seconds: 1), () {
      _controller.presetBoldchars(presetBoldchars);
    });
    notifyListeners();
  }
}
