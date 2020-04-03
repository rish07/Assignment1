import 'package:flutter/material.dart';

class EnableDisableButtonWidget extends StatelessWidget {
  final Function() onClick;
  final String title;
  final double width;
  final double height;
  final double titleFontSize;
  final bool isNormal;
  final bool isHavingBorder;
  final EdgeInsets padding;
  final double letterSpacing;
  final Color bottomBgColor;

  EnableDisableButtonWidget(this.onClick, this.title,
      {this.width = double.maxFinite,
        this.height = 50.0,
        this.titleFontSize = 14.0,
        this.isNormal = false, this.isHavingBorder = false, this.padding = const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0), this.letterSpacing = 1.0, this.bottomBgColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(alignment: Alignment.bottomCenter,child: Container(height: height - 20, color: bottomBgColor,)),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: padding,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)),
              child: RaisedButton(
                color: Colors.black,
                onPressed: onClick,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                textColor: Colors.white,
                highlightColor: Colors.grey[800],
                highlightElevation: 5.0,
                child: Text(
                  title,
                  style: !isNormal
                      ? TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w900, letterSpacing: letterSpacing)
                      : TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontStyle: FontStyle.normal, letterSpacing: letterSpacing),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
