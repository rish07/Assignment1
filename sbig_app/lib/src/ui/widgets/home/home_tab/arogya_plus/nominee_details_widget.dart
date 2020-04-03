import 'dart:async';

import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/nominee_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_bloc_based_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/calender_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';
import '../../quick_fact_widget.dart';

class NomineeDetailsWidget extends StatelessWidget {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  NomineeDetailsModel nomineeDetailsModel;
  int isFrom;
  String quickFact;

  NomineeDetailsWidget(
      this.widgetListener,
      this.buyerDetailsController, this.controller, this.nomineeDetailsModel,{this.isFrom,this.quickFact});

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: NomineeDetailsPage(
          widgetListener, buyerDetailsController, controller, nomineeDetailsModel,isFrom: isFrom,quickFact: quickFact,),
      bloc: NomineeDetailsBloc(),
    );
  }
}

class NomineeDetailsPage extends StatefulWidgetBase {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  NomineeDetailsModel nomineeDetailsModel;
  int isFrom;
  String quickFact;


  NomineeDetailsPage(
      this.widgetListener, this.buyerDetailsController, this.controller, this.nomineeDetailsModel,{this.isFrom,this.quickFact});

  @override
  _NomineeDetailsPageState createState() => _NomineeDetailsPageState();
}

class _NomineeDetailsPageState extends State<NomineeDetailsPage> {
  NomineeDetailsBloc _bloc;
  String areaTitle;
  List<String> areasList;
  bool isGenderSelectionError = false,
      isNameError = false,
      isRelationshipError = false,
      isAddressError = false,
      isPinCodeError = false, isDobError = false;
  String genderErrorString = "",
      firstNameErrorString = "",
      lastNameErrorString = "",
      relationshipErrorString = "", dobErrorString = "";
  bool onNextClicked = false;
  String realtionShip;
  bool _shouldRequestFocusFirstName = true;

  FocusNode _firstNameFocusNode, _lastNameFocusNode;

  int genderIndex = -1;
  TextEditingController firstNameController, lastNameController;
  DobFormat dobFormat;

  StreamSubscription<int> _buyerDetailsStreamSubs;


  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    dobFormat = DobFormat();

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();

    areasList = List();
    _bloc = SbiBlocProvider.of<NomineeDetailsBloc>(context);

    if(null != widget.nomineeDetailsModel.firstName){
      firstNameController.text = widget.nomineeDetailsModel.firstName;
    }

    if(null != widget.nomineeDetailsModel.lastName){
      lastNameController.text = widget.nomineeDetailsModel.lastName;
    }

    if(null != widget.nomineeDetailsModel.gender){
      genderIndex = ( widget.nomineeDetailsModel.gender.compareTo("M")== 0 ? 1: 2);
    }

    if(null != widget.nomineeDetailsModel.relationshipWith){
      realtionShip = widget.nomineeDetailsModel.relationshipWith;
    }

    if(null != widget.nomineeDetailsModel.dobFormat){
      dobFormat = widget.nomineeDetailsModel.dobFormat;
      _bloc.changeDob(dobFormat.dob);
    }

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible &&
            (_firstNameFocusNode.hasFocus || _lastNameFocusNode.hasFocus)) {
          widget.controller.animateTo(
            widget.controller.offset + 100,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 1000),
          );
        } else {
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
  void didUpdateWidget(NomineeDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.buyerDetailsController.stream != widget.buyerDetailsController.stream) {
      if(_buyerDetailsStreamSubs != null) {
        _unsubscribeToBuyerDetailsScream();
      }
      _subscribeToBuyerDetailsStream();
    }
  }

  @override
  void didChangeDependencies() {
    areaTitle = S.of(context).select_area_title;
    genderErrorString = S.of(context).select_gender_error;
    relationshipErrorString = S.of(context).select_relationship_error;
    dobErrorString = S.of(context).dob_select_error;

    if(_shouldRequestFocusFirstName && widget.nomineeDetailsModel.firstName == null) {
      FocusScope.of(context).requestFocus(_firstNameFocusNode);
    }
    _shouldRequestFocusFirstName = false;
    /*_firstNameFocusNode.addListener(() {
      if (_firstNameFocusNode.hasFocus) {
        widget.focusNode = _firstNameFocusNode;
      }
    });

    _lastNameFocusNode.addListener(() {
      if (_lastNameFocusNode.hasFocus) {
        widget.focusNode = _firstNameFocusNode;
      }
    });*/
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).nominee_details_title,
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).nominee_details_subtitle,
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
        _fullNameWidget(context, _bloc),
        SizedBox(
          height: 5,
        ),
        relationshipWidget(),
        Visibility(
            visible: isRelationshipError,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                relationshipErrorString,
                style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
              ),
            )),
        SizedBox(
          height: 35,
        ),
        CalenderBlocBasedWidget(_bloc, onDateSelection, height: 40.0, outlineColor: Colors.black, dob: dobFormat.dob,),
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
        QuickFactWidget((widget.quickFact==null ||widget.quickFact.isEmpty)?StringDescription.quick_fact13:widget.quickFact),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  genderWidget(bool isMale) {
    return Row(
      children: <Widget>[
        InkResponse(
          onTap: () {
            setState(() {
              genderIndex = 1;
              if (isGenderSelectionError) {
                isGenderSelectionError = false;
              }
            });
          },
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
          onTap: () {
            setState(() {
              genderIndex = 2;
              if (isGenderSelectionError) {
                isGenderSelectionError = false;
              }
            });
          },
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

  _fullNameWidget(BuildContext context, NomineeDetailsBloc bloc) {
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
                  stream: bloc.firstNameStream,
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
                    //_bloc.addFirstNameError(firstNameErrorString);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
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
                            bloc.changeFirstName(value);
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
                          padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                          child: Text(
                            firstNameErrorString,
                            style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                          ),
                        ),
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
                    //_bloc.addLastNameError(lastNameErrorString);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          controller: lastNameController,
                          focusNode: _lastNameFocusNode,
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (value) {
                            bloc.changeLastName(value);
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                            LengthLimitingTextInputFormatter(100),
                          ],
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
                          padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                          child: Text(
                            lastNameErrorString,
                            style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  relationshipWidget() {
    onRelationSelect(String relation, int position) {
      if (relation != null) {
        realtionShip = relation;
        if (isRelationshipError) {
          setState(() {
            isRelationshipError = false;
          });
        }
      }
    }

    return DropDownWidget(S.of(context).relationship_with_primary_insured,
        StringDescription.relationshipList, onRelationSelect, realtionShip);
  }

  void _subscribeToBuyerDetailsStream() {
    _buyerDetailsStreamSubs = widget.buyerDetailsController.stream.listen((from) async {
      if (from == InsuranceBuyerDetailsScreen.NOMINEE_DETAILS_WIDGET) {
        if (genderIndex == -1) {
          setState(() {
            isGenderSelectionError = true;
          });
        } else {
          onNextClicked = true;
          _bloc.changeFirstName(firstNameController.text);
          String _fName = firstNameController.text;
          if (InsureeDetailsValidator.isNameValid(_fName)) {
            String _lName = lastNameController.text;
            _bloc.changeLastName(lastNameController.text);
            if (InsureeDetailsValidator.isNameValid(_lName)) {
              if (realtionShip == null) {
                setState(() {
                  isRelationshipError = true;
                });
              } else {
                if(dobFormat.dob == null){
                  setState(() {
                    isDobError = true;
                  });
                }else{
                  widget.nomineeDetailsModel.firstName = firstNameController.text;
                  widget.nomineeDetailsModel.lastName = lastNameController.text;
                  widget.nomineeDetailsModel.gender = (genderIndex == 1) ? "M" : "F";
                  widget.nomineeDetailsModel.dobFormat = dobFormat;
                  widget.nomineeDetailsModel.relationshipWith = realtionShip;
                  widget.widgetListener(
                      InsuranceBuyerDetailsScreen.APPOINTEE_DETAILS_WIDGET,
                      true,
                      false,
                      widget.nomineeDetailsModel);
                }
              }
            } else {
              //_bloc.addLastNameError(lastNameErrorString);
            }
          } else {
            //_bloc.addFirstNameError(firstNameErrorString);
          }
        }
      }
    });
  }

  void _unsubscribeToBuyerDetailsScream() {
    if(_buyerDetailsStreamSubs != null) {
      _buyerDetailsStreamSubs.cancel();
      _buyerDetailsStreamSubs = null;
    }
  }

  @override
  void dispose() {
    //_bloc.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _unsubscribeToBuyerDetailsScream();
    super.dispose();
  }

  onDateSelection(DateTime newDateTime, NomineeDetailsBloc _bloc) {
    String dob = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
    _bloc.changeDob(dob);
    dobFormat.dateTime = newDateTime;
    dobFormat.dob_yyyy_mm_dd = CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
    dobFormat.dob = dob;
    if(isDobError){
      setState(() {
        isDobError = false;
      });
    }
  }
}