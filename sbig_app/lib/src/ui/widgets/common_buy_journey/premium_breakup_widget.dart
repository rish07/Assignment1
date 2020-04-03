import 'package:flutter/material.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/dashed_line.dart';

import '../statefulwidget_base.dart';

class PremiumBreakUpWidget extends StatelessWidget with CommonWidget {

  final String title ;
  final bool isFromRecalculatePremium;
  final List<MapModel> mapList;
  final List<MapModel> premiumList;
  final List<MemberModel> memberMapList;
  final Function() onClick;
  final Function() onMemberSumInsuredClick;
  final Function() onTimePeriodClick;
  final BuildContext context;
  final String totalPremium;
  final bool isTimePeriodEditable;
  final int policyType;

  PremiumBreakUpWidget({this.title, this.isFromRecalculatePremium=false, this.mapList, this.premiumList, this.onClick, this.context, this.totalPremium, this.onTimePeriodClick, this.isTimePeriodEditable=false, this.memberMapList, this.policyType, this.onMemberSumInsuredClick});

  @override
  Widget build(BuildContext context) {
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
                      title,
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
                if(memberMapList != null && memberMapList.length !=0)
                  getDecoration(false),
                if(memberMapList!=null && memberMapList.length != 0)
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        S.of(context).member_details_title.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.0),
                      )),
                if(memberMapList !=null && memberMapList.length !=0)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:(getCoveredMemberWidgetList(memberMapList))),
                    ),
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
                      color: ColorConstants.disco,
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
                          totalPremium,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28.0,
                            fontWeight: FontWeight.w600
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

  getDecoration(bool isTop, ) {
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
            color: ColorConstants.disco,
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

  buildPolicyDetailsItem(MapModel mapItem) {
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
              style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  buildPolicyDetailsValueItem(MapModel mapItem, List<MemberModel> subValueList) {
    if (subValueList == null) {
      if (mapItem.key.compareTo(S.of(context).sum_insured_title) == 0 || mapItem.key.compareTo(S.of(context).sum_insured_title_each) == 0) {
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
                      color: ColorConstants.disco,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: onClick,
              child: SizedBox(
                width: 15,
                height: 15,
                child: Image.asset(AssetConstants.ic_edit),
              ),
            )
          ],
        );
      } else if(mapItem.key.compareTo(S.of(context).deductible) == 0){
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
                      color: ColorConstants.disco,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: onClick,
              child: SizedBox(
                width: 15,
                height: 15,
                child: Image.asset(AssetConstants.ic_edit),
              ),
            )
          ],
        );
      }

      else if(mapItem.key.compareTo(S.of(context).period_title) == 0 && isTimePeriodEditable){
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
              width: 15,
            ),
            InkWell(
              onTap: onTimePeriodClick,
              child: SizedBox(
                width: 15,
                height: 15,
                child: Image.asset(AssetConstants.ic_edit),
              ),
            )
          ],
        );
      }else {
        return Text(
          mapItem.value,
          style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
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

  getCoveredMemberWidgetList(List<MemberModel> subValueList) {
    List<Row> rowList = List<Row>();
    int i = 0;
    for (MemberModel item in subValueList) {
      Row row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: 100,
              child: Text(
                  'Member ${i+1} :',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              item.relation,
              style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:8.0 ),
            child: Text(
              item.details,
              style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
      i++;
      rowList.add(row);

      if(item.sumInsured !=null && item.sumInsured.length!=0){
        Row row = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                width: 100,
                child: Text(
                  S.of(context).sum_insured_title+" :",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.arogya_plus_si_edit_color),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                  child: Text(
                    item.sumInsured,
                    style: TextStyle(
                        color: ColorConstants.disco,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            InkWell(
              onTap: onMemberSumInsuredClick,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset(AssetConstants.ic_edit),
                ),
              ),
            )
          ],
        );
        i++;
        rowList.add(row);
      }
      if(item.deduction !=null && item.deduction.length!=0){
        Row row = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                width: 100,
                child: Text(
                  S.of(context).deductible+" :",
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ColorConstants.arogya_plus_si_edit_color),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 3.0, bottom: 3.0),
                  child: Text(
                    item.deduction,
                    style: TextStyle(
                        color: ColorConstants.policy_type_gradient_color2,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            InkWell(
              onTap: onMemberSumInsuredClick,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset(AssetConstants.ic_edit),
                ),
              ),
            )
          ],
        );
        i++;
        rowList.add(row);
      }

    }
    return rowList;
  }
}


