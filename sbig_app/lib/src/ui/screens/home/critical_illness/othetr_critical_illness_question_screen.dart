
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/health_question/health_question_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/other_critical_illness/other_critical_insurance_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/widget_models/home/service_model.dart';
import 'package:sbig_app/src/resources/asset_constants.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/multi_other_critical_details_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/circle_button.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/triangle_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import '../home_screen.dart';
import 'critical_health_question_screen.dart';

class OtherCriticalIllnessQuestionScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/other_critical_illness_question";
  final CriticalIllnessModel _arguments;
  OtherCriticalIllnessQuestionScreen(this._arguments);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: HealthQuestionBloc(),
      child: OtherCriticalIllnessQuestionScreenWidget(_arguments),

    );
  }
}


class OtherCriticalIllnessQuestionScreenWidget extends StatefulWidget {

  final CriticalIllnessModel _arguments;

  OtherCriticalIllnessQuestionScreenWidget(this._arguments);

  @override
  _State createState() => _State();
}

class _State extends State<OtherCriticalIllnessQuestionScreenWidget>
    with CommonWidget {
  double screenWidth;
  double screenHeight;
  bool isClaimVisible = false,
      isYesButtonClicked = false,
      isNoButtonClicked = false,
      isClaimYesButtonClicked = false,
      isClaimNoButtonClicked = true,
      onSubmit = false;
  ServiceModel buttonNo, buttonYes;
  String errorText;
  ScrollController _controller;
  bool isNextButtonEnable;
CriticalIllnessModel criticalIllnessModel;
HealthQuestionBloc healthQuestionBloc;


  @override
  void initState() {
    _controller = ScrollController();
    criticalIllnessModel=widget._arguments;
    healthQuestionBloc=SbiBlocProvider.of<HealthQuestionBloc>(context);
    _listenForEvents();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    healthQuestionBloc.dispose();
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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Text(
                        S.of(context).other_critical_illness_query,
                        style: TextStyle(
                            fontFamily: StringConstants.EFFRA_LIGHT,
                            fontSize: 24.0),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 20),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                isNoButtonClicked = true;
                                isYesButtonClicked = false;
                                updateButton(true);
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
                                isClaimYesButtonClicked = false;
                                isClaimNoButtonClicked = true;
                                updateButton(true);
                              });
                            },
                            child: button(buttonYes, isYesButtonClicked),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isYesButtonClicked,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: criticalClaimQuestionWidget(),
                              ),
                              /// -0.5 is x axis , negative value will move towards left and vice versa
                              Align(child: Triangle(color: Colors.white,),
                              alignment: Alignment(0.3, -1),),
                            /*  Align(child: Triangle(color: Colors.white,),
                                alignment: Alignment(0.5, -0.5),),*/
                            ],
                          )),
                    ),
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

  void _navigate() {
    // Navigator.of(context).pushNamed(CriticalHealthQuestionsScreen.ROUTE_NAME,arguments: widget._arguments);
  }

  updateButton(bool status) {
    isNextButtonEnable = status;
  }

  onClick() {
    if (isNoButtonClicked) {
      var otherCriticalIllness = OtherCriticalIllness();
      otherCriticalIllness.isOtherCriticalIllnessClaimed=false;
      otherCriticalIllness.otherCriticalIllnessAvailable=false;
      criticalIllnessModel.otherCriticalIllness = otherCriticalIllness;
      criticalIllnessModel.otherCriticalIllnessDetails=[];
      _makeHealthQuestionApiCall();

    } else if (isYesButtonClicked && isClaimNoButtonClicked) {

      var otherCriticalIllness = OtherCriticalIllness();
      otherCriticalIllness.isOtherCriticalIllnessClaimed=false;
      otherCriticalIllness.otherCriticalIllnessAvailable=true;
      criticalIllnessModel.otherCriticalIllness = otherCriticalIllness;
      criticalIllnessModel.otherCriticalIllnessDetails=[];
      _apiCall();

    } else {
      var otherCriticalIllness = OtherCriticalIllness();
      otherCriticalIllness.isOtherCriticalIllnessClaimed=true;
      otherCriticalIllness.otherCriticalIllnessAvailable=true;
      criticalIllnessModel.otherCriticalIllness = otherCriticalIllness;
      criticalIllnessModel.otherCriticalIllnessDetails=[];
      showCustomerRepresentativeWidget(context);
    }
  }

  _apiCall() async {
    showLoaderDialog(context);
    var response = await OtherCriticalIllnessApiProvider.getInstance().getInsuranceCompanyList();
    print('RESPONSE ${response}');
    if (response != null) {
      hideLoaderDialog(context);
      criticalIllnessModel.otherInsuranceCompanyList = response;
      Navigator.of(context).pushNamed(
          MultiOtherCriticalInsuranceDetailsScreen.ROUTE_NAME,
          arguments: criticalIllnessModel);
    }
  }


  Widget _showSubmitButton() {
    return EnableDisableButtonWidget(
      (isNextButtonEnable) ? onClick : null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.arogya_plus_bg_color,
    );
  }

  Widget button(ServiceModel serviceModel, bool isSelected) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius:
              borderRadius(radius: 6.0, topLeft: 6.0, topRight: 30.0)),
      elevation: 10.0,
      child: Container(
        height: 50,
        width: 120,
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

  Widget criticalClaimQuestionWidget() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.only(left: 15.0, top: 20.0, bottom: 20.0, right: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              S.of(context).critical_illness_claim_query,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                CircleButton(
                  onTap: () {
                    setState(() {
                      isClaimNoButtonClicked = true;
                      isClaimYesButtonClicked = false;
                    });
                  },
                  image: AssetConstants.ic_tick,
                  isGardientApplicable: isClaimNoButtonClicked,
                  color1: ColorConstants.east_bay,
                  color2: ColorConstants.disco,
                  color3: ColorConstants.disco,
                  iconColor: Colors.white,
                  circleSize: 40.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(S.of(context).no),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                CircleButton(
                  onTap: () {
                    setState(() {
                      isClaimNoButtonClicked = false;
                      isClaimYesButtonClicked = true;
                    });
                  },
                  image: AssetConstants.ic_tick,
                  isGardientApplicable: isClaimYesButtonClicked,
                  color1: ColorConstants.east_bay,
                  color2: ColorConstants.disco,
                  color3: ColorConstants.disco,
                  iconColor: Colors.white,
                  circleSize: 40.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(S.of(context).yes),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerRepresentativeWidget(
                onClick,
                title: S.of(context).online_request,
                subTitle: S.of(context).customer_representative,
              )));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(false);
              },
              child: CustomerRepresentativeWidget(
                onClick,
                title: S.of(context).online_request,
                subTitle: S.of(context).customer_representative,
              )));
    }
  }

  _makeHealthQuestionApiCall() async {
    showLoaderDialog(context);
    final response = await healthQuestionBloc.getHealthQuestionContent(StringConstants.FROM_CRITICAL_ILLNESS);
    if (null != response) {
      hideLoaderDialog(context);
      criticalIllnessModel.healthQuestionResModel=response;
      Navigator.of(context).pushNamed(CriticalHealthQuestionsScreen.ROUTE_NAME,
          arguments: criticalIllnessModel);
     }
  }

  _listenForEvents() {
    healthQuestionBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0,(int retryIdentifier) {
        _makeHealthQuestionApiCall();
      }, event.dialogType);

    });
  }
}
