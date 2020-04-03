import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_period_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/sum_insured_and_premium_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dashed_line.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class PremiumBreakupScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_plus/premium_breakup_screen";
  static const ROUTE_NAME_TWO =
      "/arogya_plus/recalculate/premium_breakup_screen";
  static const FROM_HEALTH_QUESTIONNAIRE = 1;
  static const FROM_TIME_PERIOD_SCREEN = 2;

  final SelectedMemberDetails selectedMemberDetails;

  PremiumBreakupScreen(this.selectedMemberDetails);

  @override
  _PremiumBreakupScreenState createState() => _PremiumBreakupScreenState();
}

class _PremiumBreakupScreenState extends State<PremiumBreakupScreen>
    with CommonWidget {
  List<MapModel> mapList, premiumList;
  TimePeriodModel timePeriodModel;
  PolicyType policyType;
  List<GeneralListModel> policyMemberDetails;
  SumInsuredModel sumInsuredModel;
  bool isFromRecalculatePremium = false;

  @override
  void didChangeDependencies() {
    sumInsuredModel = widget.selectedMemberDetails.selectedSumInsured;
    timePeriodModel = widget.selectedMemberDetails.finalSelectedYearAndPremium;
    policyType = widget.selectedMemberDetails.policyType;
    policyMemberDetails = widget.selectedMemberDetails.policyMembers;
    isFromRecalculatePremium = (widget.selectedMemberDetails.isFrom ==
        PremiumBreakupScreen.FROM_HEALTH_QUESTIONNAIRE);

    List<MemberModel> membersList = List();
    for (GeneralListModel policyMember in policyMemberDetails) {
      MemberDetailsModel memberDetailsModel = policyMember.memberDetailsModel;
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;
      String ageGenderString =
          "(${ageGenderModel.gender}, ${ageGenderModel.ageString})";
      MemberModel memberModel =
          MemberModel(memberDetailsModel.relation, ageGenderString);
      membersList.add(memberModel);
    }

    mapList = [
      MapModel(S.of(context).policy_title,
          value: S.of(context).arogya_plus_title),
      MapModel(S.of(context).policy_type_title,
          value: policyType.policyTypeString),
//      MapModel(S.of(context).covered_title, subValueList: membersList),
      MapModel( (policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL)?S.of(context).sum_insured_title_each:S.of(context).sum_insured_title,
      //MapModel( S.of(context).sum_insured_title_each,
          value: sumInsuredModel.amountString),
      MapModel(S.of(context).period_title, value: timePeriodModel.yearString),
//      MapModel(S.of(context).opd_limit_title,
//          value: CommonUtil.instance
//              .getCurrencyFormat()
//              .format(int.parse(timePeriodModel.opd.toString())))
    ];

    premiumList = [
      MapModel(S.of(context).net_premium_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.discountedPremium)),
//      MapModel(S.of(context).period_title, value: timePeriodModel.yearString),
//      MapModel(S.of(context).discount_title,
//          value: timePeriodModel.discountPercentage.toString()),
      MapModel(S.of(context).applicable_tax_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.tax_amount)),
    ];

    if(policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL){

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
    }

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
                        premiumBreakupWidget(),
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

  premiumBreakupWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  borderRadius(radius: 5.0, topLeft: 5.0, topRight: 5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 15.0, right: 15.0, bottom: 10.0),
                  child: Text(
                    isFromRecalculatePremium
                        ? S.of(context).recalculated_premium_title
                        : S.of(context).premium_breakup_title,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: StringConstants.EFFRA_LIGHT,
                        fontSize: 24.0),
                  ),
                ),
                getDecoration(true),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      S.of(context).policy_details_title.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.0),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: mapList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildPolicyDetailsItem(mapList[index]);
                      }),
                ),
                getDecoration(false),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    S.of(context).premium_details_title.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: premiumList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildPremiumDetailsValueItem(premiumList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    child: DashedLineWidget(
                      height: 1.5,
                      color: ColorConstants.policy_type_gradient_color2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 10.0, bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        S.of(context).total_premium_title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700),
                      ),
                      Expanded(
                        child: Text(
                          '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.total_premium)}',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
              transform: Matrix4.translationValues(0, -10, 0),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Image.asset(AssetConstants.ic_bottom_decoration),
              ))
        ],
      ),
    );
  }

  _showButton() {
    onClick() {
      Navigator.of(context).pushNamed(PolicyPeriodScreen.ROUTE_NAME,
          arguments: widget.selectedMemberDetails);
    }

    onProceedBuy() {
      Navigator.of(context).pushNamed(InsuranceBuyerDetailsScreen.ROUTE_NAME,
          arguments: widget.selectedMemberDetails);
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

  buildPolicyDetailsItem(MapModel mapItem) {
    print(mapItem.key);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 100,
            child: Text(
              mapItem.key,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          buildPolicyDetailsValueItem(mapItem, mapItem.subValueList)
        ],
      ),
    );
  }

  buildPremiumDetailsValueItem(MapModel mapItem) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: <Widget>[
//          Container(
//            width: 100,
//            child: Text(
//              mapItem.key,
//              style: TextStyle(
//                  color: Colors.grey[600],
//                  fontSize: 14.0,
//                  fontWeight: FontWeight.w500),
//            ),
//          ),
          Text(
            mapItem.key,
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              mapItem.value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }

  buildPolicyDetailsValueItem(
      MapModel mapItem, List<MemberModel> subValueList) {
    if (subValueList == null) {
      if (mapItem.key.compareTo(S.of(context).sum_insured_title) == 0 ||
          mapItem.key.compareTo(S.of(context).sum_insured_title_each) == 0) {
        return Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorConstants.arogya_plus_si_edit_color),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                child: Text(
                  mapItem.value,
                  style: TextStyle(
                      color: ColorConstants.policy_type_gradient_color2,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: () {
                Navigator.popUntil(context,
                    ModalRoute.withName(SumInsuredAndPremiumScreen.ROUTE_NAME));
              },
              child: SizedBox(
                width: 15,
                height: 15,
                child: Image.asset(AssetConstants.ic_edit),
              ),
            )
          ],
        );
      } else {
        return Text(
          mapItem.value,
          style: TextStyle(color: Colors.black, fontSize: 14.0),
        );
      }
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getCoveredWidgetList(subValueList));
    }
  }

  getCoveredWidgetList(List<MemberModel> subValueList) {
    List<Row> rowList = List<Row>();
    int i = 0;
    for (MemberModel item in subValueList) {
      Row row = Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: (i != 0) ? 8.0 : 0.0),
            child: Text(
              item.relation,
              style: TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: (i != 0) ? 8.0 : 0.0),
            child: Text(
              item.details,
              style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
            ),
          ),
        ],
      );

      i++;
      rowList.add(row);
    }
    return rowList;
  }

  getDecoration(bool isTop) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(0.0),
          width: 10.0,
          height: 16.0,
          transform: Matrix4.translationValues(-2, 0, 0),
          child: isFromRecalculatePremium
              ? Image.asset(isTop
                  ? AssetConstants.ic_half_circle_left_top_black
                  : AssetConstants.ic_half_circle_left_bottom_black)
              : Image.asset(isTop
                  ? AssetConstants.ic_half_circle_left_top
                  : AssetConstants.ic_half_circle_left_bottom),
        ),
        Expanded(
          child: DashedLineWidget(
            height: 1.5,
            color: ColorConstants.policy_type_gradient_color2,
          ),
        ),
        Container(
          margin: EdgeInsets.all(0.0),
          width: 10.0,
          height: 16.0,
          transform: Matrix4.translationValues(2, 0, 0),
          child: isFromRecalculatePremium
              ? Image.asset(isTop
                  ? AssetConstants.ic_half_circle_right_top_black
                  : AssetConstants.ic_half_circle_right_bottom_black)
              : Image.asset(isTop
                  ? AssetConstants.ic_half_circle_right_top
                  : AssetConstants.ic_half_circle_right_bottom),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.selectedMemberDetails.isFrom =
        PremiumBreakupScreen.FROM_TIME_PERIOD_SCREEN;
    super.dispose();
  }
}
