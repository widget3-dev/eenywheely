import 'package:eenywheely/state/providers.dart';
import 'package:eenywheely/ui/wheely/animated_wheel_item.dart';
import 'package:eenywheely/ui/wheely/wheel_item_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WheelyView extends HookWidget {
  Map<int, Widget> _buildWheelItemMap(
      List<String> items, double radius, double radian) {
    Map<int, Widget> wheelItemMap = {};
    items.asMap().forEach((key, item) {
      wheelItemMap[key] = CustomPaint(
        painter: ItemPainter(
          text: item,
          radius: radius,
          radian: radian,
          color: key.isOdd ? Colors.red[800] : Colors.grey[800],
        ),
      );
    });
    return wheelItemMap;
  }

  List<Widget> _buildAnimatedWheelItems(
      Map<int, Widget> itemMap, Animation<double> animation, double radian) {
    List<Widget> animatedItems = [];

    itemMap.forEach((key, item) {
      animatedItems.add(AnimatedWheelItem(
        animation: animation,
        angle: (key * radian),
        child: item,
      ));
    });

    return animatedItems;
  }

  @override
  Widget build(BuildContext context) {
    final double diameter = MediaQuery.of(context).size.width;
    final List<String> items = useProvider(canidatesProvider);
    final double radian = 6.28 / items.length;
    final radius = diameter / 2;

    final AnimationController controller = useAnimationController(
      duration: Duration(seconds: 5),
    );
    //controller.addListener(() => print('${controller.value}'));
    controller.forward();

    final Animation<double> animation =
        Tween<double>(begin: 0, end: 1).animate(controller);

    final wheelItems = _buildWheelItemMap(items, radius, radian);
    final animatedWheelItems =
        _buildAnimatedWheelItems(wheelItems, animation, radian);

    return Container(
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
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
