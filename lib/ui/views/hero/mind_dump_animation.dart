import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:path_morph/path_morph.dart';

const ONE_PATH =
    'M32.7324 0.681641H34.8477C41.8984 2.24023 45.4238 5.76563 45.4238 11.2578V156.318C44.0879 163.666 40.3027 167.34 34.0684 167.34H33.2891C25.9414 165.781 22.2676 162.293 22.2676 156.875V28.1797C17.2949 29.8125 13.4727 30.6289 10.8008 30.6289C5.53125 30.6289 2.04297 27.1035 0.335938 20.0527V17.4922C0.335938 11.5547 6.83008 7.25 19.8184 4.57812L32.7324 0.681641Z';
const TWO_PATH =
    "M24.07,52.496L1.566,30.114h13.453c-0.092-12.759,5.383-18.767,5.622-19.022C32.105-2.688,48.197,0.252,48.356,0.284 l2.574,0.5l-2.253,1.341C31.546,12.319,32.442,26.667,32.939,30.114h13.635L24.07,52.496z M6.414,32.114L24.07,49.676l17.656-17.562 H31.315L31.13,31.35c-0.043-0.177-3.88-17.07,14.022-29.346c-4.86-0.114-15.094,0.894-23.013,10.41 rc-0.091,0.1-5.481,6.089-5.103,18.67l0.03,1.03H6.414z";

class MindDumpAnimation extends StatefulWidget {
  @override
  _MindDumpAnimationState createState() => _MindDumpAnimationState();
}

class _MindDumpAnimationState extends State<MindDumpAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  SampledPathData _sampledPathData;

  @override
  void initState() {
    super.initState();
    Path path1 = createPath1();
    Path path2 = createPath2();
    _sampledPathData = PathMorph.samplePaths(path2, path1);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    PathMorph.generateAnimations(_controller, _sampledPathData, func);
  }

  void func(int i, Offset offset) {
    setState(() {
      _sampledPathData.shiftedPoints[i] = offset;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Spacer(),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                }
                if (_controller.status == AnimationStatus.dismissed) {
                  _controller.forward();
                }
              },
              child: Text('Animate'),
            ),
          ),
          FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              height: 64,
              width: 64,
              child: CustomPaint(
                painter: MyPainter(PathMorph.generatePath(_sampledPathData)),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Path createPath1() {
    final matrix4 = Matrix4.identity()..scale(0.5, 1);
    return parseSvgPathData(ONE_PATH)..transform(matrix4.storage);
  }

  Path createPath2() {
    final matrix4 = Matrix4.identity()..scale(0.5, 1);
    return parseSvgPathData(TWO_PATH)..transform(matrix4.storage);
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.path) {
    paints = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
  }

  var paints;
  Path path;

  @override
  void paint(Canvas canvas, Size size) => canvas..drawPath(path, paints);

  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}
