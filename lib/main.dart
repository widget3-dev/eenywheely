import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final canidatesProvider = Provider((_) => [
      'Eddard "Ned" Stark',
      'Robert Baratheon',
      'Jaime Lannister',
      'Catelyn Stark',
      'Cersei Lannister',
      'Daenerys Targaryen',
      'Jorah Mormont',
      'Viserys Targaryen',
      'Jon Snow',
      'Robb Stark',
      'Sansa Stark',
      'Arya Stark',
      'Theon Greyjoy',
      'Brandon "Bran" Stark',
      'Joffrey Baratheon',
      'Sandor Clegane',
      // 'Tyrion Lannister',
      // 'Petyr "Littlefinger" Baelish',
      // 'Davos Seaworth',
      // 'Samwell Tarly',
      // 'Stannis Baratheon',
      // 'Melisandre',
      // 'Jeor Mormont',
      // 'Bronn',
      // 'Varys',
      // 'Shae',
      // 'Margaery Tyrell',
      // 'Tywin Lannister',
      // 'Talisa Maegyr',
      // 'Ygritte',
      // 'Gendry',
      // 'Tormund Giantsbane',
      // 'Brienne of Tarth',
      // 'Ramsay Bolton',
      // 'Gilly',
      // 'Daario Naharis',
      // 'Missandei',
      // 'Ellaria Sand',
      // 'Tommen Baratheon',
      // 'Jaqen H\'ghar',
      // 'Roose Bolton',
      // 'The High Sparrow',
      // 'Grey Worm'
    ]);

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
      home: Scaffold(
        body: SafeArea(child: StackWheel()),
      ),
    );
  }
}

class StackWheel extends HookWidget {
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
    controller.repeat();

    final Animation<double> animation =
        Tween<double>(begin: 1, end: 0).animate(controller);

    final wheelItems = _buildWheelItemMap(items, radius, radian);
    final animatedWheelItems =
        _buildAnimatedWheelItems(wheelItems, animation, radian);

    return Container(
      child: Stack(
        children: animatedWheelItems,
      ),
    );
  }
}

class AnimatedWheelItem extends AnimatedWidget {
  final Widget child;
  final double angle;

  AnimatedWheelItem({this.child, Animation<double> animation, this.angle})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animValue = (listenable as Animation<double>).value;
    return Transform.rotate(
      origin: Offset(215, 215),
      angle: angle + (animValue * 6.28),
      child: child,
    );
  }
}

class ItemPainter extends CustomPainter {
  final String text;
  final double radian;
  final double radius;
  final Color color;

  ItemPainter({this.text, this.radian, this.radius, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(radius, radius);
    final _textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -(radian / 2),
      radian,
      true,
      paint,
    );

    _textPainter.text = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
      ),
    );

    _textPainter.layout(
      minWidth: radius - 10,
      maxWidth: double.maxFinite,
    );
    _textPainter.paint(
      canvas,
      Offset(radius, radius - 7.0),
    );
  }

  @override
  bool shouldRepaint(covariant ItemPainter oldDelegate) =>
      color != oldDelegate.color;
}
