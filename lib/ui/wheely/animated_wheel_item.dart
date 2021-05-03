import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:flutter/material.dart';

class AnimatedWheelItem extends AnimatedWidget {
  final Widget child;
  final double angle;

  AnimatedWheelItem(
      {Key key, this.child, WheelController controller, this.angle})
      : super(key: key, listenable: controller);

  static const kRadians = 6.28318530718;

  @override
  Widget build(BuildContext context) {
    final position = (listenable as WheelController).position;
    print('${(angle - position).remainder(kRadians)}');
    return Transform.rotate(
      origin: Offset(214, 214), //TODO FIX
      angle: (angle - position).remainder(kRadians),
      child: child,
    );
  }
}
