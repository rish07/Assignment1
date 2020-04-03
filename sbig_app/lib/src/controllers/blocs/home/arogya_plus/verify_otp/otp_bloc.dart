import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/otp_model.dart';

import 'otp_api_provider.dart';

class OTPBloc extends BaseBloc with OTPValidator{
  final otpTimerController = BehaviorSubject.seeded(false);

  Function(bool) get changeOtpTimer => otpTimerController.sink.add;

  Observable<bool> get otpTimerStream => otpTimerController.stream;

  final timerController = BehaviorSubject<String>();

  void changeTimer(String newValue) {
    if(!timerController.isClosed) {
      timerController.sink.add(newValue);
    }
  }

  Observable<String> get timerStream => timerController.stream;


  final otpController = BehaviorSubject.seeded("");

  Function(String) get changeOtp => otpController.sink.add;

  Observable<String> get otpStream => otpController.stream.transform(validateOtp);

  String get otp => otpController.value;





  final resendController = BehaviorSubject.seeded(false);

  Function(bool) get changeResend => resendController.sink.add;

  Observable<bool> get resendStream => resendController.stream;

  Future<OTPResponseModel> getOTP(String mobile, String quoteNo, String partyID) async {
    OTPRequestModel otpRequestModel = OTPRequestModel(mobile: mobile, quoteno: quoteNo, partyID: partyID);
    return await OTPApiProvider.getInstance().getOTP(otpRequestModel);
  }

  Future<OTPResponseModel> verifyOTP(String mobile, String quoteNo, String otp, String partyID) async {
    OTPVerifyRequestModel otpVerifyRequestModel = OTPVerifyRequestModel(mobile: mobile, otp: otp, quoteno: quoteNo, partyID: partyID);
    return await OTPApiProvider.getInstance().verifyOTP(otpVerifyRequestModel);
  }

  dispose() {
    otpTimerController.close();
    resendController.close();
    timerController.close();
    otpController.close();
  }
}



class OTPValidator{
  final validateOtp =
  StreamTransformer<String, String>.fromHandlers(handleData: (otp, sink) {
    if(otp.length != 4){
      sink.addError("");
    }else{
      sink.add(otp);
    }
  });
}