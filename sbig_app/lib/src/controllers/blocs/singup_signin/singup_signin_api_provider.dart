import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/get_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/login_otp_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/register_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/validate_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/verify_otp_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class SignupSigninApiProvider extends ApiResponseListenerDio{
  static SignupSigninApiProvider _instance;
  static const int GET_POLICY_TYPES_DIFF = 1;
  static const int LOGIN_GET_POLICY_DETAILS_DIFF = 2;
  static const int VALIDATE_POLICY_DETAILS_DIFF = 3;
  static const int GET_LOGIN_OTP_DIFF = 4;
  static const int VERIFY_OTP_DIFF = 5;
  static const int REGISTER_DIFF = 6;

  static SignupSigninApiProvider getInstance(){
    if(_instance == null){
      return SignupSigninApiProvider();
    }
    return _instance;
  }

  Future<GetPolicyDetailsResponseModel> doLoginOrGetPolicyDetails(Map<String, dynamic> body, bool isLogin) async{
    return await BaseApiProvider.postApiCall(UrlConstants.LOGIN_GET_POLICY_DETAILS_URL, body).then((response){
      GetPolicyDetailsResponseModel getPolicyDetailsResponseModel = GetPolicyDetailsResponseModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            getPolicyDetailsResponseModel = onHttpSuccess(response, diff : LOGIN_GET_POLICY_DETAILS_DIFF);
            return Future.value(getPolicyDetailsResponseModel);
          }
        }
        getPolicyDetailsResponseModel.apiErrorModel =
            onHttpFailure(response);
        return getPolicyDetailsResponseModel;

      }catch(e){
        getPolicyDetailsResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Get policy details" +e.toString());
        return getPolicyDetailsResponseModel;
      }
    });
  }

  Future<ValidatePolicyDetailsResModel> validatePolicyDetails(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.VALIDATE_POLICY_DATA_URL, body).then((response){
      ValidatePolicyDetailsResModel validatePolicyDetailsResModel = ValidatePolicyDetailsResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            validatePolicyDetailsResModel = onHttpSuccess(response, diff : VALIDATE_POLICY_DETAILS_DIFF);
            return Future.value(validatePolicyDetailsResModel);
          }
        }
        validatePolicyDetailsResModel.apiErrorModel =
            onHttpFailure(response);
        return validatePolicyDetailsResModel;

      }catch(e){
        validatePolicyDetailsResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Get policy details" +e.toString());
        return validatePolicyDetailsResModel;
      }
    });
  }

  Future<PolicyTypesResModel> getPolicyTypes() async{
    return await BaseApiProvider.getApiCall(UrlConstants.GET_POLICY_TYPES_URL).then((response){
      PolicyTypesResModel policyTypesResModel = PolicyTypesResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            policyTypesResModel = onHttpSuccess(response, diff : GET_POLICY_TYPES_DIFF);
            return Future.value(policyTypesResModel);
          }
        }
        policyTypesResModel.apiErrorModel =
            onHttpFailure(response);
        return policyTypesResModel;

      }catch(e){
        policyTypesResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Get Policy Types " +e.toString());
        return policyTypesResModel;
      }
    });
  }

  Future<LoginOTPResModel> getLoginOtp(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.GET_LOGIN_OTP, body).then((response){
      LoginOTPResModel loginOTPResModel = LoginOTPResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            loginOTPResModel = onHttpSuccess(response, diff : GET_LOGIN_OTP_DIFF);
            return Future.value(loginOTPResModel);
          }
        }
        loginOTPResModel.apiErrorModel =
            onHttpFailure(response);
        return loginOTPResModel;

      }catch(e){
        loginOTPResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Get login otp error " +e.toString());
        return loginOTPResModel;
      }
    });
  }

  Future<VerifyOTPResModel> verifyOTP(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.LOGIN_OTP_VERIFICATION_URL, body).then((response){
      VerifyOTPResModel verifyOTPResModel = VerifyOTPResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            verifyOTPResModel = onHttpSuccess(response, diff : VERIFY_OTP_DIFF);
            return Future.value(verifyOTPResModel);
          }
        }
        verifyOTPResModel.apiErrorModel =
            onHttpFailure(response);
        return verifyOTPResModel;

      }catch(e){
        verifyOTPResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Veirfy OTP error " +e.toString());
        return verifyOTPResModel;
      }
    });
  }

  Future<RegisterResModel> register(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.REGISTER_URL, body).then((response){
      RegisterResModel registerResModel = RegisterResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            registerResModel = onHttpSuccess(response, diff : REGISTER_DIFF);
            return Future.value(registerResModel);
          }
        }
        registerResModel.apiErrorModel =
            onHttpFailure(response);
        return registerResModel;

      }catch(e){
        registerResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("SingupSigninApiProvider - Veirfy OTP error " +e.toString());
        return registerResModel;
      }
    });
  }


  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    switch(diff){
      case LOGIN_GET_POLICY_DETAILS_DIFF:
        return GetPolicyDetailsResponseModel.fromJson(response.data);
      case GET_POLICY_TYPES_DIFF:
        return PolicyTypesResModel.fromJson(response.data);
      case VALIDATE_POLICY_DETAILS_DIFF:
        return ValidatePolicyDetailsResModel.fromJson(response.data);
      case GET_LOGIN_OTP_DIFF:
        return LoginOTPResModel.fromJson(response.data);
      case VERIFY_OTP_DIFF:
        return VerifyOTPResModel.fromJson(response.data);
      case REGISTER_DIFF:
        return RegisterResModel.fromJson(response.data);
    }
  }

}