import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_quick_quote_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ArogyaTopUpPremiumApiProvider extends ApiResponseListenerDio {
  static ArogyaTopUpPremiumApiProvider _instance;

  static ArogyaTopUpPremiumApiProvider getInstance() {
    if (_instance == null) {
      return ArogyaTopUpPremiumApiProvider();
    }
    return _instance;
  }

  Future<ArogyaTopUpPremiumResModel> calculatePremium(
      Map<String, dynamic> body, bool isFamilyFloaterOrFamilyIndividual) async {
    return await BaseApiProvider.postApiCall(
            (isFamilyFloaterOrFamilyIndividual)
                ? UrlConstants
                    .CALCULATE_PREMIUM_AROGYA_TOP_UP_FAMILY_FLOATER_URL
                : UrlConstants.CALCULATE_PREMIUM_AROGYA_TOP_UP_URL,
            body)
        .then((response) {
      ArogyaTopUpPremiumResModel premiumResModel =
      ArogyaTopUpPremiumResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            premiumResModel =
                ArogyaTopUpPremiumResModel.fromJson(response.data);
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

  Future<ArogyaTopUpQuickQuoteResModel> calculateQuickQuote(Map<String, dynamic> body, int policyType) async {
    return await BaseApiProvider.postApiCall(
            UrlConstants.QUICK_QUOTE_AROGYA_TOP_UP_URL, body)
        .then((response) {
      ArogyaTopUpQuickQuoteResModel quickQuoteResModel =
      ArogyaTopUpQuickQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            quickQuoteResModel =
                ArogyaTopUpQuickQuoteResModel.fromJson(response.data);
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
