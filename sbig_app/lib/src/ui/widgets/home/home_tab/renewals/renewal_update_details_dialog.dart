import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_validator.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';

class RenewalUpdateDetailsDialog {
  String mobile;
  String email;
  FocusNode _mobileFocusNode, _emailFocusNode;
  String emailErrorString, mobileErrorString;
  TextEditingController _mobileController, _emailController;
  bool onSubmit = false;

  showRenewalUpdateDetailsDialog(
      BuildContext context,
      String mobile,
      String email,
      PersonalDetailsBloc _personalDetailsBloc,
      Function(String mobile, String email) onUpdate) {
    _personalDetailsBloc.changeMobile(mobile);
    _personalDetailsBloc.changeEmail(email);

    _mobileController = TextEditingController(
        text: !TextUtils.isEmpty(_personalDetailsBloc.mobile)
            ? _personalDetailsBloc.mobile
            : "");
    _emailController = TextEditingController(
        text: !TextUtils.isEmpty(_personalDetailsBloc.email)
            ? _personalDetailsBloc.email
            : "");

    _mobileFocusNode = FocusNode();
    _emailFocusNode = FocusNode();

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            children: <Widget>[
              _mobileWidget(_personalDetailsBloc),
              _emailWidget(_personalDetailsBloc),
              _showUpdateButton(context, _personalDetailsBloc, onUpdate),
            ],
          );
        });
  }

  _mobileWidget(PersonalDetailsBloc _personalDetailsBloc) {
    return StreamBuilder<Object>(
        stream: _personalDetailsBloc.mobileStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          mobileErrorString = null;
          bool _onSubmit = onSubmit;
          if (isError) {
            switch (snapshot.error) {
              case PersonalDetailsValidator.MOBILE_EMPTY_ERROR:
                mobileErrorString =
                    _onSubmit ? S.of(context).mobile_number_empty_error : null;
                break;
              case PersonalDetailsValidator.MOBILE_LENGTH_ERROR:
                mobileErrorString = _onSubmit
                    ? S.of(context).invalid_mobile_number_error
                    : null;
                break;
              case PersonalDetailsValidator.MOBILE_INVALID_ERROR:
                mobileErrorString = S.of(context).invalid_mobile_number_error;
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).mobile_number_title.toUpperCase(),
                  style: TextStyle(
                      fontSize: 10, color: Colors.grey[800], letterSpacing: 1),
                ),
                Theme(
                  data: ThemeData(
                      primaryColor: Colors.black,
                      accentColor: Colors.black,
                      hintColor: Colors.black),
                  child: Container(
                    child: TextFormField(
                      focusNode: _mobileFocusNode,
                      controller: _mobileController,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        _mobileFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) {
                        _personalDetailsBloc.changeMobile(value);
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
                        ),
                        errorText: mobileErrorString,
                        errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  ColorConstants.policy_type_gradient_color2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _emailWidget(PersonalDetailsBloc _personalDetailsBloc) {
    return StreamBuilder<Object>(
        stream: _personalDetailsBloc.emailStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          emailErrorString = null;
          bool _onSubmit = onSubmit;
          if (isError) {
            switch (snapshot.error) {
              case PersonalDetailsValidator.EMAIL_EMPTY_ERROR:
                emailErrorString =
                    _onSubmit ? S.of(context).email_empty_error : null;
                break;
              case PersonalDetailsValidator.EMAIL_INVALID_ERROR:
                emailErrorString =
                    _onSubmit ? S.of(context).invalid_email_error : null;
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    S.of(context).email_title.toUpperCase(),
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[800],
                        letterSpacing: 1),
                  ),
                ),
                Theme(
                  data: new ThemeData(
                      primaryColor: Colors.black,
                      accentColor: Colors.black,
                      hintColor: Colors.black),
                  child: Container(
                    child: TextField(
                      autocorrect: false,
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5),
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (value) {
                        // onClick();
                      },
                      inputFormatters: [
                        //emailTextFormatter,
                        LengthLimitingTextInputFormatter(254),
                      ],
                      onChanged: (value) {
                        _personalDetailsBloc.changeEmail(value);
                      },
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
                        ),
                        errorText: emailErrorString,
                        errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  ColorConstants.policy_type_gradient_color2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _showUpdateButton(BuildContext context,
      PersonalDetailsBloc _personalDetailsBloc, Function onUpdate) {
    onUpdateButtonClick() {
      String mobileNumber = _personalDetailsBloc.mobile;
      String emailAddress = _personalDetailsBloc.email;
      onSubmit = true;
      _personalDetailsBloc.changeMobile(mobileNumber);
      Future.delayed(Duration(milliseconds: 100), () {
        if (mobileErrorString == null) {
          _personalDetailsBloc.changeEmail(emailAddress);
          if (emailErrorString == null) {
            Navigator.of(context).pop();
            onUpdate(mobileNumber, emailAddress);
          }
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: BlackButtonWidget(
        onUpdateButtonClick,
        S.of(context).update_details_title,
        width: 100,
        height: 30,
        titleFontSize: 10.0,
      ),
    );
  }
}
