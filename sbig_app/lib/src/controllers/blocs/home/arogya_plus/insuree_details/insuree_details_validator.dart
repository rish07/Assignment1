import 'dart:async';
import 'dart:math';

import 'package:sbig_app/src/utilities/text_utils.dart';

class InsureeDetailsValidator {
  static const NAME_EMPTY_ERROR = 1;
  static const NAME_LENGTH_ERROR = 2;

  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!TextUtils.isEmpty(name)) {
      if (name.length == 1) {
        sink.addError(NAME_LENGTH_ERROR);
      } else {
        sink.add(name);
      }
    } else {
      sink.addError(NAME_EMPTY_ERROR);
    }
  });

  final validateAgentCode =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!TextUtils.isEmpty(name)) {
      if (name.length < 6) {
        sink.addError(NAME_LENGTH_ERROR);
      } else {
        sink.add(name);
      }
    } else {
      sink.addError(NAME_EMPTY_ERROR);
    }
  });

  static ValidationResult nameValidationResult(String name) {
    if (!TextUtils.isEmpty(name)) {
      if (name.length == 1) {
        return ValidationResult(false, NAME_LENGTH_ERROR);
      } else {
        return ValidationResult(true);
      }
    } else {
      return ValidationResult(false, NAME_EMPTY_ERROR);
    }
  }

  static bool isNameValid(String name) {
    if(TextUtils.isEmpty(name)) {
      return false;
    }
    if(name.trim().length == 1) return false;

    return true;
  }

  static bool isAgentCodeValid(String agentCode) {
    if(TextUtils.isEmpty(agentCode)) {
      return false;
    }
    if(agentCode.trim().length <6 ) return false;

    return true;
  }

  final validatePincode = StreamTransformer<String, String>.fromHandlers(
      handleData: (pincode, sink) {
    if (!TextUtils.isEmpty(pincode)) {
      if (pincode.length == 6) {
        sink.add(pincode);
      } else {
        sink.addError(NAME_LENGTH_ERROR);
      }
    } else {
      sink.addError(NAME_EMPTY_ERROR);
    }
  });

  static ValidationResult pinCodeValidationResult(String pincode) {
    if (!TextUtils.isEmpty(pincode)) {
      if (pincode.length == 6) {
        return ValidationResult(true);
      } else {
        return ValidationResult(false, NAME_LENGTH_ERROR);
      }
    } else {
      return ValidationResult(false, NAME_EMPTY_ERROR);
    }
  }

  static bool isPinValid(String pin) {
    if(TextUtils.isEmpty(pin)) return false;
    if(pin.trim().length == 6) return true;
    return false;
  }

  final validateAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
    if (!TextUtils.isEmpty(address)) {
      if (address.length < 6) {
        sink.addError(NAME_LENGTH_ERROR);
      } else {
        sink.add(address);
      }
    } else {
      sink.addError(NAME_EMPTY_ERROR);
    }
  });

  static ValidationResult addressValidationResult(String address) {
    if (!TextUtils.isEmpty(address)) {
      if (address.length < 6) {
        return ValidationResult(false, NAME_LENGTH_ERROR);
      } else {
        return ValidationResult(true);
      }
    } else {
      return ValidationResult(false, NAME_EMPTY_ERROR);
    }
  }

  static isAddressValid(String address) {
    if(TextUtils.isEmpty(address)) return false;
    return true;
  }

  final validateAddressFields =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (TextUtils.isEmpty(name)) {
      sink.addError(NAME_EMPTY_ERROR);
    }else if(name==null || name.length==0 ){
      sink.addError(NAME_EMPTY_ERROR);
    } else {
      sink.add(name);
    }
  });
}

class ValidationResult {
  final bool isValid;
  final int invalidationIdOfInvalid;

  ValidationResult(this.isValid, [this.invalidationIdOfInvalid = -99]);

}
