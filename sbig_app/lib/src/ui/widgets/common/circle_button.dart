
import 'package:flutter/material.dart';

import '../statefulwidget_base.dart';

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final String image;
  final Color iconColor;
  final bool isGardientApplicable;
  final Color color1, color2, color3;
  final double circleSize;
  final double shadowRadius;

  const CircleButton(
      {Key key,
        this.onTap,
        this.image,
        this.isGardientApplicable = false,
        this.color1,
        this.color2,
        this.color3,
        this.circleSize = 30,
        this.iconColor = Colors.black, this.shadowRadius=20.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new InkResponse(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circleSize/2),
            boxShadow: [
              new BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(-2, 1),
                  spreadRadius: 1)
            ]),
        child: new Container(
          width: circleSize,
          height: circleSize,
          decoration: new BoxDecoration(
            color: Colors.white,
            gradient: (isGardientApplicable)
                ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [color1, color2, color3])
                : null,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            image,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
