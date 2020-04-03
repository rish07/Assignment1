import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/full_quote_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';

class FullQuoteApiProvider extends ApiResponseListenerDio {

  static FullQuoteApiProvider _instance;

  static FullQuoteApiProvider getInstance() {
    if (_instance == null) {
      return FullQuoteApiProvider();
    }
    return _instance;
  }

  Future<FullQuoteResModel> calculateCriticalFullQuote(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(UrlConstants.FULL_QUOTE_CRITICAL_ILLNESS_URL, body).then((response) {
      FullQuoteResModel fullQuoteResModel = FullQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            fullQuoteResModel = FullQuoteResModel.fromJson(response.data);
            return Future.value(fullQuoteResModel);
          }
        }
        fullQuoteResModel.apiErrorModel = onHttpFailure(response);
        return fullQuoteResModel;
      } catch (e) {
        fullQuoteResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("FullQuoteApiProvider " + e.toString());
        return fullQuoteResModel;
      }
    });
  }

  Future<ArogyaPremierFullQuoteResModel> calculateArogyaPremierFullQuote(Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(UrlConstants.FULL_QUOTE_AROGYA_PREMIER_URL, body).then((response) {
      ArogyaPremierFullQuoteResModel fullQuoteResModel = ArogyaPremierFullQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            fullQuoteResModel = ArogyaPremierFullQuoteResModel.fromJson(response.data);
            return Future.value(fullQuoteResModel);
          }
        }
        fullQuoteResModel.apiErrorModel = onHttpFailure(response);
        return fullQuoteResModel;
      } catch (e) {
        fullQuoteResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("FullQuoteApiProvider " + e.toString());
        return fullQuoteResModel;
      }
    });
  }

  Future<ArogyaTopUpFullQuoteResModel> calculateArogyaTopUpFullQuote(Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(UrlConstants.FULL_QUOTE_AROGYA_TOP_UP_URL, body).then((response) {
      ArogyaTopUpFullQuoteResModel fullQuoteResModel = ArogyaTopUpFullQuoteResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            fullQuoteResModel = ArogyaTopUpFullQuoteResModel.fromJson(response.data);
            return Future.value(fullQuoteResModel);
          }
        }
        fullQuoteResModel.apiErrorModel = onHttpFailure(response);
        return fullQuoteResModel;
      } catch (e) {
        fullQuoteResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("FullQuoteApiProvider " + e.toString());
        return fullQuoteResModel;
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
