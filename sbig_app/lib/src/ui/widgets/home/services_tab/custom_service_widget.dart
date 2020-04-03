import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_screen_phase1.dart';
import 'package:sbig_app/src/ui/screens/web_content.dart';
import 'package:sbig_app/src/ui/screens/web_post_content.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_disclaimer_widget.dart';

class CustomServiceWidget extends StatelessWidget with CommonWidget {
  final ServiceModel serviceModel;
  final String buttonTitle;
  final double height;
  final double imageHeight;
  final double imageWidth;
  final OnClickId clickId;

  CustomServiceWidget(this.serviceModel, this.buttonTitle, this.clickId,
      [this.height = 200, this.imageHeight = 150, this.imageWidth = 150]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (clickId == OnClickId.CLAIM) {
          Navigator.of(context).pushNamed(ClaimIntimationScreen.ROUTE_NAME);
        } else if (clickId == OnClickId.NETWORK_HOSPITAL) {
          Future.delayed(Duration(milliseconds: 100)).then((aValue) {
            //Navigator.of(context).pushNamed(NetworkHospitalPinCodeScreen.routeName);
            /// Pincode based search is removed from the ui. Now user can search with pincode and area
            Navigator.of(context).pushNamed(NetworkHospitalScreen.ROUTE_NAME);
          });
        } else if (clickId == OnClickId.BOOK_DOCTOR_CARD) {
          Future.delayed(Duration(milliseconds: 100)).then((aValue) {
            //Navigator.of(context).pushNamed(PartnerUiSignInScreen.routeName);
            showDisclaimer(context);
          });
        } else if (clickId == OnClickId.FITTERNITY_CARD) {
          Future.delayed(Duration(milliseconds: 100)).then((aValue) {
            Navigator.of(context).pushNamed(WebPostContent.routeName,
                arguments: WebPostContentArguments(
                    UrlConstants.FITTERNITY_URL, 'FITTERNITY', email: "", mobile: "", token: UrlConstants.FITTERNITY_TOKEN));
          });
        }
      },
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius(topRight: 40.0),
        ),
        child: Container(
          height: height,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: borderRadius(topRight: 40.0),
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [serviceModel.color1, serviceModel.color2])),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      serviceModel.title,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: serviceModel.isSubTitleRequired,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                        child: Text(
                          serviceModel.subTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    buildListOfPoints(context),
                    SizedBox(
                      height: 20,
                    ),
                    checkOutButton(context)
                  ],
                ),
              ),
              Positioned(
                bottom: -3,
                right: 0,
                child: Container(
                    height: imageHeight,
                    width: imageWidth,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(serviceModel.icon),
                        fit: BoxFit.fill,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildListOfPoints(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: serviceModel.points.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Image.asset(AssetConstants.ic_tick),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      serviceModel.points[index],
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget checkOutButton(BuildContext context) {
    return Container(
      height: 30,
      width: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buttonTitle,
            style: TextStyle(
                color: ColorConstants.arogya_plus_buy_now,
                fontWeight: FontWeight.w700,
                fontSize: 12.0),
          ),
          SizedBox(
            width: 5,
          ),
          SizedBox(
              width: 30,
              child: imageWidget(AssetConstants.ic_right_arrow, null))
        ],
      ),
    );
  }
}

void showDisclaimer(BuildContext context) async {
  onClick(bool isAgree) {
    if (isAgree) {
//      bool isUserDataAvailable = prefsHelper.isDocPrimeUserDataAvailable();
//      if(isUserDataAvailable ?? false) {
//        Navigator.of(context).pushNamed(WebContent.routeName, arguments: UrlConstants.DOC_PRIME_URL);
//      } else {
//        Navigator.of(context).pushNamed(PartnerUiSignInScreen.routeName);
//      }
      Navigator.of(context).pushNamed(WebContent.ROUTE_NAME,
          arguments:
              WebContentArguments(UrlConstants.DOC_PRIME_URL, 'DOCPRIME'));
    }
  }

  rootBundle.loadString(AssetConstants.doc_prime_disclaimer).then((disclaimer) {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: ProductDisclaimerWidget(S.of(context).disclaimer_title,
                  onClick, disclaimer, S.of(context).agree_terms_info)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: ProductDisclaimerWidget(S.of(context).disclaimer_title,
                  onClick, disclaimer, S.of(context).agree_terms_info)));
    }
  });
}

enum OnClickId { CLAIM, NETWORK_HOSPITAL, BOOK_DOCTOR_CARD, FITTERNITY_CARD }
