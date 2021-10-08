import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCircle extends CustomPainter {
  CustomCircle(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Paint paint = Paint()
      ..shader = LinearGradient(
        // begin: Alignment.topLeft,
        // end: Alignment.bottomRight,
        // // stops: [0.1, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.3, 0.9],
        colors: [
          color,
          Colors.white,
        ],
      ).createShader(rect);
    canvas.drawCircle(
        Offset(size.width, 0).translate(5, -5), size.width / 5, paint);
    paint.shader =
        LinearGradient(colors: [Colors.white, Colors.white]).createShader(rect);
    canvas.drawCircle(
        Offset(size.width, 0).translate(5, -5), size.width / 9, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
