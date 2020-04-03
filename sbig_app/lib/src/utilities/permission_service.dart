import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class PermissionService {
  static PermissionService _instance;

  factory PermissionService() {
    if(_instance == null) {
      _instance = PermissionService._private();
    }
    return _instance;
  }

  PermissionService._private() {
    _permissionHandler = PermissionHandler();
  }

  PermissionHandler _permissionHandler;

  void requestPermission(PermissionGroup permissionGroup, {@required Function onGranted, @required Function onDenied, @required Function onUserCheckedNeverOnAndroid}) async {
    var permissionStatus = await _permissionHandler.checkPermissionStatus(permissionGroup);
    if(permissionStatus == PermissionStatus.granted) {
      onGranted();
      return;
    }

    var result = await _permissionHandler.requestPermissions([permissionGroup]);
    if(result[permissionGroup] == PermissionStatus.granted) {
      onGranted();
    } else {
      if(Platform.isIOS){
        onUserCheckedNeverOnAndroid();
        return;
      }
      if(Platform.isAndroid) {
        bool showRationale = await _permissionHandler.shouldShowRequestPermissionRationale(permissionGroup);
        if(!showRationale) {
          onUserCheckedNeverOnAndroid();
          return;
        }
      }
      onDenied();
    }
  }
}