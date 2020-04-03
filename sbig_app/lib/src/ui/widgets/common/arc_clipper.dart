import 'dart:ui';

import 'package:flutter/material.dart';

//enum ClipType { pointed, curved, arc, traingle, waved }

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 200);
    path.relativeArcToPoint(Offset(size.width, size.height - 200),
        radius: Radius.elliptical(30, 10), rotation: 360, clockwise: false);
    path.lineTo(size.width, 0);
    path.close(); // this closes the loop from current position to the starting point of widget
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
