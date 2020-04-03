import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sbig_app/generated/i18n.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_premium_bloc.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/color_constants.dart';
import 'package:sbig_app/src/resources/string_constants.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dotted_line_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/enable_disable_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/sum_insured_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'critical_time_period_screen.dart';

class CriticalSumInsuredScreenNew extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness_new/sum_insured";

  final CriticalIllnessModel criticalIllnessModel;

  CriticalSumInsuredScreenNew(this.criticalIllnessModel);

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
  List<CriticalSumInsuredModel> sumInsuredList = [];
  List<CriticalSumInsuredModel> recommendedSumInsuredList = [];
  int _selectedPremium = -1;
  CriticalIllnessModel criticalIllnessModel;
  PolicyCoverMemberModel policyCoverMemberModel;
  int selectedSumInsured = -1;
  int apiCallIndex = -1;
  int _selectedIndex = -1;
  bool showRecommended = false;

  @override
  void initState() {
    _criticalIllnessBloc = SbiBlocProvider.of<CriticalPremiumBloc>(context);
    criticalIllnessModel = widget.criticalIllnessModel;
    policyCoverMemberModel = criticalIllnessModel.policyCoverMemberModel;
    selectedSumInsured = -1;
    showRecommended = true;
    _createSumInsuredModel(
        widget.criticalIllnessModel.criticalSumInsuredResModel);
    _listenForEvents();
    super.initState();
  }

  _listenForEvents() {
    _criticalIllnessBloc.eventStream.listen((event) {
      hideLoaderDialog(context);
      handleApiError(context, 0, (int retryIdentifier) {
        ///  _makeApiCall(policyType);
      }, event.dialogType);
    });
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Text(
                    S.of(context).sum_insured_amount_title,
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
                    S.of(context).sum_insured_instruction,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorConstants.critical_illness_light_gray,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(child: _sumInsuredContainer()),

//                Container(
//                  height: 80.0,
//                  color: Colors.white,
//                  child: Align(
//                      alignment: Alignment(-0.6, 1),
//                      child: DottedLineWidget(
//                        height: 5.0,
//                        width: 0.5,
//                        color: Colors.grey,
//                        axis: Axis.vertical,
//                        dashCountValue: 10,
//                      )),
//                ),
              ],
            ),
            showNextButton(),
          ],
        ),
      ),
    );
  }

  Widget showNextButton() {
    return EnableDisableButtonWidget(
      (_selectedIndex != -1)
          ? () {
              _makeApiCall();
            }
          : null,
      S.of(context).next.toUpperCase(),
      bottomBgColor: Colors.white,
    );
  }

  Widget _sumInsuredContainer() {
    return Stack(
      children: <Widget>[
        Container(
          ///1.873 is the height factor calculated for IPad, 50 is the overlay padding, 15 the padding of page indicators
          margin: EdgeInsets.only(
              top: isIPad(context)
                  ? ScreenUtil.getInstance(context).screenWidthDp / 1.873 -
                      50 +
                      15
                  : 10.0),
          width: double.infinity,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 15,
                    //offset: Offset(0, -5),
                    color: Colors.black26,
                    spreadRadius: 1)
              ],
              borderRadius: BorderRadius.only(topRight: Radius.circular(50.0)),
              color: Colors.white),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 75.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: DottedLineWidget(
                      height: 5.0,
                      width: 0.5,
                      color: Colors.grey,
                      axis: Axis.vertical,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 50.0),
                child: (showRecommended)
                    ? ListView.builder(
                        itemCount: recommendedSumInsuredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildSumInsured(
                              recommendedSumInsuredList[index], index);
                        })
                    : ListView.builder(
                        itemCount: sumInsuredList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildSumInsured(sumInsuredList[index], index);
                        }),
              ),
            ],
          ),
        )
      ],
    );
  }

  onUpdate(int index) {
    if (showRecommended) {
      setState(() {
        _selectedIndex = index;
        if (recommendedSumInsuredList != null) {
          if (recommendedSumInsuredList[index].amount == -1) {
            if (selectedSumInsured > 0) {
              for (var i = 0; i < sumInsuredList.length; i++) {
                if (sumInsuredList[i].isSelected) {
                  _selectedIndex = i;
                }
              }
            }
            showRecommended = false;
            return;
          }
          recommendedSumInsuredList.forEach((s) => s.isSelected = false);
          recommendedSumInsuredList[index].isSelected = true;
          selectedSumInsured = recommendedSumInsuredList[index].amount;
        }
      });
    } else {
      setState(() {
        _selectedIndex = index;
        if (sumInsuredList != null) {
          sumInsuredList.forEach((s) => s.isSelected = false);
          sumInsuredList[index].isSelected = true;
          selectedSumInsured = sumInsuredList[index].amount;
        }
      });
    }
  }

  @override
  void dispose() {
    _criticalIllnessBloc.dispose();
    super.dispose();
  }

  /* updateUI(int amount, int index) async {
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
        var timePeriod = response.data;
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
  }*/

  _makeApiCall() async {
    if (!showRecommended && sumInsuredList[_selectedIndex].amount == -1) {
      showCustomerRepresentativeWidget(context);
      return;
    }
    CriticalPremiumReqModel premiumReqModel;
    premiumReqModel = CriticalPremiumReqModel();
    premiumReqModel.gender =
        criticalIllnessModel.criticalSumInsuredReqModel.gender;
    premiumReqModel.age = criticalIllnessModel.criticalSumInsuredReqModel.age;
    premiumReqModel.employed =
        criticalIllnessModel.criticalSumInsuredReqModel.employed;
    premiumReqModel.grossIncome =
        criticalIllnessModel.criticalSumInsuredReqModel.grossIncome;
    premiumReqModel.sumInsured = sumInsuredList[_selectedIndex].amount;

    showLoaderDialog(context);
    var response =
        await _criticalIllnessBloc.calculateCriticalPremium(premiumReqModel);
    if (response != null) {
      hideLoaderDialog(context);
      CriticalSumInsuredModel sumInsuredModel = CriticalSumInsuredModel();
      if (response != null) {
        if (showRecommended) {
          sumInsuredModel = recommendedSumInsuredList[_selectedIndex];
          sumInsuredModel.premiumReqModel = premiumReqModel;
          sumInsuredModel.premiumResModel = response;
          var timePeriod = response.data;
          if (timePeriod != null) {
            sumInsuredModel.timePeriodList = response?.data ?? null;
          }
        } else {
          sumInsuredModel = sumInsuredList[_selectedIndex];
          sumInsuredModel.premiumReqModel = premiumReqModel;
          sumInsuredModel.premiumResModel = response;
          var timePeriod = response.data;
          if (timePeriod != null) {
            sumInsuredModel.timePeriodList = response?.data ?? null;
          }
        }
      }

      widget.criticalIllnessModel.sumInsuredModel = sumInsuredModel;
      Navigator.of(context).pushNamed(CriticalTimePeriodScreen.ROUTE_NAME,
          arguments: widget.criticalIllnessModel);
    } else {
      hideLoaderDialog(context);
      return;
    }
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

  /* void createSumInsuredValue() {
    sumInsuredList = [
      CriticalSumInsuredModel(
          amount: 200000,
          amountString: '₹2 Lakhs',
          isSelected: false,
          timePeriodList: timePeriod,
          premium: '0',
          premiumReqModel: criticalIllnessModel.premiumReqModel,
          premiumResModel: criticalIllnessModel.premiumResModel),
      CriticalSumInsuredModel(
        amount: 300000,
        amountString: '₹3 Lakhs',
        premium: '0',
      ),
      CriticalSumInsuredModel(
        amount: 400000,
        amountString: '₹4 Lakhs',
        premium: '0',
      ),
      CriticalSumInsuredModel(
        amount: 500000,
        amountString: '₹5 Lakhs',
        premium: '0',
      ),
      CriticalSumInsuredModel(
        amount: -1,
        premium: '-1',
        amountString: '5+ \nLakhs',
      )
    ];

    recommendedSumInsuredList = [
      CriticalSumInsuredModel(
          amount: 200000,
          amountString: '₹2 Lakhs',
          isSelected: false,
          timePeriodList: timePeriod,
          premium: '0',
          premiumReqModel: criticalIllnessModel.premiumReqModel,
          premiumResModel: criticalIllnessModel.premiumResModel),
      CriticalSumInsuredModel(
        amount: 300000,
        amountString: '₹3 Lakhs',
        premium: '0',
      ),
      CriticalSumInsuredModel(
        amount: 500000,
        amountString: '₹5 Lakhs',
        premium: '0',
      ),
      CriticalSumInsuredModel(
        amount: -1,
        premium: '0',
        amountString: 'more',
      )
    ];
  }*/

  void _createSumInsuredModel(
      CriticalSumInsuredResModel criticalSumInsuredResModel) {
    var data = criticalSumInsuredResModel?.data ?? [];
    CriticalSumInsuredModel criticalSumInsuredModel;
    for (var i = 0; i < data.length; i++) {
      criticalSumInsuredModel = CriticalSumInsuredModel();
      criticalSumInsuredModel.amount = data[i].suminsured ?? 0;
      criticalSumInsuredModel.premium = data[i].year1Premium;
      criticalSumInsuredModel.amountString =
          CommonUtil.instance.convertSumInsured(data[i].suminsured);
      if (data[i].suminsured == 200000 ||
          data[i].suminsured == 300000 ||
          data[i].suminsured == 500000) {
        recommendedSumInsuredList.add(criticalSumInsuredModel);
      }
      sumInsuredList.add(criticalSumInsuredModel);
    }
    if (recommendedSumInsuredList != null) {
      recommendedSumInsuredList..sort((a, b) => a.amount.compareTo(b.amount));
      recommendedSumInsuredList.add(CriticalSumInsuredModel(
          amount: -1, premium: -1, amountString: 'more'));
    }
    if (sumInsuredList != null) {
      sumInsuredList.sort((a, b) => a.amount.compareTo(b.amount));
      sumInsuredList.add(CriticalSumInsuredModel(
          amount: -1, premium: -1, amountString: '5+ Lakhs'));
    }
  }

  Widget buildSumInsured(CriticalSumInsuredModel sumInsuredList, int index) {
    var amtStr;
    String value = '';
    try {
      amtStr = sumInsuredList.amountString.split(' ');
      value = amtStr[0] + '\n' + amtStr[1];
    } catch (e) {
      value = sumInsuredList.amountString;
    }
    return InkResponse(
      onTap: () {
        onUpdate(index);
      },
      child: SumInsuredWidget(
          index,
          sumInsured: value,
          isSelected: sumInsuredList.isSelected,
          premium: CommonUtil.instance
              .getCurrencyFormat()
              .format(sumInsuredList?.premium ?? 0),
        ),
    );
  }
}
