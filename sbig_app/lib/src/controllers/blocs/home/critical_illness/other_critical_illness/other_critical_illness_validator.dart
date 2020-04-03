import 'dart:async';

import 'package:sbig_app/src/utilities/text_utils.dart';

class OtherCriticalIllnessValidator{
  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

  final validPolicyNumber =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if(name.trim().length==16){
      sink.add(name);
    }else {
      sink.addError(LENGTH_ERROR);
      print(name);
    }
  });

  final validateName =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!TextUtils.isEmpty(name)) {
      if (name.length == 1) {
        sink.addError(LENGTH_ERROR);
      } else {
        sink.add(name);
      }
    } else {
      sink.addError(EMPTY_ERROR);
    }
  });

}