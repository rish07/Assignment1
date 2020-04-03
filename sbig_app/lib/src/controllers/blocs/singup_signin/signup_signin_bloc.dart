

import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/common/common_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/singup_signin/singup_signin_api_provider.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/get_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/login_otp_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/policy_types_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/register_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/validate_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/signup_signin/verify_otp_model.dart';

class SingupSigninBloc extends CommonBloc {

  final _policyTypeController = BehaviorSubject.seeded(false);
  Function(bool) get changePolicyType => _policyTypeController.sink.add;
  Observable<bool> get policyTypeStream => _policyTypeController.stream;
  bool get policyType => _policyTypeController.value;

  Future<GetPolicyDetailsResponseModel> doLoginOrGetPolicyDetails(Map<String, dynamic> body, bool isFromLogin) async {
    return await SignupSigninApiProvider.getInstance().doLoginOrGetPolicyDetails(body, isFromLogin);
  }

  Future<PolicyTypesResModel> getPolicyTypes() async {
    return await SignupSigninApiProvider.getInstance().getPolicyTypes();
  }

  Future<ValidatePolicyDetailsResModel> validatePolicyDetails(Map<String, dynamic> body) async {
    return await SignupSigninApiProvider.getInstance().validatePolicyDetails(body);
  }

  Future<LoginOTPResModel> getLoginOTP(Map<String, dynamic> body) async {
    return await SignupSigninApiProvider.getInstance().getLoginOtp(body);
  }

  Future<VerifyOTPResModel> verifyOTP(Map<String, dynamic> body) async {
    return await SignupSigninApiProvider.getInstance().verifyOTP(body);
  }

  Future<RegisterResModel> register(Map<String, dynamic> body) async {
    return await SignupSigninApiProvider.getInstance().register(body);
  }

  @override
  void dispose() {
    _policyTypeController.close();
    super.dispose();
  }
}


