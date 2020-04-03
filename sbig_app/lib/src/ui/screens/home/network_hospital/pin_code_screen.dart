import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/network_hospital/network_hospital_validators.dart';
import 'package:sbig_app/src/models/widget_models/home/network_hospital_locator/pin_to_hospital_list_arg_model.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_list_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_onboard_screen.dart';
import 'package:sbig_app/src/ui/screens/home/network_hospital/network_hospital_screen_phase1.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class NetworkHospitalPinCodeScreen extends StatelessWidget {
  static const routeName = "/network_hospital/network_hospital_pin";

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: NetworkHospitalBloc(),
      child: _NetworkHospitalPinCodeScreenInternal(),
    );
  }

}

class _NetworkHospitalPinCodeScreenInternal extends StatefulWidget {

  @override
  _NetworkHospitalPinCodeScreenState createState() => _NetworkHospitalPinCodeScreenState();
}

class _NetworkHospitalPinCodeScreenState extends State<_NetworkHospitalPinCodeScreenInternal> with CommonWidget {

  NetworkHospitalBloc _networkHospitalBloc;

  TextEditingController _pinTextController = TextEditingController();

  double _screenWidth;
  String _pinErrorString;
  String _pinValue;
  bool isFirst =true;

  @override
  void initState() {
    _networkHospitalBloc = SbiBlocProvider.of<NetworkHospitalBloc>(context);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _screenWidth = ScreenUtil.getInstance(context).screenWidthDp;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.personal_details_bg_color,
      appBar: getAppBar(
          context, S.of(context).hospital_locator.toUpperCase(),),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 38.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        S.of(context).enter_pin_code_to_search_hospital,
                        style: TextStyle(
                          fontFamily: StringConstants.EFFRA_LIGHT,
                            fontSize: 28, color: Colors.black),
                      ),
                      SizedBox(
                        height: 28,
                      ),
                      Text(
                        S.of(context).pincode_title.toUpperCase(),
                        style: TextStyle(
                            fontSize: 12, color: ColorConstants.black_60, letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Theme(
                          data: new ThemeData(
                              primaryColor: Colors.black,
                              accentColor: Colors.black,
                              hintColor: Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Container(
                              width: _screenWidth - 40,
                              child: StreamBuilder<String>(
                                stream: _networkHospitalBloc.pinStream,
                                builder: (context, snapshot) {
                                  if(snapshot.hasError) {
                                    switch(snapshot.error) {
                                      case NetworkHospitalValidators.PIN_LENGTH_ERROR:
                                      case NetworkHospitalValidators.PIN_INVALID_ERROR:
                                        _pinErrorString = S.of(context).error_invalid_pin;
                                        break;
                                    }
                                  } else {
                                    _pinErrorString = null;
                                  }
                                  return TextField(
                                    controller: _pinTextController,
                                    style: TextStyle(
                                        fontSize: 20.4,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.89),
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.go,
                                    onSubmitted: (val){
                                      if(val != null && val.length == 6) {
                                        _pinValue = val;
                                        _onSearchClick();
                                      } else {
                                        _pinValue = null;
                                        _networkHospitalBloc.changeSearchButtonVisibility(false);
                                      }
                                    },
                                    onChanged: (val) {
                                      if(val != null && val.length == 6) {
                                        _pinValue = val;
                                        _networkHospitalBloc.changeSearchButtonVisibility(true);
                                      } else {
                                        _pinValue = null;
                                        _networkHospitalBloc.changeSearchButtonVisibility(false);
                                      }
                                    },
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp('[0-9]')),
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: 12),
                                      border: InputBorder.none,
                                      errorText: _pinErrorString,
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[500]),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorConstants
                                                .policy_type_gradient_color2,),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          )),

                    ],
                  ),
                ),
              ),
            ),
            StreamBuilder<bool>(
              stream: _networkHospitalBloc.searchButtonVisibility,
              initialData: false,
              builder: (context, snapshot) {
                bool _buttonVisibility = false;
                if(snapshot != null && snapshot.hasData && snapshot.data) {
                  _buttonVisibility = true;
                }
                return Visibility(
                  visible: _buttonVisibility,
                  child: BlackButtonWidget(
                      _onSearchClick,
                    S.of(context).search.toUpperCase(),
                    padding: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 4.0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchClick() async {
    if(!TextUtils.isEmpty(_pinValue)) {
      _networkHospitalBloc.setPin(_pinValue);
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 100));
      /*Navigator.of(context).pushNamed(
          NetworkHospitalListScreen.ROUTE_NAME,
          arguments: PinToHospitalListArgModel(_pinValue));*/
      Navigator.of(context).pushNamed(
          NetworkHospitalScreen.ROUTE_NAME,
          arguments: PinToHospitalListArgModel(_pinValue));
    }
  }

  @override
  void dispose() {
    _pinTextController.dispose();
    super.dispose();
  }



}
