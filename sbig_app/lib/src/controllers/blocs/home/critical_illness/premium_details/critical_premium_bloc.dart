import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_premium_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/sum_insured/critical_sum_insured_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';

import 'critical_illness_validator.dart';

class CriticalPremiumBloc extends BaseBloc with CriticalIllnessValidator {

  final _incomeController = BehaviorSubject.seeded("");
  Function(String) get changeIncome => _incomeController.sink.add;
  Observable<String> get incomeStream => _incomeController.stream.transform(validIncome);
  String get incomeValue => _incomeController.value;


  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();

  Observable<DialogEvent> get eventStream => _eventStreamController.stream;

  Function(DialogEvent) get changeEventStream => _eventStreamController.add;

  Future<CriticalPremiumResModel> calculateCriticalPremium(CriticalPremiumReqModel reqModel) async {
    Map<String, dynamic> body = reqModel.toJson();
    var response = await CriticalPremiumApiProvider.getInstance().calculateCriticalPremium(body);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(
            DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }
  Future<QuickQuoteResModel> calculateQuickQuote(QuickQuoteReqModel reqModel) async {
    Map<String, dynamic> body = reqModel.toJson();
    var response = await CriticalPremiumApiProvider.getInstance().calculateQuickQuote(body);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(
            DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }

  Future<CriticalSumInsuredResModel> getSumInsured (CriticalSumInsuredReqModel reqModel) async {
    Map<String, dynamic> body = reqModel.toJson();
    var response = await CriticalSumInuredApiProvider.getInstance().getSumInsured(body);
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(
            DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }



  @override
  void dispose() async {
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _incomeController.drain();
    _incomeController.close();

  }
}
