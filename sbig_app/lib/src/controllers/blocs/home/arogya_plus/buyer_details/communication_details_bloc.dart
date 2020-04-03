import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/communication_details_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';

class CommunicationDetailsBloc extends BaseBloc with InsureeDetailsValidator{

  final _plotNumberController = BehaviorSubject.seeded("");
  Function(String) get changeplotNumber => _plotNumberController.sink.add;
  Observable<String> get plotNumberStream => _plotNumberController.stream.transform(validateAddressFields);
  String get plotNumber => _plotNumberController.value;

  final _pincodeController = BehaviorSubject.seeded("");
  Function(String) get changePincode => _pincodeController.sink.add;
  Observable<String> get pincodeStream => _pincodeController.stream.transform(validatePincode);
  String get pincode => _pincodeController.value;

  BehaviorSubject<UIEvent> _eventStreamController = BehaviorSubject();
  Observable<UIEvent> get eventStream => _eventStreamController.stream;
  Function(UIEvent) get changeEventStream => _eventStreamController.add;

  final _buildingNameController = BehaviorSubject.seeded("");
  Function(String) get changeBuildingName => _buildingNameController.sink.add;
  Observable<String> get buildingNameStream => _buildingNameController.stream.transform(validateAddressFields);
  String get buildingName => _buildingNameController.value;

  final _streetNameController = BehaviorSubject.seeded("");
  Function(String) get changeStreetName => _streetNameController.sink.add;
  Observable<String> get streetNameStream => _streetNameController.stream.transform(validateAddressFields);
  String get streetName => _streetNameController.value;

  final _locationController = BehaviorSubject.seeded("");
  Function(String) get changeLocation => _locationController.sink.add;
  Observable<String> get locationStream => _locationController.stream.transform(validateAddressFields);
  String get location => _locationController.value;

  Future<PinCodeResModel> getAreas(String pincode) async{
    Map<String, dynamic> body = {"pincode":pincode};
    var response = await CommunicationDetailsApiProvider.getInstance().getAreas(body);
    if(response.apiErrorModel != null){
      if(response.apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION){
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR));
      }else if(response.apiErrorModel.statusCode== ApiResponseListenerDio.MAINTENANCE){
        changeEventStream(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE));
      }else if(response.apiErrorModel.statusCode== ApiResponseListenerDio.DDOS_ERROR){
        changeEventStream(DialogEvent.dialogWithOutMessage(ApiResponseListenerDio.DDOS_ERROR));
      }
      else {
        changeEventStream(SnackBarEvent(CommunicationPageSnackBarMessageKeys.invalid_pin));
      }
      return null;
    }
    return response;
  }

  @override
  void dispose() async{
    await _eventStreamController.drain();
    _eventStreamController.close();
    await _pincodeController.drain();
    _pincodeController.close();
    await _plotNumberController.drain();
    _plotNumberController.close();
    await _buildingNameController.drain();
    _buildingNameController.close();
    await _streetNameController.drain();
    _streetNameController.close();
    await _locationController.drain();
    _locationController.close();
  }
}

class CommunicationPageSnackBarMessageKeys {
  static const String invalid_pin =  "invalid_pincode";
}