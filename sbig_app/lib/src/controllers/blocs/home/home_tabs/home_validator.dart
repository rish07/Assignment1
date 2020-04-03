
import 'dart:async';

import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/service_item.dart';

class HomeValidator{

  static const DATA_ERROR = 1;

  final validateServicesList =
  StreamTransformer<List<ServicesListItem>, List<ServicesListItem>>.fromHandlers(handleData: (servicesList, sink) {
    if (servicesList == null) {
      sink.addError(DATA_ERROR);
    } else {
      sink.add(servicesList);
    }
  });

  final validatePoliciesList =
  StreamTransformer<List<PolicyListItem>, List<PolicyListItem>>.fromHandlers(handleData: (policiesList, sink) {
    if (policiesList == null) {
      sink.addError(DATA_ERROR);
    } else {
      sink.add(policiesList);
    }
  });
}