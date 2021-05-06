import 'dart:math';
import 'package:flutter/material.dart';

enum WheelDirection { clockwise, anticlockwise }

class WheelController extends ChangeNotifier {
  AnimationController animationController;
  int numberOfSegments;

  WheelController({
    @required this.numberOfSegments,
    @required this.animationController,
  });

  int _currentSegment = 0;
  int get currentSegment => _currentSegment;

  double _position = 0.0;
  double get position => _position;

  double get angle => _position * ((pi * 2) / numberOfSegments);

  double _controllerPosition = 0.0;

  //always set position via this function
  setControllerPosition(double position) {
    _controllerPosition = position;
    _position = position.remainder(numberOfSegments);
    if (_position.floor() != currentSegment)
      _currentSegment = _position.floor();
    notifyListeners();
  }

  void reset() {
    setControllerPosition(0.0);
    notifyListeners();
  }

  void goTo(int index,
      [WheelDirection direction = WheelDirection.clockwise]) async {
    final extraRounds = 0 * numberOfSegments;
    final directionSign = (direction == WheelDirection.clockwise) ? -1.0 : 1.0;

    double distance = 0.0;

    if (direction == WheelDirection.clockwise) {
      if (_position <= index) {
        distance = index - _position + extraRounds + 0.3;
      } else {
        distance = numberOfSegments - _position + index + extraRounds;
      }
    } else {
      if (_position <= index) {
        distance = (numberOfSegments - index + extraRounds).toDouble();
      } else {
        distance = _position - index + extraRounds;
      }
    }

    await _goTo(
      start: _controllerPosition,
      distance: directionSign * distance,
      curve: Curves.easeOutCubic,
      duration: Duration(seconds: 2),
    );

    await _goTo(
      start: _controllerPosition,
      distance: -directionSign * 0.3,
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
    );
  }

  Future _goTo({
    double start,
    double distance,
    Duration duration,
    Curve curve,
  }) async {
    Animation<double> curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: curve,
    );

    animationController.reset();
    animationController.duration = duration;

    Function calculatePosition =
        () => setControllerPosition(start + (curvedAnimation.value * distance));

    curvedAnimation.addListener(calculatePosition);
    await animationController.forward().orCancel;
    curvedAnimation.removeListener(calculatePosition);
  }
}
