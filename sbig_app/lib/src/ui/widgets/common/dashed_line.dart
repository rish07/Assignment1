import 'package:flutter/material.dart';

class DashedLineWidget extends StatelessWidget {
  final double height;
  final Color color;
  final double spacing;

  const DashedLineWidget({this.height = 1, this.color = Colors.black, this.spacing = 2.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (1.6 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: EdgeInsets.only(right: spacing),
              child: SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}