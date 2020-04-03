import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/product_model.dart';

import '../../base_bloc.dart';

class ClaimIntimationBloc extends BaseBloc with ClaimIntimationValidator {

  final _firstNameController = BehaviorSubject.seeded("");
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Observable<String> get firstNameStream => _firstNameController.stream.transform(validateName);
  String get firstName => _firstNameController.value;


  final _lastNameController = BehaviorSubject.seeded("");
  Function(String) get changeLastName => _lastNameController.sink.add;
  Observable<String> get lastNameStream => _lastNameController.stream.transform(validateName);
  String get lastName => _lastNameController.value;


  final _policyNumberController = BehaviorSubject.seeded("");
  Function(String) get changePolicyNumber => _policyNumberController.sink.add;
  Observable<String> get policyNumberStream => _policyNumberController.stream.transform(validPolicyNumber);
  String get policyNumber => _policyNumberController.value;


  final _cityController = BehaviorSubject<List<CityList>>();
  Function(List<CityList>) get changeCity => _cityController.sink.add;
  Observable<List<CityList>> get cityStream => _cityController.stream.transform(searchCityName);
  List<CityList> get cityList => _cityController.value;

  final _productController = BehaviorSubject<List<ProductList>>();
  Function(List<ProductList>) get changeProduct => _productController.sink.add;
  Observable<List<ProductList>> get productStream => _productController.stream;


  final _errorController = BehaviorSubject.seeded("");
  Function(String) get changeError => _errorController.sink.add;
  Observable<String> get errorStream => _errorController.stream;
  String get error => _errorController.value;

  Future<ClaimIntimationResponseModel> submitClaimIntimation(
      ClaimIntimationRequestModel requestModel) async {
    return ClaimIntimationApiProvider.getInstance()
        .postClaimIntimation(requestModel.toJson());
  }

  Future<CityResponseModel> getCity() async {
    return ClaimIntimationApiProvider.getInstance().getCity();
  }

  Future<ProductResponseModel> getProduct() async {
    return ClaimIntimationApiProvider.getInstance().getProduct();
  }

  @override
  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _policyNumberController.close();
    _cityController.close();
    _productController.close();
    _errorController.close();
  }
}
