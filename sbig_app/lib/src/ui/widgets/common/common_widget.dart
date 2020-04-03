import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/device_util.dart';
import 'package:sbig_app/src/utilities/email_input_formatter.dart';
import 'package:sbig_app/src/utilities/permission_service.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../statefulwidget_base.dart';

class CommonWidget {
  bool _isDialogVisible = false;
  final String directoryPath = "/SBIGInsurance";
  EmailTextFormatter emailTextFormatter = EmailTextFormatter(RegExp(r"[a-zA-Z0-9.@_!#%&'*+-/=?^_`{|}~(),:;<>$]"));

  final int termsConditions = 1;
  final int privacyPolicy = 2;
  final int taxBenefit = 3;
  final int opdBenefit = 4;
  final int policyBenefit = 5;
  final double imageWidthPercent = 0.85;

  void showLoaderDialog(BuildContext context) {
    if (_isDialogVisible == true) return;
    _isDialogVisible = true;

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return LoadingScreen();
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingScreen();
          });
    }
  }

  void hideLoaderDialog(BuildContext context) {
    if (_isDialogVisible) Navigator.of(context).pop();
    _isDialogVisible = false;
  }

  BorderRadius borderRadius(
      {double radius = 5.0, double topLeft = 5.0, topRight = 5.0}) {
    return BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  BorderRadius borderRadiusAll(
      {double radius = 5.0}) {
    return BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius));
  }

  BorderRadius borderRadiusCustom(
      {double topLeft = 0.0, topRight = 0.0, double bottomLeft = 0.0, bottomRight = 0.0}) {
    return BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight));
  }

  Widget imageWidget(String icon, Function() onClick) {
    return InkResponse(onTap: onClick, child: Image.asset(icon));
  }

  Widget closeImageWidget(Function() onClick) {
    return FlatButton(
      onPressed: onClick,
      color: Colors.transparent,
      shape: CircleBorder(
          side: BorderSide(style: BorderStyle.solid, color: Colors.white)),
      child: Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  Route createRoute(Widget toScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => toScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  AppBar getAppBar(BuildContext context, String title,
      {backActionRequired = true, Function(int) onBackPressed,
        int isFrom,
        Color titleColor = Colors.black,
        double fontSize = 14.0,
        bool isNormal = true,
        double letterSpacing = 1.0, isActionRequired = false, Widget actionWidget, String actionName = "", Color actionTextColor = Colors.black, double widthOfAction = 65.0, Function() onActionClicked, backgroundColor = Colors.transparent}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
      leading: backActionRequired ? InkResponse(
          onTap: () {
            if (onBackPressed != null) {
              onBackPressed(isFrom);
            } else {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 0.0, top: 18.0, bottom: 18.0),
            child: (titleColor == Colors.white)
                ? Image.asset(AssetConstants.ic_left_arrow_white)
                : Image.asset(AssetConstants.ic_left_arrow),
          )) : null,
      actions: isActionRequired ? <Widget>[
        (actionWidget == null) ? SizedBox(
          width: widthOfAction,
          child: FlatButton(
            onPressed: () {
              onActionClicked();
            },
            child: Text(
              "$actionName", style: TextStyle(color: actionTextColor, fontSize: 12.0, fontWeight: FontWeight.w500),
            ),
          ),
        ) : actionWidget
      ] : null,
      centerTitle: true,
      title: Text(
        title,
        style: isNormal
            ? TextStyle(
            color: titleColor,
            fontStyle: FontStyle.normal,
            fontSize: fontSize,
            letterSpacing: letterSpacing)
            : TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
            letterSpacing: letterSpacing),
      ),
    );
  }

  skipOnboard(BuildContext context){
     Navigator.of(context).pushReplacementNamed(HomeScreen.ROUTE_NAME);
  }

//  getCloseButton(
//      {Color color = Colors.white, double width = 30.0, Function onClose}) {
//    return InkWell(
//      onTap: onClose,
//      child: Container(
//        width: width,
//        height: width,
//        decoration: BoxDecoration(
//            border: Border.all(color: color), shape: BoxShape.circle),
//        child: Icon(
//          Icons.close,
//          color: color,
//        ),
//      ),
//    );
//  }

  getCloseButton(
      {Color color = Colors.white, double width = 35.0, Function onClose}) {
    return RawMaterialButton(
      onPressed: onClose,
      constraints: BoxConstraints(maxWidth: width, maxHeight: width, minWidth: width, minHeight: width),
      child: Container(
        width: width,
        height: width,
        decoration: BoxDecoration(
            border: Border.all(color: color), shape: BoxShape.circle),
        child: Icon(
          Icons.close,
          color: color,
        ),
      ),
      shape: CircleBorder(),
    );
  }

  void showNoInternetDialog(
      BuildContext context, int retryIdentifier, Function(int) onRetryClick,
      {bool showCloseButton: true,
      String title,
      String message,
      Function onClose}) {
    if (TextUtils.isEmpty(title)) {
      title = S.of(context).no_internet_dialog_title;
    }
    if (TextUtils.isEmpty(message)) {
      message = S.of(context).no_internet_dialog_message;
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return getDialogStructure(
              context,
              AssetConstants.ic_no_internet,
              showCloseButton,
              title,
              message,
              retryIdentifier,
              onRetryClick,
              onClose, true
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return getDialogStructure(
              context,
              AssetConstants.ic_no_internet,
              showCloseButton,
              title,
              message,
              retryIdentifier,
              onRetryClick,
              onClose, true
            );
          });
    }
  }

  void showMaintenanceDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return _getMaintenanceBuilder(context);
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return _getMaintenanceBuilder(context);
          });
    }
  }

  Widget _getMaintenanceBuilder(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      ColorConstants.policy_type_gradient_color2,
                      ColorConstants.policy_type_gradient_color1
                    ])),
              ),
              Container(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width:
                          MediaQuery.of(context).size.width * imageWidthPercent,
                      child: Image(
                        image: AssetImage(
                            AssetConstants.img_site_under_maintenance),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
                      child: Text(
                        S.of(context).sorry_for_inconvenience,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: Text(
                        S.of(context).app_under_maintenance,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0),
                  child: getCloseButton(onClose: (){
                    Navigator.of(context).pop();
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showServerErrorDialog(
      BuildContext context, int retryIdentifier, Function(int) onRetryClick,
      {bool showCloseButton: true,
      String title,
      String message,
      Function onClose}) {
    if (TextUtils.isEmpty(title)) {
      title = S.of(context).oh_no_dialog_title;
    }
    if (TextUtils.isEmpty(message)) {
      message = S.of(context).oh_no_dialog_message;
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return getDialogStructure(
              context,
              AssetConstants.image_server_error_dialog,
              showCloseButton,
              title,
              message,
              retryIdentifier,
              onRetryClick,
              onClose, false
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return getDialogStructure(
              context,
              AssetConstants.image_server_error_dialog,
              showCloseButton,
              title,
              message,
              retryIdentifier,
              onRetryClick,
              onClose, false
            );
          });
    }
  }

  Widget getDialogStructure(
      BuildContext context,
      String imageAsset,
      bool showCloseButton,
      String title,
      String subTitle,
      int retryIdentifier,
      Function onRetryClick,
      Function onClose, bool isFromInternet) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.maxFinite,
              width: double.infinity,
              color: Colors.black45,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  visible: showCloseButton,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: getCloseButton(onClose: () {
                          Navigator.pop(context);
                          if (onClose != null) {
                            onClose();
                          }
                        }),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(50)),
                    child: Container(
                      color: Colors.white,
                      width: ScreenUtil.getInstance(context)
                          .screenPercentWidth(90),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 36,
                          ),
                          isFromInternet
                              ? Image(
                            width: double.infinity,
                            image: AssetImage(imageAsset),
                            fit: BoxFit.fitWidth,
                          )
                              : Image(
                            height: 160,
                            image: AssetImage(imageAsset),
                          ),
//                          Image(
//                            height: 179,
//                            image: AssetImage(imageAsset),
//                          ),
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontFamily: StringConstants.EFFRA,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Text(
                                subTitle,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: ColorConstants.blakish_1),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: BlackButtonWidget(
                              () {
                                Navigator.of(context).pop();
                                onRetryClick(retryIdentifier);
                              },
                              S.of(context).retry.toUpperCase(),
                              titleFontSize: 12,
                              width: ScreenUtil.getInstance(context)
                                  .screenPercentWidth(60),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleApiError(BuildContext buildContext, int retryIdentifier,
      Function onRetryClick, int statusCode,
      {bool showCloseButton: true,
      String title,
      String message,
      Function onClose}) {
    print("statusCode "+statusCode.toString());
    switch (statusCode) {
      case ApiResponseListenerDio.NO_INTERNET_CONNECTION:
        showNoInternetDialog(buildContext, 0, onRetryClick,
            showCloseButton: showCloseButton,
            title: title,
            message: message,
            onClose: onClose);
        break;
      case DialogEvent.DIALOG_TYPE_NETWORK_ERROR:
        showNoInternetDialog(buildContext, 0, onRetryClick,
            showCloseButton: showCloseButton,
            title: title,
            message: message,
            onClose: onClose);
        break;
      case ApiResponseListenerDio.MAINTENANCE:
        showMaintenanceDialog(buildContext);
        break;
      case ApiResponseListenerDio.DDOS_ERROR:
        showServerErrorDialog(buildContext, 0, onRetryClick,
            showCloseButton: showCloseButton,
            title: "Oh no!!",
            message: "Too many requests. Please try after sometime",
            onClose: onClose);
        break;
      case DialogEvent.DIALOG_TYPE_MAINTENANCE:
        showMaintenanceDialog(buildContext);
        break;
      case DialogEvent.DIALOG_TYPE_OH_SNAP:
        showServerErrorDialog(buildContext, 0, onRetryClick,
            showCloseButton: showCloseButton,
            title: title,
            message: message,
            onClose: onClose);
        break;
      default:
        showServerErrorDialog(buildContext, 0, onRetryClick,
            showCloseButton: showCloseButton,
            title: title,
            message: message,
            onClose: onClose);
        break;
    }
  }

  showWebView(String url, String title, DialogKind dialogKind, int initialScale,
      BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return WebViewDialog(
            url,
            title,
            dialogKind,
            initialScale: initialScale,
          );
        });
  }

  bool isIPad(BuildContext context){
    bool isIPad = false;
    if(Platform.isIOS && DeviceUtil.getInstance(context).model.compareTo("iPad") == 0){
      isIPad = true;
    }
    return isIPad;
  }

  double getScreenWidth(BuildContext context){
    return ScreenUtil
        .getInstance(context)
        .screenWidthDp;
  }

  double getScreenHeight(BuildContext context){
    return ScreenUtil
        .getInstance(context)
        .screenHeightDp;
  }

  Future<Directory> downloadDirectory(String policyId) async {
    Directory rootDir;
    if(Platform.isAndroid) {
      rootDir = await getApplicationSupportDirectory();
//      rootDir = Directory('/storage/emulated/0/');
//      bool rootExists = await rootDir.exists();
//      if(!rootExists) {
//        rootDir = await getExternalStorageDirectory();
//        rootDir = await getApplicationSupportDirectory();
//      }
    } else {
//      dirName = "/"+dirName;
      rootDir = await getApplicationDocumentsDirectory();
    }
    //dirName = "/"+dirName;
    debugPrint("getExternalStorageDirectory:  ${rootDir.path}");
    Directory downloadDirectory = Directory('${rootDir.path}$directoryPath/$policyId');
    bool exists = await downloadDirectory.exists();
    if(!exists) await downloadDirectory.create(recursive: true);
    return downloadDirectory;
  }

  void checkStoragePermission(BuildContext context, Function taskToExecuteIfGranted, GlobalKey<ScaffoldState> _scaffoldKey) {
    PermissionService().requestPermission(PermissionGroup.storage, onGranted: () {
      taskToExecuteIfGranted();
    }, onDenied: () {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(S.of(context).need_storage_permission),));
    }, onUserCheckedNeverOnAndroid: () {
      showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(S.of(context).need_storage_permission),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).cancel, style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(S.of(context).open_settings, style: TextStyle(color: Colors.black),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    PermissionHandler().openAppSettings();
                  },
                ),
              ],
            );
          });
    });
  }
}
