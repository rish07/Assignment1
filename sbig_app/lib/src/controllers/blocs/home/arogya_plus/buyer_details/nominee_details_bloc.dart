import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/communication_details_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';

class NomineeDetailsBloc extends BaseBloc with InsureeDetailsValidator{

  final _firstNameController = BehaviorSubject.seeded("");
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get addFirstName => _firstNameController.add;
  Observable<String> get firstNameStream => _firstNameController.stream.transform(validateName);
  String get firstName => _firstNameController.value;

  final _lastNameController = BehaviorSubject.seeded("");
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get addLastName => _lastNameController.add;
  Observable<String> get lastNameStream => _lastNameController.stream.transform(validateName);
  String get lastName => _lastNameController.value;

  final _errorController = BehaviorSubject.seeded("");
  Function(String) get changeError => _errorController.sink.add;
  Observable<String> get errorStream => _errorController.stream;
  String get error => _errorController.value;

  final _dobController = BehaviorSubject.seeded("");
  Function(String) get changeDob => _dobController.sink.add;
  Observable<String> get dobStream => _dobController.stream;
  String get dob => _dobController.value;

  final _agentCodeController = BehaviorSubject.seeded("");
  Function(String) get changeAgentCode => _agentCodeController.sink.add;
  Function(String) get addAgentCode => _agentCodeController.add;
  Observable<String> get agentCodeStream => _agentCodeController.stream.transform(validateAgentCode);
  String get agentCode => _agentCodeController.value;

  @override
  void dispose() async{
    await _dobController.drain();
    _dobController.close();
    await _firstNameController.drain();
    _firstNameController.close();
    await _lastNameController.drain();
    _lastNameController.close();
    await _errorController.drain();
    _errorController.close();
    await _agentCodeController.drain();
    _agentCodeController.close();
  }
}