import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/insure_details/insure_details_bloc.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insure_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';



class ArogyaIndividualMemberDetailsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/arogya/arogya_inusree_member_details_screen";

  final ArogyaPremierModel arogyaPremierModel;

  ArogyaIndividualMemberDetailsScreen(this.arogyaPremierModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: InsureMemberDetailsScreenWidget(arogyaPremierModel),
      bloc: InsureeDetailsBloc(),
    );
  }
}



class InsureMemberDetailsScreenWidget extends StatefulWidget {
  final ArogyaPremierModel arogyaPremierModel;

   InsureMemberDetailsScreenWidget(this.arogyaPremierModel);

  @override
  _InsureMemberDetailsScreenState createState() =>
      _InsureMemberDetailsScreenState();
}

class _InsureMemberDetailsScreenState
    extends State<InsureMemberDetailsScreenWidget> with CommonWidget {
  InsureeDetailsBloc bloc;
  List<PolicyCoverMemberModel> policyMembers = [];
  PolicyCoverMemberModel policyCoverMemberModel;

  static MemberDetailsModel memberDetailsModel;
  bool isAddButtonClicked = false;
  String errorText;
  TextEditingController firstNameController,
      lastNameController;
  bool isMarried;
  bool isMaritalStatusFixed;
  int age;
  String dob;
  bool autofocus;
  double deviceWidth;
  ScrollController _controller;

  FocusNode _firstNameFocusNode,
      _lastNameFocusNode;

  @override
  void initState() {
    bloc = SbiBlocProvider.of<InsureeDetailsBloc>(context);

    policyMembers = widget.arogyaPremierModel.policyMembers;
    if(policyMembers.length == 1){
      memberDetailsModel = widget.arogyaPremierModel.policyMembers[0].memberDetailsModel;
    }
    age = memberDetailsModel.ageGenderModel.age;
    _controller = ScrollController();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();


    firstNameController = TextEditingController(
        text: !TextUtils.isEmpty(bloc.firstName) ? bloc.firstName : null);
    lastNameController = TextEditingController(
        text: !TextUtils.isEmpty(bloc.lastName) ? bloc.lastName : null);

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
          if ((_firstNameFocusNode.hasFocus || _lastNameFocusNode.hasFocus)) {
            offset = 100;
          }
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
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(
          context,
          S.of(context).insured_details.toUpperCase(),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                // shrinkWrap:true,
                controller: _controller,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0, bottom: 12.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                                height: 30,
                                width: 30,
                                child:(memberDetailsModel.icon.contains('assets')||memberDetailsModel.icon.length==0 )? Image.asset(AssetConstants.ic_self): Image(image: NetworkImage(UrlConstants.ICON +memberDetailsModel.icon),)),
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
                          height: 40.0,
                        ),
                        maritalStatus(),
                        SizedBox(
                          height: 5.0,
                        ),
                        fullNameWidget(autofocus),
                        SizedBox(
                          height: 5.0,
                        ),
                        calenderWidget(),
                        SizedBox(
                          height: 30.0,
                        ),
                        /*StreamBuilder<String>(
                            stream: bloc.errorStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data,
                                  textAlign: TextAlign.center,
                                  style: (TextStyle(
                                      color: Colors.red, fontSize: 12)),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                );
                              }
                            }),*/
                        SizedBox(
                          height: 180,
                        ),
                      ],
                    ),
                  ),
                ],
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
                Container(
                  height: 40,
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
                                ColorConstants
                                    .policy_type_gradient_color1,
                                ColorConstants.policy_type_gradient_color2
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
                                ColorConstants
                                    .policy_type_gradient_color1,
                                ColorConstants.policy_type_gradient_color2
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
                                color: ColorConstants.error_red, fontSize: 12,fontStyle: FontStyle.normal)),
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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.grey[600],fontSize: 12,letterSpacing: 0.5),
                          labelText: S.of(context).first_name_title.toUpperCase(),
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
                                color: firstNameError.isNotEmpty
                                    ? Colors.red
                                    : _firstNameFocusNode.hasFocus
                                    ? ColorConstants
                                    .policy_type_gradient_color2
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0,left: 0.0),
                        child: Text(
                          firstNameError,
                          style: TextStyle(color: Colors.red, fontSize: 12),
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
                        },
                        onChanged: (value) {
                          bloc.changeLastName(value);
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                          LengthLimitingTextInputFormatter(100),
                        ],
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontStyle: FontStyle.normal, color: Colors.grey[600],fontSize: 12,letterSpacing: 0.5),
                          labelText: S.of(context).last_name_title.toUpperCase(),
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
                                color:lastNameError.isNotEmpty
                                    ? Colors.red
                                    : _lastNameFocusNode.hasFocus
                                    ? ColorConstants
                                    .policy_type_gradient_color2
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          lastNameError,
                          style: TextStyle(color: Colors.red, fontSize: 12),
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
        CalenderWidget(
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


  Widget _showAddDetailsButton() {
    onClick() {
      isAddButtonClicked = true;

      if (bloc.martialStatus == null) {
        errorText = S.of(context).enter_marital_status_error;
        bloc.changeError(errorText);
      } else {
        bloc.changeFirstName(bloc.firstName);

        Future.delayed(Duration(milliseconds: 200), () {
          if (errorText == null) {
            bloc.changeLastName(bloc.lastName);

            Future.delayed(Duration(milliseconds: 200), () {
              if (errorText == null) {
                if (null == memberDetailsModel.ageGenderModel.dob) {
                  errorText = S.of(context).dob_error;
                  bloc.changeError(errorText);
                } else {
                  Future.delayed(Duration(milliseconds: 200), () {
                    if (errorText == null) {
                      memberDetailsModel.firstName = bloc.firstName;
                      memberDetailsModel.lastName = bloc.lastName;
                      memberDetailsModel.isMarried=bloc.martialStatus;

                      widget.arogyaPremierModel.policyMembers[0].memberDetailsModel= memberDetailsModel;
                      Navigator.of(context).pushNamed(
                          ArogyaInsureDetailsScreen.ROUTE_NAME,
                          arguments: widget.arogyaPremierModel);
                    }
                  });
                }
              }
            });
          }
        });
      }
    }

    return BlackButtonWidget(
      onClick,
      S.of(context).save_details.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );
  }

  onDateSelection(DateTime newDateTime,InsureeDetailsBloc bloc) {
    if (newDateTime == null) {
      errorText = null;
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
    _lastNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    firstNameController.dispose();
    lastNameController.dispose();

    super.dispose();
  }
}
