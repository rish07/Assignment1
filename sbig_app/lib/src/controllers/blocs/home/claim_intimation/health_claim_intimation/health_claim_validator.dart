import 'dart:async';
import 'dart:math';

import 'package:sbig_app/src/utilities/email_validator.dart';

class HealthClaimValidator {
  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

  static const MOBILE_EMPTY_ERROR = 1;
  static const REASON_EMPTY_ERROR = 1;
  static const DOCTOR_NAME_EMPTY_ERROR = 1;
  static const AMOUNT_EMPTY_ERROR = 1;
  static const OTHER_EMPTY_ERROR = 1;
  static const MOBILE_LENGTH_ERROR = 2;
  static const MOBILE_INVALID_ERROR = 3;

  static const EMAIL_EMPTY_ERROR = 4;
  static const EMAIL_INVALID_ERROR = 5;


  final validateMobile = StreamTransformer<String, String>.fromHandlers(
      handleData: (mobile, sink) {
        if (mobile.length == 0) {
          sink.addError(MOBILE_EMPTY_ERROR);
        } else if (mobile.length == 10) {
          if (int.parse(mobile.substring(0, 1)) >= 6) {
            print(int.parse(mobile.substring(0, 1).toString()));
            sink.add(mobile);
          } else {
            sink.addError(MOBILE_INVALID_ERROR);
          }
        } else {
          sink.addError(MOBILE_LENGTH_ERROR);
        }
      });


  final validateAmount = StreamTransformer<String, String>.fromHandlers(
      handleData: (amount, sink) {
    if (amount.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else {
      sink.add(amount);
    }

    /* else if (mobile.length == 10) {
          if (int.parse(mobile.substring(0, 1)) >= 6) {
            print(int.parse(mobile.substring(0, 1).toString()));
            sink.add(mobile);
          }
        }*/
  });

  final validateOther =
      StreamTransformer<String, String>.fromHandlers(handleData: (other, sink) {
    if (other.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else {
      sink.add(other);
    }
  });

  final validateDoctorName = StreamTransformer<String, String>.fromHandlers(
      handleData: (doctorName, sink) {
    if (doctorName.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else {
      sink.add(doctorName);
    }
  });

  final validateReasonOfHospitalization =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (reasonOfHospitalization, sink) {
    if (reasonOfHospitalization.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else {
      sink.add(reasonOfHospitalization);
    }
  });

  final validateCity =
      StreamTransformer<String, String>.fromHandlers(handleData: (city, sink) {
    if (city.length == 0) {
      sink.addError(MOBILE_EMPTY_ERROR);
    } else {
      sink.add(city);
    }
  });

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name == null || name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else {
      sink.add(name);
      print(name);
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty) {
      sink.addError(EMAIL_EMPTY_ERROR);
    } else if (EmailValidator.validate(email)) {
      sink.add(email);
    } else {
      sink.addError(EMAIL_INVALID_ERROR);
    }
  });

  final validPolicyNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if (name.trim().length == 16) {
      sink.add(name);
    } else {
      sink.addError(LENGTH_ERROR);
      print(name);
    }
  });
}
