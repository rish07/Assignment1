
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_validators.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/controllers/service/location_service.dart';

import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_list_response.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_suggestion.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/widgets/common/bottom_dialog.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/dash_separator.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/auto_complete_text_field.dart';

import 'package:sbig_app/src/utilities/permission_service.dart';
import 'package:sbig_app/src/utilities/recase.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkHospitalScreen extends StatelessWidget {
  static const ROUTE_NAME = "/network_hospital/network_hospital";

  NetworkHospitalScreen();

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: NetworkHospitalBloc(),
      child: _NetworkHospitalListScreenInternal(),
    );
  }
}
class _NetworkHospitalListScreenInternal extends StatefulWidget {
  @override
  _NetworkHospitalListState createState() => _NetworkHospitalListState();
}

class _NetworkHospitalListState extends State<_NetworkHospitalListScreenInternal> with CommonWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchBoxTextController;
  NetworkHospitalBloc _networkHospitalBloc;
  SelectionChipItemIds _selectedId = SelectionChipItemIds.ALL;
  String selectedTpaCategory = NetworkHospitalBloc.TPA_CATEGORY_ALL;
  String keyWord = '';
  String latitude = '', longitude = '';

  ScrollController _listScrollController = ScrollController();
  final List<SelectionChipItem> _availableChipItems = [];
  bool isFirst = true;
  LocationService locationService = LocationService.getInstance();
  List<String> suggestions = [];
  List<SuggestionData> oldSuggestions = [];
  List<SuggestionData> areaSuggestions = [];
  //SimpleAutoCompleteTextField simpleAutoCompleteTextField;
  AutoCompleteTextField<SuggestionData> textField;
  GlobalKey<AutoCompleteTextFieldState<SuggestionData>> key = new GlobalKey();
  SuggestionData selected;
  Location location;
  bool _serviceEnabled=false;
  List<ResponseData> _hospitalList = [];



  @override
  void initState() {
    _networkHospitalBloc = SbiBlocProvider.of<NetworkHospitalBloc>(context);
    location = new Location();
    _searchBoxTextController = TextEditingController();
    _availableChipItems.add(
      SelectionChipItem(' All ', SelectionChipItemIds.ALL,
          _findSelectionChipOnClickById(SelectionChipItemIds.ALL)),
    );
    _availableChipItems.add(SelectionChipItem(
        'Medi Assist',
        SelectionChipItemIds.MEDI_ASSIST,
        _findSelectionChipOnClickById(SelectionChipItemIds.MEDI_ASSIST)));
    _availableChipItems.add(SelectionChipItem(
        ' Paramount ',
        SelectionChipItemIds.PARAMOUNT,
        _findSelectionChipOnClickById(SelectionChipItemIds.PARAMOUNT)));
    _checkService();
    _autoCompleteTextField();
    if (!prefsHelper.isFirstTimeNetworkHospital()) {
      _getLocation();
    }else{
      _networkHospitalBloc.changeIsFirst(true);
    }
    _networkHospitalBloc.changeGpsIconStatus(true);
    _listenToEvents();
    super.initState();
  }

  void _listenToEvents() {
    _networkHospitalBloc.eventStream.listen((event) {

      if (event is DialogEvent) {
        DialogEvent de = event;
        handleApiError(context, 0, (int retryIdentifier) {
          _callListAPi();
        }, event.dialogType);
      } else if (event is SnackBarEvent) {
        SnackBarEvent snackBarEvent = event;
        _scaffoldKey.currentState.showSnackBar((SnackBar(
          content: Text(snackBarEvent.payload.toString()),
        )));
      }
    });

    _listScrollController.addListener(() {
      if (_listScrollController.position.pixels ==
          _listScrollController.position.maxScrollExtent) {
        if (!_networkHospitalBloc.loadMoreEnabled) {
          _networkHospitalBloc.hospitalListTryToLoadMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorConstants.personal_details_bg_color,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getAppBar(
                        context, S.of(context).hospital_locator.toUpperCase(),
                        onBackPressed: _onAppBarBackPresses, isFrom: 0),
                    SizedBox(
                      height: 5,
                    ),
                    //_searchBox(_searchButtonVisibility),
                    _autoCompleteSearchBox(),
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///All, Media, Paramount UI
                      _selectionChipWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: StreamBuilder<List<ResponseData>>(
                            stream: _networkHospitalBloc.hospitalListStream,
                            builder: (context, snapshot) {
                              if (snapshot != null) {
                                if ((snapshot.hasData &&
                                    snapshot.data != null)) {
                                  if (snapshot.data.length == 0 && !_networkHospitalBloc.isLoading) {
                                    return Center(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(bottom: 50.0),
                                        child: Text(
                                          S.of(context).no_hospital,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<ResponseData> list = snapshot.data;
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 25, right: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: Text(
                                              "${_networkHospitalBloc.getTotalSearchResult()} ${S.of(context).n_search_result}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MediaQuery.removePadding(
                                            context: context,
                                            removeTop: true,
                                            child: ListView.builder(
                                              controller: _listScrollController,
                                              itemCount: list.length,
                                              itemBuilder: (context, pos) {
                                                return _listItem(
                                                    list[pos],
                                                    pos,
                                                    list.length - 1 == pos,
                                                    _networkHospitalBloc.isThereDataToLoad());
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                } else {
                                  return Container(
                                    height: 0,
                                    width: 0,
                                  );
                                }
                              } else {
                                return Container(
                                  height: 0,
                                  width: 0,
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          StreamBuilder<bool>(
              stream: _networkHospitalBloc.isLoadingStream,
              builder: (context, snapshot) {
                bool isVisible = false;
                if (snapshot != null && (snapshot.hasData && snapshot.data)) {
                  isVisible = true;
                }
                return Visibility(
                  visible: isVisible,
                  child: LoadingScreen(),
                );
              }),
          StreamBuilder<bool>(
              stream: _networkHospitalBloc.isFirstStream,
              builder: (context, snapshot) {
                bool isVisible = false;
                if (snapshot != null && (snapshot.hasData && snapshot.data)) {
                  isVisible = _networkHospitalBloc.isFirst;
                }
                return Visibility(
                  visible: isVisible,
                  child: Opacity(
                    opacity: 0.8,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                );
              }),
          StreamBuilder<bool>(
              stream: _networkHospitalBloc.isFirstStream,
              builder: (context, snapshot) {
                bool isVisible = false;
                if (snapshot != null && (snapshot.hasData && snapshot.data)) {
                  isVisible = _networkHospitalBloc.isFirst;
                }
                return Visibility(
                  visible: isVisible,
                  child: instruction(),
                );
              }),
        ],
      ),
    );
  }

  Widget _autoCompleteTextField(){
    return textField = new AutoCompleteTextField<SuggestionData>(
      decoration: InputDecoration(
        alignLabelWithHint: false,
        border: InputBorder.none,
        hintText: "Search by Area or Pincode",
        hintStyle: TextStyle(fontSize: 13,color: Colors.black26),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp('[A-Za-z0-9 ,.]')),
      ],
      controller: _searchBoxTextController,
      clearOnSubmit: false, /// should be always false.. else it will clear the text from textfield
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
      itemSubmitted: (item){
        setState((){
          textField.textField.controller.text=item.autoCompleteSearch;
          _searchBoxTextController.text=item.autoCompleteSearch;
          //_networkCall(item.autoCompleteSearch);
        });
      },
      key: key,
      suggestions: areaSuggestions,
      suggestionsAmount: 10,
      textInputAction: TextInputAction.done,
      itemBuilder: (context, suggestion){
        bool area = suggestion?.area !=null || suggestion?.pincode!=null  || suggestion.area!=''|| suggestion.pincode!=''  ;
        return Padding(
          padding: EdgeInsets.only(top:5.0,bottom: 5.0,right: 10.0,left: 10.0),
          child:Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if(suggestion?.area !=null || suggestion.area!='' )
                      Text( suggestion.area ,style: TextStyle(fontSize:13),softWrap: true, ),
                    if(suggestion?.pincode !=null || suggestion.pincode!='' )
                      Text( suggestion.pincode ,style: TextStyle(fontSize:13),softWrap: true, ),
                    if(area && suggestion?.city !=null && suggestion?.state!=null)
                      Text(suggestion.city+', '+suggestion.state,style: TextStyle(fontSize:13,color: Colors.grey),softWrap: true,),
                    if(!area && suggestion?.city !=null && suggestion.city!='')
                      Text(suggestion.city,style: TextStyle(fontSize:13,color: Colors.grey),softWrap: true,),
                    if(!area && suggestion?.state !=null && suggestion.state!='' )
                      Text(suggestion.state,style: TextStyle(fontSize:13,color: Colors.grey),softWrap: true,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetConstants.ic_network_search_arrow,height: 10.0,width: 10.0,),
              ),

            ],
          ),
        );
      },
      itemSorter: (a, b) => a.autoCompleteSearch.compareTo(b.autoCompleteSearch),
      itemFilter: (suggestion, input) => suggestion.autoCompleteSearch.toLowerCase().contains(input.toLowerCase()),
      textChanged: (value) async {
        _removePinCodeErrorMessage();
        if ( value.length ==0) {
          _networkHospitalBloc.changeGpsIconStatus(true);
        }
        if(value.length >= 1 || value.length < 3){
          _networkHospitalBloc.changeGpsIconStatus(false);
        }
        if (value.length == 3 ) {
          _networkCall(value);
        }

        if( value.length == 6){
          _networkCall(value);
        }
      },
    );
  }

  _networkCall(dynamic value) async{
    await _networkHospitalBloc.getHospitalSuggestionList(value.toString());
    textField.updateSuggestions(_networkHospitalBloc.areaSuggestionList ?? []);
    _networkHospitalBloc.changeGpsIconStatus(false);
    setState(() {
      areaSuggestions=_networkHospitalBloc.areaSuggestionList ??[];
    });
  }

  Widget _autoCompleteSearchBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13.0, 2.0, 8.0, 3.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: ColorConstants.light_gray, width: 1)),
                    child: _autoCompleteTextField(),
                  ),
                ),
              ),

              ///Added for phase 1 new design with current detection option
              InkWell(
                onTap: () {
                  if (!_networkHospitalBloc.gpsIcon) {
                    latitude = '';
                    longitude = '';
                    keyWord = _searchBoxTextController.text;
                    _callListAPi(freshList: true);
                    setState(() {
                      _networkHospitalBloc.changeGpsIconStatus(true);
                    });
                  } else {
                    _getLocation();
                  }
                },
                child: StreamBuilder<bool>(
                    stream: _networkHospitalBloc.gpsIconStream,
                    builder: (context, snapshot) {
                      bool isVisible = false;
                      if (snapshot != null &&
                          (snapshot.hasData && snapshot.data)) {
                        isVisible = _networkHospitalBloc.gpsIcon;
                      }
                      return Container(
                        padding: EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: (isVisible)?Border.all(
                                color: ColorConstants.light_gray, width: 1):null,
                            gradient: (!isVisible)?LinearGradient(colors: [
                              ColorConstants.button_gradient_color1,
                              ColorConstants.button_gradient_color2
                            ]):null),
                        margin: EdgeInsets.only(right: 10),
                        child: (!isVisible)?Image(
                            height: 20.0,
                            width: 20.0,
                            image: AssetImage(AssetConstants.ic_network_search)):Image(
                          height: 20.0,
                          width: 20.0,
                          image: AssetImage(AssetConstants.ic_gps),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 25),
          child: StreamBuilder<String>(
              stream: _networkHospitalBloc.searchBoxPinCodeErrorStream,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData,
                  child: Text(
                    snapshot.data ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                );
              }),
        )
      ],
    );
  }

  Widget instruction() {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 90,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(13.0, 2.0, 8.0, 3.0),
                      child: Text(
                        '|Kalyan Nagar, Bangalore',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: EdgeInsets.only(right: 20),
                  child: Image(
                    image: AssetImage(AssetConstants.ic_gps),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Align(
              alignment: Alignment(-1, -0.5),
              child: Image(
                image: AssetImage(AssetConstants.ic_arrow_short),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Align(
              alignment: Alignment(-1, -0.3),
              child: Text(
                S.of(context).network_hospital_instruction_1,
                style: TextStyle(
                    fontFamily: StringConstants.BRADLEY_HAND,
                    color: Colors.white,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
              alignment: Alignment(1, -0.4),
              child: Image(
                height: 170,
                image: AssetImage(AssetConstants.ic_arrow_long),
              )),
        ),
        Padding(
          padding: EdgeInsets.only(right: 25.0),
          child: Align(
              alignment: Alignment(1, 0.05),
              child: Text(
                S.of(context).network_hospital_instruction_2,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: StringConstants.BRADLEY_HAND,
                  color: Colors.white,
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              )),
        ),
        Align(
          alignment: Alignment(0.0, 0.6),
          child: Padding(
            padding: const EdgeInsets.only(left: 90.0, right: 90.0),
            child: MaterialButton(
              height: 50.0,
              minWidth: double.maxFinite,
              color: ColorConstants.button_blue,
              onPressed: () {
                _networkHospitalBloc.changeIsFirst(false);
                prefsHelper.setToFirstNetworkHospitalDone();
                _getLocation();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              textColor: Colors.white,
              highlightColor: Colors.grey[800],
              highlightElevation: 5.0,
              child: Text(S.of(context).ok_got_it,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0)),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _selectionItemWidgetList(double totalAvailableWidth, double spaceBetween) {
    List<Widget> _list = [];
    _availableChipItems.asMap().forEach((position, item) {
      _list.add(_selectionChipItem(item, totalAvailableWidth));
      if (position != _availableChipItems.length - 1) {
        _list.add(
          SizedBox(
            height: spaceBetween,
            width: spaceBetween,
          ),
        );
      }
    });
    return _list;
  }

  Function _findSelectionChipOnClickById(SelectionChipItemIds id) {
    switch (id) {
      case SelectionChipItemIds.ALL:
        return () {
          if (_isAValidCode()) {
            selectedTpaCategory = NetworkHospitalBloc.TPA_CATEGORY_ALL;
            _callListAPi(freshList: true);
            if (_selectedId != SelectionChipItemIds.ALL) {
              setState(() {
                _selectedId = SelectionChipItemIds.ALL;
              });
            }
          } else {
            _addPinCodeErrorMessage();
          }
        };
        break;
      case SelectionChipItemIds.MEDI_ASSIST:
        return () {
          if (_isAValidCode()) {
            selectedTpaCategory = NetworkHospitalBloc.TPA_CATEGORY_MEDI_ASSIST;
            _callListAPi(freshList: true);
            if (_selectedId != SelectionChipItemIds.MEDI_ASSIST) {
              setState(() {
                _selectedId = SelectionChipItemIds.MEDI_ASSIST;
              });
            }
          } else {
            _addPinCodeErrorMessage();
          }
        };
        break;
      case SelectionChipItemIds.PARAMOUNT:
        return () {
          if (_isAValidCode()) {
            selectedTpaCategory = NetworkHospitalBloc.TPA_CATEGORY_PARAMOUNT;
            _callListAPi(freshList: true);
            if (_selectedId != SelectionChipItemIds.PARAMOUNT) {
              setState(() {
                _selectedId = SelectionChipItemIds.PARAMOUNT;
              });
            }
          } else {
            _addPinCodeErrorMessage();
          }
        };
        break;
      default:
        throw Exception("Unidentified chip item");
    }
  }

  double findSelectionChipItemWidthFractionById(SelectionChipItemIds id) {
    int totalChars = 0;
    SelectionChipItem _foundItemById;
    _availableChipItems.forEach((item) {
      totalChars += item.name.length;
      if (item.id == id) {
        _foundItemById = item;
      }
    });
    if (_foundItemById == null || totalChars == 0) return 0;
    return _foundItemById.name.length / totalChars;
  }

  Widget _selectionChipItem(SelectionChipItem selectionChipItem, double totalAvailableWidth) {
    bool isSelected = selectionChipItem.id == _selectedId;
    double widthFraction =
    findSelectionChipItemWidthFractionById(selectionChipItem.id);
    return InkResponse(
      onTap: selectionChipItem.onClick,
      child: AnimatedContainer(
        alignment: Alignment.center,
        width: totalAvailableWidth * widthFraction,
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [
              ColorConstants.button_gradient_color1,
              ColorConstants.button_gradient_color2
            ])
                : null,
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: isSelected
                ? Border.all(color: Colors.transparent)
                : Border.all(color: Colors.grey.shade500)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              selectionChipItem.name.toUpperCase(),
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                  letterSpacing: .6,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listItem(ResponseData hospitalData, int position, bool isLastItem, bool isThereDataToLoad) {
    String hospitalAddress = hospitalData.hospitalAddress1;
    if (!TextUtils.isEmpty(hospitalData.hospitalAddress2)) {
      hospitalAddress += "\n";
      hospitalAddress += hospitalData.hospitalAddress2;
    }

    if (!TextUtils.isEmpty(hospitalData.hospitalArea)) {
      hospitalAddress += "\n";
      hospitalAddress += hospitalData.hospitalArea;
    }

    if (!TextUtils.isEmpty(hospitalData.hospitalCity)) {
      hospitalAddress += "\n";
      hospitalAddress += hospitalData.hospitalCity;
    }

    if (!TextUtils.isEmpty(hospitalData.hospitalPincode)) {
      hospitalAddress += "\n";
      hospitalAddress += hospitalData.hospitalPincode;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 5),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ReCase(
                              hospitalData.hospitalName,
                            ).titleCase,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            hospitalAddress,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            hospitalData.hospitalState.toUpperCase(),
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      _listItemButton(AssetConstants.ic_phone_wb, () {
                        List<String> phoneNumberList = [];
                        if (!_isStringEmpty(hospitalData.mobileNo1)) {
                          List<String> phnList2 =
                          hospitalData.mobileNo1.split("/");
                          List<String> tmpl = [];
                          int size = phnList2.length;
                          for (int i = 0; i < size; i++) {
                            if (phnList2[i].trim().length > 3) {
                              tmpl.add(phnList2[i].trim());
                            }
                          }
                          phoneNumberList.addAll(tmpl);
                        }

                        if (!_isStringEmpty(hospitalData.mobileNo2)) {
                          List<String> phnList2 =
                          hospitalData.mobileNo2.split("/");
                          List<String> tmpl = [];
                          int size = phnList2.length;
                          for (int i = 0; i < size; i++) {
                            if (phnList2[i].trim().length > 3) {
                              tmpl.add(phnList2[i].trim());
                            }
                          }
                          phoneNumberList.addAll(tmpl);
                        }

                        if (phoneNumberList.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                            Text(S.of(context).phone_number_unavailable),
                          ));
                        } else {
                          if (Platform.isIOS) {
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return BottomDialog(
                                    child: _getPhoneDialogBody2(
                                        hospitalData.hospitalName,
                                        phoneNumberList),
                                  );
                                });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return BottomDialog(
                                    child: _getPhoneDialogBody2(
                                        hospitalData.hospitalName,
                                        phoneNumberList),
                                  );
                                });
                          }
                        }
                      }),
                      SizedBox(
                        height: 8,
                      ),
                      _listItemButton(AssetConstants.ic_gps_pin, () {
//                        if (_isStringEmpty(hospitalData.latitude) &&
//                            _isStringEmpty(hospitalData.longitude)) {
//                          _scaffoldKey.currentState.showSnackBar(
//                            SnackBar(
//                              content:
//                              Text(S.of(context).location_info_unavailable),
//                            ),
//                          );
//                        } else {
                        CommonUtil.openMap(
                            hospitalData.latitude,
                            hospitalData.longitude,
                            hospitalData.hospitalName,
                            hospitalData.location)
                            .then((success) {
                          if (!success) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(S.of(context).something_went_wrong),
                            ));
                          }
                        });
                        //}
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLastItem,
          child: isThereDataToLoad ? _listBottomLoader() : _endOfListItem(),
        ),
      ],
    );
  }

  Widget _listBottomLoader() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 50),
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _endOfListItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: DashSeparator(),
          ),
          Container(
            margin: EdgeInsets.only(left: 8, right: 6),
            child: Image(
              height: 18,
              width: 12.6,
              image: AssetImage(AssetConstants.ic_rocking),
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 8),
              child: Text(
                S.of(context).end_of_the_list,
                style: TextStyle(
                    fontFamily: StringConstants.EFFRA_LIGHT,
                    fontSize: 12,
                    letterSpacing: 0.5,
                    color: Colors.black),
              )),
          Expanded(
            child: DashSeparator(),
          ),
        ],
      ),
    );
  }

  Widget _listItemButton(String icon, Function() onClick) {
    return InkWell(
      child: Image(
        height: 35,
        width: 35,
        image: AssetImage(icon),
      ),
      onTap: onClick,
    );
  }

  void _onAppBarBackPresses(int d) {
    Navigator.of(context).pop();
  }

  void _getCurrentLocation() async {
    _networkHospitalBloc.changeLoader(true);
    try {
      UserLocation location = await locationService.getCurrentLocation();
      if (location != null) {
        print('LATITUDE : ${location.latitude}');
        print('LONGITUDE : ${location.longitude}');
        latitude = location.latitude.toString();
        longitude = location.longitude.toString();

        List<Placemark> placeMarks = await locationService.getLocationAddress(location.latitude, location.longitude);
        if (placeMarks != null && placeMarks.isNotEmpty) {
          final Placemark pos = placeMarks[0];
          keyWord = pos.locality + ', ' + pos.administrativeArea;
          _searchBoxTextController.text = keyWord;
        }
        _callListAPi(freshList: true);
        if (prefsHelper.isFirstTimeNetworkHospital()) {
          _networkHospitalBloc.changeIsFirst(true);
        } else {
          _networkHospitalBloc.changeIsFirst(false);
        }
      }else{
        _networkHospitalBloc.changeLoader(false);
      }

    } catch (e) {
      _networkHospitalBloc.changeLoader(false);
      hideLoaderDialog(context);
    }
  }

  void _getLocation() async{

    checkLocationPermission(() {
      if( _serviceEnabled ){
        _getCurrentLocation();
      }else{
        _networkHospitalBloc.changeHospitalList(_hospitalList);
        _requestGPSService();
        //_checkGps();
      }
    });
  }

  _requestGPSService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Can't get gurrent location"),
              content:
              const Text('Please make sure you enable GPS and try again'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                  /*  final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();*/
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  _checkService() async {
    bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  void checkLocationPermission(Function taskToExecuteIfGranted) {
    PermissionService().requestPermission(PermissionGroup.location,
        onGranted: () {
          _checkService();
          taskToExecuteIfGranted();
        }, onDenied: () {
          if (prefsHelper.isFirstTimeNetworkHospital()) {
            _networkHospitalBloc.changeIsFirst(true);
          } else {
            _networkHospitalBloc.changeIsFirst(false);
          }
          _networkHospitalBloc.changeHospitalList(_hospitalList);
        }, onUserCheckedNeverOnAndroid: () {
          if (prefsHelper.isFirstTimeNetworkHospital()) {
            _networkHospitalBloc.changeIsFirst(true);
          } else {
            _networkHospitalBloc.changeIsFirst(false);
          }
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.of(context).need_location_permission),
          ));
          _networkHospitalBloc.changeHospitalList(_hospitalList);
          /* showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(S.of(context).need_storage_permission),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    S.of(context).open_settings,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    PermissionHandler().openAppSettings();
                  },
                ),
              ],
            );
          });*/
        });
  }

  void _callListAPi({bool freshList = false}) {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {}
    if (freshList) {
      _networkHospitalBloc.fetchFreshHospitalList(keyWord, selectedTpaCategory,
          latitude: latitude.toString() ?? '',
          longitude: longitude.toString() ?? '');
    } else {
      _networkHospitalBloc.getHospitalList(keyWord, selectedTpaCategory,
          latitude: latitude.toString() ?? '',
          longitude: longitude.toString() ?? '');
    }
  }

  Widget _getPhoneDialogBody(String hospitalName, String phone1, String phone2) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(50)),
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 30),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    height: 38,
                    width: 51,
                    child: Image(
                      image: AssetImage(AssetConstants.ic_home_connect_with_us),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      S.of(context).connect_us_title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 0.5),
                    ),
                  )
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  hospitalName,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.39),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkResponse(
                  child: Text(
                    phone1,
                    style: TextStyle(
                        color: ColorConstants.claim_intimation_call_color2,
                        fontSize: 16),
                  ),
                  onTap: () {
                    launch("tel:$phone1");
                  },
                ),
                TextUtils.isEmpty(phone2)
                    ? Container(
                  height: 0,
                  width: 0,
                )
                    : InkResponse(
                  child: Container(
                    margin: EdgeInsets.only(top: 6),
                    child: Text(
                      phone2,
                      style: TextStyle(
                          color:
                          ColorConstants.claim_intimation_call_color2,
                          fontSize: 16),
                    ),
                  ),
                  onTap: () {
                    launch("tel: $phone2");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Widget _getPhoneDialogBody2(String hospitalName, List<String> phones) {
    return SafeArea(
      bottom: false,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(50)),
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      height: 38,
                      width: 51,
                      child: Image(
                        image:
                        AssetImage(AssetConstants.ic_home_connect_with_us),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        S.of(context).connect_us_title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 0.5),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    hospitalName,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.39),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _phoneListView(phones),
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _phoneListView(List<String> phones) {
    List<Widget> _pl = [];
    bool cond = true;
    int index = 0;
    while (cond) {
      List<Widget> _tempWL = [];
      if (phones.length > index) {
        _tempWL.add(_phoneListItem(phones[index]));
        index++;
        if (phones.length > index) {
          _tempWL.add(Text(
            " / ",
            style: _phoneNumberTextStyle(),
          ));
          _tempWL.add(_phoneListItem(phones[index]));
          index++;
        }
      }
      _pl.add(Container(
        margin: EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _tempWL,
        ),
      ));
      cond = (phones.length > index);
    }
    /*phones.asMap().forEach((index, item) {
      _pl.add(_phoneListItem(item));
      _pl.add(Text("/", style: _phoneNumberTextStyle(),));
    });*/
    return _pl;
  }

  Widget _phoneListItem(String phone) {
    return InkResponse(
      child: Container(
        child: Text(
          phone,
          style: _phoneNumberTextStyle(),
        ),
      ),
      onTap: () {
        launch("tel:$phone");
      },
    );
  }

  TextStyle _phoneNumberTextStyle() {
    return TextStyle(
        color: ColorConstants.claim_intimation_call_color2, fontSize: 16);
  }

  bool _isAValidPinCode() {
    return NetworkHospitalValidators.isAValidPinCode(
        _searchBoxTextController.text);
  }

  bool _isAValidCode() {
    return NetworkHospitalValidators.isAValidCode(
        _searchBoxTextController.text);
  }

  void _addPinCodeErrorMessage() {
    _networkHospitalBloc
        .setPinCodeErrorString(S.of(context).pincode_area_invalid);
  }

  void _removePinCodeErrorMessage() {
    _networkHospitalBloc.setPinCodeErrorString(null);
    if (!TextUtils.isEmpty(_networkHospitalBloc.searchBoxErrorStreamValue)) {
      _networkHospitalBloc.setPinCodeErrorString(null);
    }
  }

  /// This is a method to know a string is empty or not.
  /// In hospital list api response if information is empty "NULL" or "NA" is
  /// coming. To handle that situation use this method.
  /// If String value is "NULL" or "NA" this should be considered as empty
  bool _isStringEmpty(String s) {
    if (TextUtils.isEmpty(s)) {
      return true;
    }
    if (s.trim().toUpperCase() == "NULL" || s.trim().toUpperCase() == "NA") {
      return true;
    }
    return false;
  }

  Widget _selectionChipWidget() {
    const double horizontalMargin = 20;
    const double spaceBetweenItems = 8;
    const totalItems = 3;
    double screenWidth = MediaQuery.of(context).size.width;
    double availableSpaceForSelectionWidget = screenWidth -
        (horizontalMargin * 2 + (spaceBetweenItems * (totalItems - 1)));
    return Container(
      margin: EdgeInsets.only(
          top: 20, left: horizontalMargin, right: horizontalMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: _selectionItemWidgetList(
            availableSpaceForSelectionWidget, spaceBetweenItems),
      ),
    );
  }

  @override
  void dispose() {
    _searchBoxTextController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }
}

class HospitalModel {
  String name, address;

  HospitalModel(this.name, this.address);
}

class SelectionChipItem {
  String _name;

  String get name => _name;

  SelectionChipItemIds _id;

  SelectionChipItemIds get id => _id;

  final Function onClick;

  SelectionChipItem(this._name, this._id, this.onClick);
}

enum SelectionChipItemIds { ALL, MEDI_ASSIST, PARAMOUNT }


/*Widget _searchBox(bool isSearchButtonVisible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13.0, 2.0, 8.0, 3.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(
                            color: ColorConstants.light_gray, width: 1)),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: _searchBoxTextController,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(
                            RegExp('[A-Za-z0-9 ,.]')),
                        //LengthLimitingTextInputFormatter(6),
                      ],
                      onSubmitted: (val) {
                        /*if (_isAValidCode()) {
                          latitude = '';
                          longitude = '';
                          keyWord = _searchBoxTextController.text;
                          _callListAPi(freshList: true);
                        } else {
                          _addPinCodeErrorMessage();
                        }*/
                      },
                      onChanged: (val) {
                      /*  bool visible = val.trim().length == 0;
                        latitude = '';
                        longitude = '';
                        _removePinCodeErrorMessage();
                        setState(() {
                          _searchButtonVisibility = visible;
                        });*/
                      },
                      decoration: InputDecoration.collapsed(hintText: null),
                    ),
                  ),
                ),
              ),

              ///Added for phase 1 new design with current detection option
              InkWell(
                onTap: () {
                  _getLocation();
                },
                child: Container(
                  padding: EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          color: ColorConstants.light_gray, width: 1)),
                  margin: EdgeInsets.only(right: 20),
                  child: Image(
                    height: 20.0,
                    width: 20.0,
                    image: AssetImage(AssetConstants.ic_gps),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5, left: 25),
          child: StreamBuilder<String>(
              stream: _networkHospitalBloc.searchBoxPinCodeErrorStream,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.hasData,
                  child: Text(
                    snapshot.data ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.red),
                  ),
                );
              }),
        )
      ],
    );
  }*/

/* _simpleAutoCompleteTextView() {
    return simpleAutoCompleteTextField = SimpleAutoCompleteTextField(
     // key: key,
      //controller: _searchBoxTextController,
      keyboardType: TextInputType.text,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp('[A-Za-z0-9 ,.]')),
      ],
      decoration: InputDecoration(
        alignLabelWithHint: true,
        border: InputBorder.none,
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      suggestions: suggestions,
      textInputAction: TextInputAction.done,
      textChanged: (value) async {
        print('value $value , ${value.length}');
        if (value.length < 3) {
          _networkHospitalBloc.changeGpsIconStatus(true);
        } else if (value.length >= 3) {
          _networkCall(value);
        }
      },

    );
  }*/