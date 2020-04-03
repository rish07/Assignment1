import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/other_insurance_company_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class OtherCriticalIllnessApiProvider extends ApiResponseListenerDio {
  static OtherCriticalIllnessApiProvider _instance;

  static OtherCriticalIllnessApiProvider getInstance() {
    if (_instance == null) {
      return OtherCriticalIllnessApiProvider();
    }
    return _instance;
  }

  Future<OtherInsuranceCompanyList> getInsuranceCompanyList () async {

    return await BaseApiProvider.getApiCall(UrlConstants.INSURANCE_COMPANY_CRITICAL_ILLNESS_URL).then((response) {
      OtherInsuranceCompanyList otherInsuranceCompanyList = OtherInsuranceCompanyList();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            OtherInsuranceCompanyList otherInsuranceCompanyList = OtherInsuranceCompanyList.fromJson(response.data);
            return Future.value(otherInsuranceCompanyList);
          }
        }
        otherInsuranceCompanyList.apiErrorModel = onHttpFailure(response);
        return otherInsuranceCompanyList;
      } catch (e) {
        otherInsuranceCompanyList.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SumInsuredAPIProvider " + e.toString());
        return otherInsuranceCompanyList;
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
