import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WheelController extends ChangeNotifier {
  AnimationController animationController;
  int segmentCount;

  WheelController(
      {@required this.segmentCount, @required this.animationController});

  int _currentSegment = 0;
  int get currentSegment => _currentSegment;

  //position consumed by listeners
  double get position => _wheelPosition;

  //angle consumed by listeners
  double get angle => _wheelPosition * ((pi * 2) / segmentCount);

  //real animation position
  double _animPosition = 0.0;

  //setting all positions
  set _position(double pos) {
    _animPosition = pos;
    _wheelPosition = pos.remainder(segmentCount);
    if (_wheelPosition.floor() != currentSegment)
      _currentSegment = _wheelPosition.floor();
    notifyListeners();
  }

  //wheel position
  double _wheelPosition = 0.0;

  Animation<double> curvedAnimation;
  Function previousAnimPos = () => {};

  void reset() {
    _position = 0.0;
    notifyListeners();
  }

  void goTo(int index, [ScrollDirection direction = ScrollDirection.forward]) {
    final duration = 4000;
    final extraRounds = 0 * segmentCount;
    final directionSign = (direction == ScrollDirection.forward) ? -1.0 : 1.0;

    double segmentsToTravel = 0.0;

    if (direction == ScrollDirection.forward) {
      if (_wheelPosition <= index) {
        segmentsToTravel = index - _wheelPosition + extraRounds + 0.4;
      } else {
        segmentsToTravel = segmentCount - _wheelPosition + index + extraRounds;
      }
    } else {
      if (_wheelPosition <= index) {
        segmentsToTravel = (segmentCount - index + extraRounds).toDouble();
      } else {
        segmentsToTravel = _wheelPosition - index + extraRounds;
      }
    }

    animationController.reset();
    animationController.duration = Duration(milliseconds: duration);

    Function animatePosition = () {
      var startPosition = _animPosition;
      return () {
        _position = directionSign *
            (startPosition + (segmentsToTravel * curvedAnimation.value));
      };
    };

    Function animateFinale = () {
      var startPosition = _animPosition;
      print('returning function');
      return () {
        _position = startPosition - (curvedAnimation.value * 0.4);
        print('finale $_wheelPosition');
      };
    };

    Function animPos = animatePosition();

    //for removing listener that might never have been removed
    previousAnimPos = animPos;

    curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic)
          ..removeListener(previousAnimPos)
          ..addListener(animPos);

    animationController.forward()
      ..whenComplete(() {
        curvedAnimation.removeListener(animPos);
        animationController
            .addListener(() => print('${animationController.value}'));
        animationController.duration = Duration(milliseconds: 300);
        animationController.reset();
        curvedAnimation =
            CurvedAnimation(parent: animationController, curve: Curves.easeIn);
        curvedAnimation.addListener(animateFinale);
        animationController.forward();
      });
  }
}
