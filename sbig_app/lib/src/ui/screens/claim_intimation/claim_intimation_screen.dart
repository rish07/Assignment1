import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/controllers/service/call_sms_mail_service.dart';
import 'package:sbig_app/src/controllers/service/service_locator.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/claim/claim_service_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dotted_line_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ClaimIntimationScreen extends StatelessWidget {
  static const ROUTE_NAME = "/claim_intimation/claim_intimation_screen";

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: ClaimIntimationScreenWidget(),
      bloc: ClaimIntimationBloc(),
    );
  }
}

class ClaimIntimationScreenWidget extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ClaimIntimationScreenWidget> with CommonWidget {
  ClaimIntimationBloc _claimIntimationBloc;
  final Service _service = getIt<Service>();
  ServiceModel callServiceModel, messageServiceModel, emailServiceModel;
  bool onSubmit = false, firstNameError = false, lastNameError = false,isKeyboardVisible=false;
  String errorText;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  double screenWidth;
  double screenHeight;
  ScrollController _controller;
  FocusNode _firstNameFocusNode, _lastNameFocusNode;

  @override
  void initState() {
    _claimIntimationBloc = SbiBlocProvider.of<ClaimIntimationBloc>(context);
    _controller=ScrollController();
    _firstNameFocusNode=FocusNode();
    _lastNameFocusNode=FocusNode();
//    KeyboardVisibilityNotification().addNewListener(
//      onChange: (bool visible) {
//        if (visible) {
//          _moveDown();
//        }
//      },
//    );
    super.initState();
  }

  @override
  void dispose() {
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    _claimIntimationBloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    callServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_call.toUpperCase(),
        subTitle: S.of(context).claim_intimation_call_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mobile,
        color1: ColorConstants.claim_intimation_call_color1,
        color2: ColorConstants.claim_intimation_call_color2);

    messageServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_message.toUpperCase(),
        subTitle: S.of(context).claim_intimation_message_no,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_group,
        color1: ColorConstants.claim_intimation_message_color1,
        color2: ColorConstants.claim_intimation_message_color2);

    emailServiceModel = ServiceModel(
        title: S.of(context).claim_intimation_email.toUpperCase(),
        subTitle: S.of(context).claim_intimation_email_address,
        isSubTitleRequired: true,
        points: [],
        icon: AssetConstants.ic_mail,
        color1: ColorConstants.claim_intimation_email_color1,
        color2: ColorConstants.claim_intimation_email_color2);

    super.didChangeDependencies();
  }

//  _moveDown() {
//    _controller.animateTo(0.0, curve: Curves.easeOut, duration: Duration(milliseconds: 300));
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.claim_intimation_bg_color,
        appBar: getAppBar(
            context, S.of(context).claim_intimation_title.toUpperCase()),
        body: SafeArea(
            child: Stack(
              children: <Widget>[
                ListView(
                  controller: _controller,
                  shrinkWrap: true,
                  reverse: true,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              S.of(context).claim_initiate,
                              style: TextStyle(
                                  letterSpacing: 0.25,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 18.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: InkWell(
                                      child: ConnectWithUsWidget(callServiceModel),
                                      onTap: () {
                                        _service
                                            .call(S.of(context).claim_intimation_call_no);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      child: ConnectWithUsWidget(messageServiceModel),
                                      onTap: () {
                                        _service.sendSMS(
                                            S.of(context).claim.toUpperCase(),
                                            [S.of(context).claim_intimation_message_no]);
                                      },
                                    ),
                                  ),
                                ],

                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    _service.sendEmail(
                                        S.of(context).claim_intimation_email_address);
                                  },
                                  child: ConnectWithUsWidget(emailServiceModel, 2)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: new Container(
                                  child: DottedLineWidget(
                                      color: ColorConstants.claim_dot_color)),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                S.of(context).or.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: new Container(
                                  child: DottedLineWidget(
                                      color: ColorConstants.claim_dot_color)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            S.of(context).claim_form,
                            style: TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) - 40,
                                child: firstNameField(),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) - 20,
                                child: lastNameField(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                            stream: _claimIntimationBloc.errorStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Container(
                                        child: Center(
                                          child: Text(snapshot.data,
                                              textAlign: TextAlign.center,
                                              style: (TextStyle(
                                                  color: Colors.red, fontSize: 10))),
                                        )));
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                );
                              }
                            }),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ],
                ),
                Align(alignment:Alignment.bottomCenter,child: _showNextButton()),
                //  Align(alignment:Alignment.bottomCenter,child: _showNextButton()),

              ],
            )));
  }

  Widget firstNameField() {
    return StreamBuilder(
      stream: _claimIntimationBloc.firstNameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError && onSubmit == true && firstNameError == true) {
          if(snapshot.error == ClaimIntimationValidator.EMPTY_ERROR){
            errorText = S.of(context).first_name_empty;
          }
        } else {
          errorText = null;
        }
        _claimIntimationBloc.changeError(errorText);
        return Theme(
          data: new ThemeData(
            primaryColor: ColorConstants.text_field_blue,
            primaryColorDark: ColorConstants.claim_remark_color,
            accentColor: ColorConstants.claim_remark_color,
          ),
          child: TextField(
            controller: firstNameController,
            textInputAction: TextInputAction.next,
            focusNode: _firstNameFocusNode,
            onSubmitted: (value){
              if (value==null || value.trim().length == 0) {
                _claimIntimationBloc.changeFirstName(value);
                firstNameError = true;
              }else{
                lastNameError=true;
                Future.delayed(Duration(milliseconds: 200), () {
                  try {
                    FocusScope.of(context).requestFocus(_lastNameFocusNode);
                  } catch (e) {}
                });
              }
            },
            onChanged: (String value) {
              _claimIntimationBloc.changeFirstName(value);
            },
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
              LengthLimitingTextInputFormatter(50),
            ],
            style: const TextStyle(
                letterSpacing: 1.0,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 22.0),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: errorText != null
                          ? Colors.red
                          : ColorConstants.policy_type_gradient_color2),
                ),
                // errorText: error,
                labelText: S.of(context).claim_first_name_title.toUpperCase(),
                labelStyle: TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    color: Colors.black54)),
          ),
        );
      },
    );
  }

  Widget lastNameField() {
    return StreamBuilder(
      stream: _claimIntimationBloc.lastNameStream,
      builder: (context, snapshot) {
        if (snapshot.hasError && onSubmit == true && lastNameError == true) {
          if(snapshot.error == ClaimIntimationValidator.EMPTY_ERROR){
            errorText = S.of(context).last_name_empty;
          }
        } else {
          errorText = null;
        }
        _claimIntimationBloc.changeError(errorText);
        return Theme(
          data: new ThemeData(
            primaryColor: ColorConstants.text_field_blue,
            primaryColorDark: ColorConstants.claim_remark_color,
            accentColor: ColorConstants.claim_remark_color,
          ),
          child: TextField(
            controller: lastNameController,
            textInputAction: TextInputAction.next,
            focusNode: _lastNameFocusNode,
            onSubmitted: (value){
             // _claimIntimationBloc.changeLastName(value);
             onClick();
            },
            onChanged: (String value) {
              _claimIntimationBloc.changeLastName(value);
            },
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
              LengthLimitingTextInputFormatter(50),
            ],
            style: const TextStyle(
                color: Colors.black,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
                fontSize: 22.0),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: errorText != null
                          ? Colors.red
                          : ColorConstants.policy_type_gradient_color2),
                ),
                labelText: S.of(context).claim_last_name_title.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.normal,
                    color: Colors.black54)),
          ),
        );
      },
    );
  }

  onClick() {

    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    if (firstName==null || firstName.trim().length == 0) {
      _claimIntimationBloc.changeFirstName(firstName);
      firstNameError = true;
    }else if((lastName == null || lastName.trim().length == 0 ) && !lastNameError){
      lastNameError=true;
      Future.delayed(Duration(milliseconds: 200), () {
        try {
          FocusScope.of(context).requestFocus(_lastNameFocusNode);
        } catch (e) {}
      });
    }
    else if (lastName == null || lastName.trim().length == 0) {
      _claimIntimationBloc.changeLastName(lastName);
      lastNameError = true;

    } else {

      if(Platform.isIOS) {
        //prevent keyboard opening issue during popUntil
        _firstNameFocusNode = FocusNode();
        _lastNameFocusNode = FocusNode();
      }

      Future.delayed(Duration(milliseconds: 200), (){
        ClaimIntimationRequestModel responseModel = ClaimIntimationRequestModel(
            firstName: firstName, lastName: lastName);
        Navigator.of(context).pushNamed(PersonalDetailsScreen.ROUTE_NAME,
            arguments: PersonalDetailsArguments(
                StringConstants.FROM_CLAIM_INTIMATION, responseModel));
      });
    }
  }

  Widget _showNextButton() {
    onSubmit = true;
    return BlackButtonWidget(
      onClick, S.of(context).claim_next_button.toUpperCase(), bottomBgColor: ColorConstants.claim_intimation_bg_color,);
  }
}
