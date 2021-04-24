import 'package:eenywheely/state/controllers.dart';
import 'package:eenywheely/ui/wheely/wheel_controller.dart';
import 'package:eenywheely/ui/wheely/wheely_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BootStrap(),
    );
  }
}

class BootStrap extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: Duration(seconds: 5),
    );

    final wheelController =
        useProvider(wheelControllerProvider(animationController));

    return WheelyView(controller: wheelController);
  }
}
