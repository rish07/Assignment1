import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/health_claim_intimation/health_claim_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/health_claim_intimation/health_claim_intimation_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/health_claim_intimation/health_claim_validator.dart';
import 'package:sbig_app/src/controllers/service/location_service.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/health_claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/track_health_claim_intimation_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_member_bottom_sheet_widget.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/drop_down_box.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/claim_intimation/date_of_discharge_health_claim_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/claim_intimation/date_of_hospitalization_health_claim_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/ui/widgets/common/custom_stepper.dart';
import 'package:sbig_app/src/ui/widgets/common/custom_radio.dart';
import 'package:sbig_app/src/utilities/permission_service.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'track_health_claim_status_screen.dart';

class HealthClaimIntimationScreen extends StatefulWidget {
  static const ROUTE_NAME = "/claim_intimation/health_claim_initimation_screen";
  final HealthClaimIntimationArguments arguments;

  HealthClaimIntimationScreen(this.arguments);

  Function(int, String, int, bool) onUpdate;
  int selectedMember;
  bool isUpdateVisible;

  @override
  _HealthClaimIntimationScreenState createState() =>
      _HealthClaimIntimationScreenState();
}

class HealthClaimIntimationArguments {
  String policyNumber, mobileNumber, policyType;
  List<String> patientName;

  HealthClaimIntimationArguments(this.policyNumber, this.mobileNumber,
      this.policyType, this.patientName);
}

class _HealthClaimIntimationScreenState
    extends State<HealthClaimIntimationScreen>
    with CommonWidget {
  double screenWidth;
  double screenHeight;

  bool onAmountSubmitted = false,
      onOtherSubmitted = false,
      onDoctorNameSubmitted = false,
      onReasonOfHospitalizationSubmitted = false,
      isPatientNameError = false,
      isRoomTypeError = false,
      onSubmit = false,
      isCitySelected = false,
      isDohError = false,
      isDodError = false,
      onEmailSubmitted = false,
      isSelected = false,
      isCityOfTreatmentError = false,
      isClaimError = false,
      isHospitalError = false,
      onMobileSubmitted = false,
      autofocus;

  String emailErrorString,
      amountErrorString,
      doctorNameErrorString,
      reasonOfHospitalizationErrorString,
      patientName,
      patientNameErrorString = "Select Patient Name",
      roomType,
      roomTypeErrorString = "Select Room Type",
      errorText,
      cityErrorText = "",
      dohErrorString = "Select Date of Hospitalization",
      dodErrorString = "Discharge date must greater than Hospitalization date",
      cityOfTreatmentErrorString = "Select City",
      claimRadioErrorString = "Select Type of Claim",
      hospitalErrorString = "Select Hospital",
      latitude = "",
      longitude = "",
      city = "Agra",
      selectedCity = "",
      policyNumber = '',
      mobileErrorString,
      claimId;

  FocusNode _emailFocusNode,
      _reasonOfHospitalizationFocusNode,
      _doctorsNameFocusNode,
      _amountFocusNode,
      _otherFocusNode;

  DobFormat dohFormat, dodFormat;

  int selectedRadio = -1,
      _currentStep = 0,
      notInList = 0;

  List<String> cities = [];
  List<String> hospitals = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final amountController = TextEditingController();
  final otherController = TextEditingController();
  final doctorNameController = TextEditingController();
  final reasonOfHospitalizationController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final hospitalNameController = TextEditingController();
  final hospitalName1Controller = TextEditingController();
  final _mobileNumberController = TextEditingController();
  ScrollController _controller;

  final _healthBloc = HealthClaimBloc();
  LocationService locationService = LocationService.getInstance();

  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _controller = ScrollController();
    _reasonOfHospitalizationFocusNode = FocusNode();
    _doctorsNameFocusNode = FocusNode();
    _amountFocusNode = FocusNode();

    checkLocationPermission(() {
      _getCurrentLocation();
      onMobileNumberSet();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil
            .getInstance(context)
            .screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil
        .getInstance(context)
        .screenHeightDp;
    policyNumber = widget.arguments.policyNumber ?? '';

    autofocus = false;

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          double offset = 0;
          if ((_doctorsNameFocusNode.hasFocus || _emailFocusNode.hasFocus)) {
            print("offset done");
            offset = 100;
          }
          _controller.animateTo(
            _controller.offset + offset,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 100),
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

  void checkLocationPermission(Function taskToExecuteIfGranted) {
    PermissionService().requestPermission(PermissionGroup.location,
        onGranted: () {
          taskToExecuteIfGranted();
        }, onDenied: () {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S
                .of(context)
                .need_storage_permission),
          ));
        }, onUserCheckedNeverOnAndroid: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(S
                      .of(context)
                      .need_storage_permission),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        S
                            .of(context)
                            .cancel,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        S
                            .of(context)
                            .open_settings,
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        PermissionHandler().openAppSettings();
                      },
                    ),
                  ],
                );
              });
        });
  }

  void _getCurrentLocation() async {
    try {
      UserLocation location = await locationService.getCurrentLocation();
      if (location != null) {
        print('LATITUDE : ${location.latitude}');
        print('LONGITUDE : ${location.longitude}');
        latitude = location.latitude.toString();
        longitude = location.longitude.toString();
      }
    } catch (e) {
      hideLoaderDialog(context);
    }
  }

  CustomStepperType stepperType = CustomStepperType.horizontal;


  void _onAppBarBackPresses(int d) {
    if (_currentStep == 0)
      Navigator.pop(context);
    else
      setState(() {
        _currentStep = _currentStep - 1;
      });  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: getAppBar(context, S.of(context).claim_intimation_title.toUpperCase(),
          onBackPressed: _onAppBarBackPresses,),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              CustomStepper(
                customsteps: _mySteps(),
                currentStep: this._currentStep,
                onStepTapped: (step) {
                  setState(() {
                    this._currentStep = step;
                  });
                },
              ),
            ],
          ),
        ));
  }

  List<CustomStep> _mySteps() {
    List<CustomStep> _steps = [
      CustomStep(
        title: Text(
          S
              .of(context)
              .policy_details,
          style: TextStyle(color: Colors.black, fontSize: 11),
        ),
        content: Stack(
          children: <Widget>[
            SingleChildScrollView(
                controller: _controller,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: ColorConstants.health_claim_intimation_bg_color,
                      padding:
                      const EdgeInsets.fromLTRB(21.0, 30.0, 27.0, 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S
                                        .of(context)
                                        .policy_no
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Text(
                                    S
                                        .of(context)
                                        .mobile_no
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Text(
                                    S
                                        .of(context)
                                        .policy_type_title
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    policyNumber ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        widget.arguments.mobileNumber ?? '',
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          onEditMobile(
                                              widget.arguments.mobileNumber);
                                        },
                                        child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: Image.asset(
                                              AssetConstants.ic_edit),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Text(
                                    widget.arguments.policyType ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          _emailWidget(),
                          SizedBox(
                            height: 20,
                          ),
                          patientWidget(),
                          Visibility(
                              visible: isPatientNameError,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  patientNameErrorString,
                                  style: TextStyle(
                                      color: ColorConstants.shiraz,
                                      fontSize: 12),
                                ),
                              )),
                          SizedBox(
                            height: 29,
                          ),
                          Text(
                            S
                                .of(context)
                                .type_of_claim
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.3),
                              fontSize: 12,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CustomRadio(
                                value: 1,
                                groupValue: selectedRadio,
                                activeColor: ColorConstants.disco,
                                onChanged: (value) {
                                  setState(() {
                                    _healthBloc.changeTypeOfClaim(
                                        S
                                            .of(context)
                                            .cashless);
                                    isClaimError = false;
                                  });
                                  print(value);
                                  setSelectedRadioValue(value);
                                },
                              ),
                              SizedBox(width: 5,),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      (selectedRadio == 1)
                                          ? Text(
                                        S
                                            .of(context)
                                            .cashless
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                          : Text(
                                        S
                                            .of(context)
                                            .cashless
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: Colors.black
                                                .withOpacity(0.3)),
                                      ),
                                      Text(
                                        S
                                            .of(context)
                                            .cashless_subtitle,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Colors.black.withOpacity(0.3)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CustomRadio(
                                value: 2,
                                groupValue: selectedRadio,
                                activeColor: ColorConstants.disco,
                                onChanged: (value) {
                                  _healthBloc.changeTypeOfClaim(
                                      S
                                          .of(context)
                                          .reimbursement);
                                  setState(() {
                                    isClaimError = false;
                                  });
                                  setSelectedRadioValue(value);
                                },
                              ),
                              SizedBox(width: 5,),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      (selectedRadio == 2)
                                          ? Text(
                                        S
                                            .of(context)
                                            .reimbursement
                                            .toUpperCase(),
                                        style:
                                        TextStyle(fontSize: 12,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                          : Text(
                                        S
                                            .of(context)
                                            .reimbursement
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                             fontWeight: FontWeight.
                                            w600,

                                            letterSpacing: 1,
                                            color: Colors.black
                                                .withOpacity(0.3)),
                                      ),
                                      Text(
                                        S
                                            .of(context)
                                            .cashless_subtitle,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color:
                                            Colors.black.withOpacity(0.3)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Visibility(
                              visible: isClaimError,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  claimRadioErrorString,
                                  style: TextStyle(
                                      color: ColorConstants.shiraz,
                                      fontSize: 12),
                                ),
                              )),
                          SizedBox(
                            height: 250,
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            BlackButtonWidget(
              onContinuePolicyDetails,
              S
                  .of(context)
                  .claim_next_button
                  .toUpperCase(),
              bottomBgColor: ColorConstants.claim_intimation_bg_color,
            ),
          ],
        ),
        state: CustomStepState.policyDetails,
        isActive: _currentStep >= 0,
      ),
      CustomStep(
        title: Text(
          S
              .of(context)
              .hospital_details,
          style: TextStyle(color: Colors.black, fontSize: 11),
        ),
        content:
        new WillPopScope(
          onWillPop: ()  {
            setState(() {
              _currentStep = _currentStep - 1;
            });
            return Future<bool>.value(false);
          },
          child:  Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: _controller,
                  child: Container(
                    color: ColorConstants.health_claim_intimation_bg_color,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(21.0, 10.0, 27.0, 14.0),
                      child: Column(
                        children: <Widget>[
                          _reasonOfHospitalizationWidget(),
                          SizedBox(
                            height: 26,
                          ),
                          cityDropDown(),
                          Align(alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: isCityOfTreatmentError,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    cityOfTreatmentErrorString,
                                    style: TextStyle(
                                        color: ColorConstants.shiraz, fontSize: 12),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          searchHospitalDropDown(),
                          if (hospitalNameController.text == "Not in the list")
                            TextField(
                              controller: hospitalName1Controller,
                              cursorColor: ColorConstants.disco,
                              onChanged: (value) {
                                _healthBloc.changeHospitalName(value);
                                setState(() {
                                  isHospitalError = false;
                                });
                              },
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants.fuchsia_pink),
                                  ),
                                  labelText:
                                  S
                                      .of(context)
                                      .hospital_name
                                      .toUpperCase(),
                                  labelStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.3))),
                            ),
                          Align(alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: isHospitalError,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    hospitalErrorString,
                                    style: TextStyle(
                                        color: ColorConstants.shiraz, fontSize: 12),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          roomWidget(),
                          Align(alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: isRoomTypeError,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    roomTypeErrorString,
                                    style: TextStyle(
                                        color: ColorConstants.shiraz, fontSize: 12),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 21,
                          ),
                          _doctorNameWidget(),
                          SizedBox(
                            height: 29,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              S
                                  .of(context)
                                  .date_of_hospitalization
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 12,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          DateOfHospitalizationHealthClaimWidget(
                            _healthBloc,
                            onDateOfHospitalizationSelection,
                            height: 45.0,
                            dob: _healthBloc.dateOfHospitalization,
                            outlineColor: Colors.black,
                            // dob: dobFormat.dob,
                          ),

                          Align(alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: isDohError,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    dohErrorString,
                                    style: TextStyle(
                                        color: ColorConstants.shiraz, fontSize: 12),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 19,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              S
                                  .of(context)
                                  .date_of_discharge
                                  .toUpperCase(),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 12,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          DateOfDischargeHealthClaimWidget(
                            _healthBloc,
                            onDateOfDischargeSelection,
                            height: 45.0,
                            dob: _healthBloc.dateOfDischarge,
                            outlineColor: Colors.black,
                            //dob: dobFormat.dob,
                          ),
                          Align(alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: isDodError,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    dodErrorString,
                                    style: TextStyle(
                                        color: ColorConstants.shiraz, fontSize: 12),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                BlackButtonWidget(
                  onContinueHospitalDetails,
                  S
                      .of(context)
                      .claim_next_button
                      .toUpperCase(),
                  bottomBgColor: ColorConstants.claim_intimation_bg_color,
                ),
              ],
            ),
        ),




        state: CustomStepState.hospitalDetails,
        isActive: _currentStep >= 1,
      ),
      CustomStep(
        title: Text(
          S
              .of(context)
              .payment_details,
          style: TextStyle(color: Colors.black, fontSize: 11),
        ),
        content:
        new WillPopScope(
          onWillPop: ()  {
            setState(() {
              _currentStep = _currentStep - 1;
            });
            return Future<bool>.value(false);
          },
          child: Scaffold(
            backgroundColor: ColorConstants.health_claim_intimation_bg_color,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(21.0, 10.0, 27.0, 14.0),
                      child: Column(
                        children: <Widget>[
                          _amountWidget(),
                          SizedBox(height: 15),
                          _otherWidget(),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  BlackButtonWidget(
                    onInitiateClaim,
                    S
                        .of(context)
                        .initiate_claim
                        .toUpperCase(),
                    bottomBgColor: ColorConstants.claim_intimation_bg_color,
                  ),
                ],
              ),
            ),
          ),
        ),



        state: CustomStepState.paymentDetails,
        isActive: _currentStep >= 2,
      ),
    ];
    return _steps;
  }

  onEditMobile(String mob) {
    _mobileNumberController.text = mob;
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            WillPopScope(
                onWillPop: () {
                  return Future<bool>.value(true);
                },
                child: Center(
                    child: SimpleDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      contentPadding: EdgeInsets.all(0.0),
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0))),
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: ColorConstants
                                      .arogya_plus_quote_number_color,
                                ),
                                width: double.maxFinite,
                                //color: ColorConstants.arogya_plus_quote_number_color,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 12.0,
                                      bottom: 12.0),
                                  child: Text(
                                    "Edit Mobile Number",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 12.0,
                                      bottom: 12.0),
                                  child: _mobileWidget()
                                /*TextField(
                          controller: _mobileNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),*/
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BlackButtonWidget(
                                onEditMobileChange,
                                S
                                    .of(context)
                                    .save_details
                                    .toUpperCase(),
                                bottomBgColor: Colors.white,
                                height: 35,
                                width: 35,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))));
  }

  onMobileNumberSet() {
    _mobileNumberController.text = widget.arguments.mobileNumber;
  }

  onEditMobileChange() {
    print("Mobile value" +
        _mobileNumberController.text +
        "bloc" +
        _healthBloc.mobileNumber);

    if (_healthBloc.mobileNumber == null ||
        _mobileNumberController.text.length != 10)
      setState(() {
        onMobileSubmitted = true;
      });

    print(_mobileNumberController.text.length);

    if (_mobileNumberController.text.length == 10 &&
        mobileErrorString == null) {
      setState(() {
        widget.arguments.mobileNumber = _mobileNumberController.text;
      });
      onDisAgree();
    }
  }

  onDisAgree() {
    Navigator.of(context).pop();
  }

  _emailWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.emailStream,
        builder: (context, snapshot) {
          //Image image = Image.asset(AssetConstants.ic_correct);
          Image image;
          bool isError = snapshot.hasError;
          emailErrorString = null;
          bool _onSubmit = (onEmailSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case HealthClaimValidator.EMAIL_EMPTY_ERROR:
                image = _onSubmit ? null : null;
                emailErrorString =
                _onSubmit ? S
                    .of(context)
                    .email_empty_error : null;
                break;
              case HealthClaimValidator.EMAIL_INVALID_ERROR:
                image = _onSubmit ? null : null;
                emailErrorString =
                _onSubmit ? S
                    .of(context)
                    .invalid_email_error : null;
                break;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: TextField(
                  controller: _emailController,
                  cursorColor: ColorConstants.disco,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  onSubmitted: (value) {
                    _emailFocusNode.unfocus();
                    onContinuePolicyDetails();
                  },
                  inputFormatters: [
                    emailTextFormatter,
                    LengthLimitingTextInputFormatter(254),
                  ],
                  onChanged: (value) {
                    _healthBloc.changeEmail(value);
                  },
                  decoration: InputDecoration(
                    labelText: S
                        .of(context)
                        .email_address
                        .toUpperCase(),
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.only(bottom: 5.0, right: 30.0),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    errorText: emailErrorString,
                    errorStyle: TextStyle(color: ColorConstants.shiraz),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.shiraz),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorConstants.fuchsia_pink),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  _mobileWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.mobileNumberStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          mobileErrorString = null;
          bool _onSubmit = (onMobileSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case HealthClaimValidator.MOBILE_EMPTY_ERROR:
                mobileErrorString =
                _onSubmit ? S
                    .of(context)
                    .mobile_number_empty_error : null;
                break;
              case HealthClaimValidator.MOBILE_LENGTH_ERROR:
                mobileErrorString = _onSubmit
                    ? S
                    .of(context)
                    .invalid_mobile_number_error
                    : null;
                break;
              case HealthClaimValidator.MOBILE_INVALID_ERROR:
                mobileErrorString = S
                    .of(context)
                    .invalid_mobile_number_error;
                break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  S
                      .of(context)
                      .mobile_number_title
                      .toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w600,
                      fontSize: 12, color: Colors.grey[800], letterSpacing: 1),
                ),
              ),
              Stack(
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                          primaryColor: Colors.black,
                          accentColor: Colors.black,
                          hintColor: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Container(
                          width: double.maxFinite,
                          child: TextField(
                            //  focusNode: _mobileFocusNode,
                            controller: _mobileNumberController,
                            cursorColor: ColorConstants.disco,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2),
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              onEditMobileChange();
                            },
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            onChanged: (value) {
                              _healthBloc.changeMobileNumber(value);
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              errorText: mobileErrorString,
                              errorStyle:
                              TextStyle(color: ColorConstants.shiraz),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ColorConstants.shiraz),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.fuchsia_pink),
                              ),
                            ),
                          ),
                        ),
                      )),
                  //})
                ],
              )
            ],
          );
        });
  }

  patientWidget() {
    onPatientSelect(String patient, int position) {
      if (patient != null) {
        patientName = patient;
        _healthBloc.changePatientName(patientName);
        if (isPatientNameError) {
          setState(() {
            isPatientNameError = false;
          });
        }
      }
    }

    return DropDownWidget(S
        .of(context)
        .patient_name
        .toUpperCase(),
        widget.arguments.patientName, onPatientSelect, patientName);
  }

  setSelectedRadioValue(int value) {
    setState(() {
      selectedRadio = value;
      CriticalIllnessMemberDetailsBottomSheetWidget.isEmployed = (value ==
          CriticalIllnessMemberDetailsBottomSheetWidget.YES_BUTTON_VALUE)
          ? true
          : false;
    });
  }

  onContinuePolicyDetails() {
    String emailAddress = _healthBloc.email;
    onEmailSubmitted = true;
    _healthBloc.changeEmail(emailAddress);
    if (_healthBloc.email.length == 0 /*|| emailErrorString==null*/)
      setState(() {
        onEmailSubmitted = true;
      });
    else if (patientName == null)
      setState(() {
        isPatientNameError = true;
      });
    else if (selectedRadio == -1)
      setState(() {
        isClaimError = true;
      });
    else {
      _makeCityApiCall();
    }
  }

  _reasonOfHospitalizationWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.reasonOfHospitalizationStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          reasonOfHospitalizationErrorString = null;
          bool _onSubmit = (onReasonOfHospitalizationSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case HealthClaimValidator.REASON_EMPTY_ERROR:
                reasonOfHospitalizationErrorString =
                _onSubmit ? S
                    .of(context)
                    .reason_empty_error : null;
                break;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                child: TextField(
                  controller: reasonOfHospitalizationController,
                  cursorColor: ColorConstants.disco,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                  textInputAction: TextInputAction.next,
                  focusNode: _reasonOfHospitalizationFocusNode,
                  onSubmitted: (value) {
                    _reasonOfHospitalizationFocusNode.unfocus();
                    //onContinueHospitalDetails();
                    FocusScope.of(context).requestFocus(_doctorsNameFocusNode);
                  },
                  onChanged: (value) {
                    _healthBloc.changeReasonOfHospitalization(value);
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(500),
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                  ],
                  decoration: InputDecoration(
                    labelText:
                    S
                        .of(context)
                        .reason_of_hospitalization
                        .toUpperCase(),
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    errorText: reasonOfHospitalizationErrorString,
                    errorStyle: TextStyle(color: ColorConstants.shiraz),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.shiraz),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorConstants.fuchsia_pink),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget searchHospitalDropDown() {
    return Container(
      height: 53,
      child: TypeAheadFormField(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this.hospitalNameController,
            cursorColor: ColorConstants.disco,
            //focusNode: _cityFocusNode,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
            ],
            onSubmitted: (value) {
              onContinueHospitalDetails();
            },
            onChanged: (value) {
              _healthBloc.changeHospitalName(value);
              setState(() {
                isHospitalError = false;
              });
            },
            style: TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 14),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
              ),
              border: OutlineInputBorder(
                  borderRadius:
                  borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                  borderSide:
                  BorderSide(color: ColorConstants.claim_remark_color)),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide: BorderSide(color: Colors.grey[500]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              // prefixText: selectedCity,
              labelText: S
                  .of(context)
                  .search_hospital
                  .toUpperCase(),
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            )),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 0.5,
        ),
        suggestionsCallback: (pattern) {
          debugPrint('hospital pattern : $pattern');

          if (pattern.length == 0) {
            return getHospitalSuggestions('');
          } else {
            return getHospitalSuggestions(pattern);
          }
        },
        itemBuilder: (context, suggestion) {
          return Padding(
            padding: EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 8),
            child: Text(
              suggestion,
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.claim_drop_down_text),
            ),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this.hospitalNameController.text = suggestion;
          setState(() {
            isHospitalError = false;
          });
        },
      ),
    );
  }

  Widget cityDropDown() {
    return Container(
      height: 45,
      child: TypeAheadFormField(
        getImmediateSuggestions: true,
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._cityController,
            cursorColor: ColorConstants.disco,
/*
            focusNode: _cityFocusNode,
*/
            maxLines: 1,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
            ],
            onSubmitted: (value) {
              onContinueHospitalDetails();
            },
            onChanged: (value) {
              _healthBloc.changeCity(value);
              setState(() {
                isCityOfTreatmentError = false;
              });
            },
            style: TextStyle(
                letterSpacing: 1, fontWeight: FontWeight.w500, fontSize: 14),
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
              ),
              border: OutlineInputBorder(
                  borderRadius:
                  borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                  borderSide:
                  BorderSide(color: ColorConstants.claim_remark_color)),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide: BorderSide(color: Colors.grey[500]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                borderRadius(radius: 8.0, topLeft: 8.0, topRight: 8.0),
                borderSide:
                BorderSide(color: ColorConstants.claim_dropdown_color),
              ),
              labelText: S
                  .of(context)
                  .city_of_treatment
                  .toUpperCase(),
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(0.3),
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w500,
              ),
            )),
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          elevation: 0.5,
        ),
        suggestionsCallback: (pattern) {
          debugPrint('city pattern : $pattern');
          if (pattern.length == 0) {
            return getCitySuggestions('');
          } else {
            return getCitySuggestions(pattern);
          }
        },
        itemBuilder: (context, suggestion) {
          return Padding(
            padding: EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 8),
            child: Text(
              suggestion,
              textAlign: TextAlign.start,
              style: TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.claim_drop_down_text),
            ),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          this._cityController.text = suggestion;
          setState(() {
            isCityOfTreatmentError = false;
            isCitySelected = true;
            cityErrorText = " ";
            _makeHospitalListApiCall();
            hospitalNameController.text="";

          });
        },
      ),
    );
  }

  roomWidget() {
    onRoomSelect(String room, int position) {
      if (room != null) {
        roomType = room;
        _healthBloc.changeRoomType(roomType);
        if (isRoomTypeError) {
          setState(() {
            isRoomTypeError = false;
          });
        }
      }
    }

    return DropDownWidget(S
        .of(context)
        .room_type
        .toUpperCase(),
        StringDescription.roomTypeList, onRoomSelect, roomType);
  }

  _doctorNameWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.doctorNameStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          doctorNameErrorString = null;
          bool _onSubmit = (onDoctorNameSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case HealthClaimValidator.DOCTOR_NAME_EMPTY_ERROR:
                doctorNameErrorString =
                _onSubmit ? S
                    .of(context)
                    .doctor_name_empty_error : null;
                break;
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                        primaryColor: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          child: TextField(
                            controller: doctorNameController,
                            cursorColor: ColorConstants.disco,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                            focusNode: _doctorsNameFocusNode,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (value) {
                              _doctorsNameFocusNode.unfocus();
                              onContinueHospitalDetails();
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                              WhitelistingTextInputFormatter(
                                  RegExp("[a-zA-Z ]")),
                            ],
                            onChanged: (value) {
                              _healthBloc.changeDoctorName(value);
                            },
                            decoration: InputDecoration(
                              labelText:
                              S
                                  .of(context)
                                  .doctors_name
                                  .toUpperCase(),
                              labelStyle: TextStyle(
                                color: Colors.black.withOpacity(0.3),
                                fontSize: 12,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              errorText: doctorNameErrorString,
                              errorStyle:
                              TextStyle(color: ColorConstants.shiraz),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: ColorConstants.shiraz),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[500]),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.fuchsia_pink),
                              ),
                            ),
                          ),
                        ),
                      )),
                  //})
                ],
              )
            ],
          );
        });
  }

  onDateOfHospitalizationSelection(DateTime newDateTime,
      HealthClaimBloc _healthBloc) {
    if (isDohError) {
      setState(() {
        isDohError = false;
      });
    }
    String doh = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
    _healthBloc.changeDateOfHospitalization(doh);
    dohFormat.dateTime = newDateTime;
    dohFormat.dob_yyyy_mm_dd =
        CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
    dohFormat.dob = doh;
  }

  onDateOfDischargeSelection(DateTime newDateTime,
      HealthClaimBloc _healthBloc) {
    if (isDodError /*|| true*/) {
      setState(() {
        isDodError=false;

    /*    print(_healthBloc.dateOfDischarge.substring(0,2).compareTo(_healthBloc.dateOfHospitalization.substring(0,2))>0 );
        if(_healthBloc.dateOfHospitalization.isNotEmpty && _healthBloc.dateOfDischarge.isNotEmpty)
          if(_healthBloc.dateOfDischarge.substring(6,10).compareTo(_healthBloc.dateOfHospitalization.substring(6,10))>0)
            print("year");
           else if(_healthBloc.dateOfDischarge.substring(3,5).compareTo(_healthBloc.dateOfHospitalization.substring(3,5))>0 && _healthBloc.dateOfHospitalization.substring(6,10).compareTo(_healthBloc.dateOfDischarge.substring(6,10))<=0 )
            print("mon");
          else if(_healthBloc.dateOfDischarge.substring(0,2).compareTo(_healthBloc.dateOfHospitalization.substring(0,2))>0 && _healthBloc.dateOfHospitalization.substring(3,5).compareTo(_healthBloc.dateOfDischarge.substring(3,5))<=0)
            isDodError=false;*/
      });
    }
    String dod = CommonUtil.instance.convertTo_dd_MM_yyyy(newDateTime);
    _healthBloc.changeDateOfDischarge(dod);
    dodFormat.dateTime = newDateTime;
    dodFormat.dob_yyyy_mm_dd =
        CommonUtil.instance.convertTo_yyyy_MM_dd(newDateTime);
    dodFormat.dob = dod;
  }




  onContinueHospitalDetails() {
    onSubmit == true;
    print("compare");
      setState(() {

      if (_healthBloc.reasonOfHospitalization.length == 0)
        onReasonOfHospitalizationSubmitted = true;
      else if (_cityController.text.length == 0)
        isCityOfTreatmentError = true;
      else if (hospitalNameController.text.length == 0 &&
          hospitalName1Controller.text.length == 0)
        isHospitalError = true;
      else if (roomType == null)
        isRoomTypeError = true;
      else if (_healthBloc.doctorName.length == 0)
        onDoctorNameSubmitted = true;
      else if (_healthBloc.dateOfHospitalization.length == 0) isDohError = true;
      else if(_healthBloc.dateOfHospitalization.isNotEmpty && _healthBloc.dateOfDischarge.isNotEmpty)
        if(_healthBloc.dateOfHospitalization.substring(6,10).compareTo(_healthBloc.dateOfDischarge.substring(6,10))>0)
          isDodError=true;
        else if(_healthBloc.dateOfHospitalization.substring(3,5).compareTo(_healthBloc.dateOfDischarge.substring(3,5))>0 && _healthBloc.dateOfDischarge.substring(6,10).compareTo(_healthBloc.dateOfHospitalization.substring(6,10))<=0)
          isDodError=true;
        else if(_healthBloc.dateOfHospitalization.substring(0,2).compareTo(_healthBloc.dateOfDischarge.substring(0,2))>0 && _healthBloc.dateOfDischarge.substring(3,5).compareTo(_healthBloc.dateOfHospitalization.substring(3,5))<=0)
          isDodError=true;

      if (this._currentStep < this
          ._mySteps()
          .length - 1 &&
          roomType != null &&
          _healthBloc.dateOfHospitalization.length != 0 &&
          _healthBloc.doctorName.length != 0 &&
          (hospitalNameController.text.length != 0 ||
              hospitalName1Controller.text.length != 0) &&
          _healthBloc.reasonOfHospitalization.length != 0 && isDodError==false &&
          _cityController.text.length != 0) {
        this._currentStep = this._currentStep + 1;
      } else {
        //Logic to check if everything is completed
        print('Completed, check fields.');
        print(_healthBloc.dateOfHospitalization);
      }
    });
  }

  _amountWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.amountStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          amountErrorString = null;
          bool _onSubmit = (onAmountSubmitted);
          if (isError) {
            switch (snapshot.error) {
              case HealthClaimValidator.AMOUNT_EMPTY_ERROR:
                amountErrorString =
                _onSubmit ? S
                    .of(context)
                    .amount_empty_error : null;
                break;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: TextField(
                  controller: amountController,
                  cursorColor: ColorConstants.disco,
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  focusNode: _amountFocusNode,
                  onSubmitted: (value) {
                    _amountFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_otherFocusNode);
                    //onInitiateClaim();
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) {
                    _healthBloc.changeAmount(value);
                  },
                  decoration: InputDecoration(
                    labelText:
                    S
                        .of(context)
                        .estimate_amount_in_rs
                        .toUpperCase(),
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    errorText: amountErrorString,
                    errorStyle: TextStyle(color: ColorConstants.shiraz),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: ColorConstants.shiraz),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[500]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: ColorConstants.fuchsia_pink),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  _otherWidget() {
    return StreamBuilder<Object>(
        stream: _healthBloc.otherStream,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: otherController,
                cursorColor: ColorConstants.disco,
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 1),
                textInputAction: TextInputAction.next,
                focusNode: _otherFocusNode,
                onSubmitted: (value) {
                  _otherFocusNode.unfocus();
                  onInitiateClaim();
                },
                onChanged: (value) {
                  _healthBloc.changeOther(value);
                },
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
                  LengthLimitingTextInputFormatter(200),
                ],
                decoration: InputDecoration(
                  labelText: S
                      .of(context)
                      .other_details
                      .toUpperCase(),
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.3),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.fuchsia_pink),
                  ),
                ),
              )
            ],
          );
        });
  }

  initiateClaimShowDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            WillPopScope(
                onWillPop: () {
                  return Future<bool>.value(true);
                },
                child: Scaffold(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    body: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child:
                                          getCloseButton(onClose: onHomeScreen),
                                        ))),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(40)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: <Widget>[
                                      SizedBox(
                                          height: 190,
                                          width: 210,
                                          child: Image.asset(
                                              AssetConstants
                                                  .ic_claim_initimated)),
                                      Text(
                                        S
                                            .of(context)
                                            .claim_intimated,
                                        style: TextStyle(
                                            fontSize: 22,
                                            letterSpacing: 0.46,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(22.0),
                                        child: Text(
                                          S
                                              .of(context)
                                              .claim_intimated_subtitle,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black.withOpacity(
                                                  0.7)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(
                                            S
                                                .of(context)
                                                .claim_id,
                                            style: TextStyle(
                                                fontSize: 12.6,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                Colors.black.withOpacity(0.7)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            claimId ?? '',
                                            style: TextStyle(
                                                fontSize: 12.6,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          Text(
                                            S
                                                .of(context)
                                                .claim_status,
                                            style: TextStyle(
                                                fontSize: 12.6,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                Colors.black.withOpacity(0.7)),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            S
                                                .of(context)
                                                .claim_initiated,
                                            style: TextStyle(
                                                fontSize: 12.6,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      _bottomButtons(
                                        context,
                                        S
                                            .of(context)
                                            .track_claim_status,
                                      ),
                                      BlackButtonWidget(
                                        onHomeScreen,
                                        S
                                            .of(context)
                                            .thank_you_title
                                            .toUpperCase(),
                                        height: 45.0,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )))));
  }

  _makeApiCall(bool apiCall,
      HealthClaimIntimationRequestModel requestModel) async {
    retryIdentifier(int identifier) {
      HealthClaimIntimationRequestModel requestModel =
      HealthClaimIntimationRequestModel();
    }

    if (apiCall) {
      showLoaderDialog(context);
      final response =
      await _healthBloc.submitHealthClaimIntimation(requestModel);
      hideLoaderDialog(context);
      if (null != response.apiErrorModel) {
        handleApiError(
            context, 0, retryIdentifier, response.apiErrorModel.statusCode);
      } else {
        claimId = response.data.intimationNo;
        initiateClaimShowDialog();
      }
    }
  }

  onInitiateClaim() {
    //FocusScope.of(context).requestFocus(_remarkFocusNode);
    FocusScope.of(context).unfocus();
    HealthClaimIntimationRequestModel requestModel =
    HealthClaimIntimationRequestModel();
    requestModel.patientName = _healthBloc.patientName;
    if (hospitalNameController.text != "Not in the list")
      requestModel.hospitalName = hospitalNameController.text;
    else
      requestModel.hospitalName = hospitalName1Controller.text;
    requestModel.roomType = _healthBloc.roomType;
    requestModel.claimType = _healthBloc.typeOfClaim;
    requestModel.hospitilisationDate = _healthBloc.dateOfHospitalization;
    requestModel.dischargeDate = _healthBloc.dateOfDischarge;
    requestModel.email = _emailController.text;
    requestModel.hospitalisationReason = reasonOfHospitalizationController.text;
    requestModel.city = _cityController.text;
    requestModel.doctorName = doctorNameController.text;
    requestModel.amount = amountController.text;
    requestModel.otherDetails = otherController.text;
    requestModel.memberId = "12181048254";
    requestModel.policyNo = policyNumber;
    requestModel.contactNo = _mobileNumberController.text;
    requestModel.tPA = "medi_assist";

    setState(() {
      if (_healthBloc.amount.length == 0) onAmountSubmitted = true;
    });

    if (_healthBloc.amount.length != 0) _makeApiCall(true, requestModel);
  }

  onMoveTrackClaim() {
    FocusScope.of(context).unfocus();
    TrackHealthClaimIntimationRequestModel requestModel =
    TrackHealthClaimIntimationRequestModel();
    requestModel.policyNo = "0000000002202169-05";
    _makeTrackHealthClaimApiCall(true, requestModel);
  }

  String claimStatus,
      tpaClaimNo,
      sBigClaimNo,
      claimType,
      amountClaimed,
      hospitalName,
      dateOfHospitalization,
      paymentRefNo,
      paymentDate,
      approvedAmount;

  _makeTrackHealthClaimApiCall(bool apiCall,
      TrackHealthClaimIntimationRequestModel requestModel) async {
    retryIdentifier(int identifier) {}

    if (apiCall) {
      showLoaderDialog(context);
      final response =
      await _healthBloc.trackHealthClaimIntimation(requestModel);
      hideLoaderDialog(context);
      if (null != response.apiErrorModel) {
        handleApiError(
            context, 0, retryIdentifier, response.apiErrorModel.statusCode);
      } else {
        claimStatus = response.data[0].claimStatus;
        tpaClaimNo = response.data[0].tpaClaimNumber;
        sBigClaimNo = response.data[0].sbigClaimNumbere;
        claimType = _healthBloc.typeOfClaim;
        amountClaimed = amountController.text;
        if (hospitalNameController.text != "Not in the list")
          hospitalName = hospitalNameController.text;
        else
          hospitalName = hospitalName1Controller.text;
        dateOfHospitalization = _healthBloc.dateOfHospitalization;
        paymentRefNo = response.data[0].paymentRefNo;
        paymentDate = response.data[0].paymentDate;
        approvedAmount = response.data[0].approvedAmount;

        print(response.data[0].paymentRefNo);
        // print(response.data[0].addmissionDate);
        print(
            'claim: $claimStatus policy $policyNumber $amountClaimed $patientName $amountClaimed $paymentRefNo $approvedAmount $paymentDate');

        Navigator.of(context).pushNamed(HealthTrackClaimStatusScreen.ROUTE_NAME,
            arguments: HealthTrackClaimStatusScreenArguments(
                claimStatus,
                policyNumber,
                tpaClaimNo,
                sBigClaimNo,
                claimType,
                amountClaimed,
                patientName,
                hospitalName,
                dateOfHospitalization,
                paymentRefNo,
                paymentDate,
                approvedAmount));
      }
    }
  }

  List<String> getHospitalSuggestions(String query) {
    List<String> matches = List();
    if (hospitals != null) {
      matches.addAll(hospitals);
    }
    if (query.length == 0) {
      return matches;
    }
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    matches.add("Not in the list");
    return matches;
  }

  List<String> getCitySuggestions(String query) {
    List<String> matches = List();
    if (cities != null) {
      matches.addAll(cities);
    }
    if (query.length == 0) {
      return matches;
    }
    matches.retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));
    return matches;
  }

  _makeHospitalListApiCall() async {
    retryIdentifier(int identifier) {}

    showLoaderDialog(context);
    final response = await HealthClaimIntimationApiProvider.getInstance()
        .getHospital(_cityController.text);
    hideLoaderDialog(context);
    if (response != null) {
      if (null != response?.apiErrorModel) {
        handleApiError(
            context, 0, retryIdentifier, response.apiErrorModel.statusCode);
      } else {
        hospitals = [];
        for (int i = 0; i < response.data.length; i++)
          if (response.data[i].hospitalCity.toLowerCase() ==
              _cityController.text.toLowerCase()) {
            String hospital = response.data[i].hospitalName;
            hospitals.add(hospital);
          }
        // hospitals.add("Not in the list");
      }
    }
  }

  _makeCityApiCall() async {
    retryIdentifier(int identifier) {}

    showLoaderDialog(context);
    final response = await HealthClaimIntimationApiProvider.getInstance()
        .getCities(latitude, longitude);
    hideLoaderDialog(context);
    if (response != null) {
      if (null != response?.apiErrorModel) {
        handleApiError(
            context, 0, retryIdentifier, response.apiErrorModel.statusCode);
      } else {
        print(response.data.cities.length);
        cities = response.data.cities;
        selectedCity = response.data.selectedCity;
        _cityController.text = selectedCity;
        if (_cityController.text.length != 0) _makeHospitalListApiCall();
        if (this._currentStep < this
            ._mySteps()
            .length - 1 &&
            patientName != null &&
            _healthBloc.email.length != 0 &&
            emailErrorString == null &&
            selectedRadio != -1) {
          setState(() {
            this._currentStep = this._currentStep + 1;
          });
        }
      }
    }
  }

  Widget _bottomButtons(BuildContext context, String title) {
    return InkResponse(
      onTap: () {
        onMoveTrackClaim();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border:
            Border.all(color: ColorConstants.policy_type_gradient_color2)),
        child: Container(
          width: ScreenUtil.getInstance(context).screenPercentWidth(50),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.87,
                    color: ColorConstants.policy_type_gradient_color2),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Image.asset(
                  AssetConstants.ic_track_claim_status,
                  scale: 1.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onHomeScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    _emailController.dispose();
    otherController.dispose();
    doctorNameController.dispose();
    _cityController.dispose();
    hospitalNameController.dispose();
    hospitalName1Controller.dispose();
    _mobileNumberController.dispose();
    _emailFocusNode.dispose();
    _reasonOfHospitalizationFocusNode.dispose();
    _doctorsNameFocusNode.dispose();
    _controller.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }
}
