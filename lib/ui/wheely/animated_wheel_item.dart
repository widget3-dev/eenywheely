import 'package:flutter/material.dart';

class AnimatedWheelItem extends AnimatedWidget {
  final Widget child;
  final double angle;

  AnimatedWheelItem({this.child, Animation<double> animation, this.angle})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animValue = (listenable as Animation<double>).value;
    return Transform.rotate(
      origin: Offset(215, 215),
      angle: angle + (animValue * 6.28),
      child: child,
    );
  }
}
