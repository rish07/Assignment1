import 'package:flutter/material.dart';
import 'package:sbig_app/src/resources/color_constants.dart';

class GradientButtonWidget extends StatelessWidget {
  final Function() onClick;
  final String title;
  final double width;
  final double height;
  final double titleFontSize;
  final bool isNormal;
  final bool isHavingBorder;
  final EdgeInsets padding;
  final List<Color> gradientColours;

  GradientButtonWidget(this.onClick, this.title,
      {this.width = double.maxFinite,
        this.height = 50.0,
        this.titleFontSize = 14.0,
        this.isNormal = false,
        this.isHavingBorder = false,
        this.padding = const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        this.gradientColours});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: padding,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: gradientColours
              ),
            //  border: Border.all(color: ColorConstants.outline_button_color),
              borderRadius: BorderRadius.all(Radius.circular(height / 2))),
          child: MaterialButton(
            height: height,
            minWidth: width,
            onPressed: onClick,
            padding: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
            ),
            textColor: Colors.white,
           // highlightColor: Colors.grey.shade200,
            highlightElevation: 5.0,
            child: Text(
              title,
              style: isNormal
                  ? TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w900)
                  : TextStyle(
                  fontSize: titleFontSize,
                  color: Colors.white,
                  fontStyle: FontStyle.normal),
            ),
          ),
        ),
      ),
    );
  }
}
