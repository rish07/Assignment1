import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/thank_you/critical_illness_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/thank_you/critical_thank_you_widget_bloc.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/download_models.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/permission_service.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';
class CriticalIllnessThankYouWidget extends StatelessWidget {
  final Function(int) onClick;
  final List<MapModel> list;
  final String policyId;
  final String description;
  CriticalIllnessThankYouWidget(this.onClick, this.list, this.policyId, this.description);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: CriticalIllnessThankYouWidgetBloc(),
      child: _CriticalIllnessThankYouWidgetInternal(onClick, list, policyId, description),
    );
  }

}
class _CriticalIllnessThankYouWidgetInternal extends StatefulWidget {

  final Function(int) onClick;
  final List<MapModel> list;
  final String policyId;
  final String description;
  _CriticalIllnessThankYouWidgetInternal(this.onClick, this.list, this.policyId, this.description);

  @override
  __CriticalIllnessThankYouWidgetInternalState createState() => __CriticalIllnessThankYouWidgetInternalState();
}

class __CriticalIllnessThankYouWidgetInternalState extends State<_CriticalIllnessThankYouWidgetInternal> with CommonWidget {

  CriticalIllnessThankYouWidgetBloc _bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentApiCall = -1;

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<CriticalIllnessThankYouWidgetBloc>(context);

    _bloc.uiEventStream.listen((e) {
      if(e is DownloadCompleteEvent) {
        DownloadCompleteEvent event = e;
        _handleDownloadInformation(event.downloadResponse, event.docType, event.policyId);
      } else if(e is DialogEvent) {
        DialogEvent event = e;

        handleApiError(context, _currentApiCall, (retryId) {
          switch(retryId) {
            case ApiCallIdentifier.HEALTH_CARD:
              _executeHealthCardDownloadApi();
              break;
            case ApiCallIdentifier.POLICY_DETAILS:
              _executePolicyDetailsDownloadApi();
              break;
          }
        }, event.dialogType);

      } else if(e is LoadingScreenUiEvent) {
        LoadingScreenUiEvent event = e;
        if(event.isVisible) {
          showLoaderDialog(context);
        } else {
          hideLoaderDialog(context);
        }
      }
    });
    super.initState();
  }

  void _handleDownloadInformation(DownloadResponse downloadResponse, DocType docType, String policyId) async {
    String fileName;
    String successMessagePart;
    String failedMessage;
    if(docType == DocType.HEALTH_CARD) {
      fileName = "HealthCard_$policyId";
      successMessagePart = S.of(context).health_card_downloaded_successfully;
      failedMessage = S.of(context).health_card_download_failed;
    } else {
      fileName = "Policy Document_$policyId";
      successMessagePart = S.of(context).policy_document_downloaded_successfully;
      failedMessage = S.of(context).policy_document_download_failed;
    }
    try {
      fileName = "$fileName.pdf";
      Uint8List uint8list = Base64Decoder().convert(
          downloadResponse.data.payload.pDFStream);
      var dirToSave = await downloadDirectory(policyId);
      debugPrint("directiry: ${dirToSave.path}");

      File file = File("${dirToSave.path}/$fileName");
      File savedFile = await file.writeAsBytes(uint8list);

      if (savedFile != null) {
        if (savedFile.path != null) {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text("$successMessagePart"),
              duration: Duration(seconds: 60),
              action: SnackBarAction(
                label: S
                    .of(context)
                    .open.toUpperCase(),
                textColor: ColorConstants.disco,
                onPressed: () {
                  OpenFile.open(savedFile.path);
                },
              ),
            ),);
          return;
        }
      }
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(failedMessage),));
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<bool> _onBackPressed() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    void navigateToHome() {
      Navigator.of(context).pop();
      widget.onClick(1);
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.black.withOpacity(0.5),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: getCloseButton(onClose: navigateToHome),
                            ))),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(40)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top:20.0, left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              width: ScreenUtil.getInstance(context).screenPercentWidth(30),
                              child: Image.asset(AssetConstants.ic_arogya_congrats)),

                          Text(
                            S.of(context).congratulations,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                letterSpacing: 0.46),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                            width: ScreenUtil.getInstance(context).screenPercentWidth(75),
                            child: Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700]),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.list.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildPremiumDetailsValueItem(widget.list[index]);
                                }),
                          ),
                          Visibility(
                            visible: !TextUtils.isEmpty(widget.policyId),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                _bottomButtons(context, S.of(context).download_policy, () {
                                  _executePolicyDetailsDownloadApi();
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          BlackButtonWidget(navigateToHome,
                            S.of(context).thank_you_title.toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  buildPremiumDetailsValueItem(MapModel mapItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              mapItem.key,
              style: TextStyle(color: Colors.grey[600], fontSize: 13.0, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              mapItem.value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButtons(BuildContext context, String title, Function onClick) {
    return InkResponse(
      onTap: (){
        onClick();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(color: ColorConstants.disco)
        ),
        child: Container(
          width: ScreenUtil.getInstance(context).screenPercentWidth(50),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: ColorConstants.disco),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Icon(
                    Icons.file_download
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _executeHealthCardDownloadApi() {
    checkStoragePermission(context, () {
      _currentApiCall = ApiCallIdentifier.HEALTH_CARD;
      _bloc.download(DocType.HEALTH_CARD, widget.policyId);
    }, _scaffoldKey);
  }

  void _executePolicyDetailsDownloadApi() {
    checkStoragePermission(context, () {
      _currentApiCall = ApiCallIdentifier.POLICY_DETAILS;
      _bloc.download(DocType.POLICY_DOCUMENT, widget.policyId);
    }, _scaffoldKey);
  }

//  void checkStoragePermission(Function taskToExecuteIfGranted) {
//    PermissionService().requestPermission(PermissionGroup.storage, onGranted: () {
//      taskToExecuteIfGranted();
//    }, onDenied: () {
//      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(S.of(context).need_storage_permission),));
//    }, onUserCheckedNeverOnAndroid: () {
//      showDialog(context: context,
//          builder: (context) {
//            return AlertDialog(
//              content: Text(S.of(context).need_storage_permission),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text(S.of(context).cancel, style: TextStyle(color: Colors.black),),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                ),
//                FlatButton(
//                  child: Text(S.of(context).open_settings, style: TextStyle(color: Colors.black),),
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                    PermissionHandler().openAppSettings();
//                  },
//                ),
//              ],
//            );
//          });
//    });
//  }

//  Future<Directory> _downloadDirectory(String policyId) async {
//    Directory rootDir;
//    String dirName = "SBIGInsurance";
//    if(Platform.isAndroid) {
//      rootDir = Directory('/storage/emulated/0/');
//      bool rootExists = await rootDir.exists();
//      if(!rootExists) {
//        rootDir = await getExternalStorageDirectory();
//      }
//    } else {
//      dirName = "/"+dirName;
//      rootDir = await getApplicationDocumentsDirectory();
//    }
//    debugPrint("getExternalStorageDirectory:  ${rootDir.path}");
//    Directory downloadDirectory = Directory('${rootDir.path}$dirName/$policyId');
//    bool exists = await downloadDirectory.exists();
//    if(!exists) await downloadDirectory.create(recursive: true);
//    return downloadDirectory;
//  }
}

class ApiCallIdentifier {
  static const HEALTH_CARD = 1;
  static const POLICY_DETAILS = 2;
}

