import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class HealthQuestionApiProvider extends ApiResponseListenerDio {
  static HealthQuestionApiProvider _instance;

  static HealthQuestionApiProvider getInstance() {
    if (_instance == null) {
      return HealthQuestionApiProvider();
    }
    return _instance;
  }

  Future<HealthQuestionResModel> getHealthQuestionContent(int isFrom) async {
    return await BaseApiProvider.getApiCall(
            getUrls(isFrom))
        .then((response) {
      HealthQuestionResModel healthQuestionModel = HealthQuestionResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            healthQuestionModel =
                HealthQuestionResModel.fromJson(response.data);
            return Future.value(healthQuestionModel);
          }
        }
        healthQuestionModel.apiErrorModel = onHttpFailure(response);
        return healthQuestionModel;
      } catch (e) {
        healthQuestionModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("HealthQuestionApiProvider " + e.toString());
        return healthQuestionModel;
      }
    });
  }

  String getUrls(int isFrom){
    switch(isFrom){
      case StringConstants.FROM_CRITICAL_ILLNESS:
        return UrlConstants.HEALTH_QUESTION_CRITICAL_ILLNESS_URL;
        break;
      case StringConstants.FROM_AROGYA_PREMIER:
        return UrlConstants.HEALTH_QUESTION_AROGYA_PREMIER_URL;
        break;
      case StringConstants.FROM_AROGYA_TOP_UP:
        return UrlConstants.HEALTH_QUESTION_AROGYA_TOP_UP_URL;
        break;
      default :
        return '';
    }
  }


  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }
}
