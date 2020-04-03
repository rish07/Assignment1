import 'dart:async';

import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class EIAValidator {
  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

/*  final validEiaNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (eia, sink) {
    if (eia.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if(CommonUtil().eiaNumberFormatter.hasMatch(eia)){
      sink.add(eia);
    }else {
      sink.addError(INVALID_ERROR);
    }
  });*/

  final validEiaNumber =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if(name.length>=4 && !name.startsWith('1245',0)){
      sink.addError(INVALID_ERROR);
    }else if (name.trim().length != 12) {
      sink.addError(LENGTH_ERROR);
    }
    else {
      sink.add(name);
    }
  });

  final validPANNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (pan, sink) {
    if (pan.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if (CommonUtil().panCardFormatter.hasMatch(pan)) {
      sink.add(pan);
    } else {
      sink.addError(INVALID_ERROR);
      print(pan);
    }
  });

  static bool isEiaValid(String eiaNumber) {
    if(TextUtils.isEmpty(eiaNumber)) {
      return false;
    }
    if(!CommonUtil().eiaNumberFormatter.hasMatch(eiaNumber)) return false;
    return true;
  }
}
