import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/partner/partner_ui_sign_in_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/partner/partner_ui_sign_in_fields_validator.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/partner/partner_ui_api_models.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class PartnerUiSignInBloc extends BaseBloc {
  BehaviorSubject<String> _firstNameStreamController = BehaviorSubject.seeded("");
  Observable<String> get firstNameStream => _firstNameStreamController.stream.transform(PartnerUiSignInFieldsValidator.validateName);
  Function(String data) get addFirstName => _firstNameStreamController.sink.add;

  BehaviorSubject<String> _secondNameStreamController = BehaviorSubject.seeded("");
  Observable<String> get secondNameStream => _secondNameStreamController.stream.transform(PartnerUiSignInFieldsValidator.validateName);
  Function(String data) get addLastName => _secondNameStreamController.sink.add;


  BehaviorSubject<String> _emailStreamController = BehaviorSubject.seeded("");
  Observable<String> get emailStream => _emailStreamController.stream.transform(PartnerUiSignInFieldsValidator.validateEmail);
  Function(String data) get addEmail => _emailStreamController.sink.add;

  BehaviorSubject<String> _phoneStreamController = BehaviorSubject.seeded("");
  Observable<String> get phoneStream => _phoneStreamController.stream.transform(PartnerUiSignInFieldsValidator.validateMobile);
  Function(String data) get addPhone => _phoneStreamController.sink.add;

  BehaviorSubject<UIEvent> _uiEventStreamController = BehaviorSubject();
  Observable<UIEvent> get uiEventStream => _uiEventStreamController.stream;

  PartnerUiSignInApiProvider _partnerUiSignInApiProvider = PartnerUiSignInApiProvider();

  PartnerUiSignInBloc();

  void addInputFields(String firstName, String lastName, String email, String mobile) {
    _firstNameStreamController.add(firstName);
    _secondNameStreamController.add(lastName);
    _emailStreamController.add(email);
    _phoneStreamController.add(mobile);
  }

  void callSignInApi(String firstName, String lastName, String email, String mobile) {
    _uiEventStreamController.add(LoadingScreenUiEvent(true));

    PartnerUiSignInRequest request = PartnerUiSignInRequest(email: email, firstName: firstName, lastName: lastName, phone: mobile);
    _partnerUiSignInApiProvider.callPartnerUiSignInApi(request).then((parsedResponse) {
      _uiEventStreamController.add(LoadingScreenUiEvent(false));
      if(parsedResponse.hasData) {
        if(parsedResponse.data.success) {
          _uiEventStreamController.add(NavigateToWebPageUiEvent());
        } else {
          _uiEventStreamController.add(DialogEvent.dialogWithMessage(DialogEvent.DIALOG_TYPE_OH_SNAP, parsedResponse.data.message));
        }
      } else if(parsedResponse.hasError) {
        ApiErrorModel apiErrorModel = parsedResponse.error;
        if(apiErrorModel.statusCode == ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
          _uiEventStreamController.add((DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_NETWORK_ERROR)));
        } else if(apiErrorModel.statusCode == ApiResponseListenerDio.MAINTENANCE){
          _uiEventStreamController.add((DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_MAINTENANCE)));
        } else if(parsedResponse.error.statusCode== ApiResponseListenerDio.DDOS_ERROR){
          _uiEventStreamController.add(DialogEvent.dialogWithOutMessage(ApiResponseListenerDio.DDOS_ERROR));
        }else {
          _uiEventStreamController.add(DialogEvent.dialogWithOutMessage(DialogEvent.DIALOG_TYPE_OH_SNAP));
        }
      }
    });
  }


  @override
  void dispose() {
    _firstNameStreamController.close();
    _secondNameStreamController.close();
    _emailStreamController.close();
    _phoneStreamController.close();
    _uiEventStreamController.close();
  }
}

class NavigateToWebPageUiEvent extends UIEvent {
  NavigateToWebPageUiEvent() : super(null);
}