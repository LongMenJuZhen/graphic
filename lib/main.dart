import 'package:flutter/material.dart';

import 'globals.dart';
import 'algorithm.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 84, 115, 38)),
          useMaterial3: true,
        ),
        title: '安卓打不出来QAQ',
        home: const Scaffold(
          body: Stack(
            children: [CirclePainter(), Controler()],
          ),
        ));
  }
}

class CirclePainter extends StatefulWidget {
  const CirclePainter({super.key});

  @override
  _CirclePainterState createState() => _CirclePainterState();
}

class _CirclePainterState extends State<CirclePainter> {
  List<Offset> _points = <Offset>[];
  bool _showText = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        int x = details.localPosition.dx ~/ pixelsize * pixelsize;
        int y = details.localPosition.dy ~/ pixelsize * pixelsize;
        setState(() {
          _showText = false;
          _points = List.from(_points)..add(Offset(x.toDouble(), y.toDouble()));
          if (_points.length > 2) {
            _points.removeAt(0);
          }
        });
      },
      child: CustomPaint(
        painter: CirclePainterCanvas(_points, context),
        child: Container(),
      ),
    );
  }
}

class CirclePainterCanvas extends CustomPainter {
  CirclePainterCanvas(this.points, this.context);
  final List<Offset> points;
  final BuildContext context;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..strokeCap = StrokeCap.square
      ..strokeWidth = pixelsize.toDouble();
    //canvas.drawPoints(ui.PointMode.points, points, paint);
    if (currentShape == Shape.Line) {
      bresenhamLine(canvas, paint, points[0], points[1]); // Call bresenhamLine
    } else if (currentShape == Shape.Circle) {
      bresenhamCircle(canvas, paint, points[0], points[1]);
    } else {
      bresenhamEllipse(canvas, paint, points[0], points[1]);
    }
  }

  @override
  bool shouldRepaint(CirclePainterCanvas oldDelegate) =>
      oldDelegate.points != points;
}

class Controler extends StatefulWidget {
  const Controler({super.key});

  @override
  State<StatefulWidget> createState() => _ControlerState();
}

class _ControlerState extends State<Controler> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        switch (currentShape) {
                          case Shape.Circle:
                            currentShape = Shape.Line;
                            break;
                          case Shape.Line:
                            currentShape = Shape.Ellipse;
                            break;
                          case Shape.Ellipse:
                            currentShape = Shape.Circle;
                            break;
                        }
                      });
                    },
                    child: Text(currentShape == Shape.Circle
                        ? '圆'
                        : currentShape == Shape.Line
                            ? '线'
                            : '椭圆'),
                  ),
                  Slider(
                    value: pixelsize.toDouble(),
                    min: 1,
                    max: 64,
                    divisions: 32,
                    label: pixelsize.toString(),
                    onChanged: (value) {
                      setState(() {
                        pixelsize = value.toInt();
                      });
                    },
                  ),
                ],
              )),
        ));
  }
}
