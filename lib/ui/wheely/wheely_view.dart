import 'dart:math';

import 'package:eenywheely/state/providers.dart';
import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:eenywheely/ui/wheely/wheel_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WheelyView extends HookWidget {
  final WheelController controller;

  const WheelyView({Key key, this.controller}) : super(key: key);

  void _startWheel(int total) {
    controller
      //..reset()
      ..goTo(Random().nextInt(total));
  }

  @override
  Widget build(BuildContext context) {
    final double diameter = MediaQuery.of(context).size.width - 20;
    final List<String> items = useProvider(canidatesProvider);

    return Scaffold(
      floatingActionButton: IconButton(
        iconSize: 42.0,
        icon: Icon(Icons.play_arrow_outlined),
        onPressed: () => _startWheel(items.length),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: diameter,
            width: diameter,
            child: Stack(
              children: [
                RepaintBoundary(
                  child: AnimatedBuilder(
                      animation: controller,
                      child: CustomPaint(
                        painter: WheelPainter(
                          segmentMap: items.asMap(),
                        ),
                        size: Size(diameter, diameter),
                      ),
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: controller.angle,
                          child: child,
                        );
                      }),
                ),
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
      ),
    );
  }
}
