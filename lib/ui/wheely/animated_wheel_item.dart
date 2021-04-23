import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:flutter/material.dart';

class AnimatedWheelItem extends AnimatedWidget {
  final Widget child;
  final double angle;

  AnimatedWheelItem({this.child, WheelController controller, this.angle})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    final animValue = (listenable as WheelController).position;
    return Transform.rotate(
      origin: Offset(215, 215), //TODO FIX
      angle: angle + animValue, //(animValue * 6.28319),
      child: child,
    );
  }
}
