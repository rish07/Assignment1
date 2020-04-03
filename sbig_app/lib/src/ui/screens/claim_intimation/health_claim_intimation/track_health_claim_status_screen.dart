import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/service/service_locator.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dotted_line_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/controllers/service/call_sms_mail_service.dart';

class HealthTrackClaimStatusScreen extends StatefulWidget {
  static const ROUTE_NAME =
      "/claim_intimation/health_track_claim_initimation_screen";

  final HealthTrackClaimStatusScreenArguments arguments;

  HealthTrackClaimStatusScreen(this.arguments);

  @override
  _HealthTrackClaimStatusScreenState createState() =>
      _HealthTrackClaimStatusScreenState();
}

class HealthTrackClaimStatusScreenArguments {
  String claimStatus,
      policyNumber,
      tpaClaimNo,
      sBigClaimNo,
      claimType,
      amountClaimed,
      patientName,
      hospitalName,
      dateOfHospitalization,
      paymentRefNo,
      paymentDate,
      approvedAmount;

  HealthTrackClaimStatusScreenArguments(
      this.claimStatus,
      this.policyNumber,
      this.tpaClaimNo,
      this.sBigClaimNo,
      this.claimType,
      this.amountClaimed,
      this.patientName,
      this.hospitalName,
      this.dateOfHospitalization,
      this.paymentRefNo,
      this.paymentDate,
      this.approvedAmount);
}

class _HealthTrackClaimStatusScreenState
    extends State<HealthTrackClaimStatusScreen> with CommonWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Service _service = getIt<Service>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorConstants.personal_details_bg_color,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getAppBar(
                        context, S.of(context).track_claim_status.toUpperCase(),
                        isActionRequired: true,
                        actionWidget: getActionBarWidget()),
//                    getAppBarRight(
//                        context, S.of(context).track_claim_status.toUpperCase(),
//                        onBackPressed: _onAppBarBackPresses, isFrom: 0,claim:"Health" ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorConstants
                                      .track_health_claim_icon_color,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                height: 42,
                                width: double.maxFinite,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 13.0,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            S
                                                .of(context)
                                                .claim_status
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                letterSpacing: 0.83,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: DottedLineWidget(
                                                height: 1,
                                                width: 3,
                                                color: ColorConstants
                                                    .dotted_line_color),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.arguments.claimStatus,
                                            style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            ColorConstants
                                                .chathams_blue,
                                            ColorConstants
                                                .disco
                                          ]),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    height: 24,
                                    width: 24,
                                    child: Image.asset(AssetConstants.ic_tick),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      S.of(context).policy_no,
                                      style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      S.of(context).tpa_claim_no,
                                      style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      S.of(context).sBig_claim_no,
                                      style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      S.of(context).type_of_claim,
                                      style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      S.of(context).amount_claimed,
                                      style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.3)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      widget.arguments.policyNumber?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      widget.arguments.tpaClaimNo?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      widget.arguments.sBigClaimNo?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      widget.arguments.claimType?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      widget.arguments.amountClaimed?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).patient_name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        S.of(context).hospital_name,
                                        style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        S.of(context).date_of_admission,
                                        style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.arguments.patientName?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 150),
                                        child: Text(
                                          widget.arguments.hospitalName?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        widget.arguments.dateOfHospitalization?? ''
                                            .replaceAll("/", "-"),
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 20.0, bottom: 10.0),
                        child: DottedLineWidget(
                            height: 1,
                            width: 3,
                            color: ColorConstants.dotted_line_color),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).payment_reference_no,
                                        style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        S.of(context).payment_date,
                                        style: TextStyle(
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.3)),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.arguments.paymentRefNo?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        widget.arguments.paymentDate?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 10.0, bottom: 0.0),
                        child: DottedLineWidget(
                            height: 1,
                            width: 3,
                            color: ColorConstants.dotted_line_color),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).approved_amount,
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "₹" + widget.arguments.approvedAmount,
                                        style: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 18.0, left: 18.0, right: 18.0),
                child: InkWell(
                  onTap: () {
                    _service.call(S.of(context).claim_intimation_call_no);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    height: 40,
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.call,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          S.of(context).connect_with_SBig,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              /* BlackButtonWidget(
                () {},
                S.of(context).claim_next_button.toUpperCase(),
                bottomBgColor: ColorConstants.claim_intimation_bg_color,
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  getActionBarWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.only( right: 20),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: ColorConstants.track_health_claim_icon_color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SizedBox(
              child: Image.asset(
            AssetConstants.ic_health_claim_track,
            scale: 1.5,
          ))),
    );
  }
}
