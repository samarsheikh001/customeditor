import 'package:flutter/material.dart';

extension WidgetAddons on Widget {
  Widget addPad([double value = 8.0]) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget addVerticalPad([double value = 8.0]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: value),
      child: this,
    );
  }

  Widget addHorizontalPad([double value = 8.0]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: value),
      child: this,
    );
  }

  Widget editorImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0XFFF7986A),
        ),
      ),
      child: this.addPad(1),
    ).addVerticalPad();
  }
}
