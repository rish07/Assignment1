import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_eia_number_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_policy_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/contact_sbig_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/faqs_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/my_downloads_screen.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_options/whats_covered_screen.dart';
import 'package:sbig_app/src/ui/screens/web_content.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_disclaimer_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus_card_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/banners_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/connectus_card_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/critical_illness/critical_illness_card_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/home_service_card_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'network_hospital/network_hospital_screen_phase1.dart';
import 'network_hospital/pin_code_screen.dart';

class HomeTab extends StatefulWidgetBase {
  Function() onOpenDrawer;

  HomeTab(this.onOpenDrawer);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with CommonWidget {
  ServiceModel networkHospitalServiceModel;
 // ServiceModel criticalIllness;
  ServiceModel arogyaPremier;

  double _screenWidth;
  final double _gridPadding = 10.0;
  final int _gridItemCount = 3;
  final double spaceBetweenItems = 12;
  double _widthForEachGridItems;

  @override
  void didChangeDependencies() {
    _screenWidth = MediaQuery.of(context).size.width;
    _widthForEachGridItems = (_screenWidth - (_gridPadding *2) - (spaceBetweenItems * (_gridItemCount - 1)))/_gridItemCount;
    networkHospitalServiceModel = ServiceModel(
        title: S.of(context).arogya_plus_title,
        subTitle: S.of(context).health_insurance_title,
        isSubTitleRequired: true,
        points: [
          S.of(context).arogya_plus_point1,
          S.of(context).arogya_plus_point2,
          S.of(context).arogya_plus_point3,
          S.of(context).arogya_plus_point4
        ],
        icon: AssetConstants.bg_arogya_plus,
        color1: ColorConstants.arogya_plus_gradient_color1,
        color2: ColorConstants.arogya_plus_gradient_color2);
//    criticalIllness = ServiceModel(
//        title: S.of(context).critical_illness,
//        subTitle: S.of(context).health_insurance_title,
//        isSubTitleRequired: true,
//        points: [
//          S.of(context).arogya_plus_point1,
//          S.of(context).arogya_plus_point2,
//          S.of(context).arogya_plus_point3,
//          S.of(context).arogya_plus_point4
//        ],
//        icon: AssetConstants.bg_arogya_plus,
//        color1: ColorConstants.arogya_plus_gradient_color1,
//        color2: ColorConstants.arogya_plus_gradient_color2);

    arogyaPremier = ServiceModel(
        title: S.of(context).arogya_premier,
        subTitle: S.of(context).health_insurance_title,
        isSubTitleRequired: true,
        points: [
          S.of(context).arogya_plus_point1,
          S.of(context).arogya_plus_point2,
          S.of(context).arogya_plus_point3,
          S.of(context).arogya_plus_point4
        ],
        icon: AssetConstants.bg_arogya_plus,
        color1: ColorConstants.arogya_plus_gradient_color1,
        color2: ColorConstants.arogya_plus_gradient_color2);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[BannersWidget(), customAppBar(), _homeWidgets(context)],
        )
      ],
    );
  }

  Widget customAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: Platform.isIOS ? 10.0 : NavigationToolbar.kMiddleSpacing,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: imageWidget(AssetConstants.ic_toolbar_sbig_white, null)),
      ),
      actions: <Widget>[
        InkResponse(
          onTap: () {
            widget.onOpenDrawer();
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset(AssetConstants.ic_toolbar_menu_white),
            ),
          ),
        )
      ],
    );
  }

  Widget _homeWidgets(BuildContext context) {
    return Container(
      ///1.873 is the height factor calculated for IPad, 50 is the overlay padding, 15 the padding of page indicators
      margin: EdgeInsets.only(top: isIPad(context) ? ScreenUtil.getInstance(context).screenWidthDp/1.873-50+15 : 175.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                // offset: Offset(0, 0),
                color: Colors.black38,
                spreadRadius: 12)
          ],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0))),
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(top: 15.0, right: _gridPadding, left: _gridPadding),
              height: _widthForEachGridItems * HomeServiceCardWidget.heightAspectRatio,
              alignment: Alignment.topLeft,
              child: Row(
                children: _getGridItems(),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 12, right: 12),
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ArogyaPlusCardWidget(networkHospitalServiceModel),
              )),

//          Container(
//              margin: EdgeInsets.only(left: 12, right: 12),
//              child: Padding(
//                padding: const EdgeInsets.only(top: 5.0),
//                child: CriticalIllnessCardWidget(criticalIllness),
//              )),

          Container(
            margin: EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 12),
              child: ConnectUsCardWidget(),
          ),

          Container(
            color: ColorConstants.home_disclaimer_reddish,
            margin: EdgeInsets.only(top: 5, bottom: 12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
              child: RichText(
                  text: TextSpan(
                      children: <TextSpan> [
                        TextSpan(text: S.of(context).disclaimer_title.toUpperCase(), style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700)),
                        TextSpan(text: '\n\n'),
                        TextSpan(text: StringConstants.HOME_DISCLAIMER, style: TextStyle(fontSize: 14, color: Colors.black))
                      ]
                  )
              ),
            ),
          )
          //SizedBox(height: 54,)
        ],
      ),
    );
  }

  List<Widget> _getGridItems() {
    List<Widget> _gItems = [
      InkWell(
        onTap: () {
          Future.delayed(Duration(milliseconds: 100), (){
            Navigator.of(context)
                .pushNamed(ClaimIntimationScreen.ROUTE_NAME);
          });
        },
        child: HomeServiceCardWidget(
            ServiceModel(
                title: S.of(context).claim_intimation_title,
                icon: AssetConstants.ic_note,
                color1: ColorConstants.network_hospital_gradient_color1,
                color2:
                ColorConstants.network_hospital_gradient_color2),
            borderRadius(topLeft: 30.0, radius: 5.0),
            0.5, _widthForEachGridItems),
      ),

      InkResponse(
        onTap: () {
          Future.delayed(Duration(milliseconds: 100)).then((aValue) {
           // Navigator.of(context).pushNamed(NetworkHospitalPinCodeScreen.routeName);
            /// Pincode based search is removed from the ui. Now user can search with pincode and area
            Navigator.of(context).pushNamed(NetworkHospitalScreen.ROUTE_NAME);
          });
        },
        child: HomeServiceCardWidget(
            ServiceModel(
                title: S.of(context).network_hospitals_title,
                icon: AssetConstants.ic_home_network_hospitals,
                color1: ColorConstants
                    .network_hospital_gradient_color1,
                color2: ColorConstants
                    .network_hospital_gradient_color2),
            borderRadius(radius: 5.0, topRight: 5.0, topLeft: 5.0), 1, _widthForEachGridItems),
      ),

      InkResponse(
        onTap: (){
          onClick(bool isAgree) {
            if (isAgree) {
//                          bool isUserDataAvailable = prefsHelper.isDocPrimeUserDataAvailable();
//                          if(isUserDataAvailable ?? false) {
//                            Navigator.of(context).pushNamed(WebContent.routeName, arguments: UrlConstants.DOC_PRIME_URL);
//                          } else {
//                            Navigator.of(context).pushNamed(PartnerUiSignInScreen.routeName);
//                          }
              //  Navigator.of(context).pushNamed(WebContent.routeName, arguments: UrlConstants.DOC_PRIME_URL);
              Navigator.of(context).pushNamed(WebContent.ROUTE_NAME, arguments: WebContentArguments(UrlConstants.DOC_PRIME_URL,'DOCPRIME'));
              //Navigator.of(context).pushNamed(OTPScreen.ROUTE_NAME, arguments: OTPScreenArguments("967567888", "5678", "6789", null));
            }
          }
          rootBundle
              .loadString(AssetConstants.doc_prime_disclaimer)
              .then((disclaimer) {
                if(Platform.isIOS){
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          WillPopScope(
                              onWillPop: () {
                                return Future<bool>.value(true);
                              },
                              child: ProductDisclaimerWidget(S
                                  .of(context)
                                  .disclaimer_title, onClick,
                                  disclaimer, S
                                      .of(context)
                                      .agree_terms_info)));
                }else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          WillPopScope(
                              onWillPop: () {
                                return Future<bool>.value(true);
                              },
                              child: ProductDisclaimerWidget(S
                                  .of(context)
                                  .disclaimer_title, onClick,
                                  disclaimer, S
                                      .of(context)
                                      .agree_terms_info)));
                }
          });

        },
        child: HomeServiceCardWidget(
            ServiceModel(
                title: S.of(context).book_doctor_online_title2,
                icon: AssetConstants.ic_health_services,
                color1: ColorConstants.network_hospital_gradient_color1,
                color2:
                ColorConstants.network_hospital_gradient_color2),
            borderRadius(radius: 5.0, topRight: 5.0, topLeft: 5.0),
            0.3, _widthForEachGridItems),
      ),
    ];

    if(_gItems.length != _gridItemCount) {
      throw StateError("Grid Item count did not match.");
    }

    return _gItems;
  }
}
