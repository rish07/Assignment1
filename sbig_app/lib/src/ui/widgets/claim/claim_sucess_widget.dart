import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

import '../statefulwidget_base.dart';

class ClaimSuccessWidget extends StatelessWidget with CommonWidget {
  final double screenHeight, screenWidth;

  final String activationNumber;

  final Function() onClick;

  ClaimSuccessWidget(
      this.screenHeight, this.screenWidth, this.activationNumber, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: SafeArea(
        bottom: false,
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child:closeImageWidget(onClick),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 20.0 ),
                child: Container(
                  child: Stack(
                    children: <Widget>[

                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: borderRadius(
                                radius: 0.0, topLeft: 6.0, topRight: 50.0)),
                        child: Padding(
                          padding: const EdgeInsets.only(top:20,bottom: 70.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 20.0, left: 10, right: 10),
                                child: Text(
                                  S.of(context).claim_submit,
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: 1.0),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Text(
                                  S.of(context).claim_activation_text1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 0.25,
                                      color: ColorConstants.claim_activation_text1,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorConstants.tin_color.withOpacity(0.2),
                                        borderRadius: borderRadius(
                                            radius: 4.0, topLeft: 4.0, topRight: 4.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 4, bottom: 4),
                                      child: SelectableText(
                                        activationNumber,
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                            color:
                                            ColorConstants.claim_activation_no_color,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  S.of(context).claim_activation_text2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      letterSpacing: 0.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.0),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 80.0, right: 80.0),
                                child: MaterialButton(
                                  height: 50,
                                  minWidth: double.maxFinite,
                                  color: Colors.black,
                                  onPressed: onClick,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                  ),
                                  textColor: Colors.white,
                                  highlightColor: Colors.grey[800],
                                  highlightElevation: 5.0,
                                  child: Text(
                                    S.of(context).claim_thanks_text.toUpperCase(),
                                    style: TextStyle(
                                        letterSpacing: 1.0,
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                        child: Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset(
                              AssetConstants.ic_success,
                              alignment: Alignment.center,
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
      ),
    );
  }
}
