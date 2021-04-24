import 'package:flutter/material.dart';

class WheelController extends ChangeNotifier {
  AnimationController animation;
  int segmentCount;

  WheelController({@required this.segmentCount, @required this.animation});

  int _currentSegment = 0;
  int get currentSegment => _currentSegment;

  //position consumed by listeners
  double get position => _wheelPosition;

  //real animation position
  double _animPosition = 0.0;

  //setting all positions
  set _position(double pos) {
    _animPosition = pos;
    _wheelPosition = pos.remainder(segmentCount);
    if (_wheelPosition.round() != currentSegment)
      _currentSegment = _wheelPosition.round();
    notifyListeners();
    print('> $_animPosition');
    print('> $_wheelPosition');
    print('> $_currentSegment');
  }

  //wheel position
  double _wheelPosition = 0.0;

  Animation<double> curvedAnimation;
  Function previousAnimPos = () => {};

  void reset() {
    _position = 0.0;
    notifyListeners();
  }

  void goTo(int index) {
    final duration = 5000;
    final extraRounds = 2 * segmentCount;

    final segmentsToTravel = (_wheelPosition < index)
        ? index - _wheelPosition + extraRounds
        : segmentCount - _wheelPosition + index + extraRounds;

    animation.reset();
    animation.duration = Duration(milliseconds: duration);

    Function animatePosition = () {
      var startPosition = _animPosition;
      return () {
        _position = startPosition + (segmentsToTravel * curvedAnimation.value);
      };
    };

    Function animPos = animatePosition();

    //for removing listener that might never have been removed
    previousAnimPos = animPos;

    // Curve curve = (segmentsToTravel < 0.4 && segmentsToTravel > -0.4)
    //     ? Curves.easeOut
    //     : Curves.easeOutBack;

    Curve curve = Curves.ease;

    curvedAnimation = CurvedAnimation(parent: animation, curve: curve)
      ..removeListener(previousAnimPos)
      ..addListener(animPos);

    animation.forward()..whenComplete(() => animation.removeListener(animPos));
  }
}
