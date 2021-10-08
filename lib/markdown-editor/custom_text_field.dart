import 'dart:developer';

import 'package:flutter/material.dart';

import 'custom_text_controller.dart';

// GITHUB/samarsheikh001 (Private res)
// TODO: Exception Handling and Null Safety.
// TODO: Migrate to package.

// git 6.0 (redo 17)

class CustomTextField extends StatelessWidget {
  final Key? key;
  final FocusNode? focusNode;
  final CustomTextController? controller;

  const CustomTextField({this.focusNode, this.controller, this.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null, // Set multiline nulls so it increased \r as demanded
      decoration: InputDecoration.collapsed(
        hintText: 'Answer',
        hintStyle: TextStyle(
          fontSize: 20,
          color: Color(0xffE0E0E0),
        ),
      ),
    );
  }
}
