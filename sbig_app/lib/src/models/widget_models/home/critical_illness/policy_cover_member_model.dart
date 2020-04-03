

import 'dart:ui';

import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';


class PolicyCoverMemberModel {
  final String title;
  final String icon;
  final String activeIcon;
  final Color titleColor;
  final List<String> ageList;
  final List<String> gender;
  final Color color1;
  final Color color2;
  final dynamic priority;
  MemberDetailsModel memberDetailsModel;


  PolicyCoverMemberModel( {this.title, this.icon, this.activeIcon,this.ageList, this.gender,this.color1,this.color2,this.titleColor,this.memberDetailsModel,this.priority});
}