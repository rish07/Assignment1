import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/communication_details_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';
import 'insuree_details_validator.dart';

class InsureeDetailsBloc extends BaseBloc with InsureeDetailsValidator{

  final _firstNameController = BehaviorSubject.seeded("");
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Observable<String> get firstNameStream => _firstNameController.stream.transform(validateName);
  String get firstName => _firstNameController.value;

  final _lastNameController = BehaviorSubject.seeded("");
  Function(String) get changeLastName => _lastNameController.sink.add;
  Observable<String> get lastNameStream => _lastNameController.stream.transform(validateName);
  String get lastName => _lastNameController.value;

  final _maritalStatusController = BehaviorSubject<bool>();
  Function(bool) get changeMartialStatus => _maritalStatusController.sink.add;
  Observable<bool> get maritalStatusStream => _maritalStatusController.stream;
  bool get martialStatus => _maritalStatusController.value;

  final _dobController = BehaviorSubject.seeded("");
  Function(String) get changeDob => _dobController.sink.add;
  Observable<String> get dobStream => _dobController.stream;
  String get dob => _dobController.value;

  final _errorController = BehaviorSubject.seeded("");
  Function(String) get changeError => _errorController.sink.add;
  Observable<String> get errorStream => _errorController.stream;
  String get error => _errorController.value;

  @override
  void dispose() async{
    await _firstNameController.drain();
    _firstNameController.close();
    await _lastNameController.drain();
    _lastNameController.close();
    await _maritalStatusController.drain();
    _maritalStatusController.close();
    await _dobController.drain();
    _dobController.close();
    await _errorController.drain();
    _errorController.close();
  }
}