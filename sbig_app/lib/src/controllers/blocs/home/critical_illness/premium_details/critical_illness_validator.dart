import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class CriticalIllnessValidator {
  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

  final validIncome = StreamTransformer<String, String>.fromHandlers(
      handleData: (income, sink) {
    if (income.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if (income.trim().length <= 30) {
      String value = CommonUtil.instance.getFormattedCurrency(income);
      sink.add(value);
    } else {
      sink.addError(LENGTH_ERROR);
    }
  });

  /*final validIncome = StreamTransformer<String, String>.fromHandlers(
      handleData: (income, sink) {
    if (income.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if (income.trim().length <= 30) {
      String value = CommonUtil.instance.getFormattedCurrency(income);
      var amt=value.replaceAll(',', '');
      try{
        int val = int.parse(amt);
        if(val == 0){
          sink.addError(INVALID_ERROR);
        }else{
          sink.add(value);
        }
      }catch(e){
      }

    } else {
      sink.addError(LENGTH_ERROR);
    }
  });
*/


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

}
