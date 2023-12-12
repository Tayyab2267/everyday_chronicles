import 'package:flutter/material.dart';

class CirclePainterStart extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final double startX = size.width / 2;
    const double startY = 0;
    final double endY = size.height;

    // Draw the vertical line
    canvas.drawLine(Offset(startX, startY), Offset(startX, endY), paint);

    // Draw a circle at the top edge of the line
    const double circleRadius = 8;
    const double circleOffset = -5;

    canvas.drawCircle(
      Offset(startX, startY + circleRadius + circleOffset),
      circleRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
