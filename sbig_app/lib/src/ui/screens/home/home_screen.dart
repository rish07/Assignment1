import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/product_info/product_info_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/home_tabs/home_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/loader/loader_api_provider.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/loader/loader_api_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/download_status_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/health_claim_intimation/health_claim_intimation_screen.dart';
import 'package:sbig_app/src/ui/screens/common_buy_journey/prdoduct_info.dart';
import 'package:sbig_app/src/ui/screens/home/benefits_tab.dart';
import 'package:sbig_app/src/ui/screens/home/home_tab.dart';
import 'package:sbig_app/src/ui/screens/home/naivigation_drawer.dart';
import 'package:sbig_app/src/ui/screens/home/services_tab.dart';
import 'package:sbig_app/src/ui/screens/home/tabs/services_tab_v1.dart';
import 'package:sbig_app/src/ui/screens/onboarding/welcome_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/arc_clipper.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/bottom_navigation_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/generic_alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/product_info/product_disclaimer_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import '../log_screen.dart';
import '../web_content.dart';
import 'arogya_plus/arogya_plus_product_info_screen.dart';
import 'network_hospital/network_hospital_screen_phase1.dart';

class HomeScreen extends StatelessWidget {
  static const ROUTE_NAME = "/home_screen";

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: HomeScreenWidget(),
      bloc: HomeBloc(),
    );
  }
}

class HomeScreenWidget extends StatefulWidgetBase {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenWidget>
    with CommonWidget, TickerProviderStateMixin {
//  final Color primary = Colors.white;
//  final Color active = Colors.grey.shade800;
//  final Color divider = Colors.grey.shade600;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  HomeBloc _bloc;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  onOpenDrawer() {
    _key.currentState.openEndDrawer();
  }

  List<Widget> _widgetOptions;
  List<String> message = List<String>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _bloc = SbiBlocProvider.of<HomeBloc>(context);
    _selectedIndex = prefsHelper.isUserLoggedIn() ? 1 : 0;

    _widgetOptions = <Widget>[
      HomeTab(onOpenDrawer),
      ServicesTabV1(_bloc, _key, downloadPdf),
      //ServicesTab(),
      BenefitsTab()
    ];
    _makeLoaderMessageApiCall();
    //checkAlert();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    checkAlert();
    super.didChangeDependencies();
  }

  Future<bool> _willPopScope() {
    SystemNavigator.pop(animated: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _key,
          endDrawer: _buildDrawer(),
          appBar: _selectedIndex == 0
              ? null
              : AppBar(
                  backgroundColor: (_selectedIndex == 1)
                      ? ColorConstants.arogya_plus_gradient_color1
                      : Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: appBarTitle(),
                  titleSpacing:
                      Platform.isIOS ? 10.0 : NavigationToolbar.kMiddleSpacing,
                  actions: <Widget>[
                    InkResponse(
                      onTap: () {
                        _key.currentState.openEndDrawer();
                      },
                      child: Container(
                        child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(_selectedIndex == 0
                                ? AssetConstants.ic_toolbar_menu_white
                                : AssetConstants.ic_toolbar_menu)),
                      ),
                    )
                  ],
                ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Opacity(
                  opacity: (_selectedIndex != 0) ? 0.4 : 0,
                  child: ClipPath(
                    clipper: ArcClipper(),
                    child: Container(
                      height: 280,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            ColorConstants.home_bg_gradient_color1,
                            ColorConstants.home_bg_gradient_color2
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                  ),
                ),
                _widgetOptions.elementAt(_selectedIndex),
                _getDownloadAlert(),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            maintainBottomViewPadding: true,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
              child: BottomNavigationWidget(_selectedIndex, _onItemTapped),
            ),
          )),
    );
  }

  _getDownloadAlert() {
    return StreamBuilder(
        stream: _bloc.downloadStatusStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool isHavingData = snapshot.hasData;

          bool isVisible = isHavingData && !isError;
          DownloadStatusModel downloadStatusModel = DownloadStatusModel();
          if (isVisible) {
            downloadStatusModel = snapshot.data;
          }

          return Visibility(
            visible: isVisible,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                                downloadStatusModel.currentStatusIcon ??
                                    Icons.error,
                                color: Colors.white),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                downloadStatusModel.currentStatus ?? "",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlineButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          borderSide: BorderSide(
                              color: ColorConstants.critical_illness_blue),
                          onPressed: () {
                            if (null == downloadStatusModel.path) {
                              _bloc.addDownloadStatusError(
                                  DownloadFileStatus.CANCEL);
                            } else {
                              OpenFile.open(downloadStatusModel.path);
                              _bloc.addDownloadStatusError(
                                  DownloadFileStatus.DONE);
                            }
                          },
                          child: Text(
                            downloadStatusModel.buttonString ?? "",
                            style: TextStyle(
                                color: ColorConstants.critical_illness_blue,
                                fontSize: 14.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void downloadPdf(DocType docType, String policyId) {
    DownloadStatusModel downloadStatusModel = DownloadStatusModel(
        status: DownloadFileStatus.IN_PROGRESS,
        currentStatus: "Downloading...",
        currentStatusIcon: Icons.file_download,
        buttonString: "Cancel",
        path: null);

    checkStoragePermission(context, () {
      _bloc.changeDownloadStatus(downloadStatusModel);

      _bloc.download(docType, policyId).then((response) async {
        String fileName;
        String successMessagePart;
        String failedMessage;
        String message;
        DateTime dateTime = DateTime.now();
        String date = CommonUtil.instance.convertTo_dd_MMM_yyyy_hhmm(dateTime);

        if (docType == DocType.HEALTH_CARD) {
          fileName = "Health Card_$date";
          message = "Health Card Downloaded";
          //successMessagePart = S.of(context).health_card_downloaded_successfully;
          //failedMessage = S.of(context).health_card_download_failed;
        } else {
          fileName = "Policy Document_$date";
          message = "Policy Document Downloaded";
          //successMessagePart = S.of(context).policy_document_downloaded_successfully;
          //failedMessage = S.of(context).policy_document_download_failed;
        }
        failedMessage = S.of(context).download_failed;

        if (null != response.apiErrorModel) {
          _bloc.addDownloadStatusError(DownloadFileStatus.FAILED);
          _key.currentState.showSnackBar(SnackBar(
            content: Text(response.apiErrorModel.message ?? failedMessage),
          ));
        } else {
          DownloadStatusModel downloadStatusModel = _bloc.getDownloadStatus;
          if (downloadStatusModel != null) {
            if (downloadStatusModel.status == DownloadFileStatus.CANCEL) {
              return;
            }
          }
          try {
            fileName = "$fileName.pdf";
            Uint8List uint8list =
                Base64Decoder().convert(response.data.payload.pDFStream);
            var dirToSave = await downloadDirectory(policyId);
            debugPrint("directiry: ${dirToSave.path}");

            File file = File("${dirToSave.path}/$fileName");
            File savedFile = await file.writeAsBytes(uint8list);

            if (savedFile != null) {
              if (savedFile.path != null) {
                downloadStatusModel = DownloadStatusModel(
                    status: DownloadFileStatus.SUCCESS,
                    currentStatus: message,
                    currentStatusIcon: Icons.check,
                    buttonString: "View",
                    path: savedFile.path);
                _bloc.changeDownloadStatus(downloadStatusModel);
                return;
              }
            }
            _bloc.addDownloadStatusError(DownloadFileStatus.FAILED);
            _key.currentState.showSnackBar(SnackBar(
              content: Text(failedMessage),
            ));
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      });
    }, _key);
  }

  _getLogo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: imageWidget(AssetConstants.ic_toolbar_sbig, null)),
    );
  }

  Widget appBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return _getLogo();
      case 1:
        if (!prefsHelper.isUserLoggedIn()) {
          return _getLogo();
        } else {
          return StreamBuilder(
              stream: _bloc.policyListStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  bool isPolicyListEmpty = snapshot.data;
                  if (isPolicyListEmpty) {
                    return _getLogo();
                  }
                }

                return Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'HELLO! ',
                            style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontFamily: StringConstants.EFFRA_LIGHT,
                                fontSize: 16.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text: prefsHelper.getUserName() ?? "",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontFamily: StringConstants.EFFRA,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          S.of(context).enjoy_services,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
//          return Align(
//            alignment: Alignment.centerLeft,
//            child: Text(
//              S
//                  .of(context)
//                  .services_tab_title,
//              textAlign: TextAlign.start,
//              style: TextStyle(
//                  color: Colors.black,
//                  fontStyle: FontStyle.normal,
//                  fontSize: 16.0),
//            ),
//          );
        break;
      case 2:
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            S.of(context).benefits_tab_title,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
        );
    }
    return null;
  }

  checkAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (prefsHelper.isUserLoggedIn() && prefsHelper.isAlertShown()) {
        prefsHelper.setAlertShown(false);
        showThankYouOrWelcomeAlert(prefsHelper.isUserLinkedPolicy());
      }
    });
  }

  Widget _buildDrawer() {
    onClickNavigationDrawer(NavigationConstants from, [dynamic data]) {
      switch (from) {
        case NavigationConstants.DOCPRIME_DISCLAIMER:
          Future.delayed(Duration(microseconds: 250), () {
            Navigator.of(context).pushNamed(WebContent.ROUTE_NAME,
                arguments: WebContentArguments(
                    UrlConstants.DOC_PRIME_URL, 'DOCPRIME'));
          });
          break;
        case NavigationConstants.PRODUCT_INFO:
          _makeApiCall(data, context);
          break;
      }
    }

    return NavigationDrawer(onClickNavigationDrawer);
//    return SafeArea(
//      bottom: false,
//      child: ClipRRect(
//        borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
//        child: Drawer(
//          child: Column(
//            children: <Widget>[
//              Container(
//                width: double.infinity,
//                decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                        begin: Alignment.topRight,
//                        end: Alignment.bottomLeft,
//                        colors: [
//                      ColorConstants.policy_type_gradient_color2,
//                      ColorConstants.policy_type_gradient_color1
//                    ])),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      height: 100,
//                      margin: EdgeInsets.only(left: 20, top: 18),
//                      child: Icon(
//                        Icons.account_circle,
//                        size: 100,
//                        color: Colors.white,
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(left: 20, top: 5),
//                      child: Text(
//                        S.of(context).hi_there,
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 35.0,
//                            letterSpacing: 0.5,
//                            fontWeight: FontWeight.w700),
//                      ),
//                    ),
////                    Padding(
////                      padding: const EdgeInsets.only(left: 20.0),
////                      child: Text(
////                        "Dev 23/03/2020 Build",
////                        style: TextStyle(
////                            color: ColorConstants.policy_type_gradient_color1,
////                            fontSize: 8.0,
////                            letterSpacing: 0.5,
////                            fontWeight: FontWeight.w500),
////                      ),
////                    ),
//                    Container(
//                      margin: EdgeInsets.only(left: 20, top: 2, bottom: 20),
//                      child: Text(
//                        S.of(context).home_title,
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontSize: 13.0,
//                            letterSpacing: 0.5,
//                            fontWeight: FontWeight.w500),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                child: Container(
//                  width: 300,
//                  child: SingleChildScrollView(
//                    child: Column(
//                      children: <Widget>[
//                        SizedBox(height: 18.0),
//                        InkResponse(
//                            onTap: () {
//                              Navigator.pop(context);
//                              Future.delayed(Duration(milliseconds: 200), () {
//                                Navigator.of(context).pushNamed(
//                                    ClaimIntimationScreen.ROUTE_NAME);
//                              });
//                            },
//                            child: _buildRow(
//                                AssetConstants.ic_menu_claim_intimation,
//                                S.of(context).claim_intimation_title)),
//                        _buildDivider(),
//                        InkResponse(
//                            onTap: () {
//                              Navigator.pop(context);
//                              Future.delayed(Duration(milliseconds: 200), () {
//                                // Navigator.of(context).pushNamed(NetworkHospitalPinCodeScreen.routeName);
//                                /// Pincode based search is removed from the ui. Now user can search with pincode and area
//                                Navigator.of(context).pushNamed(
//                                    NetworkHospitalScreen.ROUTE_NAME);
//                              });
//                            },
//                            child: _buildRow(
//                                AssetConstants.ic_menu_network_hospital,
//                                S.of(context).network_hospitals_title)),
//                        _buildDivider(),
//                        InkResponse(
//                            onTap: () {
//                              Navigator.pop(context);
//                              onClick(bool isAgree) {
//                                if (isAgree) {
////                                  bool isUserDataAvailable =
////                                      prefsHelper.isDocPrimeUserDataAvailable();
////                                  if (isUserDataAvailable ?? false) {
////                                    Future.delayed(Duration(milliseconds: 250),
////                                        () {
////                                      Navigator.of(context).pushNamed(
////                                          WebContent.routeName,
////                                          arguments:
////                                              UrlConstants.DOC_PRIME_URL);
////                                    });
////                                  } else {
////                                    Future.delayed(Duration(milliseconds: 250),
////                                        () {
////                                      Navigator.of(context).pushNamed(
////                                          PartnerUiSignInScreen.routeName);
////                                    });
////                                  }
//                                  Future.delayed(Duration(milliseconds: 250),
//                                      () {
//                                    Navigator.of(context).pushNamed(
//                                        WebContent.routeName,
//                                        arguments: WebContentArguments(
//                                            UrlConstants.DOC_PRIME_URL,
//                                            'DOCPRIME'));
//                                  });
//                                }
//                              }
//
//                              rootBundle
//                                  .loadString(
//                                      AssetConstants.doc_prime_disclaimer)
//                                  .then((disclaimer) {
//                                if (Platform.isIOS) {
//                                  showCupertinoDialog(
//                                      context: context,
//                                      builder: (BuildContext context) =>
//                                          WillPopScope(
//                                              onWillPop: () {
//                                                return Future<bool>.value(true);
//                                              },
//                                              child: ProductDisclaimerWidget(
//                                                  S
//                                                      .of(context)
//                                                      .disclaimer_title,
//                                                  onClick,
//                                                  disclaimer,
//                                                  S
//                                                      .of(context)
//                                                      .agree_terms_info)));
//                                } else {
//                                  showDialog(
//                                      context: context,
//                                      builder: (BuildContext context) =>
//                                          WillPopScope(
//                                              onWillPop: () {
//                                                return Future<bool>.value(true);
//                                              },
//                                              child: ProductDisclaimerWidget(
//                                                  S
//                                                      .of(context)
//                                                      .disclaimer_title,
//                                                  onClick,
//                                                  disclaimer,
//                                                  S
//                                                      .of(context)
//                                                      .agree_terms_info)));
//                                }
//                              });
//                            },
//                            child: _buildRow(
//                                AssetConstants.ic_menu_health_service,
//                                S.of(context).book_doctor_online_title)),
//                        _buildDivider(),
//                        InkResponse(
//                            onTap: () {
//                              Navigator.pop(context);
//                              Future.delayed(Duration(milliseconds: 200), () {
//                                Navigator.of(context).pushNamed(
//                                    ArogyaPlusProductInfoScreen.ROUTE_NAME);
//                              });
//                            },
//                            child: _buildRow(
//                                AssetConstants.ic_menu_buy_arogya_plus,
//                                S.of(context).buy_arogya_plus)),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            _makeApiCall(StringConstants.FROM_CRITICAL_ILLNESS);
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_privacy_policy,
//                              S.of(context).critical_illness),
//                        ),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            showTnCandPrivacyPolicyDialog(
//                                termsConditions, context);
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_terms_conditions,
//                              S.of(context).terms_conditions),
//                        ),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            showTnCandPrivacyPolicyDialog(
//                                privacyPolicy, context);
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_privacy_policy,
//                              S.of(context).privacy_policy),
//                        ),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            _makeApiCall(StringConstants.FROM_AROGYA_PREMIER);
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_privacy_policy,
//                              S.of(context).arogya_premier),
//                        ),
//                         _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            _makeApiCall(StringConstants.FROM_AROGYA_TOP_UP);
//
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_privacy_policy,
//                              S.of(context).arogya_top_up),
//                        ),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () {
//                            Navigator.pop(context);
//                            Future.delayed(Duration(milliseconds: 200), () {
//                              Navigator.of(context)
//                                  .pushNamed(LogScreen.ROUTE_NAME);
//                            });
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_bulb, "Log(Debugging Purpose)"),
//                        ),
//                        _buildDivider(),
//                        InkResponse(
//                          onTap: () async {
//                            await prefsHelper.setToken(null);
//                            await prefsHelper.setUserIsLoggedIn(false);
//                            await prefsHelper.setUserIsLinkedPolicy(false);
//                            Navigator.of(context).pushNamedAndRemoveUntil(
//                                WelcomeScreen.ROUTE_NAME,
//                                (Route<dynamic> route) => false);
//                          },
//                          child: _buildRow(
//                              AssetConstants.ic_menu_privacy_policy,
//                              prefsHelper.isUserLoggedIn()
//                                  ? S.of(context).logout_title
//                                  : S.of(context).sign_in),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
  }

  _makeApiCall(int isFrom,  BuildContext context) async {
    retryIdentifier(int identifier) {
      _makeApiCall(isFrom, context);
    }

    showLoaderDialog(context);
    final response =
    await ProductInfoApiProvider.getInstance().getProductInfo(isFrom);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      ProductInfoResModel resModel = response ?? ProductInfoResModel();
      if (isFrom == StringConstants.FROM_AROGYA_PREMIER) {
        Future.delayed(Duration(milliseconds: 2), () {
          Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
              arguments: ProductInfoArguments(
                  StringConstants.FROM_AROGYA_PREMIER, resModel));
        });
      } else if (isFrom == StringConstants.FROM_CRITICAL_ILLNESS) {
        Future.delayed(Duration(milliseconds: 2), () {
          Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
              arguments: ProductInfoArguments(
                  StringConstants.FROM_CRITICAL_ILLNESS, resModel));
        });
      }else if (isFrom == StringConstants.FROM_AROGYA_TOP_UP){
        Future.delayed(Duration(milliseconds: 2), () {
          Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
              arguments: ProductInfoArguments(
                  StringConstants.FROM_AROGYA_TOP_UP, resModel));
        });
      }
    }
  }

//  _makeApiCall(int isFrom) async {
//    retryIdentifier(int identifier) {
//      _makeApiCall(isFrom);
//    }
//
//    showLoaderDialog(context);
//    final response =
//        await ProductInfoApiProvider.getInstance().getProductInfo(isFrom);
//    hideLoaderDialog(context);
//    if (null != response.apiErrorModel) {
//      handleApiError(
//          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
//    } else {
//      ProductInfoResModel resModel = response ?? ProductInfoResModel();
//      if (isFrom == StringConstants.FROM_AROGYA_PREMIER) {
//        Future.delayed(Duration(milliseconds: 2), () {
//          Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
//              arguments: ProductInfoArguments(
//                  StringConstants.FROM_AROGYA_PREMIER, resModel));
//        });
//      } else if (isFrom == StringConstants.FROM_CRITICAL_ILLNESS) {
//        Future.delayed(Duration(milliseconds: 2), () {
//          Navigator.of(context).pushNamed(ProductInfoScreen.ROUTE_NAME,
//              arguments: ProductInfoArguments(
//                  StringConstants.FROM_CRITICAL_ILLNESS, resModel));
//        });
//      }
//    }
//  }

//  Divider _buildDivider() {
//    return Divider(
//      color: Colors.grey[400],
//    );
//  }

//  Widget _buildRow(String assetString, String title, {bool showBadge = false}) {
//    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
//    return Container(
//      padding: const EdgeInsets.symmetric(vertical: 10.0),
//      child: Container(
//        margin: EdgeInsets.only(left: 20, right: 40),
//        child: Row(children: [
//          Image(height: 20, width: 20, image: AssetImage(assetString)),
//          SizedBox(width: 10.0),
//          Text(
//            title,
//            style: tStyle,
//          ),
//          Spacer(),
//          if (showBadge)
//            Material(
//              color: Colors.blue,
//              elevation: 5.0,
//              shadowColor: Colors.blue,
//              borderRadius: BorderRadius.circular(5.0),
//              child: Container(
//                width: 25,
//                height: 25,
//                alignment: Alignment.center,
//                decoration: BoxDecoration(
//                  color: Colors.blue,
//                  borderRadius: BorderRadius.circular(5.0),
//                ),
//                child: Text(
//                  "10+",
//                  style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 12.0,
//                      fontWeight: FontWeight.bold),
//                ),
//              ),
//            )
//        ]),
//      ),
//    );
//  }

//  Widget _logoutWidget(String icon, String title) {
//    final TextStyle tStyle = TextStyle(
//        color: Colors.blue,
//        fontSize: 12.0,
//        fontWeight: FontWeight.w700,
//        letterSpacing: .75);
//    return Container(
//      padding: const EdgeInsets.only(top: 10.0, bottom: 12),
//      child: Row(children: [
//        Image(
//          height: 20,
//          width: 20,
//          image: AssetImage(icon),
//        ),
//        SizedBox(width: 10.0),
//        Text(
//          title,
//          style: tStyle,
//        ),
//      ]),
//    );
//  }

//  showTnCandPrivacyPolicyDialog(int from, BuildContext context) {
//    BaseApiProvider.isInternetConnected().then((isConnected) {
//      if (isConnected) {
//        if (from == termsConditions) {
//          Navigator.of(context).pushNamed(WebContent.routeName,
//              arguments: WebContentArguments(
//                  UrlConstants.TERMS_OF_USE_WEBVIEW_URL, 'TERMS',
//                  title: S.of(context).terms_conditions.toUpperCase()));
//          /*showWebView(UrlConstants.TERMS_OF_USE_WEBVIEW_URL,
//              " "+S.of(context).terms_conditions, DialogKind.T_n_C, 0, context);*/
//        } else {
//          Navigator.of(context).pushNamed(WebContent.routeName,
//              arguments: WebContentArguments(
//                  UrlConstants.AROGYA_PLUS_PRIVACY_POLICY_WEBVIEW_URL,
//                  'PRIVACY',
//                  title: S.of(context).privacy_policy.toUpperCase()));
//          /* showWebView(UrlConstants.AROGYA_PLUS_PRIVACY_POLICY_WEBVIEW_URL,
//              " "+S.of(context).privacy_policy, DialogKind.PRIVACY_POLICY, 0, context);*/
//        }
//      } else {
//        showNoInternetDialog(context, from, (int retryIdentifier) {
//          showTnCandPrivacyPolicyDialog(from, context);
//        });
//      }
//    });
//  }

  void _makeLoaderMessageApiCall() async {
    String loaderDate = prefsHelper.getLoaderDate();
    String currentDate = CommonUtil.instance.convertTo_ddMMyyyy(DateTime.now());
    //String currentDate = '17-01-2020';
    if (loaderDate == null || loaderDate != currentDate) {
      LoaderApiProvider loaderApiProvider = LoaderApiProvider();
      final response = await loaderApiProvider.getLoaderMessageDetails();
      if (response.data != null) {
        List<Loadermsg> list = response.data.loadermsg;
        list.forEach((value) {
          message.add(value.loaderMsg);
        });
        if (message != null || message.length > 0) {
          prefsHelper.setLoaderMessageDate(currentDate);
          prefsHelper.setLoaderMessage(message);
        }
      }
    }
  }

  showThankYouOrWelcomeAlert(bool isPolicyLinked) {
    onClick(int from) {}

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: GenericAlertWidget(
                onClick: onClick,
                from: 1,
                title: !isPolicyLinked
                    ? S.of(context).welcome_back
                    : S.of(context).policy_linked,
                description: !isPolicyLinked
                    ? S.of(context).welcome_back_description
                    : S.of(context).policy_linked_description,
                asset: !isPolicyLinked
                    ? AssetConstants.ic_welcome_back
                    : AssetConstants.ic_policy_linked,
              )));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: GenericAlertWidget(
                  onClick: onClick,
                  from: 1,
                  title: !isPolicyLinked
                      ? S.of(context).welcome_back
                      : S.of(context).policy_linked,
                  description: !isPolicyLinked
                      ? S.of(context).welcome_back_description
                      : S.of(context).policy_linked_description,
                  asset: !isPolicyLinked
                      ? AssetConstants.ic_welcome_back
                      : AssetConstants.ic_policy_linked)));
    }
  }
}

enum NavigationConstants { DOCPRIME_DISCLAIMER, PRODUCT_INFO }
