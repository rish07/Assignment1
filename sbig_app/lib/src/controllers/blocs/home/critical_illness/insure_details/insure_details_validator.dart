import 'dart:async';

import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class InsureDetailsValidator {
  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

  final validIncome = StreamTransformer<String, String>.fromHandlers(
      handleData: (income, sink) {
        if (income.trim().length == 0) {
          sink.addError(EMPTY_ERROR);
        } else if (income.trim().length <= 30) {
          String value = CommonUtil.instance.getFormattedCurrency(income);
          print('VALUE : $value');
          sink.add(value);
        } else {
          sink.addError(LENGTH_ERROR);
          print(income);
        }
      });

  final validEiaNumber =
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

  final validPANNumber =
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

  final validateWeight =
  StreamTransformer<int, int>.fromHandlers(handleData: (weight, sink) {
    if (weight==-1) {
      sink.addError(EMPTY_ERROR);
    } else if(weight <= 999 ){
      sink.add(weight);
    }else {
      sink.addError(LENGTH_ERROR);
      print(weight);
    }
  });

  final validateHeight =
  StreamTransformer<int, int>.fromHandlers(handleData: (height, sink) {
    if (height == -1) {
      sink.addError(EMPTY_ERROR);
    } else if(height >0){
      sink.add(height);
    }
    else {
      sink.addError(INVALID_ERROR);
    }
  });

  ///NOT Validating  for Inch as its not mandatory kept this validation for future purpose
  final validateHeightInch =
  StreamTransformer<int, int>.fromHandlers(handleData: (height, sink) {
    if (height == -1) {
      //sink.addError(EMPTY_ERROR);
      sink.add(0);
    } else if(height >=0){
      sink.add(height);
    }
    else {
      sink.addError(INVALID_ERROR);
    }
  });

}
