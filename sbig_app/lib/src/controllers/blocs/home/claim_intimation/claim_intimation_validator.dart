import 'dart:async';
import 'dart:math';

import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';

class ClaimIntimationValidator {

  static const EMPTY_ERROR = 1;
  static const LENGTH_ERROR = 2;
  static const INVALID_ERROR = 3;

  final validateName =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name == null || name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else {
      sink.add(name);
    }
  });

  final validateNameWithLength =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name == null || name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if(name.trim().length == 1){
      sink.addError(LENGTH_ERROR);
    } else {
      sink.add(name);
    }
  });

  final validPolicyNumber =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } else if(name.trim().length==16){
      sink.add(name);
    }else {
      sink.addError(LENGTH_ERROR);
    }
  });

  final searchCityName =
  StreamTransformer<List<CityList>, List<CityList>>.fromHandlers(
      handleData: (cityList, searchList) {
        if (cityList.length > 0) {
          searchList.add(cityList);
        } else {}
      });

  final validEiaNumber =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.trim().length == 0) {
      sink.addError(EMPTY_ERROR);
    } if (name.trim().length != 12) {
      sink.addError(LENGTH_ERROR);
    } if (!(name.trim().startsWith("1245"))) {
      sink.addError(INVALID_ERROR);
    } else {
      sink.add(name);
    }
  });
}
