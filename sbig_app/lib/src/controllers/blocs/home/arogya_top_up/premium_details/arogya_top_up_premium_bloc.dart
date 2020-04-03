import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_top_up/premium_details/arogya_top_up_premium_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_premium_model.dart';


class ArogyaTopUpPremiumBloc extends BaseBloc{

  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();
  Observable<DialogEvent> get eventStream => _eventStreamController.stream;
  Function(DialogEvent) get changeEventStream => _eventStreamController.add;

  Future<ArogyaTopUpPremiumResModel> calculatePremium(ArogyaTopUpPremiumReqModel reqModel, bool isFamilyFloaterOrFamilyIndividual) async{
    Map<String, dynamic> body = reqModel.toJson();
    var response = await ArogyaTopUpPremiumApiProvider.getInstance().calculatePremium(body, isFamilyFloaterOrFamilyIndividual);
    if(response.apiErrorModel != null){
      if(response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION){
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      }
      else if(response.apiErrorModel.statusCode== ApiResponseListenerDio.MAINTENANCE){
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      }
      else if(response.apiErrorModel.statusCode== ApiResponseListenerDio.DDOS_ERROR){
        changeEventStream(DialogEvent.dialogWithOutMessage(ApiResponseListenerDio.DDOS_ERROR));
      }
      else {
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }

 /* Future<ArogyaPremierQuickQuoteResModel> calculateQuickQuote(ArogyaPremierQuickQuoteReqModel reqModel,int policyType) async {
    Map<String, dynamic> body = reqModel.toJson();
    var response = await ArogyaPremierPremiumApiProvider.getInstance().calculateQuickQuote(body,policyType);
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
  }*/

  @override
  void dispose() async{
    await _eventStreamController.drain();
    _eventStreamController.close();
  }
}