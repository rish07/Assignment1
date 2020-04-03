import 'package:flutter/material.dart';

import '../statefulwidget_base.dart';

class CalendarWidget extends StatelessWidget {

  final Function() onClick;
  final double height;
  final double radius;
  final String titleDate;


   CalendarWidget({this.onClick, this.height=40.0, this.radius=5.0, this.titleDate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: height,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius:
            BorderRadius.all(Radius.circular(radius))),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  titleDate,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
                width: 30,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child:
                  Image.asset(AssetConstants.ic_calender),
                ))
          ],
        ),
      ),
    );
  }
}
