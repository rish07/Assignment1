import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class SumInuredApiProvider extends ApiResponseListenerDio {
  static SumInuredApiProvider _instance;

  static SumInuredApiProvider getInstance() {
    if (_instance == null) {
      return SumInuredApiProvider();
    }
    return _instance;
  }

  Future<SumInsuredResModel> getSumInsured(int isFrom,int age ) async {
    Map<String, dynamic> body ={};
    body['age']=age;
    return await BaseApiProvider.postApiCall(getUrls(isFrom), body).then((response) {
      SumInsuredResModel sumInsuredResModel = SumInsuredResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            SumInsuredResModel sumInsuredResModel = SumInsuredResModel.fromJson(response.data);
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

  Future<ArogyaTopUpSumInsuredResModel> getArogyaTopUpSumInsured(int age ) async {
    Map<String, dynamic> body ={};
    body['age']=age;
    return await BaseApiProvider.postApiCall(UrlConstants.SUM_INSURED_AROGYA_TOP_UP_URL, body).then((response) {
      ArogyaTopUpSumInsuredResModel sumInsuredResModel = ArogyaTopUpSumInsuredResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            ArogyaTopUpSumInsuredResModel sumInsuredResModel = ArogyaTopUpSumInsuredResModel.fromJson(response.data);
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

  String getUrls(int isFrom) {
    switch (isFrom) {
      case StringConstants.FROM_AROGYA_PREMIER:
        return UrlConstants.SUM_INSURED_AROGYA_PREMIER_URL;
        break;
      case StringConstants.FROM_AROGYA_TOP_UP:
        return UrlConstants.SUM_INSURED_AROGYA_TOP_UP_URL;
        break;
    }
    return '';
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
