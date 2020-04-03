
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';

class GeneralListModel{
  final String title;
  final String subTitle;
  final String icon;

  final Color titleColor;
  final Color subTitleColor;
  final String activeIcon;
  MemberDetailsModel memberDetailsModel;
  final String moreInfo;

  GeneralListModel({this.title, this.subTitle, this.icon, this.titleColor = Colors.black,
      this.subTitleColor = Colors.grey, this.activeIcon, this.memberDetailsModel, this.moreInfo});

}