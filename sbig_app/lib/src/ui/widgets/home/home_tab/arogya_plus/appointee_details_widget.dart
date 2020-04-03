import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/nominee_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';
import '../../quick_fact_widget.dart';

class AppointeeDetailsWidget extends StatelessWidget {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  AppointeeDetailsModel appointeeDetailsModel;
  int isFrom;
  String quickFact;

  AppointeeDetailsWidget(
      this.widgetListener,
      this.buyerDetailsController, this.controller, this.appointeeDetailsModel,{this.isFrom,this.quickFact});

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: AppointeeDetailsPage(widgetListener, buyerDetailsController,
          controller, appointeeDetailsModel,isFrom: isFrom,quickFact: quickFact,),
      bloc: NomineeDetailsBloc(),
    );
  }
}

class AppointeeDetailsPage extends StatefulWidgetBase {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  AppointeeDetailsModel appointeeDetailsModel;
  int isFrom;
  String quickFact;

  AppointeeDetailsPage(this.widgetListener, this.buyerDetailsController,
      this.controller, this.appointeeDetailsModel,{this.isFrom,this.quickFact});

  @override
  _AppointeeDetailsPageState createState() => _AppointeeDetailsPageState();
}

class _AppointeeDetailsPageState extends State<AppointeeDetailsPage> {
  NomineeDetailsBloc _bloc;
  String areaTitle;
  List<String> areasList;
  bool isGenderSelectionError = false,
      isNameError = false,
      isRelationshipError = false;
  String genderErrorString = "",
      firstNameErrorString = "",
      lastNameErrorString,
      relationshipErrorString = "";
  bool onNextClicked = false;
  String relationShip;

  /// This value is being used to check if we should set focus to the
  /// firstName text field. The requirement is to provide focus to the
  /// firstName text field when user navigates to the screen.
  ///
  /// This job is being done this way because 'autofocus: true' is not working.
  bool _shouldRequestForFirstNameRequest = true;

  FocusNode _firstNameFocusNode = FocusNode(), _lastNameFocusNode = FocusNode();

  int genderIndex = -1;
  TextEditingController firstNameController = TextEditingController(), lastNameController = TextEditingController();
  DobFormat dobFormat;

  StreamSubscription<int> _buyerDetailsStreamSubs;


  @override
  void initState() {
    dobFormat = DobFormat();

    areasList = List();
    _bloc = SbiBlocProvider.of<NomineeDetailsBloc>(context);

    if (null != widget.appointeeDetailsModel.firstName) {
      firstNameController.text = widget.appointeeDetailsModel.firstName;
    }

    if (null != widget.appointeeDetailsModel.lastName) {
      lastNameController.text = widget.appointeeDetailsModel.lastName;
    }

    if (null != widget.appointeeDetailsModel.gender) {
      genderIndex =
      (widget.appointeeDetailsModel.gender.compareTo("M") == 0 ? 1 : 2);
    }

    if (null != widget.appointeeDetailsModel.relationshipWith) {
      relationShip = widget.appointeeDetailsModel.relationshipWith;
    }

//    KeyboardVisibilityNotification().addNewListener(
//      onChange: (bool visible) {
//        if (visible &&
//            (_firstNameFocusNode.hasFocus || _lastNameFocusNode.hasFocus)) {
//          widget.controller.animateTo(
//            widget.controller.offset + 100,
//            curve: Curves.easeOut,
//            duration: const Duration(milliseconds: 1000),
//          );
//        } else {
//          widget.controller.animateTo(
//            0.0,
//            curve: Curves.easeOut,
//            duration: const Duration(milliseconds: 1000),
//          );
//        }
//      },
//    );

    _subscribeToBuyerDetailsStream();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_shouldRequestForFirstNameRequest && widget.appointeeDetailsModel.firstName == null) {
      FocusScope.of(context).requestFocus(_firstNameFocusNode);
    }
    _shouldRequestForFirstNameRequest = false;
    areaTitle = S
        .of(context)
        .select_area_title;
    relationshipErrorString = S
        .of(context)
        .select_relationship_error;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AppointeeDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buyerDetailsController.stream !=
        widget.buyerDetailsController.stream) {
      _unsubscribeToBuyerDetailsStream();
      _subscribeToBuyerDetailsStream();
    }
  }

  void _subscribeToBuyerDetailsStream() {
    _buyerDetailsStreamSubs =
        widget.buyerDetailsController.stream.listen((from) async {
          if (from == InsuranceBuyerDetailsScreen.APPOINTEE_DETAILS_WIDGET) {
            onNextClicked = true;
            String _fName = firstNameController.text;
            _bloc.changeFirstName(_fName);
            //await Future.delayed(Duration(milliseconds: 500));
            if (InsureeDetailsValidator.isNameValid(_fName)) {
              String _lName = lastNameController.text;
              _bloc.changeLastName(_lName);
              if (InsureeDetailsValidator.isNameValid(_lName)) {
                if (TextUtils.isEmpty(relationShip)) {
                  setState(() {
                    isRelationshipError = true;
                  });
                } else {
                  widget.appointeeDetailsModel.firstName =
                      firstNameController.text;
                  widget.appointeeDetailsModel.lastName =
                      lastNameController.text;
                  widget.appointeeDetailsModel.relationshipWith = relationShip;
                  widget.appointeeDetailsModel.gender =
                  (genderIndex == 1) ? "M" : "F";

                  widget.widgetListener(
                      InsuranceBuyerDetailsScreen.TO_POLICY_SUMMERY_SCREEN,
                      true,
                      false,
                      widget.appointeeDetailsModel);
                }
              } else {
                _bloc.changeError(lastNameErrorString);
              }
            } else {
              _bloc.changeError(firstNameErrorString);
            }
          }
        });
  }

  void _unsubscribeToBuyerDetailsStream() {
    _buyerDetailsStreamSubs?.cancel();
    _buyerDetailsStreamSubs = null;
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
          S.of(context).appointee_details_title,
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).appointee_details_subtitle,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 25,
        ),
        _fullNameWidget(context, _bloc),
        SizedBox(
          height: 10,
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
        Expanded(child: Container()),
        QuickFactWidget((widget.quickFact==null)?StringDescription.quick_fact12:widget.quickFact),
        SizedBox(
          height: (Platform.isIOS ? 260 : 210) + InsuranceBuyerDetailsScreen.EXTRA_SPACE,
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
                          firstNameErrorString = S
                              .of(context)
                              .first_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          firstNameErrorString =
                              S
                                  .of(context)
                                  .first_name_invalid;
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
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                color: Colors.grey[600]),
                            labelText: S
                                .of(context)
                                .first_name_title
                                .toUpperCase(),
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
                          padding: const EdgeInsets.only(top: 5.0),
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
                  stream: bloc.lastNameStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError && onNextClicked) {
                      switch (snapshot.error) {
                        case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                          lastNameErrorString = S
                              .of(context)
                              .last_name_empty;
                          break;
                        case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                          lastNameErrorString = S
                              .of(context)
                              .last_name_invalid;
                          break;
                      }
                    } else {
                      lastNameErrorString = "";
                    }
                    //_bloc.changeError(lastNameErrorString);

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
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                            LengthLimitingTextInputFormatter(100),
                          ],
                          onChanged: (value) {
                            bloc.changeLastName(value);
                          },
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                                color: Colors.grey[600]),
                            labelText: S
                                .of(context)
                                .last_name_title
                                .toUpperCase(),
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
                          padding: const EdgeInsets.only(top: 5.0),
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

  relationshipWidget() {
    onRelationSelect(String relation, int position) {
      if (relation != null) {
        relationShip = relation;
        if (isRelationshipError) {
          setState(() {
            isRelationshipError = false;
          });
        }
      }
    }
    return DropDownWidget(S
        .of(context)
        .relationship_with_appointee,
        StringDescription.appointeeRelationshipList, onRelationSelect,
        relationShip);
  }

  @override
  void dispose() {
    //_bloc.dispose();
    _unsubscribeToBuyerDetailsStream();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
