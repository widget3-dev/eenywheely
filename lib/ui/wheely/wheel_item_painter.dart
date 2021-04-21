import 'package:flutter/material.dart';

class ItemPainter extends CustomPainter {
  final String text;
  final double radian;
  final double radius;
  final Color color;

  ItemPainter({this.text, this.radian, this.radius, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(radius, radius);
    final _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -(radian / 2),
      radian,
      true,
      paint,
    );

    _textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    );

    _textPainter.layout(
      minWidth: radius - 10,
      maxWidth: double.maxFinite,
    );
    _textPainter.paint(
      canvas,
      Offset(radius, radius - 7.0),
    );
  }

  @override
  bool shouldRepaint(covariant ItemPainter oldDelegate) =>
      color != oldDelegate.color;
}
