import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';

class ArogyaPremierPremiumApiProvider extends ApiResponseListenerDio {

  static ArogyaPremierPremiumApiProvider _instance;

  static ArogyaPremierPremiumApiProvider getInstance() {
    if (_instance == null) {
      return ArogyaPremierPremiumApiProvider();
    }
    return _instance;
  }

  Future<ArogyaPremierPremiumResModel> calculatePremium(Map<String, dynamic> body,bool isFamilyFloaterOrFamilyIndividual) async {
    return await BaseApiProvider.postApiCall( (isFamilyFloaterOrFamilyIndividual)? UrlConstants.CALCULATE_PREMIUM_AROGYA_PREMIER_FAMILY_FLOATER_URL :  UrlConstants.CALCULATE_PREMIUM_AROGYA_PREMIER_URL, body).then((response) {
      ArogyaPremierPremiumResModel premiumResModel = ArogyaPremierPremiumResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            premiumResModel = ArogyaPremierPremiumResModel.fromJson(response.data);
            return Future.value(premiumResModel);
          }
        }
        premiumResModel.apiErrorModel = onHttpFailure(response);
        return premiumResModel;
      } catch (e) {
        premiumResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("ArogyaPremierPremiumApiProvider " + e.toString());
        return premiumResModel;
      }
    });
  }

  Future<ArogyaPremierQuickQuoteResModel> calculateQuickQuote(Map<String, dynamic> body, int policyType) async {

   //return await BaseApiProvider.postApiCall((policyType==PolicyTypeScreen.INDIVIDUAL)?UrlConstants.QUICK_QUOTE_AROGYA_PREMIER_INDIVIDUAL_URL:UrlConstants.QUICK_QUOTE_AROGYA_PREMIER_URL, body).then((response) {
    return await BaseApiProvider.postApiCall(UrlConstants.QUICK_QUOTE_AROGYA_PREMIER_URL, body).then((response) {
      ArogyaPremierQuickQuoteResModel quickQuoteResModel = ArogyaPremierQuickQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            quickQuoteResModel = ArogyaPremierQuickQuoteResModel.fromJson(response.data);
            return Future.value(quickQuoteResModel);
          }
        }
        quickQuoteResModel.apiErrorModel = onHttpFailure(response);
        return quickQuoteResModel;
      } catch (e) {
        quickQuoteResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("ArogyaPremierPremiumApiProvider " + e.toString());
        return quickQuoteResModel;
      }
    });
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }

}
