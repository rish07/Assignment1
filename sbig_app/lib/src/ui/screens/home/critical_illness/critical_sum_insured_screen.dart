import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_premium_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'critical_time_period_screen.dart';

class CriticalSumInsuredScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/sum_insured";

  final CriticalIllnessModel criticalIllnessModel;

  CriticalSumInsuredScreen(this.criticalIllnessModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: CriticalSumInsuredScreenWidget(criticalIllnessModel),
      bloc: CriticalPremiumBloc(),
    );
  }
}

class CriticalSumInsuredScreenWidget extends StatefulWidget {
  final CriticalIllnessModel criticalIllnessModel;

  CriticalSumInsuredScreenWidget(this.criticalIllnessModel);

  @override
  _CriticalSumInsuredScreenWidgetState createState() =>
      _CriticalSumInsuredScreenWidgetState();
}

class _CriticalSumInsuredScreenWidgetState
    extends State<CriticalSumInsuredScreenWidget> with CommonWidget {
  double screenWidth;
  double screenHeight;
  CriticalPremiumBloc _criticalIllnessBloc;
  String errorText;
  bool onSubmit = false;
  List<CriticalSumInsuredModel> sumInsuredList;
  int _selectedPremium = -1;
  CriticalIllnessModel criticalIllnessModel;
  PolicyCoverMemberModel policyCoverMemberModel;
  int selectedSumInsured;
  int apiCallIndex = -1;
  List<Data> timePeriod =[];

  @override
  void initState() {
    _criticalIllnessBloc = SbiBlocProvider.of<CriticalPremiumBloc>(context);
    criticalIllnessModel = widget.criticalIllnessModel;
    policyCoverMemberModel = criticalIllnessModel.policyCoverMemberModel;
    timePeriod = widget.criticalIllnessModel.premiumResModel.data;
    selectedSumInsured = 0;
    createSumInsuredValue();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    screenWidth =
        ScreenUtil.getInstance(context).screenWidthDp - 40; //remove margin
    screenHeight = ScreenUtil.getInstance(context).screenHeightDp;

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.critical_illness_bg_color,
      appBar: getAppBar(context, S.of(context).coverage_amount.toUpperCase()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Text(
                      S.of(context).sum_insured_lacs,
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: StringConstants.EFFRA_LIGHT,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      S.of(context).critical_sum_insured_sub_title,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        color: ColorConstants.critical_illness_light_gray,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                                child: InkResponse(
                              onTap: () =>
                                  updateUI(sumInsuredList[0].amount, 0),
                              child: amountCard(sumInsuredList[0].amountString,
                                  sumInsuredList[0].isSelected),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: InkResponse(
                              onTap: () =>
                                  updateUI(sumInsuredList[1].amount, 1),
                              child: amountCard(sumInsuredList[1].amountString,
                                  sumInsuredList[1].isSelected),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: InkResponse(
                              onTap: () =>
                                  updateUI(sumInsuredList[2].amount, 2),
                              child: amountCard(sumInsuredList[2].amountString,
                                  sumInsuredList[2].isSelected),
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: InkResponse(
                              onTap: () =>
                                  updateUI(sumInsuredList[3].amount, 3),
                              child: amountCard(sumInsuredList[3].amountString,
                                  sumInsuredList[3].isSelected),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: InkResponse(
                              onTap: () =>
                                  updateUI(sumInsuredList[4].amount, 4),
                              child: amountCard(sumInsuredList[4].amountString,
                                  sumInsuredList[4].isSelected),
                            )),
                          ],
                        ),
                        quickFact(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            showNextButton(),
          ],
        ),
      ),
    );
  }

  Widget showNextButton() {
    return BlackButtonWidget(
      onClick,
      S.of(context).next.toUpperCase(),
      bottomBgColor: ColorConstants.critical_illness_bg_color,
    );
  }

  Widget quickFact() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 50.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.critical_illness_note_bg_color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                S.of(context).note.toUpperCase(),
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '* ',
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Flexible(
                        //newly added
                        child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 15.0),
                      child: Text(
                          (policyCoverMemberModel.title.compareTo(S.of(context).self_title) == 0)
                              ? S.of(context).critical_note_proposer
                              : S.of(context).critical_note_insurer,
                          style: TextStyle(
                              color: ColorConstants
                                  .critical_illness_note_text_color),
                          softWrap: true),
                    )),
                    /*Text(
                         S.of(context).critical_note_proposer,
                        style: TextStyle(
                          color: ColorConstants.critical_illness_note_text_color
                        ),
                      ),*/
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget amountCard(String amount, bool isSelected) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: screenHeight / 12,
        width: screenWidth / 3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: (isSelected)
              ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                      ColorConstants.policy_type_gradient_color1,
                      ColorConstants.policy_type_gradient_color2
                    ])
              : null,
        ),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
              fontSize: 19,
              color: (isSelected) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  onClick() {
    onSubmit = true;
    _navigate();
  }

  @override
  void dispose() {
    _criticalIllnessBloc.dispose();
    super.dispose();
  }

  void _navigate() {
    CriticalSumInsuredModel sumInsuredModel = CriticalSumInsuredModel();
    sumInsuredModel = sumInsuredList[selectedSumInsured];
    widget.criticalIllnessModel.sumInsuredModel = sumInsuredModel;
    Navigator.of(context).pushNamed(CriticalTimePeriodScreen.ROUTE_NAME,
        arguments: widget.criticalIllnessModel);
  }

  updateUI(int amount, int index) async {
    if (index == -1) {
      return;
    }
    if (index == 4) {
      showCustomerRepresentativeWidget(context);
      return;
    }
    if (null == sumInsuredList[index].timePeriodList) {
      CriticalPremiumReqModel premiumReqModel;
      if (sumInsuredList[index].premiumReqModel == null) {
        premiumReqModel = criticalIllnessModel.premiumReqModel;
        premiumReqModel.sumInsured = sumInsuredList[index].amount;
        sumInsuredList[index].premiumReqModel = premiumReqModel;
      } else {
        premiumReqModel = sumInsuredList[index].premiumReqModel;
      }

      apiCallIndex = index;
      showLoaderDialog(context);
      var response =
          await _criticalIllnessBloc.calculateCriticalPremium(premiumReqModel);
      if (response != null) {
        hideLoaderDialog(context);
        sumInsuredList[index].premiumResModel = response;
        List<Data> timePeriod = response.data;
        if (timePeriod != null) {
          sumInsuredList[index].timePeriodList = timePeriod;
          //premiumList = opd.year1;
        }
      } else {
        return;
      }
    } else {
      // premiumList = sumInsuredList[index].timePeriodList;
    }

    setState(() {
      sumInsuredList.map((sum) {
        if (sum.amount == amount)
          sum.isSelected = true;
        else
          sum.isSelected = false;
      }).toList();
      selectedSumInsured = index;
    });
  }

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.pop(context);
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }
  }

  void createSumInsuredValue() {
    sumInsuredList = [
      CriticalSumInsuredModel(
          amount: 200000,
          amountString: '₹2 Lakhs',
          isSelected: true,
          timePeriodList: timePeriod,
          premiumReqModel: criticalIllnessModel.premiumReqModel,
          premiumResModel: criticalIllnessModel.premiumResModel),
      CriticalSumInsuredModel(
        amount: 300000,
        amountString: '₹3 Lakhs',
      ),
      CriticalSumInsuredModel(
        amount: 400000,
        amountString: '₹4 Lakhs',
      ),
      CriticalSumInsuredModel(
        amount: 500000,
        amountString: '₹5 Lakhs',
      ),
      CriticalSumInsuredModel(
        amount: 0,
        amountString: 'More than ₹ 5 Lakhs',
      )
    ];
  }
}
