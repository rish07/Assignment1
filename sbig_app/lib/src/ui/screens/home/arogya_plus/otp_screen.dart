import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/verify_otp/otp_bloc.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/common/site_under_maintenance_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/otp_validation_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class OTPScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya_plus/otp_screen";

  final OTPScreenArguments otpScreenArguments;

  OTPScreen(this.otpScreenArguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: OTPScreenWidget(otpScreenArguments.mobile, otpScreenArguments.quoteNo, otpScreenArguments.partyId,
          otpScreenArguments.selectedMemberDetails),
      bloc: OTPBloc(),
    );
  }
}

class OTPScreenWidget extends StatefulWidget {

  final String mobile;
  final String quoteNo;
  final String partyID;
  final SelectedMemberDetails selectedMemberDetails;

  OTPScreenWidget(this.mobile, this.quoteNo, this.partyID, this.selectedMemberDetails);

  @override
  State createState() => _State();
}

class _State extends State<OTPScreenWidget> with CommonWidget {
  String mobileNo = "";
  String quoteNo = "";
  String partyID = "";
  String otp = "";
  String _onComplete = "";
  bool validOtp = false;
  bool resendEnabled = false, backPressed = false;
  OTPBloc _otpBloc;
  final int _countdownTime = 30;
  String _otpTimerValue = "";
  Timer _otpTimer;
  int _beginTime;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  OtpFieldController _otpFieldController = OtpFieldController();

  void _startTimer() {
    _beginTime = _countdownTime;
    const oneSecond = const Duration(seconds: 1);
    _otpTimer = Timer.periodic(oneSecond, (Timer timer) {
      _beginTime = _beginTime - 1;
      onTimerTick(_beginTime);
    });
  }

  void _cancelOtpTimer() {
    _otpTimer.cancel();
    _otpTimerValue = "00:00";
    _otpBloc.changeTimer(_otpTimerValue);
  }

  void onTimerTick(int currentNumber) {
    if (currentNumber < 1) {
      _cancelOtpTimer();
      _otpTimerValue = '00:00';
      _otpBloc.changeResend(true);
    } else {
      String seconds = "";
      if (currentNumber < 10) {
        seconds = "0$currentNumber";
      } else {
        seconds = currentNumber.toString();
      }
      _otpTimerValue = "00:$seconds";
    }
    _otpBloc.changeTimer(_otpTimerValue);
  }

  @override
  void initState() {
    mobileNo = widget.mobile;
    quoteNo = widget.quoteNo;
    partyID =  widget.partyID;
    _otpBloc = SbiBlocProvider.of<OTPBloc>(context);
    _otpBloc.changeResend(false); // disable resend button when timer is ON
    _startTimer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _cancelOtpTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: ColorConstants.arogya_plus_bg_color,
      appBar: getAppBar(context, S.of(context).validation_text.toUpperCase(), onBackPressed: _onAppBarBackPress, isFrom: 1),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              S.of(context).otp_text + ' ',
                              style: TextStyle(
                                  color: ColorConstants.otp_text_color,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                            Text(
                              this.widget.mobile + ' ',
                              style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 60,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).enter_otp_text.toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: ColorConstants.otp_text_color,
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      VerificationCodeInput(
                        autofocus: true,
                        themeData: ThemeData(
                            accentColor: Colors.black,
                            primaryColorDark: Colors.black,
                            primaryColor: Colors.black),
                        lableTextStyleColor: Colors.black,
                        textStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 32,
                        ),
                        keyboardType: TextInputType.number,
                        length: 4,
                        onCompleted: (String value) {
                          if(value.length == 4) {

                          }
                          _otpBloc.changeOtp(value);
                        },
                        otpFieldController: _otpFieldController,
                      ),

                      //otpWidget(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                          StreamBuilder<String>(
                            stream: _otpBloc.timerStream,
                            builder: (context, snapshot) {
                              _otpTimerValue = "00:$_countdownTime";
                              if (snapshot.hasData) {
                                _otpTimerValue = snapshot.data;
                              }
                              return Text(
                                _otpTimerValue,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 13,
                                    fontStyle: FontStyle.normal),
                              );
                            }),
                            SizedBox(
                              width: 5,
                            ),
                            StreamBuilder<bool>(
                                stream: _otpBloc.resendStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    print(snapshot.data);
                                    if (snapshot.data == true) {
                                      resendEnabled = true;
                                    } else {
                                      resendEnabled = false;
                                    }
                                  }
                                  return InkWell(
                                    onTap: resendEnabled? _resendOtp: null,
                                    child: Text(
                                      S.of(context).resend_otp,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: (resendEnabled)
                                              ? ColorConstants.disco
                                              : ColorConstants.london_hue,
                                          fontSize: 13,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<String>(
                stream: _otpBloc.otpStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _onComplete = snapshot.data;
                    if ((_onComplete.isNotEmpty)) {
                      //otp=snapshot.data;
                      otp = _onComplete;
                      validOtp = true;
                    } else {
                      validOtp = false;
                    }
                  } else {
                    validOtp = false;
                    otp = "";
                  }
                  return (validOtp)
                      ? BlackButtonWidget(
                          () {
                            _cancelOtpTimer();
                            _otpBloc.changeResend(true);
                            _onPaymentClick(this.widget.mobile, quoteNo, otp, partyID);
                          },
                          S.of(context).make_payment.toUpperCase(),
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
                          bottomBgColor: ColorConstants.arogya_plus_bg_color,
                        )
                      : Padding(
                          padding: EdgeInsets.all(0.0),
                        );
                }),
          ],
        ),
      ),
    );
  }

  void _resendOtp() {
    if(resendEnabled) {
      _otpBloc.changeResend(false);
      _cancelOtpTimer();
      _makeOTPApiCall(this.widget.mobile, quoteNo, partyID);
    }
  }

  void _onAppBarBackPress(int id) {
    FocusScope.of(context).unfocus();
    Future.delayed(Duration(milliseconds: 300), (){
      Navigator.of(context).pop();
    });
  }

  Widget otpWidget(){

    return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 300)),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator()
              );
            default:
              return VerificationCodeInput(
                autofocus: true,
                themeData: ThemeData(
                    accentColor: Colors.black,
                    primaryColorDark: Colors.black,
                    primaryColor: Colors.black),
                lableTextStyleColor: Colors.black,
                textStyle: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontSize: 32,
                ),
                keyboardType: TextInputType.number,
                length: 4,
                onCompleted: (String value) {
                  if(value.length == 4) {

                  }
                  _otpBloc.changeOtp(value);
                },
                otpFieldController: _otpFieldController,
              );
          }
        }
    );


  }

  _onPaymentClick(String mobileNo, String quoteNo, String otp, String partyID)  {
    retryIdentifier(int identifier) {
      _onPaymentClick(mobileNo, quoteNo, otp, partyID);
    }
    FocusScope.of(context).unfocus();
    showLoaderDialog(context);
    Future.delayed(Duration(milliseconds: 10), () async{
      final response = await _otpBloc.verifyOTP(mobileNo, quoteNo, otp, partyID);
      hideLoaderDialog(context);
      if (null != response.apiErrorModel) {
        if (response.apiErrorModel.statusCode ==
            ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          showNoInternetDialog(context, 0, retryIdentifier);
        } else if(response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE){
          showMaintenanceDialog(context);
        }else {
          _key.currentState.showSnackBar(SnackBar(content: Text( null != response.apiErrorModel.message ? response.apiErrorModel.message : "Something went wrong. Please try again"),));
        }
      } else {
        if(null != response.verifyHash){
          String toBeEncryptedString = "verifiedotpappscreen"+"$mobileNo$quoteNo$otp";
          String encryptedString = CommonUtil.instance.generateSha256Hexa(toBeEncryptedString);
          //print("encryptedString "+encryptedString);
          if(response.verifyHash.compareTo(encryptedString) == 0){
            OtpScreenReturnDataModel returnData = OtpScreenReturnDataModel(true);
            Navigator.pop(context, returnData);
          }else{
            _key.currentState.showSnackBar(SnackBar(content: Text("Something went wrong. Please try again"),));
          }
        }else {
          _key.currentState.showSnackBar(SnackBar(content: Text("Something went wrong. Please try again"),));
          //OtpScreenReturnDataModel returnData = OtpScreenReturnDataModel(true);
          //Navigator.pop(context, returnData);
        }
      }
    });
  }

  _makeOTPApiCall(String mobileNo, String quoteNo, String partyID) async {
    _otpFieldController.clearFields();
    _otpBloc.otpController.addError("");
    showLoaderDialog(context);
    retryIdentifier(int identifier) {
      _makeOTPApiCall(mobileNo, quoteNo, partyID);
    }

    final response = await _otpBloc.getOTP(mobileNo, quoteNo, partyID);
    hideLoaderDialog(context);

    if (null != response.apiErrorModel) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        showNoInternetDialog(context, 0, retryIdentifier);
      }
      else if(response.apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE){
        showMaintenanceDialog(context);
      }
      else {
        _key.currentState.showSnackBar(SnackBar(content: Text( null != response.apiErrorModel.message ? response.apiErrorModel.message : "Something went wrong. Please try again"),));
        //showServerErrorDialog(context, 0, retryIdentifier);
      }
    } else {
      if (response.success) {
        otp = response.otp ?? '';
        _startTimer();
        _otpBloc.changeResend(false);
      }
    }
  }

}

class OTPScreenArguments {
  String mobile;
  String quoteNo;
  String partyId;
  SelectedMemberDetails selectedMemberDetails;

  OTPScreenArguments(this.mobile, this.quoteNo, this.partyId, this.selectedMemberDetails);
}

class OtpScreenReturnDataModel {
  bool _isSuccess;
  bool get isSuccess => _isSuccess;

  String message = "";

  OtpScreenReturnDataModel(this._isSuccess, {this.message});
}