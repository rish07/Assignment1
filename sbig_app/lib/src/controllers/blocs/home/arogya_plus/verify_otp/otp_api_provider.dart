import 'package:dio/src/response.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/otp_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class OTPApiProvider extends ApiResponseListenerDio {

  static OTPApiProvider _instance;

  static OTPApiProvider getInstance() {
    if (_instance == null) {
      return OTPApiProvider();
    }
    return _instance;
  }

  Future<OTPResponseModel> getOTP(OTPRequestModel requestModel) async {
    return await BaseApiProvider.postApiCall(UrlConstants.GET_OTP_API, requestModel.toJson())
        .then((response) {
      OTPResponseModel otpResponseModel = OTPResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            otpResponseModel = OTPResponseModel.fromJson(response.data);
            return otpResponseModel;
          }
        }
        otpResponseModel.apiErrorModel = onHttpFailure(response);
        return otpResponseModel;
      } catch (e) {
        otpResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return otpResponseModel;
      }
    });
  }

  Future<OTPResponseModel> verifyOTP(OTPVerifyRequestModel requestModel) async {
    return await BaseApiProvider.postApiCall(UrlConstants.VERIFY_OTP_API, requestModel.toJson())
        .then((response) {
      OTPResponseModel otpResponseModel = OTPResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            otpResponseModel = OTPResponseModel.fromJson(response.data);
            return otpResponseModel;
          }
        }
        otpResponseModel.apiErrorModel = onHttpFailure(response);
        return otpResponseModel;
      } catch (e) {
        otpResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return otpResponseModel;
      }
    });
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }
}
