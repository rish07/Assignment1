import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CriticalSumInuredApiProvider extends ApiResponseListenerDio {
  static CriticalSumInuredApiProvider _instance;

  static CriticalSumInuredApiProvider getInstance() {
    if (_instance == null) {
      return CriticalSumInuredApiProvider();
    }
    return _instance;
  }

  Future<CriticalSumInsuredResModel> getSumInsured(Map<String, dynamic> body) async {

    return await BaseApiProvider.postApiCall(UrlConstants.SUM_INSURED_CRITICAL_ILLNESS_URL, body).then((response) {
      CriticalSumInsuredResModel sumInsuredResModel = CriticalSumInsuredResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            CriticalSumInsuredResModel sumInsuredResModel = CriticalSumInsuredResModel.fromJson(response.data);
            return Future.value(sumInsuredResModel);
          }
        }
        sumInsuredResModel.apiErrorModel = onHttpFailure(response);
        return sumInsuredResModel;
      } catch (e) {
        sumInsuredResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SumInsuredAPIProvider " + e.toString());
        return sumInsuredResModel;
      }
    });
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
