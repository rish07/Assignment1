import 'dart:ui';

import 'package:flutter/material.dart';

class CurveClipper2 extends CustomClipper<Path> {
  double _buttonHeight;
  double _gap;

  CurveClipper2(this._buttonHeight) {
    _gap = _buttonHeight/2 + (_buttonHeight * 0.12);
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    Offset _curveStartPoint = Offset(0, size.height-_gap);
    Offset _curveControlPoint = Offset(size.width/2, size.height);
    Offset _curveEndPoint = Offset(size.width, size.height-_gap);

    path.moveTo(0, 0);
    path.lineTo(_curveStartPoint.dx, _curveStartPoint.dy);
    path.quadraticBezierTo(_curveControlPoint.dx, _curveControlPoint.dy, _curveEndPoint.dx, _curveEndPoint.dy);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }

}