

import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/other_critical_illness/other_critical_illness_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/other_critical_illness/other_critical_insurance_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/other_insurance_company_model.dart';

class OtherCriticalIllnessBloc extends BaseBloc with OtherCriticalIllnessValidator{

  final _policyNumberController = BehaviorSubject.seeded("");
  Function(String) get changePolicyNumber => _policyNumberController.sink.add;
  Observable<String> get policyNumberStream => _policyNumberController.stream.transform(validPolicyNumber);
  String get policyNumber => _policyNumberController.value;

  final _sumInsuredController = BehaviorSubject.seeded("");
  Function(String) get changeSumInsured => _sumInsuredController.sink.add;
  Observable<String> get sumInsuredStream => _sumInsuredController.stream.transform(validateName);
  String get sumInsured => _sumInsuredController.value;

  final _specialConditionsController = BehaviorSubject.seeded("");
  Function(String) get changeSpecialConditions => _specialConditionsController.sink.add;
  Observable<String> get specialInsuredStream => _specialConditionsController.stream.transform(validateName);
  String get incomeValue => _specialConditionsController.value;

  BehaviorSubject<DialogEvent> _eventStreamController = BehaviorSubject();
  Observable<DialogEvent> get eventStream => _eventStreamController.stream;
  Function(DialogEvent) get changeEventStream => _eventStreamController.add;



  Future<OtherInsuranceCompanyList> getInsuranceCompanyList () async {

    var response = await OtherCriticalIllnessApiProvider.getInstance().getInsuranceCompanyList();
    if (response.apiErrorModel != null) {
      if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      } else if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.MAINTENANCE) {
        changeEventStream(DialogEvent.dialogWithOutMessage(
            DialogEvent.DIALOG_TYPE_MAINTENANCE));
      } else {
        changeEventStream(
            DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
      }
      return null;
    }
    return response;
  }



  @override
  void dispose() {
   _policyNumberController.close();
   _sumInsuredController.close();
   _specialConditionsController.close();
  }

}