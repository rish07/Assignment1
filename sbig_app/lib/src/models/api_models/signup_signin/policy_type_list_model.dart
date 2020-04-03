import 'dart:ui';

import 'package:flutter/material.dart';

class PolicyTypesListModel{
  final String title;
  final String subTitle;
  final String icon;

  final Color titleColor;
  final Color subTitleColor;
  final String activeIcon;
  final String moreInfo;

  final String productCode;
  final String policyType;
  final String policyTypeName;
  final int navigateId;

  PolicyTypesListModel({this.title, this.subTitle, this.icon, this.titleColor = Colors.black,
    this.subTitleColor = Colors.grey, this.activeIcon, this.moreInfo, this.productCode, this.policyType, this.policyTypeName, this.navigateId});

}