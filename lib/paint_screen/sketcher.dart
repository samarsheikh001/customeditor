import 'dart:ui';

import 'draw_line.dart';
import 'package:flutter/material.dart';

class Sketcher extends CustomPainter {
  final List<DrawnLine> lines;

  Sketcher({required this.lines});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt;

    for (var i = 0; i < lines.length; i++) {
      for (var j = 0; j < lines[i].path.length - 1; j++) {
        paint
          ..color = lines[i].color
          ..strokeWidth = lines[i].width;
        canvas.drawLine(lines[i].path[j], lines[i].path[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
