import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';

class CriticalPremiumApiProvider extends ApiResponseListenerDio {

  static CriticalPremiumApiProvider _instance;

  static CriticalPremiumApiProvider getInstance() {
    if (_instance == null) {
      return CriticalPremiumApiProvider();
    }
    return _instance;
  }

  Future<CriticalPremiumResModel> calculateCriticalPremium(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
            UrlConstants.CALCULATE_PREMIUM_CRITICAL_ILLNESS_URL, body)
        .then((response) {
      CriticalPremiumResModel premiumResModel = CriticalPremiumResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            premiumResModel = CriticalPremiumResModel.fromJson(response.data);
            return Future.value(premiumResModel);
          }
        }
        premiumResModel.apiErrorModel = onHttpFailure(response);
        return premiumResModel;
      } catch (e) {
        premiumResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " + e.toString());
        return premiumResModel;
      }
    });
  }

  Future<QuickQuoteResModel> calculateQuickQuote(Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(UrlConstants.QUICK_QUOTE_CRITICAL_ILLNESS_URL, body).then((response) {
      QuickQuoteResModel quickQuoteResModel = QuickQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            quickQuoteResModel = QuickQuoteResModel.fromJson(response.data);
            return Future.value(quickQuoteResModel);
          }
        }
        quickQuoteResModel.apiErrorModel = onHttpFailure(response);
        return quickQuoteResModel;
      } catch (e) {
        quickQuoteResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " + e.toString());
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
