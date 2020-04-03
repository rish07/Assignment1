import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/utilities/page_indicator_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = "/onboarding";
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

/// 1212 x 1740
class _OnboardingScreenState extends State<OnboardingScreen> {
  double imageWidth, imageHeight;
  
  int currentPage = 0;

  List<SwipperItem> _swipperItems;

  PageController _pageController;
  PageIndicatorController _pageIndicatorController = PageIndicatorController();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _swipperItems = [
      SwipperItem(
          S.of(context).buy_a,
          S.of(context).policy,
          S.of(context).onboarding_buy_a_policy_message,
          AssetConstants.bg_onboarding_1
      ),
      SwipperItem(
          S.of(context).intimate_a,
          S.of(context).claim,
          S.of(context).onboarding_claim_intimation_message,
          AssetConstants.bg_onboarding_2
      ),
      SwipperItem(
          S.of(context).book_health,
          S.of(context).services,
          S.of(context).onboarding_book_health_service_message,
          AssetConstants.bg_onboarding_3
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    imageWidth = ScreenUtil.getInstance(context).screenPercentWidth(80);
    imageHeight = (1740.0/1212.0) * imageWidth;
    return Scaffold(
      backgroundColor: ColorConstants.opd_amount_text_color,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(1, .8),
            child: Transform.rotate(
              angle: pi,
              child: Image(
                height: 120,
                fit: BoxFit.fill,
                image: AssetImage(AssetConstants.onboarding_half_circle),
              ),
            ),
          ),
          Align(
            alignment: Alignment(-1.1, .1),
            child: Image(
              height: 120,
              fit: BoxFit.fill,
              image: AssetImage(AssetConstants.onboarding_half_circle),
            ),
          ),
          Visibility(
            visible: true,
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                _pageItem(
                    _swipperItems[0],
                ),
                _pageItem(
                    _swipperItems[1],
                ),
                _pageItem(
                    _swipperItems[2],
                )
              ],
              onPageChanged: (currPage) {
                this.currentPage = currPage;
                _pageIndicatorController.notifyPageChange(currentPage);
              },
            ),
          ),
          Transform.rotate(
            angle: -80/360,
            child: Align(
              alignment: Alignment(-1, 1),
              child: Image(
                fit: BoxFit.fill,
                height: ScreenUtil.getInstance(context).screenPercentageHeight(50),
                image: AssetImage(AssetConstants.onboarding_dotted_curve_1),
              ),
            ),
          ),
          Transform.rotate(
            angle: -45/360,
            child: Align(
              alignment: Alignment(1, -1),
              child: Image(
                fit: BoxFit.fill,
                height: ScreenUtil.getInstance(context).screenPercentageHeight(50),
                image: AssetImage(AssetConstants.onboarding_dotted_curve_2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: EdgeInsets.only(left: 20, bottom: 25),
              child: PageIndicatorWidget(
                  _swipperItems.length,
                0,
                Colors.grey.shade100.withOpacity(0.3),
                Colors.white,
                18,
                _pageIndicatorController
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 10, right: 20),
              child: InkWell(
                onTap: () {
                  if(currentPage < _swipperItems.length-1) {
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.decelerate);
                  } else {
                    prefsHelper.setToFirstTimeLaunchDone();
//                    Navigator.pushReplacementNamed(
//                      context, HomeScreen.ROUTE_NAME,
//                    );
                    Navigator.pushReplacementNamed(
                      context, WelcomeScreen.ROUTE_NAME,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(S.of(context).next.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: .75),),
                      SizedBox(width: 5,),
                      Image.asset(
                          AssetConstants.ic_long_right_arrow_white,
                        width: 25,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _pageItem(SwipperItem swipperItem) {
    return Align(
      alignment: Alignment(0, -.4),
      child: Container(
        height: imageHeight,
        width: imageWidth,
        child: Center(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Image(
                  width: ScreenUtil.getInstance(context).screenWidthDp - 50,
                  fit: BoxFit.contain,
                  image: AssetImage(swipperItem.image),
                ),
              ),
              Align(
                alignment: Alignment(0, .7),
                child: Container(
                  margin: EdgeInsets.only(left: 12, right: 12,),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: <TextSpan> [
                          TextSpan(text: swipperItem.headerNormalPart, style: TextStyle(fontSize: 22, color: Colors.black)),
                          TextSpan(text: swipperItem.headerBoldPart, style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w900)),
                          TextSpan(text: '\n\n'),
                          TextSpan(text: swipperItem.message, style: TextStyle(fontSize: 14, color: Colors.grey.shade600))
                        ]
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}

class SwipperItem {
  final String headerNormalPart, headerBoldPart;
  final String message;
  final String image;

  SwipperItem(this.headerNormalPart, this.headerBoldPart, this.message, this.image);

}
