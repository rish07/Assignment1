import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/utilities/device_util.dart';

class HomeServiceCardWidget extends StatelessWidget with CommonWidget{
  final ServiceModel serviceModel;
  final BorderRadius hsBorderRadius;
  final double opacity;
  final _itemWidth;

  HomeServiceCardWidget(
      this.serviceModel, this.hsBorderRadius, this.opacity, this._itemWidth,
      {leftPaddingForIcon});

  static const double heightAspectRatio = 100 / 120;

  @override
  Widget build(BuildContext context) {

    double height = _itemWidth * heightAspectRatio;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: hsBorderRadius,
        ),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Opacity(
                opacity: opacity,
                child: Container(
                  height: _itemWidth * heightAspectRatio,
                  width: _itemWidth,
                  decoration: BoxDecoration(
                      borderRadius: hsBorderRadius,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [serviceModel.color1, serviceModel.color2])),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: height,
                width: _itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: isIPad(context) ? Image.asset(serviceModel.icon, height: 130, fit: BoxFit.fill,) : Image.asset(serviceModel.icon),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0)),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 4.0, right: 4.0, top: 5.0, bottom: 5),
                          child: Text(
                            serviceModel.title,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
