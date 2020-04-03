import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';

import 'eia_validator.dart';


class EiaBloc extends BaseBloc with EIAValidator {


  final _eiaNumberController = BehaviorSubject.seeded("");
  Function(String) get changeEiaNumber => _eiaNumberController.sink.add;
  Observable<String> get eiaNumberStream => _eiaNumberController.stream.transform(validEiaNumber);
  String get eiaNumber => _eiaNumberController.value;

  final _panNumberController = BehaviorSubject.seeded("");
  Function(String) get changePANNumber => _panNumberController.sink.add;
  Observable<String> get panNumberStream =>
      _panNumberController.stream.transform(validPANNumber);
  String get panNumber => _panNumberController.value;

  final _errorController = BehaviorSubject.seeded("");
  Function(String) get changeError => _errorController.sink.add;
  Observable<String> get errorStream => _errorController.stream;
  String get error => _errorController.value;


  @override
  void dispose() async {
    _eiaNumberController.close();
    _panNumberController.close();
    _errorController.close();


  }
}
