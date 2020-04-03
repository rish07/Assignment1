import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:sbig_app/src/controllers/service/authentication_service.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/onboarding_screen.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';

import 'package:flutter/animation.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/device_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'package:trust_fall/trust_fall.dart';

class SplashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashAnimation(),
    );
  }
}

class SplashAnimation extends StatefulWidget {
  static const routeName = "/splash_anim";

  _SplashAnimationState createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with CommonWidget, TickerProviderStateMixin {
  GifController _gifAnimationController;

  initState() {
    super.initState();
    DeviceUtil.getInstance(context);
    _gifAnimationController =
        GifController(vsync: this, duration: Duration(milliseconds: 2790));
    _gifAnimationController.animateTo(92);
    _gifAnimationController.addStatusListener((animationStatus) {
      if (animationStatus == AnimationStatus.completed ||
          animationStatus == AnimationStatus.dismissed) {
        checkDeviceSecurity();
      }
    });
  }

  checkDeviceSecurity() {
    isJailBroken().then((isJailBroken) {
      if (isJailBroken) {
        showServerErrorDialog(context, 1, (callBack) {
          checkDeviceSecurity();
        },
            message:
                "Sorry! This app only supported on unmodified iOS software.",
            title: "Security Risk");
      } else {
        _checkAuthToken();
      }
    });
  }

  Future<bool> isJailBroken() async {
    if (Platform.isIOS) {
      bool isJailBroken = await TrustFall.isJailBroken;
      return isJailBroken;
    }
    return Future.value(false);
  }

  _checkAuthToken() async {
    AuthResponse authResponse;
    if (!TextUtils.isEmpty(prefsHelper.getToken())) {
      _openHomeScreen();
    } else {
      authResponse = await AuthenticationService(prefsHelper).authenticate();
      if (authResponse.status) {
        _openHomeScreen();
      } else {
        handleApiError(context, 0, (int retryIdentifier) {
          _checkAuthToken();
        }, authResponse.statusCode, showCloseButton: false);
      }
    }
  }

  void _openHomeScreen() {
    if (prefsHelper.isFirstTimeLaunch()) {
      Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
    } else {
      if (prefsHelper.isUserLoggedIn()) {
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.ROUTE_NAME,
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          WelcomeScreen.ROUTE_NAME,
        );
      }
    }
  }

  @override
  dispose() {
    _gifAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: GifImage(
              controller: _gifAnimationController,
              image: AssetImage(AssetConstants.splash_gif),
            ),
          ),
        ),
      ),
    );
  }
}
