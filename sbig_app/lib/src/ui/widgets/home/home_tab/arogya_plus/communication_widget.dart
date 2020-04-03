import 'dart:async';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/buyer_details/communication_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/insuree_details/insuree_details_validator.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import '../../../statefulwidget_base.dart';
import '../../quick_fact_widget.dart';

class CommunicationWidget extends StatelessWidget {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  CommunicationDetailsModel communicationDetailsModel;
  String quickFact;
  int isFrom;



  CommunicationWidget(this.widgetListener, this.buyerDetailsController,
      this.controller, this.communicationDetailsModel,{this.isFrom,this.quickFact});

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: CommunicationPage(widgetListener, buyerDetailsController,
          controller, communicationDetailsModel),
      bloc: CommunicationDetailsBloc(),
    );
  }
}

class CommunicationPage extends StatefulWidgetBase {
  Function(int, bool, bool, dynamic) widgetListener;
  StreamController<int> buyerDetailsController;
  ScrollController controller;
  CommunicationDetailsModel communicationDetailsModel;
  String quickFact;
  int isFrom;

  CommunicationPage(this.widgetListener, this.buyerDetailsController,
      this.controller, this.communicationDetailsModel,{this.isFrom,this.quickFact});

  @override
  _CommunicationPageState createState() => _CommunicationPageState();
}

class _CommunicationPageState extends State<CommunicationPage>
    with CommonWidget {
  CommunicationDetailsBloc _bloc;
  String areaTitle = "";
  List<String> areasList;
  PinCodeData seletedAreaData;
  bool isAreaSelectionError = false,
      isAddressError = false,
      isPinCodeError = false;
  String areaErrorString = "",
      pincodeErrorString = "",
      plotNumberErrorString = "",
      buildingNameError = "",
      locationError,
      streetNameError;
  TextEditingController pinCodeController,
      plotNumberController,
      buildingNameController,
      streetNameController,
      locationController;
  bool onNextClicked = false;
  FocusNode pinCodeFocusNode,
      addressFocusNode,
      buildingNameFocusNode,
      streetNameFocusNode,
      locationFocusNode,
      plotNumberFocusNode;

  List<PinCodeData> dataList = List();
  String selectedArea;

  StreamSubscription<dynamic> _kSs;
  StreamSubscription<UIEvent> _uiEventStream;
  bool _pinCodeApiCallInAction = false;

  bool _shouldRequestPinFocus = true;

  @override
  void initState() {
    pinCodeController = TextEditingController();
    plotNumberController = TextEditingController();
    buildingNameController = TextEditingController();
    streetNameController = TextEditingController();
    locationController = TextEditingController();
    pinCodeFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    buildingNameFocusNode = FocusNode();
    streetNameFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    plotNumberFocusNode = FocusNode();

    areasList = List();
    _bloc = SbiBlocProvider.of<CommunicationDetailsBloc>(context);

    if (null != widget.communicationDetailsModel.pinCode) {
      pinCodeController.text = widget.communicationDetailsModel.pinCode;
      _bloc.changePincode(pinCodeController.text);
    }

    if (null != widget.communicationDetailsModel.plotNo) {
      plotNumberController.text = widget.communicationDetailsModel.plotNo;
      _bloc.changeplotNumber(plotNumberController.text);
    }

    if (null != widget.communicationDetailsModel.selectedArea) {
      selectedArea = widget.communicationDetailsModel.selectedArea;
    }

    if (null != widget.communicationDetailsModel.seletedAreaData) {
      seletedAreaData = widget.communicationDetailsModel.seletedAreaData;
    }

    if (null != widget.communicationDetailsModel.areasList) {
      areasList = widget.communicationDetailsModel.areasList;
    }

    if (null != widget.communicationDetailsModel.buildingName) {
      buildingNameController.text =
          widget.communicationDetailsModel.buildingName;
      _bloc.changeBuildingName(buildingNameController.text);
    }

    if (null != widget.communicationDetailsModel.streetName) {
      streetNameController.text = widget.communicationDetailsModel.streetName;
      _bloc.changeStreetName(streetNameController.text);
    }

//    if (null != widget.communicationDetailsModel.location) {
//      locationController.text = widget.communicationDetailsModel.location;
//      _bloc.changeLocation(locationController.text);
//    }

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (visible) {
          double offset = 0;
          if ((addressFocusNode.hasFocus)) {
            offset = 100;
          } else if (buildingNameFocusNode.hasFocus) {
            offset = 150;
          } else if (streetNameFocusNode.hasFocus) {
            offset = 170;
          } else if (locationFocusNode.hasFocus) {
            offset = 190;
          }
          widget.controller.animateTo(
            widget.controller.offset + offset,
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
    _subscribeToEventStream();
    super.initState();
  }

  @override
  void didUpdateWidget(CommunicationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buyerDetailsController.stream !=
        widget.buyerDetailsController.stream) {
      if (_kSs != null) {
        _unsubscribeToBuyerDetailsStream();
      }
      if (_uiEventStream != null) {
        _unsubscribeToEventStream();
      }
      //_subscribeToBuyerDetailsStream();
      _subscribeToBuyerDetailsStream();
    }
  }

  void _subscribeToBuyerDetailsStream() {
    _kSs = widget.buyerDetailsController.stream.listen((from) {
      if (from == InsuranceBuyerDetailsScreen.COMMUNICATION_DETAILS_WIDGET) {
        _validateInputAndProceedFurther();
      }
    });
  }

  void _unsubscribeToBuyerDetailsStream() {
    if (_kSs != null) {
      _kSs.cancel();
      _kSs = null;
    }
  }

  void _validateInputAndProceedFurther() {
    try {
      String pinCode = pinCodeController.text;
      onNextClicked = true;
      _bloc.changePincode(pinCode);
      if (!InsureeDetailsValidator.isPinValid(pinCode)) {
        onNextClicked = true;
        FocusScope.of(context).requestFocus(pinCodeFocusNode);
        return;
      }
      onNextClicked = false;
      if (InsureeDetailsValidator.isPinValid(pinCode)) {
        if (selectedArea == null) {
          setState(() {
            isAreaSelectionError = true;
          });
        } else {
          print("selectedArea " + selectedArea);
          String plotNo = plotNumberController.value.text;
          _bloc.changeplotNumber(plotNo);
          if (TextUtils.isEmpty(plotNo)) {
            onNextClicked = true;
            FocusScope.of(context).requestFocus(plotNumberFocusNode);
          } else {
            String buildingName = buildingNameController.text;
            _bloc.changeBuildingName(buildingName);
            if (TextUtils.isEmpty(buildingName)) {
              onNextClicked = true;
              FocusScope.of(context).requestFocus(buildingNameFocusNode);
            } else {
              String streetName = streetNameController.text;
              _bloc.changeStreetName(streetName);
              if (TextUtils.isEmpty(streetName)) {
                onNextClicked = true;
                FocusScope.of(context).requestFocus(streetNameFocusNode);
              } else {
//                    String location = locationController.text;
//                    _bloc.changeLocation(location);
//                    if (location.isEmpty) {
//                      Future.delayed(Duration(milliseconds: 100), () {
//                        FocusScope.of(context).requestFocus(locationFocusNode);
//                      });
//                    } else {
                widget.communicationDetailsModel.pinCode = pinCode;
                widget.communicationDetailsModel.plotNo = plotNo;
                widget.communicationDetailsModel.areasList = areasList;
                widget.communicationDetailsModel.selectedArea = selectedArea;
                widget.communicationDetailsModel.buildingName = buildingName;
                widget.communicationDetailsModel.streetName = streetName;
                //widget.communicationDetailsModel.location = location;
                widget.communicationDetailsModel.address =
                    "$plotNo, $buildingName, $streetName";
                for (PinCodeData item in dataList) {
                  if (item.LCLTY_SUBRB_TALUK_TEHSL_NM.compareTo(selectedArea) ==
                      0) {
                    widget.communicationDetailsModel.seletedAreaData = item;
                  }
                }
                widget.widgetListener(
                    InsuranceBuyerDetailsScreen.NOMINEE_DETAILS_WIDGET,
                    true,
                    false,
                    widget.communicationDetailsModel);
                //  }
              }
            }
          }
        }
      } else {
//            Future.delayed(Duration(milliseconds: 20), () {
//              FocusScope.of(context).requestFocus(pinCodeFocusNode);
//            });
      }
    } catch (e) {
      Crashlytics.instance.log('$e');
    }
  }

  @override
  void didChangeDependencies() {
    areaErrorString = S.of(context).select_area_error;
    buildingNameError = S.of(context).building_name_error;
    locationError = S.of(context).location_error;
    streetNameError = S.of(context).street_name_error;

    plotNumberErrorString = S.of(context).address_error;

    if (areaTitle.isEmpty) {
      areaTitle = S.of(context).select_area_title.toUpperCase();
    }

    pinCodeController.addListener(() {
      if (areaTitle.compareTo(S.of(context).select_area_title) != 0 &&
          pinCodeController.text.length != 6) {
        setState(() {
          selectedArea = null;
          isAreaSelectionError = false;
          areaTitle = S.of(context).select_area_title;
          areasList.clear();
        });
      }
    });

    if (_shouldRequestPinFocus &&
        widget.communicationDetailsModel.pinCode == null) {
      FocusScope.of(context).requestFocus(pinCodeFocusNode);
    }
    _shouldRequestPinFocus = false;
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
          S.of(context).communication_details_title,
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).communication_details_subtitle,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 10,
        ),
        pinWidget(),
        SizedBox(
          height: 20,
        ),
        areaWidget(),
        Visibility(
            visible: isAreaSelectionError,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                areaErrorString,
                style: TextStyle(color: ColorConstants.shiraz, fontSize: 12),
              ),
            )),
        SizedBox(
          height: 20,
        ),
        plotNumberWidget(),
        SizedBox(
          height: 10,
        ),
        buildingNameWidget(),
        SizedBox(
          height: 10,
        ),
        streetNameWidget(),
        SizedBox(
          height: 20,
        ),
        //locationWidget(),
        //SizedBox(height: 30,),
        QuickFactWidget((widget.quickFact == null)?StringDescription.quick_fact3:widget.quickFact),
      ],
    );
  }

  areaWidget() {
    onSelection(String value, int position) {
      if (value != null) {
        selectedArea = value;
        setState(() {
          isAreaSelectionError = false;
        });
      }
    }

    return DropDownWidget(areaTitle, areasList, onSelection, selectedArea);
  }

  pinWidget() {
    return StreamBuilder<Object>(
        stream: _bloc.pincodeStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          pincodeErrorString = "";
          bool _onSubmit = (onNextClicked);
          if (isError) {
            switch (snapshot.error) {
              case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                pincodeErrorString =
                    _onSubmit ? S.of(context).pincode_empty : "";
                break;
              case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                pincodeErrorString =
                    _onSubmit ? S.of(context).pincode_invalid : "";
                break;
            }
          }
          return Stack(
            children: <Widget>[
              Theme(
                  data: new ThemeData(
                      primaryColor: Colors.black,
                      accentColor: Colors.black,
                      hintColor: Colors.black),
                  child: Container(
                    child: TextField(
                      focusNode: pinCodeFocusNode,
                      controller: pinCodeController,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp("[ A-Za-z0-9,./-]")),
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: (value) {
                        onNextClicked = false;
                        _bloc.changePincode(value);
                        if (value.length == 6) {
                          if (!_pinCodeApiCallInAction) {
                            _pinCodeApiCallInAction = true;
                            getAreas(value);
                          }
                        }
                      },
                      decoration: InputDecoration(
                        labelText: S.of(context).pincode_title.toUpperCase(),
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            letterSpacing: 1.0,
                            color: Colors.grey[600]),
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        errorText: pincodeErrorString.isNotEmpty
                            ? pincodeErrorString
                            : null,
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
                              color: (pincodeErrorString.isEmpty)
                                  ? ColorConstants.fuchsia_pink
                                  : ColorConstants.shiraz),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                  right: 0,
                  top: 20,
                  child: SizedBox(height: 20, width: 20, child: image))
              //})
            ],
          );
        });
  }

  getAreas(String pincode) async {
    //if(Platform.isIOS) pinCodeFocusNode.unfocus();
    pinCodeFocusNode.unfocus();
    showLoaderDialog(context);
    try {
      var response = await _bloc.getAreas(pincode);
      _pinCodeApiCallInAction = false;
      if (response != null) {
        hideLoaderDialog(context);
//        if(Platform.isAndroid) {
//          Future.delayed(Duration(milliseconds: 500), () {
//            FocusScope.of(context).unfocus();
//          });
//        }
        List<PinCodeData> data = response.data;
        List<String> tempAreasList = List();
        String tempAreaTitle = "";
        dataList.clear();
        dataList.addAll(data);
        for (PinCodeData area in data) {
          tempAreasList.add(area.LCLTY_SUBRB_TALUK_TEHSL_NM);
          tempAreaTitle = "Select Area(${area.CITY_NM})".toUpperCase();
        }
        if (tempAreasList.isNotEmpty) {
          setState(() {
            areaTitle = tempAreaTitle;
            selectedArea = null;
            areasList = tempAreasList;
          });
        } else {
          seletedAreaData = null;
          selectedArea = null;
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(S
                .of(context)
                .communication_details_no_area_available_error_message),
          ));
        }
      }
    } catch (e) {
      _pinCodeApiCallInAction = false;
      debugPrint(e.toString());
    }
  }

  plotNumberWidget() {
    return StreamBuilder<String>(
        stream: _bloc.plotNumberStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool _onSubmit = (onNextClicked) &&
              pinCodeController.text.length == 6 &&
              selectedArea != null;
          if (isError) {
            switch (snapshot.error) {
              case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                //image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                plotNumberErrorString =
                    _onSubmit ? S.of(context).plot_no_error : "";
                break;
              case InsureeDetailsValidator.NAME_LENGTH_ERROR:
                //image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                plotNumberErrorString =
                    _onSubmit ? S.of(context).plot_no_length_error : "";
                break;
            }
          } else {
            plotNumberErrorString = "";
          }

          return Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: TextFormField(
              focusNode: addressFocusNode,
              controller: plotNumberController,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[ A-Za-z0-9,./-]")),
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                _bloc.changeplotNumber(value);
              },
              decoration: InputDecoration(
                labelText: S.of(context).plot_number.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[600]),
                errorText: plotNumberErrorString.isNotEmpty
                    ? plotNumberErrorString
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                //errorText: mobileErrorString,
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
              ),
            ),
          );
        });
  }

  buildingNameWidget() {
    return StreamBuilder<String>(
        stream: _bloc.buildingNameStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool _onSubmit = (onNextClicked) &&
              pinCodeController.text.length == 6 &&
              selectedArea != null &&
              plotNumberController.text != null;
          if (isError) {
            switch (snapshot.error) {
              case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                buildingNameError =
                    _onSubmit ? S.of(context).building_name_error : "";
                break;
            }
          } else {
            buildingNameError = "";
          }

          return Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: TextFormField(
              focusNode: buildingNameFocusNode,
              controller: buildingNameController,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[ A-Za-z0-9,./-]")),
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                _bloc.changeBuildingName(value);
              },
              decoration: InputDecoration(
                labelText: S.of(context).building_name_title.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[600]),
                errorText:
                    buildingNameError.isNotEmpty ? buildingNameError : null,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                //errorText: mobileErrorString,
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
              ),
            ),
          );
        });
  }

  streetNameWidget() {
    return StreamBuilder<String>(
        stream: _bloc.streetNameStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool _onSubmit = (onNextClicked) &&
              pinCodeController.text.length == 6 &&
              selectedArea != null &&
              plotNumberController.text != null &&
              buildingNameController.text != null;
          if (isError) {
            switch (snapshot.error) {
              case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                streetNameError =
                    _onSubmit ? S.of(context).street_name_error : "";
                break;
            }
          } else {
            streetNameError = "";
          }

          return Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: TextFormField(
              focusNode: streetNameFocusNode,
              controller: streetNameController,
              onEditingComplete: () {
                _validateInputAndProceedFurther();
              },
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[ A-Za-z0-9,./-]")),
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                _bloc.changeStreetName(value);
              },
              decoration: InputDecoration(
                labelText: S.of(context).street_name_title.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[600]),
                errorText: streetNameError.isNotEmpty ? streetNameError : null,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                //errorText: mobileErrorString,
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
              ),
            ),
          );
        });
  }

  locationWidget() {
    return StreamBuilder<String>(
        stream: _bloc.locationStream,
        builder: (context, snapshot) {
          bool isError = snapshot.hasError;
          bool _onSubmit = (onNextClicked) &&
              pinCodeController.text.length == 6 &&
              selectedArea != null &&
              plotNumberController.text != null &&
              buildingNameController.text != null &&
              streetNameController.text != null;
          if (isError) {
            switch (snapshot.error) {
              case InsureeDetailsValidator.NAME_EMPTY_ERROR:
                locationError = _onSubmit ? S.of(context).location_error : "";
                break;
            }
          } else {
            locationError = "";
          }

          return Theme(
            data: new ThemeData(
                primaryColor: Colors.black,
                accentColor: Colors.black,
                hintColor: Colors.black),
            child: TextField(
              focusNode: locationFocusNode,
              controller: locationController,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
                LengthLimitingTextInputFormatter(50),
              ],
              onChanged: (value) {
                _bloc.changeLocation(value);
              },
              decoration: InputDecoration(
                labelText: S.of(context).location_title.toUpperCase(),
                labelStyle: TextStyle(
                    fontSize: 12.0,
                    letterSpacing: 1.0,
                    color: Colors.grey[600]),
                errorText: locationError.isNotEmpty ? locationError : null,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[500]),
                ),
                //errorText: mobileErrorString,
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.shiraz),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: ColorConstants.fuchsia_pink),
                ),
              ),
            ),
          );
        });
  }

  _subscribeToEventStream() {
    _bloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      if (event is DialogEvent) {
        DialogEvent de = event;
        handleApiError(context, 0,(int retryIdentifier) {
          getAreas(pinCodeController.text);
        }, event.dialogType);
        /*switch (de.dialogType) {
          case DialogEvent.DIALOG_TYPE_NETWORK_ERROR:
            showNoInternetDialog(
              context,
              0,
              (int retryIdentifier) {
                getAreas(pinCodeController.text);
              },
            );
            break;
          case DialogEvent.DIALOG_TYPE_OH_SNAP:
            showServerErrorDialog(context, 0, (int retryIdentifier) {
              getAreas(pinCodeController.text);
            });
            break;
        }*/
      } else if (event is SnackBarEvent) {
        SnackBarEvent sbe = event;
        String messageToShow = S.of(context).something_went_wrong;
        if (sbe.message == CommunicationPageSnackBarMessageKeys.invalid_pin) {
          messageToShow = S
              .of(context)
              .communication_details_no_area_available_error_message;
        }
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(messageToShow),
        ));
      }
    });
  }

  _unsubscribeToEventStream() {
    _uiEventStream?.cancel();
    _uiEventStream = null;
  }

  @override
  void dispose() {
    //_bloc.dispose();
    plotNumberController.dispose();
    pinCodeController.dispose();
    buildingNameController.dispose();
    streetNameController.dispose();
    locationController.dispose();

    pinCodeFocusNode.dispose();
    plotNumberFocusNode.dispose();
    streetNameFocusNode.dispose();
    buildingNameFocusNode.dispose();
    addressFocusNode.dispose();
    locationFocusNode.dispose();

    _unsubscribeToBuyerDetailsStream();
    _unsubscribeToEventStream();
    super.dispose();
  }
}
