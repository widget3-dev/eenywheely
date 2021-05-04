import 'package:eenywheely/state/providers.dart';
import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final wheelControllerProvider =
    ChangeNotifierProvider.family<WheelController, AnimationController>(
        (ref, controller) {
  final count = ref.read(canidatesProvider).length;
  return WheelController(animationController: controller, segmentCount: count);
});

//bad bad bad but let's see what happens
