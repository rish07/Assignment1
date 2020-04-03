import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;

  SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
//          transitionsBuilder: (BuildContext context,
//              Animation<double> animation,
//              Animation<double> secondaryAnimation,
//              Widget child) {
//            return new SlideTransition(
//              position: new Tween<Offset>(
//                begin: const Offset(1.0, 0.0),
//                end: Offset.zero,
//              ).animate(animation),
//              child: child,
//            );
//          },
        );
}
