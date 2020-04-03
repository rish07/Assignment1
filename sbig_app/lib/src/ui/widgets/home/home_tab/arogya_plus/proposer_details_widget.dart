import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/nominee_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_bloc_based_widget.dart';

import '../../../statefulwidget_base.dart';
import '../../quick_fact_widget.dart';

class ProposerDetailsWidget extends StatelessWidget {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  ProposerDetailsModel proposerDetailsModel;
  bool isProposerEditable;
  int isFrom;
  String quickFact;
  static const int YES_BUTTON_VALUE=1;
  static const int NO_BUTTON_VALUE=2;


  ProposerDetailsWidget(this.widgetListener,
      this.buyerDetailsController, this.controller, this.proposerDetailsModel, this.isProposerEditable,{this.isFrom=StringConstants.FROM_AROGYA_PLUS,this.quickFact});

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: ProposerDetailsPage(widgetListener, buyerDetailsController,
          controller, proposerDetailsModel, isProposerEditable,isFrom: isFrom,quickFact: quickFact,),
      bloc: NomineeDetailsBloc(),
    );
  }
}

class ProposerDetailsPage extends StatefulWidgetBase {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  ProposerDetailsModel proposerDetailsModel;
  bool isProposerEditable;
  int isFrom;
  String quickFact;
  ProposerDetailsPage(this.widgetListener, this.buyerDetailsController,
      this.controller, this.proposerDetailsModel, this.isProposerEditable, {this.isFrom,this.quickFact});

  @override
  _ProposerDetailsPageState createState() => _ProposerDetailsPageState();
}

class _ProposerDetailsPageState extends State<ProposerDetailsPage> {
  NomineeDetailsBloc _bloc;
  bool isGenderSelectionError = false, isDobError = false;
  String genderErrorString = "",
      firstNameErrorString = "",
      lastNameErrorString = "",
      agentCodeErrorString = "",
      dobErrorString = "";
  bool onNextClicked = false;
  bool isAgentCodeAvailable=false;
  FocusNode _firstNameFocusNode, _lastNameFocusNode,_agentCodeFocusNode;
  int genderIndex = -1;
  TextEditingController firstNameController, lastNameController,agentCodeController;
  DobFormat dobFormat;

  StreamSubscription<int> _buyerDetailsStreamSubs;
  int selectedRadio;

  /// This value is being used to check if we should set focus to the
  /// firstName text field. The requirement is to provide focus to the
  /// firstName text field when user navigates to the screen.
  ///
  /// This job is being done this way because 'autofocus: true' is not working.
  bool _shouldRequestFocusForFirstName = true;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    agentCodeController = TextEditingController();
    dobFormat = DobFormat();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _agentCodeFocusNode = FocusNode();

    _bloc = SbiBlocProvider.of<NomineeDetailsBloc>(context);

    selectedRadio=ProposerDetailsWidget.NO_BUTTON_VALUE;
    //widget.focusNode = _firstNameFocusNode;

    if (null != widget.proposerDetailsModel.dobFormat) {
      dobFormat = widget.proposerDetailsModel.dobFormat;
      _bloc.changeDob(dobFormat.dob);
    }

    if (null != widget.proposerDetailsModel.gender) {
      if (widget.proposerDetailsModel.gender.compareTo("M") == 0) {
        genderIndex = 1;
      } else {
        genderIndex = 2;
      }
    }

    if (null != widget.proposerDetailsModel.firstName) {
      firstNameController.text = widget.proposerDetailsModel.firstName;
      _bloc.changeFirstName(widget.proposerDetailsModel.firstName);
    }

    if (null != widget.proposerDetailsModel.lastName) {
      lastNameController.text = widget.proposerDetailsModel.lastName;
      _bloc.changeFirstName(widget.proposerDetailsModel.lastName);
    }

    if (null != widget.proposerDetailsModel.agentCode && widget.isFrom!=StringConstants.FROM_AROGYA_PLUS) {
      agentCodeController.text = widget.proposerDetailsModel.agentCode;
      _bloc.changeAgentCode(widget.proposerDetailsModel.agentCode);
      selectedRadio=ProposerDetailsWidget.YES_BUTTON_VALUE;
      isAgentCodeAvailable=true;
    }

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible && (_firstNameFocusNode.hasFocus || _lastNameFocusNode.hasFocus)) {
          widget.controller.animateTo(
            widget.controller.offset + 100,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        } else if(visible && _agentCodeFocusNode.hasFocus){
          widget.controller.animateTo(
            widget.controller.offset + 400,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        }else {
          widget.controller.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        }
      },
    );

    _subscribeToBuyerDetailsStream();

    super.initState();
  }

  @override
  void didUpdateWidget(ProposerDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.buyerDetailsController.stream != oldWidget.buyerDetailsController.stream) {
      _unsubscribeToBuyerDetailsStream();

      _subscribeToBuyerDetailsStream();
    }
  }

  @override
  void didChangeDependencies() {
    genderErrorString = S.of(context).select_gender_error;
    dobErrorString = S.of(context).dob_select_error;
    if(_shouldRequestFocusForFirstName && widget.isProposerEditable) {
      _shouldRequestFocusForFirstName = false;
      FocusScope.of(context).requestFocus(_firstNameFocusNode);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            (widget.isFrom == StringConstants.FROM_AROGYA_PLUS)?S.of(context).insurance_buyer_details:S.of(context).details_of_proposer,

            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            (widget.isFrom == StringConstants.FROM_AROGYA_PLUS)?S.of(context).proposer_details_details:S.of(context).proposer_subtitle,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            S.of(context).select_gender_title.toUpperCase(),
            style: TextStyle(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          genderWidget(true),
          Visibility(
              visible: isGenderSelectionError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  genderErrorString,
                  style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          _fullNameWidget(context),
//        StreamBuilder<String>(
//            stream: _bloc.errorStream,
//            builder: (context, snapshot) {
//              String text = snapshot.data;
//              if (text == null || text.isEmpty) {
//                return Padding(
//                  padding: EdgeInsets.all(10),
//                );
//              } else {
//                return Padding(
//                  padding: const EdgeInsets.only(bottom: 10.0),
//                  child: Container(
//                    width: double.maxFinite,
//                    child: Text(
//                      text,
//                      textAlign: (text.contains("first")) ? TextAlign.start : TextAlign.end,
//                      style: TextStyle(color: Colors.red, fontSize: 12),
//                    ),
//                  ),
//                );
//              }
//            }),
          SizedBox(
            height: 5,
          ),
//        relationshipWidget(),
//        Visibility(
//            visible: isRelationshipError,
//            child: Padding(
//              padding: const EdgeInsets.only(top: 8.0),
//              child: Text(com
//                relationshipErrorString,
//                style: TextStyle(color: Colors.red, fontSize: 12),
//              ),
//            )),
          CalenderBlocBasedWidget(
            _bloc,
            onDateSelection,
            height: 40.0,
            outlineColor: Colors.black,
            dob: dobFormat.dob,
            isEditable: widget.isProposerEditable,
            isFromProposer: true,
          ),
          Visibility(
              visible: isDobError,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  dobErrorString,
                  style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                ),
              )),
          SizedBox(height: 30,),
          if(widget.isFrom!=StringConstants.FROM_AROGYA_PLUS)
          //agentWidget(),
           agentWidget(),
          QuickFactWidget((widget.quickFact == null)?StringDescription.quick_fact14:widget.quickFact),
          SizedBox(
            height: 250,
          ),

        ],
      ),
    );
  }

  genderWidget(bool isMale) {
    return Row(
      children: <Widget>[
        InkResponse(
          onTap: widget.isProposerEditable ? () {
            setState(() {
              genderIndex = 1;
              if (isGenderSelectionError) {
                isGenderSelectionError = false;
              }
            });
          } : null,
          child: SizedBox(
            width: 60,
            height: 60,
            child: (genderIndex == 1)
                ? Image.asset(AssetConstants.ic_male_selected)
                : Image.asset(AssetConstants.ic_male),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        InkResponse(
          onTap: widget.isProposerEditable ? () {
            setState(() {
              genderIndex = 2;
              if (isGenderSelectionError) {
                isGenderSelectionError = false;
              }
            });
          } : null,
          child: SizedBox(
            width: 60,
            height: 60,
            child: (genderIndex == 2)
                ? Image.asset(AssetConstants.ic_female_selected)
                : Image.asset(AssetConstants.ic_female),
          ),
        ),
      ],
    );
  }

  agentWidget(){
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(S.of(context).agent_title,style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(S.of(context).agent_sub_tittle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),),
        ),
        SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Radio(
                value: ProposerDetailsWidget.YES_BUTTON_VALUE,
                groupValue: selectedRadio ,
                activeColor: ColorConstants.disco,
                onChanged: (value){
                  print(value);
                  setState(() {
                    selectedRadio=value;
                    isAgentCodeAvailable=true;
                  });
                },
              ),
            ),
            SizedBox(width: 5,),
            Text(S.of(context).yes),
            SizedBox(width: 20,),
            Radio(
              value: ProposerDetailsWidget.NO_BUTTON_VALUE,
              groupValue: selectedRadio,
              activeColor: ColorConstants.disco,
              onChanged: (value){
                print(value);
                //  setSelectedRadioValue(value);
                setState(() {
                  selectedRadio=value;
                  isAgentCodeAvailable=false;
                  widget.proposerDetailsModel.agentCode=null;
                });
              },
            ),
            SizedBox(width: 5,),
            Text(S.of(context).no),
          ],
        ),
        SizedBox(height: 10.0,),
        if(isAgentCodeAvailable)
          Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: StreamBuilder<String>(
                stream: _bloc.agentCodeStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError && onNextClicked) {
                    switch (snapshot.error) {
                      case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                        agentCodeErrorString = S.of(context).please_enter_agent_code;
                        break;
                      case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                        agentCodeErrorString = S.of(context).please_enter_agent_code;
                        break;
                    }
                  } else {
                    agentCodeErrorString = "";
                  }
                  print("agentCodeErrorString " + agentCodeErrorString);
                  //_bloc.changeError(lastNameErrorString);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        // enabled: widget.isProposerEditable,
                        controller: agentCodeController,
                        focusNode: _agentCodeFocusNode,
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        keyboardType: Platform.isIOS ? TextInputType.numberWithOptions(signed: true, decimal: true) : TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          _bloc.changeAgentCode(value);
                        },
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12.0, color: Colors.grey[600]),
                          labelText: S.of(context).enter_agent_code.toUpperCase(),
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
                                color: agentCodeErrorString.isNotEmpty
                                    ? ColorConstants.shiraz
                                    : _agentCodeFocusNode.hasFocus
                                    ? ColorConstants
                                    .fuchsia_pink
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: Text(
                          agentCodeErrorString,
                          style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                        ),
                      )
                    ],
                  );
                }),
          ),
      ],
    );
  }

  _fullNameWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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
                  stream: _bloc.firstNameStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && onNextClicked) {
                      switch (snapshot.error) {
                        case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                          firstNameErrorString = S.of(context).first_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          firstNameErrorString =
                              S.of(context).first_name_invalid;
                          break;
                      }
                    } else {
                      firstNameErrorString = "";
                    }
                    //_bloc.changeError(firstNameErrorString);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    TextFormField(
                      autofocus: widget.isProposerEditable,
                      enabled: widget.isProposerEditable,
                      controller: firstNameController,
                      focusNode: _firstNameFocusNode,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (term) {
                        _firstNameFocusNode.unfocus();
                        FocusScope.of(context).requestFocus(_lastNameFocusNode);
                      },
                      onChanged: (value) {
                        _bloc.changeFirstName(value);
                      },
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                        LengthLimitingTextInputFormatter(100),
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12.0, color: Colors.grey[600]),
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
                              color: firstNameErrorString.isNotEmpty
                                  ? ColorConstants.shiraz
                                  : _firstNameFocusNode.hasFocus
                                  ? ColorConstants
                                  .fuchsia_pink
                                  : Colors.grey),
                        ),
                      ),
                    ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                          child: Text(
                            firstNameErrorString,
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
                  stream: _bloc.lastNameStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && onNextClicked) {
                      switch (snapshot.error) {
                        case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                          lastNameErrorString = S.of(context).last_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          lastNameErrorString = S.of(context).last_name_invalid;
                          break;
                      }
                    } else {
                      lastNameErrorString = "";
                    }
                    print("lastNameErrorString " + lastNameErrorString);
                    //_bloc.changeError(lastNameErrorString);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                    TextFormField(
                    enabled: widget.isProposerEditable,
                      controller: lastNameController,
                      focusNode: _lastNameFocusNode,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                        LengthLimitingTextInputFormatter(100),
                      ],
                      onChanged: (value) {
                        _bloc.changeLastName(value);
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12.0, color: Colors.grey[600]),
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
                              color: lastNameErrorString.isNotEmpty
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
                            lastNameErrorString,
                            style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void _subscribeToBuyerDetailsStream() {
    _buyerDetailsStreamSubs = widget.buyerDetailsController.stream.listen((from) async {
      if (from == InsuranceBuyerDetailsScreen.PROPOSER_DETAILS_WIDGET) {
        if (genderIndex == -1) {
          setState(() {
            isGenderSelectionError = true;
          });
        } else {
          onNextClicked = true;
          _bloc.changeFirstName(firstNameController.text);
          await Future.delayed(Duration(milliseconds: 500));
          if (InsureeDetailsValidator.isNameValid(firstNameController.text)) {
            _bloc.changeLastName(lastNameController.text);
            if (InsureeDetailsValidator.isNameValid(lastNameController.text)) {
              if (dobFormat.dob != null) {
               if(!isAgentCodeAvailable ) {
                  widget.proposerDetailsModel.gender =
                  (genderIndex == 1) ? "M" : "F";
                  widget.proposerDetailsModel.firstName = _bloc.firstName;
                  widget.proposerDetailsModel.lastName = _bloc.lastName;
                  widget.proposerDetailsModel.dobFormat = dobFormat;
                  widget.widgetListener(
                      InsuranceBuyerDetailsScreen
                          .COMMUNICATION_DETAILS_WIDGET,
                      true,
                      false,
                      widget.proposerDetailsModel);
                }else{
                 _bloc.changeAgentCode(agentCodeController.text);
                 await Future.delayed(Duration(milliseconds: 500));
                 if(InsureeDetailsValidator.isAgentCodeValid(agentCodeController.text)){
                   widget.proposerDetailsModel.gender = (genderIndex == 1) ? "M" : "F";
                   widget.proposerDetailsModel.firstName = _bloc.firstName;
                   widget.proposerDetailsModel.lastName = _bloc.lastName;
                   widget.proposerDetailsModel.dobFormat = dobFormat;
                   widget.proposerDetailsModel.agentCode=_bloc.agentCode;
                   widget.widgetListener(
                       InsuranceBuyerDetailsScreen
                           .COMMUNICATION_DETAILS_WIDGET,
                       true,
                       false,
                       widget.proposerDetailsModel);
                 }else{
                   _bloc.changeError(agentCodeErrorString);
                 }
               }
              } else {
                setState(() {
                  isDobError = true;
                });
              }
            } else {
              _bloc.changeError(lastNameErrorString);
            }
          } else {
            _bloc.changeError(firstNameErrorString);
          }
        }
      }
    });
  }

  void _unsubscribeToBuyerDetailsStream() {
    _buyerDetailsStreamSubs?.cancel();
    _buyerDetailsStreamSubs = null;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    _unsubscribeToBuyerDetailsStream();
    //_bloc.dispose();
    super.dispose();
  }

  onDateSelection(DateTime newDateTime, NomineeDetailsBloc _bloc) {
    String dob = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
    _bloc.changeDob(dob);
    dobFormat.dateTime = newDateTime;
    dobFormat.dob_yyyy_mm_dd = CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
    dobFormat.dob = dob;
    if (isDobError) {
      setState(() {
        isDobError = false;
      });
    }
  }
}
