import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';

class InsureeDetailsDialog {
  static MemberDetailsModel memberDetailsModel;
  bool isAddButtonClicked = false;
  String errorText;
  TextEditingController firstNameController, lastNameController;
  bool isMarried;
  bool isMaritalStatusFixed;

  FocusNode _firstNameFocusNode, _lastNameFocusNode;

  showInsureeDetailsDialog(
      BuildContext context,
      InsureeDetailsBloc bloc,
      MemberDetailsModel memberDetailsModel,
      Function(MemberDetailsModel) onUpdate) {
    InsureeDetailsDialog.memberDetailsModel = memberDetailsModel;
    bool autofocus = TextUtils.isEmpty(memberDetailsModel.firstName);
    firstNameController = TextEditingController(
        text: !TextUtils.isEmpty(bloc.firstName) ? bloc.firstName : null);
    lastNameController = TextEditingController(
        text: !TextUtils.isEmpty(bloc.lastName) ? bloc.lastName : null);

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();

    isMarried = memberDetailsModel.isMarried;
    isMaritalStatusFixed = memberDetailsModel.maritalStatusIsFixed;

    bloc.changeMartialStatus(isMarried);

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            contentPadding: EdgeInsets.all(0.0),
            children: <Widget>[
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: ColorConstants.arogya_plus_quote_number_color,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(memberDetailsModel.icon)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        memberDetailsModel.relation,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              _maritalStatus(context, bloc),
              _fullNameWidget(context, bloc, autofocus),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 8.0),
                child: _calenderWidget(
                  context,
                  bloc,
                  memberDetailsModel.ageGenderModel.age,
                ),
              ),
              StreamBuilder<String>(
                  stream: bloc.errorStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(
                           top: 5.0),
                        child: Text(
                          snapshot.data,
                          textAlign: TextAlign.center,
                          style: (TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500)),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                      );
                    }
                  }),
              _showAddDetailsButton(
                context,
                autofocus
                    ? S.of(context).save_details.toUpperCase()
                    : S.of(context).update_details_title.toUpperCase(),
                onUpdate,
                bloc,
              )
            ],
          );
        });
  }

  _maritalStatus(BuildContext context, InsureeDetailsBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0, bottom: 12.0),
      child: StreamBuilder<bool>(
          stream: bloc.maritalStatusStream,
          builder: (context, snapshot) {
            bool isMarried = bloc.martialStatus;

            if (isMaritalStatusFixed != null) {
              return Row(
                children: <Widget>[
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorConstants.policy_type_gradient_color1,
                            ColorConstants.policy_type_gradient_color2
                          ]),
                    ),
                    child: MaterialButton(
                      onPressed: null,
                      child: Text(
                        isMarried
                            ? S.of(context).married_title
                            : S.of(context).unmarried_title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      border: (isMarried == null || !isMarried)
                          ? Border.all(color: Colors.grey[500])
                          : null,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: (isMarried != null && isMarried)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.policy_type_gradient_color1,
                                  ColorConstants.policy_type_gradient_color2
                                ])
                          : null,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        InsureeDetailsDialog.memberDetailsModel.isMarried =
                            true;
                        bloc.changeMartialStatus(true);
                      },
                      child: Text(
                        S.of(context).married_title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: (isMarried != null && isMarried)
                                ? Colors.white
                                : Colors.grey[500]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 25,
                    decoration: BoxDecoration(
                      border: (isMarried == null || isMarried)
                          ? Border.all(color: Colors.grey[500])
                          : null,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: (isMarried != null && !isMarried)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.policy_type_gradient_color1,
                                  ColorConstants.policy_type_gradient_color2
                                ])
                          : null,
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        InsureeDetailsDialog.memberDetailsModel.isMarried =
                            false;
                        bloc.changeMartialStatus(false);
                      },
                      child: Text(
                        S.of(context).unmarried_title,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: (isMarried != null && !isMarried)
                                ? Colors.white
                                : Colors.grey[500]),
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  _fullNameWidget(
      BuildContext context, InsureeDetailsBloc bloc, bool autofocus) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: Expanded(
              child: StreamBuilder<String>(
                  stream: bloc.firstNameStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && isAddButtonClicked) {
                      switch (snapshot.error) {
                        case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                          errorText = S.of(context).first_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          errorText = S.of(context).first_name_invalid;
                          break;
                      }
                    } else {
                      errorText = null;
                    }
                    bloc.changeError(errorText);

                    return TextFormField(
                      controller: firstNameController,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      autofocus: autofocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: _firstNameFocusNode,
                      onFieldSubmitted: (term) {
                        _firstNameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      onChanged: (value) {
                        bloc.changeFirstName(value);
                      },
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600]),
                        labelText: S.of(context).first_name_title,
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
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
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: Expanded(
              child: StreamBuilder<String>(
                  stream: bloc.lastNameStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && isAddButtonClicked) {
                      switch (snapshot.error) {
                        case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                          errorText = S.of(context).last_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          errorText = S.of(context).last_name_invalid;
                          break;
                      }
                    } else {
                      errorText = null;
                    }
                    bloc.changeError(errorText);

                    return TextFormField(
                      controller: lastNameController,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      autofocus: autofocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _lastNameFocusNode,
                      onChanged: (value) {
                        bloc.changeLastName(value);
                      },
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[600]),
                        labelText: S.of(context).last_name_title,
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]),
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
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  _calenderWidget(BuildContext context, InsureeDetailsBloc bloc, int age) {
    bool isAdult = true;
    if(memberDetailsModel.relation.startsWith("Child")){
      isAdult = false;
    }
    return CalenderWidget(bloc, onDateSelection,
        age: age, dob: memberDetailsModel.ageGenderModel.dob, isAdult: isAdult,);
  }

  Widget _showAddDetailsButton(BuildContext context, String title,
      Function(MemberDetailsModel) onUpdate, InsureeDetailsBloc bloc) {
    onClick() {
      isAddButtonClicked = true;

      if(bloc.martialStatus == null){
        errorText = S.of(context).enter_marital_status_error;
        bloc.changeError(errorText);
      }else {
        bloc.changeFirstName(bloc.firstName);

        Future.delayed(Duration(milliseconds: 200), () {
          if (errorText == null) {
            bloc.changeLastName(bloc.lastName);

            Future.delayed(Duration(milliseconds: 200), () {
              if (errorText == null) {
                if (null == memberDetailsModel.ageGenderModel.dob) {
                  errorText = S
                      .of(context)
                      .dob_error;
                  bloc.changeError(errorText);
                } else {
                  memberDetailsModel.firstName = bloc.firstName;
                  memberDetailsModel.lastName = bloc.lastName;
                  onUpdate(InsureeDetailsDialog.memberDetailsModel);
                  Navigator.of(context).pop();
                }
              }
            });
          }
        });
      }
    }

    return Column(
      children: <Widget>[
        BlackButtonWidget(
          onClick,
          title,
          padding: EdgeInsets.only(bottom: 15.0),
          width: 100,
          height: 30,
          titleFontSize: 10.0,
        ),
      ],
    );
  }

  onDateSelection(DateTime newDateTime, InsureeDetailsBloc bloc) {
    if (newDateTime == null) {
      errorText = null;
    } else {
      print(newDateTime.toString());
      String day = newDateTime.day.toString();
      String month = newDateTime.month.toString();
      String year = newDateTime.year.toString();
      //String dob = '$day/$month/$year';
      String dob = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
      memberDetailsModel.ageGenderModel.dob = dob;
      memberDetailsModel.ageGenderModel.dateTime = newDateTime;
      //memberDetailsModel.ageGenderModel.dob_yyyy_mm_dd = "$year-$month-$day";
      memberDetailsModel.ageGenderModel.dob_yyyy_mm_dd = CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
      bloc.changeDob(dob);
    }
  }
}
