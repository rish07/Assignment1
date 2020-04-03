import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/verify_otp/otp_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';

import '../base_bloc.dart';

class CommonBloc extends BaseBloc
    with ClaimIntimationValidator, PersonalDetailsValidator, OTPValidator {

  final _policyNumberController = BehaviorSubject.seeded("");
  Function(String) get changePolicyNumber => _policyNumberController.sink.add;
  Observable<String> get policyNumberStream =>
      _policyNumberController.stream.transform(validPolicyNumber);
  String get policyNumber => _policyNumberController.value;


  final _dobController = BehaviorSubject.seeded("");
  Function(String) get changeDob => _dobController.sink.add;
  Observable<String> get dobStream => _dobController.stream;
  String get dob => _dobController.value;

  final _onSubmitController = BehaviorSubject.seeded(false);
  Function(bool) get changeOnSubmit => _onSubmitController.sink.add;
  Observable<bool> get onSubmitStream => _onSubmitController.stream;
  bool get onSubmit => _onSubmitController.value;

  final _firstNameController = BehaviorSubject.seeded("");
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Observable<String> get firstNameStream =>
      _firstNameController.stream.transform(validateNameWithLength);
  String get firstName => _firstNameController.value;

  final _mobileController = BehaviorSubject.seeded("");
  Function(String) get changeMobile => _mobileController.sink.add;
  Observable<String> get mobileStream =>
      _mobileController.stream.transform(validateMobile);
  String get mobile => _mobileController.value;

  final _otpTimerController = BehaviorSubject.seeded(false);
  Function(bool) get changeOtpTimer => _otpTimerController.sink.add;
  Observable<bool> get otpTimerStream => _otpTimerController.stream;

  final _timerController = BehaviorSubject<String>();
  void changeTimer(String newValue) {
    if (!_timerController.isClosed) {
      _timerController.sink.add(newValue);
    }
  }
  Observable<String> get timerStream => _timerController.stream;

  final _otpController = BehaviorSubject.seeded("");
  Function(String) get changeOtp => _otpController.sink.add;
  Observable<String> get otpStream =>
      _otpController.stream.transform(validateOtp);
  String get otp => _otpController.value;

  final _resendController = BehaviorSubject.seeded(false);
  Function(bool) get changeResend => _resendController.sink.add;
  Observable<bool> get resendStream => _resendController.stream;
  bool get isResendControllerClosed => _resendController.isClosed;

  @override
  void dispose() {
    _policyNumberController.close();
    _dobController.close();
    _firstNameController.close();
    _onSubmitController.close();
    _otpTimerController.close();
    _resendController.close();
    _timerController.close();
    _otpController.close();
  }
}
