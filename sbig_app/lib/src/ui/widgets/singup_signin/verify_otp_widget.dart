import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sbig_app/src/ui/screens/onboarding/signup_signin_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/otp_validation_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class VerifyOTPWidget extends StatefulWidget {

  SingupSigninArguments singupSigninArguments;

  VerifyOTPWidget(this.singupSigninArguments);

  @override
  _VerifyOTPWidgetState createState() => _VerifyOTPWidgetState();
}

class _VerifyOTPWidgetState extends State<VerifyOTPWidget>
    with CommonWidget {

  SingupSigninArguments singupSigninArguments;
  bool resendEnabled = false;
  final int _countdownTime = 30;
  String _otpTimerValue;
  int _beginTime;
//  Timer otpTimer;
  OtpFieldController _otpFieldController = OtpFieldController();

  @override
  void initState() {
    singupSigninArguments = widget.singupSigninArguments;
    singupSigninArguments.singupSigninBloc.changeResend(false); // disable resend button when timer is ON
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _beginTime = _countdownTime;
    const oneSecond = const Duration(seconds: 1);
    singupSigninArguments.otpTimer = null;
    singupSigninArguments.otpTimer = Timer.periodic(oneSecond, (Timer timer) {
      _beginTime = _beginTime - 1;
      onTimerTick(_beginTime);
      print("_beginTime +"+_beginTime.toString());
    });
  }

  void cancelOtpTimer() {
    if(singupSigninArguments.otpTimer != null) {
      singupSigninArguments.otpTimer.cancel();
      _otpTimerValue = '00:00';
      singupSigninArguments.singupSigninBloc.changeTimer(_otpTimerValue);
    }
  }

  void onTimerTick(int currentNumber) {
    if (currentNumber < 1) {
      cancelOtpTimer();
      //_otpTimerValue = '00:00';
      if(!singupSigninArguments.singupSigninBloc.isResendControllerClosed) {
        singupSigninArguments.singupSigninBloc.changeResend(true);
      }else{
        cancelOtpTimer();
      }
    } else {
      String seconds = "";
      if (currentNumber < 10) {
        seconds = "0$currentNumber";
      } else {
        seconds = currentNumber.toString();
      }
      _otpTimerValue = "00:$seconds";
    }
    singupSigninArguments.singupSigninBloc.changeTimer(_otpTimerValue);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    Text(
                      S.of(context).verify_otp_message + ' ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: StringConstants.EFFRA_LIGHT,
                          fontSize: 18.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          this.widget.singupSigninArguments.singupSigninBloc.mobile + ' ',
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.5,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: InkResponse(
                            onTap: (){
                              widget.singupSigninArguments.onBackPressed(1);
                            },
                            child: Text(
                              S.of(context).edit_title,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.blue_text,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).enter_otp_text.toUpperCase(),
                        style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                      ),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                      keyboardType: TextInputType.number,
                      length: 4,
                      firstDigitFocusNode: singupSigninArguments.focusNode,
                      onCompleted: (String value) {
                        singupSigninArguments.singupSigninBloc.changeOtp(value);
                        singupSigninArguments.onOTPCompleted(value.length == 4);
                      },
                      otpFieldController: _otpFieldController,
                    ),

                    //otpWidget(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          StreamBuilder<String>(
                              stream: singupSigninArguments.singupSigninBloc.timerStream,
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
                              stream: singupSigninArguments.singupSigninBloc.resendStream,
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
                                  onTap: (){
                                    _otpFieldController.clearFields();
                                    if(resendEnabled){ widget.singupSigninArguments.onResendOtp(true).then((isSuccess){
                                      if(isSuccess){
                                        _startTimer();
                                        widget.singupSigninArguments.singupSigninBloc.changeResend(false);
                                      }
                                    });}
                                  },
                                  child: Text(
                                    S.of(context).resend_otp,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: (resendEnabled)
                                            ? ColorConstants.blue_text
                                            : ColorConstants.light_blue_text,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
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
            )
          ],
        ),
        Container(
          width: double.infinity,
          height: 100,
        )
      ],
    );
  }

  Widget signInButton(String title) {
    return Center(
      child: FlatButton(
        onPressed: () {},
        child: Text(
          "$title",
          style: TextStyle(
              color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget linkPolicyButton(String title) {
    return MaterialButton(
      minWidth: double.infinity,
      height: 50,
      color: Colors.black,
      onPressed: () {
        //widget.onStatusChange(ScreenStatus.welcome_screen);
        Navigator.of(context).pushNamed(SignupSigninScreen.ROUTE_NAME,
            arguments: SignupSigninScreenStatus.choose_policy_type_screen);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100 / 2),
      ),
      textColor: Colors.white,
      highlightColor: Colors.grey[800],
      highlightElevation: 5.0,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.0),
      ),
    );
  }
}
