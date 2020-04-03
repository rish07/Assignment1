

import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class PremiumApiProvider extends ApiResponseListenerDio{
  static PremiumApiProvider _instance;
  static const int CALCULATE_PREMIUM_DIFF = 1;
  static const int RECALCULATE_PREMIUM_DIFF = 2;

  static PremiumApiProvider getInstance(){
    if(_instance == null){
      return PremiumApiProvider();
    }
    return _instance;
  }

  Future<CalculatedPremiumResModel> calculatePremium(Map<String, dynamic> body, bool isFamilyFloater) async{
    return await BaseApiProvider.postApiCall(isFamilyFloater ? UrlConstants.CALCULATE_PREMIUM_FAMILY_FLOATER_URL : UrlConstants.CALCULATE_PREMIUM_URL, body).then((response){
      CalculatedPremiumResModel calculatedPremiumResModel = CalculatedPremiumResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            calculatedPremiumResModel = onHttpSuccess(response, diff : CALCULATE_PREMIUM_DIFF);
            return Future.value(calculatedPremiumResModel);
          }
        }
        calculatedPremiumResModel.apiErrorModel =
            onHttpFailure(response);
        return calculatedPremiumResModel;

      }catch(e){
        calculatedPremiumResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " +e.toString());
        return calculatedPremiumResModel;
      }
    });
  }

  Future<RecalculatePremiumResModel> reCalculatePremium(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.RECALCULATE_PREMIUM_URL, body).then((response){
      RecalculatePremiumResModel recalculatePremiumResModel = RecalculatePremiumResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            recalculatePremiumResModel = onHttpSuccess(response, diff : RECALCULATE_PREMIUM_DIFF);
            return Future.value(recalculatePremiumResModel);
          }
        }
        recalculatePremiumResModel.apiErrorModel =
            onHttpFailure(response);
        return recalculatePremiumResModel;

      }catch(e){
        recalculatePremiumResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " +e.toString());
        return recalculatePremiumResModel;
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
      case CALCULATE_PREMIUM_DIFF:
        return CalculatedPremiumResModel.fromJson(response.data);
        break;
      case RECALCULATE_PREMIUM_DIFF:
        return RecalculatePremiumResModel.fromJson(response.data);
        break;
    }
  }

}