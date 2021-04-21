import 'package:eenywheely/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class CustomPaintWheel extends ConsumerWidget {
  CustomPaintWheel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final List<String> names = watch(canidatesProvider);
    final double wheelDiameter = MediaQuery.of(context).size.width - 40.0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: CustomPaint(
                size: Size(wheelDiameter, wheelDiameter),
                painter: WheelPainter(names),
              ),
            ),
            Expanded(
              child: ListView(
                children: names
                    .map(
                      (name) => Container(
                        child: ListTile(
                          leading: Icon(Icons.wb_sunny),
                          title: Text(name),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  List<String> items;
  WheelPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()
      ..color = Colors.grey[800]
      ..style = PaintingStyle.fill;

    final lightPaint = Paint()
      ..color = Colors.red[800]
      ..style = PaintingStyle.fill;

    final radius = size.width / 2;
    //canvas.drawCircle(Offset(radius, radius), radius, paint);

    final double radian = 6.28 / items.length;
    final center = Offset(radius, radius);
    final _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    items.asMap().forEach((key, item) {
      // canvas.drawLine(
      //     Offset(radius, radius), Offset(radius * 2, radius), paint);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -(radian / 2),
        radian,
        true,
        key.isEven ? darkPaint : lightPaint,
      );

      _textPainter.text = TextSpan(
        text: item,
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

      canvas.transform(Matrix4Transform()
          .rotateByCenter(radian, Size.fromRadius(radius))
          .matrix4
          .storage);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
