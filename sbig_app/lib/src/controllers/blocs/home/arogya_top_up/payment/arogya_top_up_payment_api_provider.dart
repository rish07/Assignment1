import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/insurance_payment.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class ArogyaTopUpPaymentApiProvider extends ApiResponseListenerDio {
  Future<ParsedResponse<InsurancePaymentResModel>> paymentStatusCheckApiCall(InsurancePayment request) async {
    return BaseApiProvider.postApiCall(UrlConstants.PAYMENT_PROCESS_AROGYA_TOP_UP_URL, request.toJson()).then((response) {
      try {
        if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
          return ParsedResponse.addData(InsurancePaymentResModel.fromJson(response.data));
        } else {
          return ParsedResponse.addError(onHttpFailure(response));
        }
      } catch(e) {
        return ParsedResponse.addError(onHttpFailure(null));
      }
    });
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }
}
