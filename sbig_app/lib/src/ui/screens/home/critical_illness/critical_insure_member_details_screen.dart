import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/insure_details/insure_details_bloc.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import 'calendar_widget_critical.dart';
import 'critical_insure_details_screen.dart';

class CriticalInsureMemberDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME =
      "/critical_illness/critical_inusree_member_details_screen";

  final CriticalIllnessModel criticalIllnessModel;

  CriticalInsureMemberDetailsScreen(this.criticalIllnessModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: CriticalInsureMemberDetailsScreenWidget(criticalIllnessModel),
      bloc: CriticalInsureDetailsBloc(),
    );
  }
}

class CriticalInsureMemberDetailsScreenWidget extends StatefulWidget {
  final CriticalIllnessModel criticalIllnessModel;

  const CriticalInsureMemberDetailsScreenWidget(this.criticalIllnessModel);

  @override
  _CriticalInsureMemberDetailsScreenState createState() =>
      _CriticalInsureMemberDetailsScreenState();
}

class _CriticalInsureMemberDetailsScreenState
    extends State<CriticalInsureMemberDetailsScreenWidget> with CommonWidget {
  CriticalInsureDetailsBloc bloc;
  List<PolicyCoverMemberModel> policyMembers = [];
  PolicyCoverMemberModel policyCoverMemberModel;

  static MemberDetailsModel memberDetailsModel;
  bool isAddButtonClicked = false;
  String errorText;
  TextEditingController firstNameController,
      lastNameController,
      heightInchController,
      heightFeetController,
      weightController;

  bool isMarried;
  bool isMaritalStatusFixed;
  int age;
  String dob;
  bool autofocus;
  double deviceWidth;
  ScrollController _controller;

  FocusNode _firstNameFocusNode,
      _lastNameFocusNode,
      _heightInchFocusNode,
      _heightFeetFocusNode,
      _weightFocusNode;


  @override
  void initState() {
    bloc = SbiBlocProvider.of<CriticalInsureDetailsBloc>(context);
    policyCoverMemberModel = widget.criticalIllnessModel.policyCoverMemberModel;
    policyMembers.add(widget.criticalIllnessModel.policyCoverMemberModel);
    memberDetailsModel =
        widget.criticalIllnessModel.policyCoverMemberModel.memberDetailsModel;
    age = memberDetailsModel.ageGenderModel.age;
    _controller = ScrollController();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _heightFeetFocusNode = FocusNode();
    _heightInchFocusNode = FocusNode();
    _weightFocusNode = FocusNode();

    firstNameController = TextEditingController(text: !TextUtils.isEmpty(bloc.firstName) ? bloc.firstName : null);
    lastNameController = TextEditingController(text: !TextUtils.isEmpty(bloc.lastName) ? bloc.lastName : null);
    heightFeetController = TextEditingController(text: (bloc.heightFeet != null && bloc.heightFeet != -1) ? bloc.heightFeet.toString() : null);
    heightInchController = TextEditingController(text: (bloc.heightInch != null && bloc.heightInch != -1)? bloc.heightInch.toString(): null);
    weightController = TextEditingController(text: (bloc.weight != null && bloc.weight != -1) ? bloc.weight.toString() : null);

    isMarried = memberDetailsModel.isMarried;
    isMaritalStatusFixed = memberDetailsModel.maritalStatusIsFixed;

    bloc.changeMartialStatus(isMarried);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    deviceWidth = ScreenUtil.getInstance(context).screenWidthDp;
    autofocus = false;

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          double offset = 0;
          if ((_firstNameFocusNode.hasFocus)) {
            offset = 100;
          } else if (_heightFeetFocusNode.hasFocus|| _heightInchFocusNode.hasFocus) {
            offset = 170;
          } else if (_weightFocusNode.hasFocus) {
            offset = 190;
          } /*else if (locationFocusNode.hasFocus) {
            offset = 190;
          }*/
          _controller.animateTo(
            _controller.offset + offset,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        } else {
          _controller.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(
          context,
          S.of(context).insured_details.toUpperCase(),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: _controller,
                child:   Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 15.0, bottom: 12.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                              height: 30,
                              width: 30,
                              child: (memberDetailsModel.icon
                                  .contains('assets') ||
                                  memberDetailsModel.icon.length == 0)
                                  ? Image.asset(AssetConstants.ic_self)
                                  : Image(
                                image: NetworkImage(UrlConstants.ICON +
                                    memberDetailsModel.icon),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            memberDetailsModel.relation +
                                ' ' +
                                S.of(context).details,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      maritalStatus(),
                      fullNameWidget(autofocus),
                      SizedBox(height: 5.0,),
                      calenderWidget(),
                      SizedBox(height: 5.0,),
                      heightWidget(),
                      SizedBox(height: 5.0,),
                      weightWidget(),
                      SizedBox(height: 300,),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: _showAddDetailsButton()),
            ],
          ),
        ));
  }

  Widget maritalStatus() {
    return StreamBuilder<bool>(
        stream: bloc.maritalStatusStream,
        builder: (context, snapshot) {
          bool isMarried = bloc.martialStatus;

          if (isMaritalStatusFixed != null) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorConstants.east_bay,
                            ColorConstants.disco,
                            ColorConstants.disco
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
                  ),
                )
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 40,
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
                                    ColorConstants.east_bay,
                                    ColorConstants.disco,
                                    ColorConstants.disco
                                    ])
                              : null,
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            /// CriticalInsureMemberDetailsScreen.memberDetailsModel.isMarried = true;
                            bloc.changeMartialStatus(true);
                            bloc.changeError("");
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
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
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
                                    ColorConstants.east_bay,
                                    ColorConstants.disco,
                                    ColorConstants.disco
                                    ])
                              : null,
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            ///  CriticalInsureMemberDetailsScreen.memberDetailsModel.isMarried = false;
                            bloc.changeMartialStatus(false);
                            bloc.changeError("");
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
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                StreamBuilder<String>(
                    stream: bloc.errorStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: ScreenUtil.instance.screenWidthDp,
                          child: Text(
                            (snapshot.data.compareTo(S
                                        .of(context)
                                        .enter_marital_status_error) ==
                                    0)
                                ? snapshot.data
                                : "",
                            //textAlign: TextAlign.center,
                            style: (TextStyle(
                                color: ColorConstants.disco, fontSize: 12,fontStyle: FontStyle.normal)),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                        );
                      }
                    }),
              ],
            );
          }
        });
  }

  Widget fullNameWidget(bool autofocus) {
    String firstNameError="";
    String lastNameError="";
    return Row(
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
                        firstNameError = S.of(context).first_name_empty;
                        errorText = S.of(context).first_name_empty;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        firstNameError = S.of(context).first_name_invalid;
                        errorText = S.of(context).first_name_invalid;
                        break;
                    }
                  } else {
                    firstNameError = "";
                    errorText = null;
                  }
                  bloc.changeError(errorText);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: firstNameController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                          LengthLimitingTextInputFormatter(100),
                        ],
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.grey[600],fontSize: 12,letterSpacing: 0.5),
                          labelText: S.of(context).first_name_title.toUpperCase(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.shiraz),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: firstNameError.isNotEmpty
                                    ? ColorConstants.shiraz
                                    : _firstNameFocusNode.hasFocus
                                    ? ColorConstants
                                    .fuchsia_pink
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0,left: 0.0),
                        child: Text(
                          firstNameError,
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
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
                        lastNameError = S.of(context).last_name_empty;
                        errorText = S.of(context).last_name_empty;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        lastNameError = S.of(context).last_name_invalid;
                        errorText = S.of(context).last_name_invalid;
                        break;
                    }
                  } else {
                    lastNameError = "";
                    errorText = null;
                  }
                  bloc.changeError(errorText);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: lastNameController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        autofocus: autofocus,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _lastNameFocusNode,
                        onFieldSubmitted: (term) {
                          _lastNameFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_heightFeetFocusNode);
                        },
                        onChanged: (value) {
                          bloc.changeLastName(value);
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                          LengthLimitingTextInputFormatter(100),
                        ],
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.grey[600],fontSize: 12,letterSpacing: 0.5),
                          labelText: S.of(context).last_name_title.toUpperCase(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.shiraz),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:lastNameError.isNotEmpty
                                    ? ColorConstants.shiraz
                                    : _lastNameFocusNode.hasFocus
                                    ? ColorConstants
                                    .fuchsia_pink
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          lastNameError,
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget calenderWidget() {
    bool isAdult = true;
    if (memberDetailsModel.relation.startsWith("Child")) {
      isAdult = false;
    }
    return Column(
      children: <Widget>[
        CriticalCalenderWidget(
          bloc,
          onDateSelection,
          age: age,
          dob: memberDetailsModel.ageGenderModel.dob,
          height: 50.0,
          isAdult: isAdult,
        ),
        SizedBox(height: 10.0,),
        StreamBuilder<String>(
            stream: bloc.errorStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  width: ScreenUtil.instance.screenWidthDp,
                  child: Text(
                    (snapshot.data.compareTo(S
                        .of(context)
                        .dob_error) ==
                        0)
                        ? snapshot.data
                        : "",
                    //textAlign: TextAlign.center,
                    style: (TextStyle(
                        color: ColorConstants.error_red, fontSize: 12)),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                );
              }
            }),
      ],
    );
  }

  Widget heightWidget() {
    String feetError="";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text(
            S.of(context).height.toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.0,
                fontStyle: FontStyle.normal,
                color: Colors.grey[600]),
          ),
        ),
        SizedBox(
          width: 30.0,
        ),
        Theme(
          data: new ThemeData(
              primaryColor: Colors.black,
              accentColor: Colors.black,
              hintColor: Colors.black),
          child: Expanded(
            child: StreamBuilder<int>(
                stream: bloc.heightFeetStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError && isAddButtonClicked) {
                    switch (snapshot.error) {
                      case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                        feetError = S.of(context).height_empty;
                        errorText = S.of(context).height_empty;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        feetError = S.of(context).height_empty;
                        errorText = S.of(context).height_empty;
                        break;
                    }
                  } else {
                    feetError = "";
                    errorText = null;
                  }
                  bloc.changeError(errorText);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        enableInteractiveSelection: false,
                        controller: heightFeetController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        //autofocus: autofocus,
                        keyboardType: Platform.isIOS ? TextInputType.numberWithOptions(signed: true, decimal: true) : TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _heightFeetFocusNode,
                        onFieldSubmitted: (term) {
                          _heightFeetFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_heightInchFocusNode);
                        },
                        onChanged: (value) {
                          if(value != null && value.length !=0 ){
                            bloc.changeHeightfFeet( int.parse(value));
                          }else{
                            bloc.changeHeightfFeet(-1);
                          }
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],

                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.5,
                              color: Colors.grey[600]),
                          labelText: '(' + S.of(context).feet + ')',
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.shiraz),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: feetError.isNotEmpty
                                    ? ColorConstants.shiraz
                                    : _heightFeetFocusNode.hasFocus
                                    ? ColorConstants
                                    .fuchsia_pink
                                    : Colors.grey),
                          ),

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          feetError,
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
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
            child: StreamBuilder<int>(
                stream: bloc.heightInchStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError && isAddButtonClicked) {
                    switch (snapshot.error) {
                      case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                        errorText = S.of(context).height_empty;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        errorText = S.of(context).height_empty;
                        break;
                    }
                  } else {
                    errorText = null;
                  }
                  bloc.changeError(errorText);

                  return Column(
                    children: <Widget>[
                      TextFormField(
                        enableInteractiveSelection: false,
                        controller: heightInchController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        // autofocus: autofocus,
                        keyboardType: Platform.isIOS ? TextInputType.numberWithOptions(signed: true, decimal: true) : TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _heightInchFocusNode,
                        onFieldSubmitted: (term) {
                          _heightInchFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_weightFocusNode);
                        },
                        onChanged: (value) {
                          if(value != null && value.length !=0 ){
                            bloc.changeHeightInch( int.parse(value));
                          }else{
                            bloc.changeHeightInch(-1);
                          }
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0.5,
                              color: Colors.grey[600]),
                          labelText: '(' + S.of(context).inch + ')',
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.shiraz),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: ColorConstants.fuchsia_pink
                                //errorText != null ? Colors.red : ColorConstants.policy_type_gradient_color2
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          "",
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget weightWidget() {
    String weightError="";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Theme(
          data: new ThemeData(
              primaryColor: Colors.black,
              accentColor: Colors.black,
              hintColor: Colors.black),
          child: Expanded(
            child: StreamBuilder<int>(
                stream: bloc.weightStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError && isAddButtonClicked) {
                    switch (snapshot.error) {
                      case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                        weightError = S.of(context).weight_empty;
                        errorText = S.of(context).weight_empty;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        weightError = S.of(context).weight_valid;
                        errorText = S.of(context).weight_valid;
                        break;
                    }
                  } else {
                    weightError = "";
                    errorText = null;
                  }
                  bloc.changeError(errorText);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        enableInteractiveSelection: false,
                        controller: weightController,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        // autofocus: autofocus,
                        keyboardType: Platform.isIOS ? TextInputType.numberWithOptions(signed: true, decimal: true) : TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: _weightFocusNode,
                        onFieldSubmitted: (term) {
                          //_firstNameFocusNode.unfocus();
                          // FocusScope.of(context).requestFocus(_lastNameFocusNode);
                        },
                        onChanged: (value) {
                          if(value != null && value.length !=0 ){
                            bloc.changeWeight( int.parse(value));
                          }else{
                            bloc.changeWeight(-1);
                          }

                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.grey[600],fontSize: 12,letterSpacing: 1),
                          labelText: S.of(context).weight.toUpperCase(),
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[500]),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: ColorConstants.shiraz),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: weightError.isNotEmpty
                                    ? ColorConstants.shiraz
                                    : _weightFocusNode.hasFocus
                                    ? ColorConstants
                                    .fuchsia_pink
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          weightError,
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
                  );
                }),
          ),
        ),
      ],
    );
  }

  Widget _showAddDetailsButton() {
    onClick() {
      isAddButtonClicked=true;
      if (bloc.martialStatus == null) {
        errorText = S.of(context).enter_marital_status_error;
        bloc.changeError(errorText);
      } else {
        if(TextUtils.isEmpty(bloc.firstName)|| bloc.firstName.length == 1){
          bloc.changeFirstName(bloc.firstName);
        }else if(TextUtils.isEmpty(bloc.lastName)|| bloc.lastName.length == 1){
          bloc.changeLastName(bloc.lastName);
        }else if(null == memberDetailsModel.ageGenderModel.dob){
          errorText = S.of(context).dob_error;
          bloc.changeError(errorText);
        }else if (TextUtils.isEmpty(bloc.heightFeet.toString() ??'')|| bloc.heightFeet.toString() =='-1'){
          bloc.changeHeightfFeet(bloc.heightFeet);
        }else if(TextUtils.isEmpty(bloc.weight.toString()??'') || bloc.weight.toString()=='-1'){
          bloc.changeWeight(bloc.weight);
        }else{
          memberDetailsModel.firstName = bloc.firstName;
          memberDetailsModel.lastName = bloc.lastName;
          memberDetailsModel.heightInFeet = bloc.heightFeet;
          memberDetailsModel.heightInInch = bloc.heightInch;
          memberDetailsModel.weight = bloc.weight;
          memberDetailsModel.isMarried = bloc.martialStatus;

          widget.criticalIllnessModel.policyCoverMemberModel
              .memberDetailsModel = memberDetailsModel;
          Navigator.of(context).pushNamed(
              CriticalInsureDetailsScreen.ROUTE_NAME,
              arguments: widget.criticalIllnessModel);
        }

      }
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).save_details.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );
  }

  onDateSelection(DateTime newDateTime) {
    if (newDateTime == null) {
      errorText=null;
    } else {
      print(newDateTime.toString());
      String dob = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
      memberDetailsModel.ageGenderModel.dob = dob;
      memberDetailsModel.ageGenderModel.dateTime = newDateTime;
      memberDetailsModel.ageGenderModel.dob_yyyy_mm_dd =
          CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
      bloc.changeDob(dob);
      bloc.changeError('');
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    _controller.dispose();
    _heightInchFocusNode.dispose();
    _heightFeetFocusNode.dispose();
    _weightFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    heightInchController.dispose();
    heightFeetController.dispose();
    weightController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }
}
