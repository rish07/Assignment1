import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_bloc.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/claim/claim_sucess_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ClaimIntimationRemarkScreen extends StatelessWidget {
  static const ROUTE_NAME = "/claim_intimation/claim_intimation_remark_screen";

  final ClaimIntimationRemarkArguments claimIntimationRemarkArguments;

  ClaimIntimationRemarkScreen(this.claimIntimationRemarkArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: ClaimRemarkWidget(
        requestModel: claimIntimationRemarkArguments.requestModel,
      ),
      bloc: ClaimIntimationBloc(),
    );
  }
}

class ClaimRemarkWidget extends StatefulWidget {
  final ClaimIntimationRequestModel requestModel;

  ClaimRemarkWidget({this.requestModel});

  @override
  _ClaimRemarkState createState() => _ClaimRemarkState();
}

class _ClaimRemarkState extends State<ClaimRemarkWidget> with CommonWidget {
  double screenWidth;
  double screenHeight;
  var activationNumber;

  ClaimIntimationBloc _claimIntimationBloc;
  final remarkController = TextEditingController();
  FocusNode _remarkFocusNode;
  ScrollController _controller;

  _ClaimRemarkState();

  @override
  void initState() {
    _claimIntimationBloc = SbiBlocProvider.of<ClaimIntimationBloc>(context);
    _remarkFocusNode = FocusNode();
    _controller = ScrollController();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _moveDown();
        }
      },
    );
    super.initState();
  }

  _moveDown() {
    _controller.animateTo(0.0,
        curve: Curves.easeOut, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _claimIntimationBloc.dispose();
    remarkController.dispose();
    _remarkFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenWidth = ScreenUtil.getInstance(context).screenWidthDp;
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.claim_intimation_bg_color,
      appBar: getAppBar(
          context, S.of(context).claim_intimation_title.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              child: ListView(
                controller: _controller,
                shrinkWrap: true,
                reverse: true,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 150,
                      ),
                      TextField(
                        textAlign: TextAlign.start,
                        controller: remarkController,
                        maxLines: null,
                        focusNode: _remarkFocusNode,
                        keyboardType: TextInputType.multiline,
                        //textInputAction: TextInputAction.newline,
                        /* onSubmitted: (value){
                      onClick();
                    },*/
                        inputFormatters: [
                          WhitelistingTextInputFormatter(
                              RegExp(r"[\n0-9a-zA-Z-., ]")),
                        ],
                        style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: borderRadius(
                                radius: 8.0, topLeft: 8.0, topRight: 8.0),
                            borderSide: BorderSide(
                                color: ColorConstants.claim_remark_color),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: borderRadius(
                                radius: 8.0, topLeft: 8.0, topRight: 8.0),
                            borderSide: BorderSide(
                                color: ColorConstants.claim_remark_color),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: borderRadius(
                                radius: 8.0, topLeft: 8.0, topRight: 8.0),
                            borderSide: BorderSide(
                                color: ColorConstants.claim_remark_color),
                          ),
                          labelText:
                              S.of(context).claim_remark_title.toUpperCase(),
                          labelStyle:
                              TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            S.of(context).claim_optional_title,
                            style: TextStyle(
                                color: Colors.black54,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                                fontSize: 11.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            _showSubmitButton(),
            //  Visibility(visible: _apiCall, child: LoadingScreen()),
          ],
        ),
      ),
    );
  }

  onClick() {
    Future.delayed(Duration(milliseconds: 500), () {
      //FocusScope.of(context).requestFocus(_remarkFocusNode);
      FocusScope.of(context).unfocus();
      ClaimIntimationRequestModel requestModel = this.widget.requestModel;
      requestModel.remarks = remarkController.text;
      _makeApiCall(true, requestModel);
    });
  }

  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).submit.toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    return Future.value(false);
  }

  void _showSuccessDialog() {
    onClick() {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return _onBackPressed();
              },
              child: ClaimSuccessWidget(
                  screenHeight, screenWidth, activationNumber, onClick)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return _onBackPressed();
              },
              child: ClaimSuccessWidget(
                  screenHeight, screenWidth, activationNumber, onClick)));
    }
  }

  _makeApiCall(bool apiCall, ClaimIntimationRequestModel requestModel) async {
    retryIdentifier(int identifier) {
      ClaimIntimationRequestModel requestModel = this.widget.requestModel;
      _makeApiCall(true, requestModel);
    }

    if (apiCall) {
      showLoaderDialog(context);
      final response =
          await _claimIntimationBloc.submitClaimIntimation(requestModel);
      hideLoaderDialog(context);
      if (null != response.apiErrorModel) {
        /*if (response.apiErrorModel.statusCode ==
            ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          showNoInternetDialog(context, 0, retryIdentifier);
        } else {
          showServerErrorDialog(context, 0, retryIdentifier);
        }*/
        handleApiError(
            context, 0, retryIdentifier, response.apiErrorModel.statusCode);
      } else {
        activationNumber = response.data?.claimData?.activityNumber ?? '';
        _showSuccessDialog();
      }
    }
  }
}

class ClaimIntimationRemarkArguments {
  ClaimIntimationRequestModel requestModel;

  ClaimIntimationRemarkArguments(this.requestModel);
}
