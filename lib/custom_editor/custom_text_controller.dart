import 'package:flutter/material.dart';

enum Markdown { Bold, Italic, Underline }

class CustomTextController extends TextEditingController {
  CustomTextController({String? text}) : super(text: text);

  // Fields are self explanatory no comments REQUIRED
  List<int> boldChars = [];
  List<int> italicChars = [];
  List<int> underlinedChars = [];

  // For saved editor
  void presetBoldchars(List<int>? _presetBoldchars) {
    if (_presetBoldchars != null) {
      boldChars = _presetBoldchars;
      this.notifyListeners();
    }
  }

  void setSelectedWithStyle(Markdown _markdown) {
    List<int> tempChars = [];
    bool allSameStyle = true;
    for (int char = selection.baseOffset;
        char < selection.extentOffset;
        char++) {
      if (_markdown == Markdown.Bold) {
        if (!boldChars.contains(char)) {
          boldChars.add(char);
          allSameStyle = false;
        } else
          tempChars.add(char);
      }
      if (_markdown == Markdown.Italic) {
        if (!italicChars.contains(char)) {
          italicChars.add(char);
          allSameStyle = false;
        } else
          tempChars.add(char);
      }
      if (_markdown == Markdown.Underline) {
        if (!underlinedChars.contains(char)) {
          underlinedChars.add(char);
          allSameStyle = false;
        } else
          tempChars.add(char);
      }
    }
    if (allSameStyle)
      tempChars.map((e) {
        if (_markdown == Markdown.Bold) return boldChars.remove(e);
        if (_markdown == Markdown.Italic) return italicChars.remove(e);
        if (_markdown == Markdown.Underline) return underlinedChars.remove(e);
      }).toList();
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
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
