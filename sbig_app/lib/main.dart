  import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/app.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/controllers/service/service_locator.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPrefsHelper().initialize();
  await prefsHelper.setIsReloadRequired(false);
  setupLocator();

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  if(UrlConstants.URL.startsWith("http")) {
    Crashlytics.instance.enableInDevMode = true;
  }

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    runApp(SBIGApp());
  }, onError: Crashlytics.instance.recordError);
}

//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    //systemNavigationBarColor: Colors.blue, // navigation bar color
//    statusBarColor: Colors.black.withOpacity(0.5), // status bar color
//  ));
//SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

