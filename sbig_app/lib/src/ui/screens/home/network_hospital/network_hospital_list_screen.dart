import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_validators.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_list_response.dart';
import 'package:sbig_app/src/models/widget_models/home/network_hospital_locator/pin_to_hospital_list_arg_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/bottom_dialog.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/loading_screen.dart';
import 'package:sbig_app/src/ui/widgets/dash_separator.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/recase.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkHospitalListScreen extends StatelessWidget {
  static const ROUTE_NAME = "/network_hospital/network_hospital_list";
  final PinToHospitalListArgModel argModel;

  NetworkHospitalListScreen(this.argModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: NetworkHospitalBloc(),
      child: _NetworkHospitalListScreenInternal(argModel),
    );
  }
}

class _NetworkHospitalListScreenInternal extends StatefulWidget {
  final PinToHospitalListArgModel argModel;

  _NetworkHospitalListScreenInternal(this.argModel);

  @override
  _NetworkHospitalListState createState() => _NetworkHospitalListState();
}

class _NetworkHospitalListState
    extends State<_NetworkHospitalListScreenInternal> with CommonWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _searchBoxTextController;
  NetworkHospitalBloc _networkHospitalBloc;

  SelectionChipItemIds _selectedId = SelectionChipItemIds.ALL;

  String selectedTpaCategory = NetworkHospitalBloc.TPA_CATEGORY_ALL;

  bool _searchButtonVisibility = true;
  ScrollController _listScrollController = ScrollController();

  final List<SelectionChipItem> _availableChipItems = [];

  @override
  void initState() {
    _networkHospitalBloc = SbiBlocProvider.of<NetworkHospitalBloc>(context);
    _searchBoxTextController = TextEditingController();
   _searchBoxTextController.text = widget.argModel.pin;
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

    _callListAPi();
    _listenToEvents();
    super.initState();
  }

  void _listenToEvents() {
    _networkHospitalBloc.eventStream.listen((event) {
      if (event is DialogEvent) {
        DialogEvent de = event;
        handleApiError(context,0, (int retryIdentifier) {
          _callListAPi();
        }, event.dialogType);
        /*switch (de.dialogType) {
          case DialogEvent.DIALOG_TYPE_NETWORK_ERROR:
            showNoInternetDialog(
              context,
              0,
                  (int retryIdentifier) {
                _callListAPi();
              },
            );
            break;
          case DialogEvent.DIALOG_TYPE_OH_SNAP:
            showServerErrorDialog(context, 0, (int retryIdentifier) {
              _callListAPi();
            });
            break;
        }*/
      } else if (event is SnackBarEvent) {
        SnackBarEvent snackBarEvent = event;
        Scaffold.of(context).showSnackBar((SnackBar(
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
                    _searchBox(_searchButtonVisibility),
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
                                  if (snapshot.data.length == 0 &&
                                      !_networkHospitalBloc.isLoading) {
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
                                                    _networkHospitalBloc
                                                        .isThereDataToLoad());
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
              })
        ],
      ),
    );
  }

  Widget _searchBox(bool isSearchButtonVisible) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: ColorConstants.light_gray, width: 1)),
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13.0, 2.0, 8.0, 3.0),
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: _searchBoxTextController,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.number,
                    inputFormatters: [ /// need to change this with alphanumeric
                      WhitelistingTextInputFormatter(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(6),
                    ],
                    onSubmitted: (val) {
                      if (_isAValidPinCode()) {
                        _callListAPi(freshList: true);
                      } else {
                        _addPinCodeErrorMessage();
                      }
                    },
                    onChanged: (val) {
                      bool visible = val.trim().length == 6;
                      _removePinCodeErrorMessage();
                      setState(() {
                        _searchButtonVisibility = visible;
                      });
                    },
                    decoration: InputDecoration.collapsed(hintText: null),
                  ),
                ),
              ),
             /// remove for phase 1
              IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.search,
                  color:
                      isSearchButtonVisible ? Colors.grey : Colors.transparent,
                ),
                onPressed: () {
                  if (_searchButtonVisibility) {
                    FocusScope.of(context).unfocus();
                    _callListAPi(freshList: true);
                  }
                },
              )
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

  List<Widget> _selectionItemWidgetList(
      double totalAvailableWidth, double spaceBetween) {
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
          if (_isAValidPinCode()) {
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
          if (_isAValidPinCode()) {
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
          if (_isAValidPinCode()) {
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

  Widget _selectionChipItem(
      SelectionChipItem selectionChipItem, double totalAvailableWidth) {
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

  Widget _listItem(ResponseData hospitalData, int position, bool isLastItem,
      bool isThereDataToLoad) {
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
                          if(Platform.isIOS){
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return BottomDialog(
                                    child: _getPhoneDialogBody2(
                                        hospitalData.hospitalName,
                                        phoneNumberList),
                                  );
                                });
                          }else{
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
                                hospitalData.hospitalState)
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

  void _callListAPi({bool freshList = false}) {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      //
    }
    if (freshList) {
      _networkHospitalBloc.fetchFreshHospitalList(
          _searchBoxTextController.text, selectedTpaCategory);
    } else {
      _networkHospitalBloc.getHospitalList(
          _searchBoxTextController.text, selectedTpaCategory);
    }
  }

  Widget _getPhoneDialogBody(
      String hospitalName, String phone1, String phone2) {
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

  void _addPinCodeErrorMessage() {
    _networkHospitalBloc.setPinCodeErrorString(S.of(context).pincode_invalid);
  }

  void _removePinCodeErrorMessage() {
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
