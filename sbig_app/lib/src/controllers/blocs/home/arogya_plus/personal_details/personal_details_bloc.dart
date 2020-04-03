import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/cover_member/cover_member_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_bloc.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/product_model.dart';
import './personal_details_validator.dart';

class PersonalDetailsBloc extends BaseBloc with PersonalDetailsValidator{

  final _mobileController = BehaviorSubject.seeded("");
  Function(String) get changeMobile => _mobileController.sink.add;
  Observable<String> get mobileStream => _mobileController.stream.transform(validateMobile);
  String get mobile => _mobileController.value;

  final _emailController = BehaviorSubject.seeded("");
  Function(String) get changeEmail => _emailController.sink.add;
  Observable<String> get emailStream => _emailController.stream.transform(validateEmail);
  String get email => _emailController.value;

  Future<CityResponseModel> getCity () async {
    return ClaimIntimationBloc().getCity();
  }

  Future<ProductResponseModel> getProduct () async {
    return ClaimIntimationBloc().getProduct();
  }


  @override
  void dispose() {
    _mobileController.close();
    _emailController.close();
  }


}