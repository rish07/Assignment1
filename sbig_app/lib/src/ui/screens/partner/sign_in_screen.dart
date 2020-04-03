import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/partner/partner_ui_sign_in_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/partner/partner_ui_sign_in_fields_validator.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/common/site_under_maintenance_screen.dart';
import 'package:sbig_app/src/ui/screens/web_content.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class PartnerUiSignInScreen extends StatelessWidget {
  static const routeName = "partner_ui/signin";
  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: PartnerUiSignInBloc(),
      child: _PartnerUiSignInScreenInternal(),
    );
  }

}

class _PartnerUiSignInScreenInternal extends StatefulWidget {
  @override
  _PartnerUiSignInScreenInternalState createState() => _PartnerUiSignInScreenInternalState();
}

class _PartnerUiSignInScreenInternalState extends State<_PartnerUiSignInScreenInternal> with CommonWidget {

  PartnerUiSignInBloc _partnerUiSignInBloc;

  TextEditingController _firstNameTextController = TextEditingController();
  FocusNode _firstNameFocusNode = FocusNode();

  TextEditingController _lastNameTextController = TextEditingController();
  FocusNode _lastNameFocusNode = FocusNode();

  TextEditingController _emailTextController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();

  TextEditingController _phoneTextController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

  bool isInputDataValid = false;
  bool _signInButtonClicked = false;

  bool _hasFirstNameFieldError = true;
  bool _hasLastNameFieldError = true;
  bool _hasMobileFieldError = true;
  bool _hasEmailFieldError = true;

  @override
  void initState() {
    _partnerUiSignInBloc = SbiBlocProvider.of<PartnerUiSignInBloc>(context);

    _partnerUiSignInBloc.uiEventStream.listen((uiEvent) {
      if(uiEvent is LoadingScreenUiEvent) {
        LoadingScreenUiEvent event = uiEvent;
        if(event.isVisible) {
          showLoaderDialog(context);
        } else {
          hideLoaderDialog(context);
        }
      } else if(uiEvent is NavigateToWebPageUiEvent) {
        prefsHelper.setDocPrimeUserDataAvailable(true);
        Navigator.of(context).pushNamed(WebContent.ROUTE_NAME, arguments: WebContentArguments(UrlConstants.DOC_PRIME_URL,'DOCPRIME'));
      //  Navigator.of(context).popAndPushNamed(WebContent.routeName, arguments: UrlConstants.DOC_PRIME_URL);
      } else if(uiEvent is DialogEvent) {
        DialogEvent dialogEvent = uiEvent;
        if(dialogEvent.dialogType == DialogEvent.DIALOG_TYPE_OH_SNAP) {
          showServerErrorDialog(context, 1, (identifier) {
            _onSignInClicked();
          }, message: dialogEvent.message);
        }else if(dialogEvent.dialogType == DialogEvent.DIALOG_TYPE_MAINTENANCE){
          showMaintenanceDialog(context);
        }
        else if(dialogEvent.dialogType == DialogEvent.DIALOG_TYPE_NETWORK_ERROR) {
          showNoInternetDialog(context, 1, (identifier) {
            _onSignInClicked();
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, S.of(context).sign_in.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(21, 10, 21, 80),
                child: Column(
                  crossAxisAlignment:  CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _screenHeader(S.of(context).sign_in),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: StreamBuilder<String>(
                                stream: _partnerUiSignInBloc.firstNameStream,
                                builder: (context, snapshot) {
                                  String errorString;
                                  if(snapshot.hasError) {
                                    _hasEmailFieldError = true;
                                    switch(snapshot.error) {
                                      case PartnerUiSignInFieldsValidator.NAME_EMPTY_ERROR:
                                        errorString = S.of(context).first_name_empty;
                                        break;
                                      case PartnerUiSignInFieldsValidator.NAME_LENGTH_ERROR:
                                        errorString = S.of(context).first_name_invalid;
                                        break;
                                      default:
                                        errorString = S.of(context).first_name_invalid;
                                    }
                                  } else {
                                    errorString = null;
                                    _hasFirstNameFieldError = false;
                                  }
                                  return _textInputField(
                                      S.of(context).first_name_title.toUpperCase(),
                                      errorString,
                                      _firstNameTextController,
                                      _firstNameFocusNode,
                                      InputFieldName.F_NAME);
                                }
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: StreamBuilder<String>(
                                stream: _partnerUiSignInBloc.secondNameStream,
                                builder: (context, snapshot) {
                                  String errorString;
                                  if(snapshot.hasError) {
                                    _hasLastNameFieldError = true;
                                    switch(snapshot.error) {
                                      case PartnerUiSignInFieldsValidator.NAME_EMPTY_ERROR:
                                        errorString = S.of(context).last_name_empty;
                                        break;
                                      case PartnerUiSignInFieldsValidator.NAME_LENGTH_ERROR:
                                        errorString = S.of(context).last_name_invalid;
                                        break;
                                      default:
                                        errorString = S.of(context).last_name_invalid;
                                    }
                                  } else {
                                    _hasLastNameFieldError = false;
                                    errorString = null;
                                  }
                                  return _textInputField(
                                      S.of(context).last_name_title.toUpperCase(),
                                      errorString,
                                      _lastNameTextController,
                                      _lastNameFocusNode,
                                      InputFieldName.L_NAME);
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: StreamBuilder<String>(
                          stream: _partnerUiSignInBloc.emailStream,
                          builder: (context, snapshot) {
                            String errorString;
                            if(snapshot.hasError) {
                              _hasEmailFieldError = true;
                              switch(snapshot.error) {
                                case PartnerUiSignInFieldsValidator.EMAIL_EMPTY_ERROR:
                                  errorString = S.of(context).email_empty_error;
                                  break;
                                case PartnerUiSignInFieldsValidator.NAME_LENGTH_ERROR:
                                  errorString = S.of(context).invalid_email_error;
                                  break;
                                default:
                                  errorString = S.of(context).invalid_email_error;
                              }
                            } else {
                              errorString = null;
                              _hasEmailFieldError = false;
                            }
                            return _textInputField(
                                S.of(context).email_title.toUpperCase(),
                                errorString,
                                _emailTextController,
                                _emailFocusNode,
                                InputFieldName.EMAIL);
                          }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: StreamBuilder<String>(
                          stream: _partnerUiSignInBloc.phoneStream,
                          builder: (context, snapshot) {
                            String errorString;
                            if(snapshot.hasError) {
                              _hasMobileFieldError = true;
                              switch(snapshot.error) {
                                case PartnerUiSignInFieldsValidator.MOBILE_EMPTY_ERROR:
                                  errorString = S.of(context).mobile_number_empty_error;
                                  break;
                                case PartnerUiSignInFieldsValidator.MOBILE_INVALID_ERROR:
                                  errorString = S.of(context).invalid_mobile_number_error;
                                  break;
                                case PartnerUiSignInFieldsValidator.MOBILE_LENGTH_ERROR:
                                  errorString = S.of(context).invalid_mobile_number_error;
                                  break;
                                default:
                                  errorString = S.of(context).invalid_mobile_number_error;
                              }
                            } else {
                              _hasMobileFieldError = false;
                              errorString = null;
                            }
                            return _textInputField(
                                S.of(context).mobile_number_title.toUpperCase(),
                                errorString,
                                _phoneTextController,
                                _phoneFocusNode,
                                InputFieldName.PHONE);
                          }
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: BlackButtonWidget(
                      () {
                    _onSignInClicked();
                  },
                  S.of(context).sign_in.toUpperCase()
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _screenHeader(String title) {
    return Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 32,
          letterSpacing: 1),
    );
  }

  Widget _textInputField(
      String title,
      String errorString,
      TextEditingController textController,
      FocusNode focusNode,
      InputFieldName inputFieldName) {
    isInputDataValid = TextUtils.isEmpty(errorString);
    if(!_signInButtonClicked) errorString = null;
    return Theme(
      data: new ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.black,
          hintColor: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            inputFormatters: _getInputFormatter(inputFieldName),
            controller: textController,
            focusNode: focusNode,
            style: TextStyle(fontSize: 23, letterSpacing: 1.5, color: Colors.black),
            keyboardType: _getTextInputType(inputFieldName),
            maxLength: (inputFieldName == InputFieldName.PHONE)? 10: null,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              _signInButtonClicked = false;
              switch(inputFieldName) {
                case InputFieldName.F_NAME:
                  _partnerUiSignInBloc.addFirstName(value);
                  break;
                case InputFieldName.L_NAME:
                  _partnerUiSignInBloc.addLastName(value);
                  break;
                case InputFieldName.PHONE:
                  _partnerUiSignInBloc.addPhone(value);
                  break;
                case InputFieldName.EMAIL:
                  _partnerUiSignInBloc.addEmail(value);
                  break;
              }
            },
            decoration: InputDecoration(
              counter: Container(),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 12.0, color: Colors.grey[600]),
              labelText: title,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: !TextUtils.isEmpty(errorString)
                        ? Colors.red
                        : ColorConstants.policy_type_gradient_color2),
              ),
            ),
          ),
          Text(errorString?? "", style: TextStyle(
              color: Colors.red, fontSize: 12
          ),),
        ],
      ),
    );
  }

  void _onSignInClicked() {
    _signInButtonClicked = true;
    _partnerUiSignInBloc.addInputFields(_firstNameTextController.text, _lastNameTextController.text, _emailTextController.text, _phoneTextController.text);
    if(_hasFirstNameFieldError || _hasLastNameFieldError || _hasMobileFieldError || _hasEmailFieldError) {
      debugPrint("Invalid INPUT");
    } else {
      debugPrint("Valid Input");
      _partnerUiSignInBloc.callSignInApi(_firstNameTextController.text, _lastNameTextController.text, _emailTextController.text, _phoneTextController.text);
    }
  }

  List<TextInputFormatter> _getInputFormatter(InputFieldName fieldName) {
    switch(fieldName) {
      case InputFieldName.F_NAME:
      case InputFieldName.L_NAME:
      return [
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
      ];
      case InputFieldName.PHONE:
        return [
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ];
      case InputFieldName.EMAIL:
        return [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9.@_]")),
          LengthLimitingTextInputFormatter(50),
        ];
      default:
        return null;
    }
  }

  TextInputType _getTextInputType(InputFieldName inputFieldName) {
    switch(inputFieldName) {
      case InputFieldName.F_NAME:
      case InputFieldName.L_NAME:
        return TextInputType.text;
      case InputFieldName.PHONE:
        return TextInputType.phone;
        break;
      case InputFieldName.EMAIL:
        return TextInputType.emailAddress;
      default:
        return TextInputType.text;
    }
  }
}

enum InputFieldName {F_NAME, L_NAME, PHONE, EMAIL}
