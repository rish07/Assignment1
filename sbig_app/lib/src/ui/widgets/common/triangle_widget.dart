import 'package:flutter/material.dart';
import 'dart:math' as math;

class Triangle extends StatelessWidget {
  const Triangle({
    Key key,
    this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.75,
      child: CustomPaint(
          painter: _ShapesPainter(color),
          child: Container(
              height: 20,
              width: 20,
            decoration:  BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
               /*  BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0.0, 0.0),
                ),*/
               /* BoxShadow(
                  color: Colors.white,
                  offset: const Offset(0.0, 0.0),
                  spreadRadius: -12.0,
                  blurRadius: 12.0,
                ),*/


              ],
            ),
             )),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;

  _ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
   // paint.maskFilter=MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(0.9));
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawShadow(path, Colors.black12, 10, false);
    canvas.drawPath(path, paint);
  }
  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
