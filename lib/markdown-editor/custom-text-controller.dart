import 'package:flutter/material.dart';

enum Markdown { Bold, Italic, Underline }

class CustomTextController extends TextEditingController {
  CustomTextController({String text, bool bold}) : super(text: text);

  // Fields are self explanatory no comments REQUIRED
  List<int> boldChars = [];
  List<int> italicChars = [];
  List<int> underlinedChars = [];



  // For saved editor
  void presetBoldchars(List _presetBoldchars) {
    if (_presetBoldchars!=null) {
      boldChars = _presetBoldchars;
      this.notifyListeners();
    }
  }


  void setSelectedBold() {
    // List of char position which are already bold
    List<int> tempChars = [];
    bool allBold = true;
    for (int char = selection.baseOffset;
        char < selection.extentOffset;
        char++) {
      if (!boldChars.contains(char)) {
        boldChars.add(char);
        allBold = false;
      } else
        tempChars.add(char);
    }
    if (allBold) tempChars.map((e) => boldChars.remove(e)).toList();
    // Notifies [ TextField ] to rebuild itself. (helps avoid using setState()({}) which might cause performance issues)
    this.notifyListeners();
  }

  void setSelectedItalic() {
    List<int> tempChars = [];
    bool allItalic = true;
    for (int char = selection.baseOffset;
        char < selection.extentOffset;
        char++) {
      if (!italicChars.contains(char)) {
        italicChars.add(char);
        allItalic = false;
      } else
        tempChars.add(char);
      if (allItalic) tempChars.map((e) => italicChars.remove(e)).toList();
    }
    this.notifyListeners();
  }

  void setSelectedUnderlined() {
    List<int> tempChars = [];
    bool allUnderLined = true;
    for (int char = selection.baseOffset;
        char < selection.extentOffset;
        char++) {
      if (!underlinedChars.contains(char)) {
        underlinedChars.add(char);
        allUnderLined = false;
      } else
        tempChars.add(char);
      if (allUnderLined)
        tempChars.map((e) => underlinedChars.remove(e)).toList();
    }
    this.notifyListeners();
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext context, TextStyle style, bool withComposing}) {
    List<TextSpan> markdownTextSpans = [];
    List<String> textFieldCharacters = text.split('');

    for (int charIndex = 0;
        charIndex < textFieldCharacters.length;
        charIndex++) {
      String char = textFieldCharacters[charIndex];

      bool charIsBold = boldChars.contains(charIndex);
      bool charIsItalic = italicChars.contains(charIndex);
      bool charIsUnderlined = underlinedChars.contains(charIndex);

      // Uncomment below code to deal with emojis
      // if (char.runes.first.bitLength > 14)
      //   markdownTextSpans.add(TextSpan(text: ' '));
      // else
        markdownTextSpans.add(
          TextSpan(
            text: char,
            style: TextStyle(
              decoration: charIsUnderlined
                  ? TextDecoration.underline
                  : TextDecoration.none,
              fontWeight: charIsBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: charIsItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        );
    }
    return TextSpan(style: style, children: markdownTextSpans);
  }
}
