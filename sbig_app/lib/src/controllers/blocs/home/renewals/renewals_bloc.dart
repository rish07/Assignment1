import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_eia_model.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_update_details_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

import '../../base_bloc.dart';

class RenewalsBloc extends BaseBloc with ClaimIntimationValidator {
  final _policyNumberController = BehaviorSubject.seeded("");

  Function(String) get changePolicyNumber => _policyNumberController.sink.add;

  Observable<String> get policyNumberStream =>
      _policyNumberController.stream.transform(validPolicyNumber);

  String get policyNumber => _policyNumberController.value;


  final _eiaNumberController = BehaviorSubject.seeded("");
  Function(String) get changeEiaNumber => _eiaNumberController.sink.add;
  Observable<String> get eiaNumberStream => _eiaNumberController.stream.transform(validEiaNumber);
  String get eiaNumber => _eiaNumberController.value;

//  Future<RenewalPolicyDetailsResModel> getPolicyDetails(
//      Map<String, dynamic> body) async {
//    return RenewalsPolicyDetailsApiProvider.getInstance()
//        .getRenewalPolicyDetails(body);
//  }

  Future<RenewalUpdateDetailsResModel> updatePolicyDetails(
      Map<String, dynamic> body) async {
    return RenewalsPolicyDetailsApiProvider.getInstance()
        .updateRenewalPolicyDetails(body);
  }

  Future<RenewalStoreEIAResModel> storeEIA(
      Map<String, dynamic> body) async {
    return RenewalsPolicyDetailsApiProvider.getInstance()
        .storeEIA(body);
  }

  @override
  void dispose() {
    _policyNumberController.close();
    _eiaNumberController.close();
  }
}
