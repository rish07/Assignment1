import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/product_info/product_info_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/loader/loader_api_provider.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/loader/loader_api_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/common_buy_journey/prdoduct_info.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_disclaimer_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import '../log_screen.dart';
import '../web_content.dart';
import 'arogya_plus/arogya_plus_product_info_screen.dart';
import 'network_hospital/network_hospital_screen_phase1.dart';

class NavigationDrawer extends StatelessWidget with CommonWidget{

  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Function(NavigationConstants, [dynamic]) onClickNavigationDrawer;

  NavigationDrawer(this.onClickNavigationDrawer);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_type_gradient_color2,
                          ColorConstants.policy_type_gradient_color1
                        ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      margin: EdgeInsets.only(left: 20, top: 18),
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        S.of(context).hi_there,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
//                    Padding(
//                      padding: const EdgeInsets.only(left: 20.0),
//                      child: Text(
//                        "Dev 23/03/2020 Build",
//                        style: TextStyle(
//                            color: ColorConstants.policy_type_gradient_color1,
//                            fontSize: 8.0,
//                            letterSpacing: 0.5,
//                            fontWeight: FontWeight.w500),
//                      ),
//                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 2, bottom: 20),
                      child: Text(
                        S.of(context).home_title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 18.0),
                        InkResponse(
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 200), () {
                                Navigator.of(context).pushNamed(
                                    ClaimIntimationScreen.ROUTE_NAME);
                              });
                            },
                            child: _buildRow(
                                AssetConstants.ic_menu_claim_intimation,
                                S.of(context).claim_intimation_title)),
                        _buildDivider(),
                        InkResponse(
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 200), () {
                                // Navigator.of(context).pushNamed(NetworkHospitalPinCodeScreen.routeName);
                                /// Pincode based search is removed from the ui. Now user can search with pincode and area
                                Navigator.of(context).pushNamed(
                                    NetworkHospitalScreen.ROUTE_NAME);
                              });
                            },
                            child: _buildRow(
                                AssetConstants.ic_menu_network_hospital,
                                S.of(context).network_hospitals_title)),
                        _buildDivider(),
                        InkResponse(
                            onTap: () {
                              Navigator.pop(context);
                              onClick(bool isAgree) {
                                if (isAgree) {
//                                  bool isUserDataAvailable =
//                                      prefsHelper.isDocPrimeUserDataAvailable();
//                                  if (isUserDataAvailable ?? false) {
//                                    Future.delayed(Duration(milliseconds: 250),
//                                        () {
//                                      Navigator.of(context).pushNamed(
//                                          WebContent.routeName,
//                                          arguments:
//                                              UrlConstants.DOC_PRIME_URL);
//                                    });
//                                  } else {
//                                    Future.delayed(Duration(milliseconds: 250),
//                                        () {
//                                      Navigator.of(context).pushNamed(
//                                          PartnerUiSignInScreen.routeName);
//                                    });
//                                  }
//                                  Future.delayed(Duration(milliseconds: 1000),
//                                          () {
//                                        Navigator.of(context).pushNamed(
//                                            WebContent.routeName,
//                                            arguments: WebContentArguments(
//                                                UrlConstants.DOC_PRIME_URL,
//                                                'DOCPRIME'));
//                                      });
                                   onClickNavigationDrawer(NavigationConstants.DOCPRIME_DISCLAIMER);
                                }
                              }

                              rootBundle
                                  .loadString(
                                  AssetConstants.doc_prime_disclaimer)
                                  .then((disclaimer) {
                                if (Platform.isIOS) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          WillPopScope(
                                              onWillPop: () {
                                                return Future<bool>.value(true);
                                              },
                                              child: ProductDisclaimerWidget(
                                                  S
                                                      .of(context)
                                                      .disclaimer_title,
                                                  onClick,
                                                  disclaimer,
                                                  S
                                                      .of(context)
                                                      .agree_terms_info)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          WillPopScope(
                                              onWillPop: () {
                                                return Future<bool>.value(true);
                                              },
                                              child: ProductDisclaimerWidget(
                                                  S
                                                      .of(context)
                                                      .disclaimer_title,
                                                  onClick,
                                                  disclaimer,
                                                  S
                                                      .of(context)
                                                      .agree_terms_info)));
                                }
                              });
                            },
                            child: _buildRow(
                                AssetConstants.ic_menu_health_service,
                                S.of(context).book_doctor_online_title)),
                        _buildDivider(),
                        InkResponse(
                            onTap: () {
                              Navigator.pop(context);
                              Future.delayed(Duration(milliseconds: 200), () {
                                Navigator.of(context).pushNamed(
                                    ArogyaPlusProductInfoScreen.ROUTE_NAME);
                              });
                            },
                            child: _buildRow(
                                AssetConstants.ic_menu_buy_arogya_plus,
                                S.of(context).buy_arogya_plus)),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                            //_makeApiCall(StringConstants.FROM_CRITICAL_ILLNESS, context);
                            onClickNavigationDrawer(NavigationConstants.PRODUCT_INFO, StringConstants.FROM_CRITICAL_ILLNESS);
//                            Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
//                                arguments: ProductInfoArguments(
//                                    StringConstants.FROM_CRITICAL_ILLNESS, null));
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_privacy_policy,
                              S.of(context).critical_illness),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                            showTnCandPrivacyPolicyDialog(
                                termsConditions, context);
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_terms_conditions,
                              S.of(context).terms_conditions),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                            showTnCandPrivacyPolicyDialog(
                                privacyPolicy, context);
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_privacy_policy,
                              S.of(context).privacy_policy),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                           // _makeApiCall(StringConstants.FROM_AROGYA_PREMIER, context);
                            onClickNavigationDrawer(NavigationConstants.PRODUCT_INFO, StringConstants.FROM_AROGYA_PREMIER);
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_privacy_policy,
                              S.of(context).arogya_premier),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                            //_makeApiCall(StringConstants.FROM_AROGYA_TOP_UP, context);
                            onClickNavigationDrawer(NavigationConstants.PRODUCT_INFO, StringConstants.FROM_AROGYA_TOP_UP);
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_privacy_policy,
                              S.of(context).arogya_top_up),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () {
                            Navigator.pop(context);
                            Future.delayed(Duration(milliseconds: 200), () {
                              Navigator.of(context)
                                  .pushNamed(LogScreen.ROUTE_NAME);
                            });
                          },
                          child: _buildRow(
                              AssetConstants.ic_bulb, "Log(Debugging Purpose)"),
                        ),
                        _buildDivider(),
                        InkResponse(
                          onTap: () async {
                            await prefsHelper.setToken(null);
                            await prefsHelper.setUserIsLoggedIn(false);
                            await prefsHelper.setUserIsLinkedPolicy(false);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                WelcomeScreen.ROUTE_NAME,
                                    (Route<dynamic> route) => false);
                          },
                          child: _buildRow(
                              AssetConstants.ic_menu_privacy_policy,
                              prefsHelper.isUserLoggedIn()
                                  ? S.of(context).logout_title
                                  : S.of(context).sign_in),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String assetString, String title, {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 40),
        child: Row(children: [
          Image(height: 20, width: 20, image: AssetImage(assetString)),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.blue,
              elevation: 5.0,
              shadowColor: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "10+",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.grey[400],
    );
  }

  Widget _logoutWidget(String icon, String title) {
    final TextStyle tStyle = TextStyle(
        color: Colors.blue,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
        letterSpacing: .75);
    return Container(
      padding: const EdgeInsets.only(top: 10.0, bottom: 12),
      child: Row(children: [
        Image(
          height: 20,
          width: 20,
          image: AssetImage(icon),
        ),
        SizedBox(width: 10.0),
        Text(
          title,
          style: tStyle,
        ),
      ]),
    );
  }

  showTnCandPrivacyPolicyDialog(int from, BuildContext context) {
    BaseApiProvider.isInternetConnected().then((isConnected) {
      if (isConnected) {
        if (from == termsConditions) {
          Navigator.of(context).pushNamed(WebContent.ROUTE_NAME,
              arguments: WebContentArguments(
                  UrlConstants.TERMS_OF_USE_WEBVIEW_URL, 'TERMS',
                  title: S.of(context).terms_conditions.toUpperCase()));
          /*showWebView(UrlConstants.TERMS_OF_USE_WEBVIEW_URL,
              " "+S.of(context).terms_conditions, DialogKind.T_n_C, 0, context);*/
        } else {
          Navigator.of(context).pushNamed(WebContent.ROUTE_NAME,
              arguments: WebContentArguments(
                  UrlConstants.AROGYA_PLUS_PRIVACY_POLICY_WEBVIEW_URL,
                  'PRIVACY',
                  title: S.of(context).privacy_policy.toUpperCase()));
          /* showWebView(UrlConstants.AROGYA_PLUS_PRIVACY_POLICY_WEBVIEW_URL,
              " "+S.of(context).privacy_policy, DialogKind.PRIVACY_POLICY, 0, context);*/
        }
      } else {
        showNoInternetDialog(context, from, (int retryIdentifier) {
          showTnCandPrivacyPolicyDialog(from, context);
        });
      }
    });
  }
}
