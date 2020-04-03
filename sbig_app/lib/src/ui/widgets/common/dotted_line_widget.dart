import 'package:flutter/material.dart';


class DottedLineWidget extends StatelessWidget {
  final double height;
  final Color color;
  final Axis axis;
  final double width;
  final int dashCountValue;

  const DottedLineWidget({this.height = 1, this.color = Colors.black,this.axis=Axis.horizontal,this.width=5.0,this.dashCountValue=50});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = width;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis,
          children: List.generate((axis== Axis.vertical)? dashCountValue : dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),

        );
      },
    );
  }
}