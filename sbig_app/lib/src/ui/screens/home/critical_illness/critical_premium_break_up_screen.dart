import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';

import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';

import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_illness_insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_sum_insured_new_screen.dart';
import 'package:sbig_app/src/ui/screens/home/critical_illness/critical_sum_insured_screen.dart';

import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dashed_line.dart';
import 'package:sbig_app/src/ui/widgets/common_buy_journey/premium_breakup_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';

import 'critical_time_period_screen.dart';


class CriticalPremiumBreakupScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/critical_illness/premium_breakup_screen";
  static const FROM_HEALTH_QUESTIONNAIRE = 1;
  static const FROM_TIME_PERIOD_SCREEN = 2;

  final CriticalIllnessModel criticalIllnessModel;

  CriticalPremiumBreakupScreen(this.criticalIllnessModel);

  @override
  _PremiumBreakupScreenState createState() => _PremiumBreakupScreenState();
}

class _PremiumBreakupScreenState extends State<CriticalPremiumBreakupScreen>
    with CommonWidget {
  List<MapModel> mapList, premiumList;
  CriticalTimePeriodModel timePeriodModel;
  String policyType;
  PolicyCoverMemberModel policyMemberDetails;
  CriticalSumInsuredModel sumInsuredModel;
  bool isFromRecalculatePremium = false;
  List<MemberModel> membersList = List();

  @override
  void didChangeDependencies() {
    sumInsuredModel = widget.criticalIllnessModel.sumInsuredModel;
    timePeriodModel = widget.criticalIllnessModel.timePeriodModel;
    policyType = widget.criticalIllnessModel.policyTpeString;
    policyMemberDetails = widget.criticalIllnessModel.policyCoverMemberModel;
    //isFromRecalculatePremium = (widget.criticalIllnessModel.isFrom == PremiumBreakupScreen.FROM_HEALTH_QUESTIONNAIRE);
    membersList = List();
    if ( policyMemberDetails != null) {
      MemberDetailsModel memberDetailsModel = policyMemberDetails.memberDetailsModel;
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
      String ageGenderString = ", ${ageGenderModel.gender}, ${ageGenderModel.ageString}";
      MemberModel memberModel = MemberModel(memberDetailsModel.relation, ageGenderString);
      membersList.add(memberModel);
    }
    var amt =sumInsuredModel.amount.toString().replaceAll('0', '');
    int amount=0;
    try{
     amount = int.parse(amt);
    }catch(e){
    }

    mapList = [
      MapModel(S.of(context).policy_title, value: S.of(context).critical_illness),
      MapModel(S.of(context).policy_type_title, value: policyType),
      MapModel(S.of(context).sum_insured_title,value:(amount<=1)? CommonUtil.instance.getCurrencyFormat().format(amount)+' Lakh': CommonUtil.instance.getCurrencyFormat().format(amount)+' Lakhs'),
      MapModel(S.of(context).period_title, value: timePeriodModel.yearString),
//
    ];

    premiumList = [
      MapModel(S.of(context).gross_premium, value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.discountedPremium)),
      MapModel(S.of(context).applicable_tax_title, value: CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.taxAmount)),
    ];

    //NO discount for critical illness .. incase required need to uncomment below code .

   /* if(policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL){

      int insertPosition = 1;

      if(!TextUtils.isEmpty(timePeriodModel.member_discount_percentage.toString()) && timePeriodModel.member_discount_percentage.toString().compareTo("0") != 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .family_discount_title +
            "(${timePeriodModel.member_discount_percentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.member_discount_value)));
        insertPosition = 2;
      }

      if(timePeriodModel.discountPercentage > 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .long_term_discount_title +
            "(${timePeriodModel.discountPercentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.discount_value)));
      }
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
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        ColorConstants.eminence,
                        ColorConstants.disco,
                        ColorConstants.disco
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
                            Navigator.popUntil(context,
                                ModalRoute.withName(CriticalSumInsuredScreenNew.ROUTE_NAME));
                          },
                          onTimePeriodClick: (){
                            Navigator.popUntil(context,
                                ModalRoute.withName(CriticalTimePeriodScreen.ROUTE_NAME));
                          },
                          isTimePeriodEditable: true,
                          premiumList: premiumList,
                          memberMapList:  membersList,
                          title: isFromRecalculatePremium
                              ? S.of(context).recalculated_premium_title
                              : S.of(context).premium_breakup_title,
                          totalPremium: '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.totalPremium)}' ,

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
                padding: EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0),
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
      Navigator.of(context).pushNamed(CriticalIllnessPolicyPeriodScreen.ROUTE_NAME, arguments: widget.criticalIllnessModel);
    }

    onProceedBuy() {
      Navigator.of(context).pushNamed(CriticalIllnessInsuranceBuyerDetailsScreen.ROUTE_NAME, arguments: widget.criticalIllnessModel);
    }

    if (isFromRecalculatePremium) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: MaterialButton(
          height: 40,
          minWidth: 180,
          color: ColorConstants.disco,
          onPressed: onProceedBuy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textColor: Colors.white,
          highlightColor: ColorConstants.disco,
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
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 8.0 : 0.0),
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
    super.dispose();
  }
}
