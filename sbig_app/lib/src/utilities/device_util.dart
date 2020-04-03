// https://github.com/OpenFlutter/flutter_screenutil
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class DeviceUtil {
  static DeviceUtil instance;

  static String _platform;
  static String _osVersion;
  static String _manufacturer;
  static String _model;
  static String _appVersion;
  static String _buildNumber;

  DeviceUtil();

  static DeviceUtil getInstance(BuildContext context) {
    if(instance == null) {
      return instance = DeviceUtil._(context);
    }
    return instance;
  }

  DeviceUtil._(BuildContext context) {
    if(Platform.isAndroid) {
      DeviceInfoPlugin().androidInfo.then((androidInfo) {
        _platform = "Android";
        _osVersion = androidInfo.version.release.replaceAll(RegExp('[^\u0001-\u007F]'),'_');
        _manufacturer = androidInfo.manufacturer.replaceAll(RegExp('[^\u0001-\u007F]'),'_');
        _model = androidInfo.model.replaceAll(RegExp('[^\u0001-\u007F\']'),'_');;
      });
    }

    if(Platform.isIOS){
      DeviceInfoPlugin().iosInfo.then((iosInfo){
        _platform = "iOS";
        _osVersion = iosInfo.systemVersion.replaceAll(RegExp('[^\u0001-\u007F]'),'_');
        _manufacturer = iosInfo.name.replaceAll(RegExp('[^\u0001-\u007F]'),'_');
        _model = iosInfo.model.replaceAll(RegExp('[^\u0001-\u007F\']'),'_');
      });
    }

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      _appVersion = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  String get platform => _platform;

  String get osVersion => _osVersion;

  String get manufacturer => _manufacturer;

  String get model => _model;

  String get appVersion => _appVersion;

  String get buildNumber => _buildNumber;

}