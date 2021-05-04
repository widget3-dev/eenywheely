import 'dart:math';

import 'package:flutter/material.dart';

class WheelPainter extends CustomPainter {
  final Map<int, String> segmentMap;

  WheelPainter({this.segmentMap});

  void paintWheelItem(
      {String text, double radian, double radius, Color color, Canvas canvas}) {
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
  void paint(Canvas canvas, Size size) {
    final radian = (pi * 2) / segmentMap.length;
    final radius = size.width / 2;

    segmentMap.forEach((index, segmentValue) {
      paintWheelItem(
        text: segmentValue,
        color: index.isEven ? Colors.red : Colors.blue,
        radian: radian,
        radius: radius,
        canvas: canvas,
      );
      canvas.translate(radius, radius);
      canvas.rotate(radian);
      canvas.translate(-radius, -radius);
    });
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) => false;
}
