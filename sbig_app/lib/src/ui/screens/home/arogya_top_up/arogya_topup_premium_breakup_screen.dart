import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';

import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';

import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insurance_buyer_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_sum_insured_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_time_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_cover_member_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_top_up_time_period.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_sum_insured_screen.dart';

import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/premium_breakup_widget.dart';

import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

import 'arogya_top_up_policy_period.dart';

class ArogyaTopUpPremiumBreakupScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_top_up/premium_breakup_screen";
  static const ROUTE_NAME_TWO = "/arogya_top_up/recalculate/premium_breakup_screen";
  static const FROM_HEALTH_QUESTIONNAIRE = 1;
  static const FROM_TIME_PERIOD_SCREEN = 2;

  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpPremiumBreakupScreen(this.arogyaTopUpModel);

  @override
  _PremiumBreakupScreenState createState() => _PremiumBreakupScreenState();
}

class _PremiumBreakupScreenState extends State<ArogyaTopUpPremiumBreakupScreen>
    with CommonWidget {
  List<MapModel> mapList, premiumList;
  ArogyaTimePeriodModel timePeriodModel;
  PolicyType policyType;
  List<PolicyCoverMemberModel> policyMemberDetails;
  ArogyaSumInsuredModel sumInsuredModel;
  bool isFromRecalculatePremium = false;
  List<MemberModel> membersList = List();
  String sumInsuredValue='';

  @override
  void didChangeDependencies() {
    sumInsuredModel = widget.arogyaTopUpModel.selectedSumInsured;
    timePeriodModel = widget.arogyaTopUpModel.selectedTimePeriodModel;
    policyType = widget.arogyaTopUpModel.policyType;
    policyMemberDetails = widget.arogyaTopUpModel.policyMembers;
    isFromRecalculatePremium = (widget.arogyaTopUpModel.isPremiumFrom == ArogyaTopUpPremiumBreakupScreen.FROM_HEALTH_QUESTIONNAIRE);

    membersList = List();
    for (PolicyCoverMemberModel policyMember in policyMemberDetails) {
      MemberDetailsModel memberDetailsModel = policyMember.memberDetailsModel;
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
      String ageGenderString = ", ${ageGenderModel.gender}, ${ageGenderModel.ageString} ";
      MemberModel memberModel =
      MemberModel(memberDetailsModel.relation, ageGenderString,sumInsured: memberDetailsModel.sumInsuredString,deduction: memberDetailsModel.deductionString);
      membersList.add(memberModel);
    }

    mapList = [
      MapModel(S.of(context).policy_title, value: S.of(context).arogya_top_up),
      MapModel(S.of(context).policy_type_title, value: policyType.policyTypeString??''),
      if(policyType.id != PolicyTypeScreen.FAMILY_INDIVIDUAL)
      MapModel( S.of(context).sum_insured_title, value: CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredModel.amount)?? '' ),
      if(policyType.id != PolicyTypeScreen.FAMILY_INDIVIDUAL)
      MapModel( S.of(context).deductible, value: CommonUtil.instance.convertSumInsuredWithRupeeSymbol(sumInsuredModel.deduction)?? '' ),
      MapModel(S.of(context).period_title, value: timePeriodModel.yearString ??''),
    ];

    premiumList = [
      MapModel(S.of(context).base_premium_title, value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.basicPremium)??''),
      if(!TextUtils.isEmpty(timePeriodModel.discountPercentage.toString()) && timePeriodModel.discountPercentage.toString().compareTo("0") != 0)
        MapModel(S.of(context).tenure_discount_title + '('+ timePeriodModel.discountPercentage.toString() +'%)', value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.discountValue)??''),
      if(!TextUtils.isEmpty(timePeriodModel.member_discount_percentage.toString()) && timePeriodModel.member_discount_percentage.toString().compareTo("0") != 0)
        MapModel(S
            .of(context)
            .family_discount_title +
            "(${timePeriodModel.member_discount_percentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.member_discount_value ?? 0 )),
      MapModel(S.of(context).net_premium_title, value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.discountedPremium)??''),
//      MapModel(S.of(context).period_title, value: timePeriodModel.yearString),
//      MapModel(S.of(context).discount_title,value: timePeriodModel.discountPercentage.toString()),
      MapModel(S.of(context).applicable_tax_title, value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.taxAmount)??''),
    ];


  /*  if(policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL){

      int insertPosition = 2;

      if(!TextUtils.isEmpty(timePeriodModel.member_discount_percentage.toString()) && timePeriodModel.member_discount_percentage.toString().compareTo("0") != 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .family_discount_title +
            "(${timePeriodModel.member_discount_percentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.member_discount_value ?? 0 )));
        insertPosition = 3;
      }

      *//*if(timePeriodModel.discountPercentage > 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .long_term_discount_title +
            "(${timePeriodModel.discountPercentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.discountValue)));
      }*//*
    }*/

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      isFromRecalculatePremium ? Colors.black.withOpacity(0.5) : null,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              color: isFromRecalculatePremium
                  ? Colors.black.withOpacity(0.5)
                  : null,
              decoration: isFromRecalculatePremium
                  ? null
                  : BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        ColorConstants.policy_type_gradient_color2,
                        ColorConstants.policy_type_gradient_color1
                      ])),
            ),
            Column(
              children: <Widget>[
                getHeader(),
                Expanded(
                  child: Container(
                    height: ScreenUtil.getInstance(context).screenHeightDp - 100,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[

                        PremiumBreakUpWidget(
                          context: context,
                          isFromRecalculatePremium: isFromRecalculatePremium,
                          mapList: mapList,
                          onClick: () {
                            if(policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL){
                              Navigator.popUntil(context,
                                  ModalRoute.withName(ArogyaTopUpCoverMemberScreen.ROUTE_NAME));
                            }else{
                              Navigator.popUntil(context,
                                  ModalRoute.withName(ArogyaTopUpSumInsuredScreen.ROUTE_NAME));
                            }
                          },
                          onTimePeriodClick: (){
                            Navigator.popUntil(context,
                                ModalRoute.withName(ArogyaTopUpTimePeriodScreen.ROUTE_NAME));
                          },
                          onMemberSumInsuredClick: (){
                            Navigator.popUntil(context,
                                  ModalRoute.withName(ArogyaTopUpCoverMemberScreen.ROUTE_NAME));
                          },
                          isTimePeriodEditable: true,
                          premiumList: premiumList,
                          memberMapList:  membersList,
                          title: isFromRecalculatePremium
                              ? S.of(context).recalculated_premium_title
                              : S.of(context).premium_breakup_title,
                          totalPremium: '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.totalPremium)}',
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: _showButton()),
          ],
        ),
      ),
    );
  }

  Widget getHeader() {
    if (isFromRecalculatePremium) {
      return Container(
          child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
                child: getCloseButton(onClose: () {
                  Navigator.of(context).pop();
                }),
              )));
    } else {
      return getAppBar(context, S.of(context).review_quote.toUpperCase(),
          titleColor: Colors.white);
    }
  }

  _showButton() {
    onClick() {
      Navigator.of(context).pushNamed(ArogyaTopUpPolicyPeriodScreen.ROUTE_NAME,
          arguments: widget.arogyaTopUpModel);
    }

    onProceedBuy() {
      Navigator.of(context).pushNamed(ArogyaTopUpInsuranceBuyerDetailsScreen.ROUTE_NAME,
          arguments: widget.arogyaTopUpModel);
    }

    if (isFromRecalculatePremium) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: MaterialButton(
          height: 40,
          minWidth: 180,
          color: ColorConstants.premium_opd_amount_card_color,
          onPressed: onProceedBuy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textColor: Colors.white,
          highlightColor: ColorConstants.opd_amount_text_color,
          highlightElevation: 5.0,
          child: Text(
            S.of(context).proceed_to_buy.toUpperCase(),
            style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 12.0 : 0.0),
        child: BlackButtonWidget(
          onClick,
          S.of(context).proceed_to_buy.toUpperCase(),
          bottomBgColor: Colors.transparent,
        ),
      );
    }
  }

  @override
  void dispose() {
    if(widget?.arogyaTopUpModel !=null){
      widget.arogyaTopUpModel.isPremiumFrom = ArogyaTopUpPremiumBreakupScreen.FROM_TIME_PERIOD_SCREEN;
    }
    super.dispose();
  }
}
