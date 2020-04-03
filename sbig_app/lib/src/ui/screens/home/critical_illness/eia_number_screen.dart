import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/eia/eia_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/eia/eia_validator.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/eia_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_policy_summary_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

class EIANumberScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/eia_number_screen";

  CriticalIllnessModel criticalIllnessModel;

  EIANumberScreen(this.criticalIllnessModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: EIANumberScreenWidget(criticalIllnessModel),
      bloc: EiaBloc(),
    );
  }
}

class EIANumberScreenWidget extends StatefulWidget {
  CriticalIllnessModel criticalIllnessModel;

  EIANumberScreenWidget(this.criticalIllnessModel);

  @override
  _State createState() => _State();
}

class _State extends State<EIANumberScreenWidget> with CommonWidget {
  double screenWidth;
  double screenHeight;
  bool isEiaNumberVisible = false,
      isYesButtonClicked = false,
      isNoButtonClicked = false,
      onSubmit = false;
  ServiceModel buttonNo, buttonYes;
  EiaBloc eiaBloc;
  String eiaErrorText, panErrorText;
  ScrollController _controller;
  String quoteNumber = "";
  String dropDownValue = "";
  CriticalIllnessModel criticalIllnessModel;

  @override
  void initState() {
    eiaBloc = SbiBlocProvider.of<EiaBloc>(context);
    _controller = ScrollController();
    criticalIllnessModel=widget.criticalIllnessModel;
    super.initState();
  }

  @override
  void dispose() {
    eiaBloc.dispose();
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

    quoteNumber = S.of(context).quote_number.toUpperCase() + ": ";
    /* if (null != widget.selectedMemberDetails.quoteNumber) {
      quoteNumber = quoteNumber + widget.selectedMemberDetails.quoteNumber;
    }*/
    dropDownValue = S.of(context).select_insurance_repo;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(context, S.of(context).critical_illness.toUpperCase()),
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
                    /*Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: ColorConstants
                                .critical_illness_quote_number_color,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            quoteNumber,
                            style:
                                TextStyle(fontSize: 12.0, letterSpacing: 1.0),
                          ),
                        ),
                      ),
                    ),*/
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Text(
                        ((!isYesButtonClicked && !isNoButtonClicked) || isYesButtonClicked)
                            ? S.of(context).eia_number_question
                            : S.of(context).eia_number.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 23.0),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Text(
                        S.of(context).eia_sub_title,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontStyle: FontStyle.normal,
                            color: ColorConstants
                                .critical_illness_eia_sub_title_color),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                isNoButtonClicked = true;
                                isYesButtonClicked = false;
                                onSubmit=false;
                                eiaBloc.changePANNumber('');
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
                                onSubmit=false;
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
                    Visibility(
                      visible: isYesButtonClicked,
                      child: EIANumber(),
                    ),
                    /*Visibility(
                      visible: isNoButtonClicked,
                      child: createEIAAccount(),
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

  Widget EIANumber() {
    return StreamBuilder(
        stream: eiaBloc.eiaNumberStream,
        builder: (context, snapshot) {
           Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          eiaErrorText = null;
          bool _onSubmit = (onSubmit);
          if (isError && isYesButtonClicked) {
            switch (snapshot.error) {
              case EIAValidator.EMPTY_ERROR:
               image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                eiaErrorText =
                _onSubmit ? S.of(context).eia_valid_number : null;
                break;
              case EIAValidator.LENGTH_ERROR:
              image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                eiaErrorText =
                _onSubmit ? S.of(context).eia_valid_number : null;
                break;
              case EIAValidator.INVALID_ERROR:
                image =  Image.asset(AssetConstants.ic_wrong);
                eiaErrorText = S.of(context).eia_valid_number ;
                break;
              default:
              image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                eiaErrorText =
                (_onSubmit) ? S.of(context).eia_valid_number : null;
                break;
            }
          } else if (snapshot.hasData) {
            eiaErrorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          } else {
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            eiaErrorText = (_onSubmit) ? S.of(context).eia_valid_number : null;
          }

          return Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: 8.0),
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
                    //controller: ,
                    onChanged: (String value) {
                      eiaBloc.changeEiaNumber(value);
                    },
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      onClick();
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.shiraz),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.fuchsia_pink),
                      ),
                      labelText: S.of(context).eia_enter_number.toUpperCase(),
                      errorText: eiaErrorText,
                      errorStyle: TextStyle(color: ColorConstants.shiraz),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                 Positioned(
                    right: 10,
                    top: 10,
                    child: SizedBox(height: 25, width: 25, child: image))
              ],
            ),
          );
        });
  }

  Widget PANNumber() {
    return StreamBuilder(
        stream: eiaBloc.panNumberStream,
        builder: (context, snapshot) {
          Image image = Image.asset(AssetConstants.ic_correct);
          bool isError = snapshot.hasError;
          panErrorText = null;
          bool _onSubmit = (onSubmit);
          if (isError && isNoButtonClicked) {
            switch (snapshot.error) {
              case EIAValidator.EMPTY_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                panErrorText =
                _onSubmit ? S.of(context).enter_pan_number : null;
                break;
              case EIAValidator.LENGTH_ERROR:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                panErrorText =
                _onSubmit ? S.of(context).valid_pan_number : null;
                break;
              default:
                image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
                panErrorText =
                (_onSubmit) ? S.of(context).valid_pan_number : null;
                break;
            }
          } else if (snapshot.hasData) {
            panErrorText = null;
            image = Image.asset(AssetConstants.ic_correct);
          } else {
            image = _onSubmit ? Image.asset(AssetConstants.ic_wrong) : null;
            panErrorText = (_onSubmit) ? S.of(context).valid_pan_number : null;
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
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
                    //controller: ,
                    onChanged: (String value) {
                      eiaBloc.changePANNumber(value);
                    },
                    textInputAction: TextInputAction.next,
                    onSubmitted: (value) {
                      onClick();
                    },
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 23.0),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(right: 10.0),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorConstants.shiraz),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[500]),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: ColorConstants.fuchsia_pink),
                      ),
                      hintText: S.of(context).pan_number.toUpperCase(),
                      hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                      errorText: panErrorText,
                      errorStyle: TextStyle(color: ColorConstants.shiraz),
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                Positioned(
                    right: 10,
                    top: 10,
                    child: SizedBox(height: 25, width: 25, child: image))
              ],
            ),
          );
        });
  }

  Widget createEIAAccount() {
    List<String> repolist = [
      S.of(context).select_insurance_repo,
      "repo 1",
      "repo 2",
      "repo 3",
      "repo 4",
      "repo 5",
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontStyle: FontStyle.normal),
                  children: <TextSpan>[
                    TextSpan(
                        text: S.of(context).eia_question,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: S.of(context).eia_answer,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey,
                        )),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                S.of(context).eia_create_account,
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(width: 1, color: Colors.black38),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.grey[700],
                    ),
                    underline: Text(''),
                    isExpanded: true,
                    hint: Text(S.of(context).select_insurance_repo),
                    value: dropDownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropDownValue = newValue;
                      });
                    },
                    items:
                    repolist.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            PANNumber()
          ],
        ),
      ),
    );
  }

  onClick() {
    setState(() {
      onSubmit=true;
    });
    if(isYesButtonClicked){
      String eia_number = eiaBloc.eiaNumber;
      eiaBloc.changeEiaNumber(eia_number);
      Future.delayed(Duration(microseconds: 200)).then((value){
        if(EIAValidator.isEiaValid(eiaBloc.eiaNumber)){
          EIAModel eiaModel=EIAModel();
          eiaModel.eiaNumber=eia_number;
          eiaModel.isEIAAvailable=true;
          criticalIllnessModel.eiaModel=eiaModel;
          _navigate(widget.criticalIllnessModel);
        }else{
          eiaBloc.changeEiaNumber(eia_number);
        }
      });
    }else {
      EIAModel eiaModel=EIAModel();
      eiaModel.isEIAAvailable=false;
      criticalIllnessModel.eiaModel=eiaModel;
      _navigate(widget.criticalIllnessModel);
    }
  }

  Widget _showSubmitButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).claim_next_button.toUpperCase(),
      bottomBgColor: ColorConstants.claim_intimation_bg_color,
    );
  }

  Widget button(ServiceModel serviceModel, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
          borderRadius(radius: 6.0, topLeft: 6.0, topRight: 30.0)),
      elevation: 10.0,
      child: Container(
        height: screenHeight / 12,
        width: screenWidth / 2 - 40,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: (isSelected)
                    ? [
                  ColorConstants.east_bay,
                  ColorConstants.disco,
                  ColorConstants.disco
                ]
                    : [serviceModel.color1, serviceModel.color2]),
            borderRadius:
            borderRadius(radius: 5.0, topLeft: 5.0, topRight: 30.0)),
        child: Center(
          child: Text(
            serviceModel.title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: (isSelected)
                    ? Colors.white
                    : ColorConstants.button_not_selected_text_color),
          ),
        ),
      ),
    );
  }

  void _navigate(CriticalIllnessModel criticalIllnessModel) {
    Navigator.of(context).pushNamed(CriticalPolicySummeryScreen.ROUTE_NAME,
        arguments: widget.criticalIllnessModel);
  }
}
