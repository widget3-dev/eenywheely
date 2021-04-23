import 'package:eenywheely/state/providers.dart';
import 'package:eenywheely/ui/wheely/animated_wheel_item.dart';
import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:eenywheely/ui/wheely/wheel_item_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WheelyView extends HookWidget {
  static const kRadians = 6.28319;

  Map<int, Widget> _buildWheelItemMap(
      List<String> items, double radius, double radian) {
    Map<int, Widget> wheelItemMap = {};
    items.asMap().forEach((index, item) {
      wheelItemMap[index] = CustomPaint(
        painter: ItemPainter(
          text: item,
          radius: radius,
          radian: radian,
          color: index.isOdd ? Colors.red[800] : Colors.grey[800],
        ),
      );
    });
    return wheelItemMap;
  }

  List<Widget> _buildAnimatedWheelItems(
      Map<int, Widget> itemMap, WheelController controller, double radian) {
    List<Widget> animatedItems = [];

    itemMap.forEach((index, item) {
      animatedItems.add(AnimatedWheelItem(
        controller: controller,
        angle: (index * radian),
        child: item,
      ));
    });

    return animatedItems;
  }

  void _startWheel(WheelController controller) {
    controller
      ..reset()
      ..goTo(6);
  }

  @override
  Widget build(BuildContext context) {
    final double diameter = MediaQuery.of(context).size.width;
    final List<String> items = useProvider(canidatesProvider);
    final double radian = kRadians / items.length;
    final radius = diameter / 2;

    final AnimationController animationController = useAnimationController(
      duration: Duration(seconds: 5),
    );

    final wheelController = WheelController(
      animation: animationController,
      segmentCount: 8,
    )..addListener(() {
        print('wheelposition: ');
      });

    final wheelItems = _buildWheelItemMap(items, radius, radian);
    final animatedWheelItems =
        _buildAnimatedWheelItems(wheelItems, wheelController, radian);

    return Scaffold(
      floatingActionButton: IconButton(
        iconSize: 42.0,
        icon: Icon(Icons.play_arrow_outlined),
        onPressed: () => _startWheel(wheelController),
      ),
      body: SafeArea(
        child: Container(
          height: diameter,
          width: diameter,
          child: Stack(
            children: [
              ...animatedWheelItems,
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.yellow[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
