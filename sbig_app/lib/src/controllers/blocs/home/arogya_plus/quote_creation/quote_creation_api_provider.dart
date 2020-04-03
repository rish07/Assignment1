

import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/agent_receipt_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class QuoteCreationApiProvider extends ApiResponseListenerDio{
  static QuoteCreationApiProvider _instance;
  static const int QUOTE_CREATION_API = 1;
  static const int AGENT_RECEIPT = 2;

  static QuoteCreationApiProvider getInstance(){
    if(_instance == null){
      return QuoteCreationApiProvider();
    }
    return _instance;
  }

  Future<RecalculatePremiumResModel> quoteCreation(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.QUOTE_CREATION_URL, body).then((response){
      RecalculatePremiumResModel recalculatePremiumResModel = RecalculatePremiumResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            recalculatePremiumResModel = onHttpSuccess(response, diff : QUOTE_CREATION_API);
            return Future.value(recalculatePremiumResModel);
          }
        }
        recalculatePremiumResModel.apiErrorModel =
            onHttpFailure(response);
        return recalculatePremiumResModel;

      }catch(e){
        recalculatePremiumResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint(" QuoteCreationApiProvider " +e.toString());
        return recalculatePremiumResModel;
      }
    });
  }

  Future<AgentReceiptModel> agentReceipt(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.AGENT_RECEIPT_URL, body).then((response){
      AgentReceiptModel agentReceiptModel = AgentReceiptModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            agentReceiptModel = onHttpSuccess(response, diff : AGENT_RECEIPT);
            return Future.value(agentReceiptModel);
          }
        }
        agentReceiptModel.apiErrorModel =
            onHttpFailure(response);
        return agentReceiptModel;

      }catch(e){
        agentReceiptModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("QuoteCreationApiProvider " +e.toString());
        return agentReceiptModel;
      }
    });
  }



  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    switch(diff){
      case QUOTE_CREATION_API:
        return RecalculatePremiumResModel.fromJson(response.data);
        break;
      case AGENT_RECEIPT:
        return AgentReceiptModel.fromJson(response.data);
        break;
    }
  }

}