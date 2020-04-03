import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/claim_intimation/claim_intimation_validator.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/claim_intimation/claim_remark_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class ClaimPolicyNumberScreen extends StatelessWidget {
  static const ROUTE_NAME = "/claim_intimation/claim_intimation_policy_screen";

  final ClaimPolicyArgument argument;

  ClaimPolicyNumberScreen(this.argument);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: ClaimPolicyNumberScreenWidget(
          argument.requestModel ?? ClaimIntimationResponseModel()),
      bloc: ClaimIntimationBloc(),
    );
  }
}

class ClaimPolicyNumberScreenWidget extends StatefulWidget {
  final ClaimIntimationRequestModel responseModel;

  ClaimPolicyNumberScreenWidget(this.responseModel);

  @override
  _ClaimPolicyNumberScreenState createState() =>
      _ClaimPolicyNumberScreenState();
}

class _ClaimPolicyNumberScreenState extends State<ClaimPolicyNumberScreenWidget>
    with CommonWidget {
  double screenWidth;
  double screenHeight;
  bool isPolicyNumberVisible = false,
      policyNumberError = false,
      isYesButtonClicked = false,
      isNoButtonClicked = false,
      onSubmit = false,
      isKeyboardVisible = false;
  ServiceModel buttonNo, buttonYes;
  final policyNumberController = TextEditingController();
  ClaimIntimationBloc _claimIntimationBloc;
  String errorText;
  ScrollController _controller;

  @override
  void initState() {
    _claimIntimationBloc = SbiBlocProvider.of<ClaimIntimationBloc>(context);
    _controller = ScrollController();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print("fOCUS " + visible.toString());
        if (visible) {
          _moveDown();
        } else {}
        print("I AM HERE");
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    policyNumberController.dispose();
    _claimIntimationBloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    buttonNo = ServiceModel(
        title: S.of(context).no,
        subTitle: '',
        isSubTitleRequired: false,
        points: [],
        icon: null,
        color1: Colors.white,
        color2: Colors.white);

    buttonYes = ServiceModel(
        title: S.of(context).yes,
        subTitle: '',
        isSubTitleRequired: false,
        points: [],
        icon: null,
        color1: Colors.white,
        color2: Colors.white);
    super.didChangeDependencies();
  }

  _moveDown() {
    _controller.animateTo(0.0,
        curve: Curves.easeOut, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.claim_intimation_bg_color,
      appBar: getAppBar(
          context, S.of(context).claim_intimation_title.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              controller: _controller,
              reverse: true,
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 40),
                      child: Text(
                        S.of(context).claim_policy_number_query,
                        style: TextStyle(
                            fontFamily: StringConstants.EFFRA_LIGHT,
                            fontSize: 28.0),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                isNoButtonClicked = true;
                                isYesButtonClicked = false;
                                if (isPolicyNumberVisible) {
                                  isPolicyNumberVisible = false;
                                }
                              });
                            },
                            child: button(buttonNo, isNoButtonClicked),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isYesButtonClicked = true;
                                isNoButtonClicked = false;
                                if (!isPolicyNumberVisible) {
                                  isPolicyNumberVisible = true;
                                }
                              });
                            },
                            child: button(buttonYes, isYesButtonClicked),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                   if(isPolicyNumberVisible)policyNumber(),
                   /* Visibility(
                      visible: isPolicyNumberVisible,
                      child: policyNumber(),
                    ),*/
                    SizedBox(
                      height: 80,
                    ),
                  ],
                )
              ],
            ),
            if (isYesButtonClicked || isNoButtonClicked)
              _showSubmitButton(),
            //  Align(alignment: Alignment.bottomCenter, child: _showPremiumButton()),
          ],
        ),
      ),
    );
  }


  onClick() {
    String policyNumber = _claimIntimationBloc.policyNumber ?? '';
    print('Policy Number : $policyNumber');
    if (isNoButtonClicked) {
      onSubmit = true;
      _claimIntimationBloc.changePolicyNumber('');
      ClaimIntimationRequestModel responseModel = this.widget.responseModel;
      responseModel.policyNo = '';
      _navigate(responseModel);
    } else if (isYesButtonClicked && policyNumber.length != 16) {
      onSubmit = true;
      policyNumberError = true;
      _claimIntimationBloc.changePolicyNumber(policyNumber);
    } else {
      onSubmit = true;
      _claimIntimationBloc.changePolicyNumber(policyNumber);
      ClaimIntimationRequestModel responseModel = this.widget.responseModel;
      responseModel.policyNo = policyNumber;
      _navigate(responseModel);
    }
  }
  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).claim_next_button.toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  void _navigate(ClaimIntimationRequestModel responseModel) {
    Navigator.of(context).pushNamed(ClaimIntimationRemarkScreen.ROUTE_NAME,
        arguments: ClaimIntimationRemarkArguments(responseModel));
  }

  Widget button(ServiceModel serviceModel, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
          borderRadius(radius: 6.0, topLeft: 6.0, topRight: 30.0)),
      elevation: 10.0,
      child: Container(
        height: screenHeight / 10,
        width: screenWidth / 2 - 20,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: (isSelected)
                    ? [
                  ColorConstants.button_gradient_color1,
                  ColorConstants.button_gradient_color2
                ]
                    : [serviceModel.color1, serviceModel.color2]),
            borderRadius:
            borderRadius(radius: 5.0, topLeft: 5.0, topRight: 30.0)),
        child: Center(
          child: Text(
            serviceModel.title,
            style: TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 20.8,
                color: (isSelected)
                    ? Colors.white
                    : ColorConstants.button_not_selected_text_color),
          ),
        ),
      ),
    );
  }

  Widget policyNumber() {
    return StreamBuilder(
        stream: _claimIntimationBloc.policyNumberStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          errorText=null;
          bool _onSubmit = (onSubmit);
          if(isError && isYesButtonClicked){
            switch(snapshot.error){
              case ClaimIntimationValidator.EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText =
                _onSubmit ? S.of(context).policy_number_error : null;
                break;
              case ClaimIntimationValidator.LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText = _onSubmit
                    ? S.of(context).invalid_policy_number
                    : null;
                break;
              default:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                errorText=(_onSubmit)?S.of(context).invalid_policy_number:null;
                break;

            }
          }else if (snapshot.hasData){
            errorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          }else{
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            errorText=(_onSubmit)?S.of(context).invalid_policy_number:null;
          }

          return Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
            child: Stack(
              children: <Widget>[
                Theme(
                  data: new ThemeData(
                    primaryColor: ColorConstants.text_field_blue,
                    // changes the under line colour
                    primaryColorDark: ColorConstants.text_field_blue,
                    accentColor: ColorConstants.text_field_blue,
                  ),
                  child: TextField(
                    controller: policyNumberController,
                    onChanged: (String value) {
                      _claimIntimationBloc.changePolicyNumber(value);
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value){
                     // _claimIntimationBloc.changePolicyNumber(value);
                      onClick();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                    ],
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right:10.0, bottom: 5.0),
                      border:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color:ColorConstants.policy_type_gradient_color2),
                      ),
                      labelText: S.of(context).policy_number_title.toUpperCase(),
                      errorText: errorText ,
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                Positioned(
                    right: 0,
                    top: 15,
                    child: SizedBox(height: 25, width: 25, child: image))
              ],
            ),
          );
        });
  }
}

class ClaimPolicyArgument {
  ClaimIntimationRequestModel requestModel;

  ClaimPolicyArgument(this.requestModel);
}