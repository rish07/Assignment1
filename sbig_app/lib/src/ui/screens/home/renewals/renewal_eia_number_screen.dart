import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/verify_otp/otp_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_eia_model.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/otp_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_remark_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class RenewalEIANumberScreen extends StatelessWidget {
  static const ROUTE_NAME = "/renewals/eia_number_screen";

  EiaScreenArguments eiaScreenArguments;

  RenewalEIANumberScreen(this.eiaScreenArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: RenewalEIANumberScreenWidget(this.eiaScreenArguments),
      bloc: RenewalsBloc(),
    );
  }
}

class RenewalEIANumberScreenWidget extends StatefulWidget {
  EiaScreenArguments eiaScreenArguments;

  RenewalEIANumberScreenWidget(this.eiaScreenArguments);

  @override
  _RenewalEIANumberScreenState createState() => _RenewalEIANumberScreenState();
}

class _RenewalEIANumberScreenState extends State<RenewalEIANumberScreenWidget>
    with CommonWidget {
  double screenWidth;
  double screenHeight;
  bool isEiaNumberVisible = false,
      eiaNumberError = false,
      isYesButtonClicked = false,
      isNoButtonClicked = false,
      onSubmit = false,
      isKeyboardVisible = false;
  ServiceModel buttonNo, buttonYes;
  final eiaNumberController = TextEditingController();
  RenewalsBloc renewalsBloc;
  String errorText;
  ScrollController _controller;

  @override
  void initState() {
    renewalsBloc = SbiBlocProvider.of<RenewalsBloc>(context);
    _controller = ScrollController();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          _moveDown();
        } else {}
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    eiaNumberController.dispose();
    renewalsBloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil
            .getInstance(context)
            .screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil
        .getInstance(context)
        .screenHeightDp;

    buttonNo = ServiceModel(
        title: S
            .of(context)
            .no,
        subTitle: '',
        isSubTitleRequired: false,
        points: [],
        icon: null,
        color1: Colors.white,
        color2: Colors.white);

    buttonYes = ServiceModel(
        title: S
            .of(context)
            .yes,
        subTitle: '',
        isSubTitleRequired: false,
        points: [],
        icon: null,
        color1: Colors.white,
        color2: Colors.white);
    super.didChangeDependencies();
  }

  _moveDown() {
    _controller.animateTo(0.0,
        curve: Curves.easeOut, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.claim_intimation_bg_color,
      appBar: getAppBar(
          context, S
          .of(context)
          .renewal_title
          .toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              controller: _controller,
              reverse: true,
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Text(
                        S
                            .of(context)
                            .eia_number_question,
                        style: TextStyle(
                            fontFamily: StringConstants.EFFRA,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: Text(
                        S
                            .of(context)
                            .eia_message,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.0),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                isNoButtonClicked = true;
                                isYesButtonClicked = false;
                                if (isEiaNumberVisible) {
                                  isEiaNumberVisible = false;
                                }
                              });
                            },
                            child: button(buttonNo, isNoButtonClicked),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isYesButtonClicked = true;
                                isNoButtonClicked = false;
                                if (!isEiaNumberVisible) {
                                  isEiaNumberVisible = true;
                                }
                              });
                            },
                            child: button(buttonYes, isYesButtonClicked),
                          ),
                        ],
                      ),
                    ),
                    if (isEiaNumberVisible) eiaNumber(),
                    /* Visibility(
                      visible: isPolicyNumberVisible,
                      child: policyNumber(),
                    ),*/
                    SizedBox(
                      height: 80,
                    ),
                  ],
                )
              ],
            ),
            if (isYesButtonClicked || isNoButtonClicked)
              _showSubmitButton(),
            //  Align(alignment: Alignment.bottomCenter, child: _showPremiumButton()),
          ],
        ),
      ),
    );
  }

  onClick() {
    String eiaNumber = renewalsBloc.eiaNumber;
    if (isYesButtonClicked) {
      onSubmit = true;
      renewalsBloc.changeEiaNumber(eiaNumber);

      Future.delayed(Duration(milliseconds: 200), () {
        if (errorText == null) {
          _storeEiaNumber(eiaNumber);
        }
      });
    } else {
      try {
//        onRetry(int from) {
//          onClick();
//        }
        showLoaderDialog(context);
        _makeOTPApiCall(widget.eiaScreenArguments.mobileNumber, widget.eiaScreenArguments.quoteNumber);
//        widget.eiaScreenArguments.onNextPressed("").then((error) {
//          hideLoaderDialog(context);
//          if (error != null) {
//            handleApiError(
//                context, 0, onRetry, error.statusCode, message: error.message);
//          }else{
//            widget.eiaScreenArguments.navigateToOtpScreen();
//          }
//        });
      }catch(e){
        print(e.toString());
        hideLoaderDialog(context);
      }
    }
  }

  _makeOTPApiCall(String mobileNo, String quoteNo) async {
    retryIdentifier(int identifier) {
      _makeOTPApiCall(mobileNo, quoteNo);
    }

    OTPRequestModel otpRequestModel =
    OTPRequestModel(mobile: mobileNo, quoteno: quoteNo);
    final response = await OTPApiProvider.getInstance().getOTP(otpRequestModel);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      //return Future.value(response.apiErrorModel);
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode, message: response.apiErrorModel.message);
    } else {
      if (response.success) {
        String otp = response.otp ?? '';
        //_navigateToOptScreen(mobileNo, otp, quoteNo);
        widget.eiaScreenArguments.navigateToOtpScreen(mobileNo, otp, quoteNo);
      }
    }
    //return null;
  }

  _storeEiaNumber(String eiaNumber) {

    onRetry(int from){
      _storeEiaNumber(eiaNumber);
    }

    showLoaderDialog(context);
    RenewalStoreEIAReqModel renewalStoreEIAReqModel = RenewalStoreEIAReqModel();
    renewalStoreEIAReqModel.EIA = eiaNumber;
    renewalStoreEIAReqModel.ref_type = "renewals";
    renewalStoreEIAReqModel.policyNumber = widget.eiaScreenArguments.policyNumber;
    renewalStoreEIAReqModel.mobile = widget.eiaScreenArguments.mobileNumber;
    renewalsBloc.storeEIA(renewalStoreEIAReqModel.toJson())
        .then((response) {
          if(response.apiErrorModel != null){
            hideLoaderDialog(context);
            handleApiError(context, 0, onRetry, response.apiErrorModel.statusCode, message: response.apiErrorModel.message, title: "Error");
          }else{
            _makeOTPApiCall(widget.eiaScreenArguments.mobileNumber, widget.eiaScreenArguments.quoteNumber);
          }
    });
  }

  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S
          .of(context)
          .claim_next_button
          .toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  void _navigate(ClaimIntimationRequestModel responseModel) {
    Navigator.of(context).pushNamed(ClaimIntimationRemarkScreen.ROUTE_NAME,
        arguments: ClaimIntimationRemarkArguments(responseModel));
  }

  Widget button(ServiceModel serviceModel, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
          borderRadius(radius: 6.0, topLeft: 6.0, topRight: 15.0)),
      elevation: 10.0,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: (isSelected)
                    ? [
                  ColorConstants.button_gradient_color1,
                  ColorConstants.button_gradient_color2
                ]
                    : [serviceModel.color1, serviceModel.color2]),
            borderRadius:
            borderRadius(radius: 5.0, topLeft: 5.0, topRight: 15.0)),
        child: Center(
          child: Text(
            serviceModel.title,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: (isSelected)
                    ? Colors.white
                    : ColorConstants.button_not_selected_text_color),
          ),
        ),
      ),
    );
  }

  Widget eiaNumber() {
    return StreamBuilder(
        stream: renewalsBloc.eiaNumberStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          errorText = null;
          bool _onSubmit = (onSubmit);
          if (isError && isYesButtonClicked) {
            switch (snapshot.error) {
              case ClaimIntimationValidator.EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText = _onSubmit ? S
                    .of(context)
                    .enter_eia_number : null;
                break;
              case ClaimIntimationValidator.INVALID_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText = _onSubmit ? S
                    .of(context)
                    .invalid_eia_number : null;
                break;
              case ClaimIntimationValidator.LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText = _onSubmit ? S
                    .of(context)
                    .invalid_eia_number : null;
                break;
            }
          } else if (snapshot.hasData) {
            errorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          } else {
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            errorText =
            (_onSubmit) ? S
                .of(context)
                .invalid_policy_number : null;
          }

          return Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
            child: Stack(
              children: <Widget>[
                Theme(
                  data: new ThemeData(
                    primaryColor: ColorConstants.text_field_blue,
                    // changes the under line colour
                    primaryColorDark: ColorConstants.text_field_blue,
                    accentColor: ColorConstants.text_field_blue,
                  ),
                  child: TextField(
                    controller: eiaNumberController,
                    onChanged: (String value) {
                      renewalsBloc.changeEiaNumber(value);
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      // _claimIntimationBloc.changePolicyNumber(value);
                      onClick();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10.0, bottom: 5.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.policy_type_gradient_color2),
                      ),
                      labelText: S
                          .of(context)
                          .enter_eia_number
                          .toUpperCase(),
                      errorText: errorText,
                      errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 15,
                    child: SizedBox(height: 25, width: 25, child: image))
              ],
            ),
          );
        });
  }
}

class EiaScreenArguments {
  Future<ApiErrorModel> Function(String) onNextPressed;
  Function(String, String, String) navigateToOtpScreen;
  String policyNumber;
  String quoteNumber;
  String mobileNumber;

  EiaScreenArguments({this.onNextPressed, this.navigateToOtpScreen,
    this.policyNumber,
    this.quoteNumber,
    this.mobileNumber});
}
