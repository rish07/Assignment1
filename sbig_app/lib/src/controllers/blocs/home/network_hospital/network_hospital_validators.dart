import 'dart:async';

import 'package:sbig_app/src/utilities/text_utils.dart';

class NetworkHospitalValidators {

  static const PIN_EMPTY = 0;
  static const PIN_LENGTH_ERROR = 1;
  static const PIN_INVALID_ERROR = 2;

  static getPinValidator() {
    return StreamTransformer<String, String>.fromHandlers(
        handleData: (mobile, sink) {
          if (mobile.length == 0) {
            sink.addError(PIN_EMPTY);
          } else if (mobile.length == 6) {
            sink.add(mobile);
          } else {
            sink.addError(PIN_LENGTH_ERROR);
          }
        });
  }


  static bool isAValidPinCode(String pinCode) {
    if(TextUtils.isEmpty(pinCode)) {
      return false;
    }
    pinCode = pinCode.trim();
    if(pinCode.length == 0) {
      return false;
    } else if(pinCode.length == 6) {
      return true;
    } else {
      return false;
    }
  }

  static bool isAValidCode(String keyWord) {
    print('KEYWORD : $keyWord');
    if(TextUtils.isEmpty(keyWord)) {
      return false;
    }
    keyWord = keyWord.trim();
    if(keyWord.length == 0) {
      return false;
    } else {
      return true;
    }
  }

}