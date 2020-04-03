import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/home/connect_with_us.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

class ConnectUsCardWidget extends StatelessWidget with CommonWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Future.delayed(Duration(milliseconds: 100), () {
          if(Platform.isIOS){
            showCupertinoDialog(
                context: context,
                builder: (BuildContext context) => WillPopScope(
                    onWillPop: () {
                      return Future<bool>.value(true);
                    },
                    child: ConnectWithUsScreen()));
          }else {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    WillPopScope(
                        onWillPop: () {
                          return Future<bool>.value(true);
                        },
                        child: ConnectWithUsScreen()));
          }
        });
      },
      child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius(radius: 5.0, topLeft: 5.0, topRight: 5.0),
          ),
          child: Container(
            height: 80,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius:
                  borderRadius(radius: 5.0, topLeft: 5.0, topRight: 5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            S.of(context).connect_us_title,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            S.of(context).connect_us_title,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage(AssetConstants.ic_home_connect_with_us2),
                          fit: BoxFit.fitHeight,
                        ),
                      )),
                ],
              ),
            ),
          )),
    );
  }
}
