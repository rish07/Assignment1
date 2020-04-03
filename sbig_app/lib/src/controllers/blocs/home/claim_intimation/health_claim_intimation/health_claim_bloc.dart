import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'dart:async';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/health_claim_intimation/health_claim_validator.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/cities_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/health_claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/hospital_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/policy_health_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/track_health_claim_intimation_model.dart';
import 'health_claim_intimation_api_provider.dart';


class HealthClaimBloc extends BaseBloc with HealthClaimValidator {

  HealthClaimIntimationApiProvider _cityListAPiProvider = HealthClaimIntimationApiProvider();
  HealthClaimIntimationApiProvider _hospitalListAPiProvider = HealthClaimIntimationApiProvider();



  final _emailController = BehaviorSubject.seeded("");
  Function(String) get changeEmail => _emailController.sink.add;
  Observable<String> get emailStream => _emailController.stream.transform(validateEmail);
  String get email => _emailController.value;


  final _reasonOfHospitalizationController = BehaviorSubject.seeded("");
  Function(String) get changeReasonOfHospitalization => _reasonOfHospitalizationController.sink.add;
  Observable<String> get reasonOfHospitalizationStream =>
      _reasonOfHospitalizationController.stream.transform(validateDoctorName);
  String get reasonOfHospitalization => _reasonOfHospitalizationController.value;

  final _cityController = BehaviorSubject.seeded("");
  Function(String) get changeCity => _cityController.sink.add;
  Stream<String> get cityStream =>
      _cityController.stream.transform(validateCity);
  String get city => _cityController.value;


  final _doctorNameController = BehaviorSubject.seeded("");
  Function(String) get changeDoctorName => _doctorNameController.sink.add;
  Observable<String> get doctorNameStream =>
      _doctorNameController.stream.transform(validateDoctorName);
  String get doctorName => _doctorNameController.value;


  final _dateOfHospitalizationController = BehaviorSubject.seeded("");
  Function(String) get changeDateOfHospitalization => _dateOfHospitalizationController.sink.add;
  Observable<String> get dateOfHospitalizationStream => _dateOfHospitalizationController.stream;
  String get dateOfHospitalization => _dateOfHospitalizationController.value;



  final _dateOfDischargeController = BehaviorSubject.seeded("");
  Function(String) get changeDateOfDischarge => _dateOfDischargeController.sink.add;
  Observable<String> get dateOfDischargeStream => _dateOfDischargeController.stream;
  String get dateOfDischarge => _dateOfDischargeController.value;


  final _amountController = BehaviorSubject.seeded("");
  Function(String) get changeAmount => _amountController.sink.add;
  Observable<String> get amountStream =>
      _amountController.stream.transform(validateAmount);
  String get amount => _amountController.value;


  final _otherController = BehaviorSubject.seeded("");
  Function(String) get changeOther => _otherController.sink.add;
  Observable<String> get otherStream =>
      _otherController.stream.transform(validateOther);
  String get other => _otherController.value;

  final _errorController = BehaviorSubject.seeded("");
  Function(String) get changeError => _errorController.sink.add;
  Observable<String> get errorStream => _errorController.stream;
  String get error => _errorController.value;


  final _typeOfClaimController = BehaviorSubject.seeded("");
  Function(String) get changeTypeOfClaim => _typeOfClaimController.sink.add;
  Observable<String> get typeOfClaimStream =>
      _typeOfClaimController.stream;
  String get typeOfClaim => _typeOfClaimController.value;


  final _roomTypeController = BehaviorSubject.seeded("");
  Function(String) get changeRoomType => _roomTypeController.sink.add;
  Observable<String> get roomTypeStream => _roomTypeController.stream;
  String get roomType => _roomTypeController.value;

  final _patientNameController = BehaviorSubject.seeded("");
  Function(String) get changePatientName => _patientNameController.sink.add;
  Observable<String> get patientNameStream => _patientNameController.stream;
  String get patientName => _patientNameController.value;

  final _hospitalNameController = BehaviorSubject.seeded("");
  Function(String) get changeHospitalName => _hospitalNameController.sink.add;
  Observable<String> get hospitalNameStream => _hospitalNameController.stream;
  String get hospitalName => _hospitalNameController.value;

  final _mobileNumberController = BehaviorSubject.seeded("");
  Function(String) get changeMobileNumber => _mobileNumberController.sink.add;
  Observable<String> get mobileNumberStream => _mobileNumberController.stream.transform(validateMobile);
  String get mobileNumber => _mobileNumberController.value;


  Future<HealthClaimIntimationResponseModel> submitHealthClaimIntimation(
      HealthClaimIntimationRequestModel requestModel) async {
    return HealthClaimIntimationApiProvider.getInstance()
        .postHealthClaimIntimation(requestModel.toJson());
  }

  Future<TrackHealthClaimIntimationResponseModel> trackHealthClaimIntimation(
      TrackHealthClaimIntimationRequestModel requestModel) async {
    return HealthClaimIntimationApiProvider.getInstance()
        .postTrackHealthClaimIntimation(requestModel.toJson());
  }



  Future<PolicyDetailsResponseModel> submitPolicyDetails(
      PolicyDetailsRequestModel requestModel) async {
    return HealthClaimIntimationApiProvider.getInstance()
        .postPolicyDetails(requestModel.toJson());
  }


  Future<HospitalResponseModel> getHospital(String city)
  {
    _hospitalListAPiProvider.getHospital(city);
  }


  Future<CitiesResponseModel> getCities(String latitude, String longitude)
  {
    _cityListAPiProvider.getCities(latitude, longitude);
  }
  @override
  void dispose() {

    _emailController.close();
    _reasonOfHospitalizationController.close();
    _cityController.close();
    _doctorNameController.close();
    _dateOfHospitalizationController.close();
    _dateOfDischargeController.close();
    _amountController.close();
    _otherController.close();
    _errorController.close();
    _typeOfClaimController.close();
    _roomTypeController.close();
    _hospitalNameController.close();
    _mobileNumberController.close();
    _patientNameController.close();
    _mobileNumberController.close();

  }

}

