
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sbig_app/src/resources/color_constants.dart';

class TabItemModel{

  final String icon;
  final String title;
  final Color titleColor;
  final String activeIcon;
  final Color activeTitleColor;

  TabItemModel({this.icon, this.title, this.titleColor, this.activeIcon, this.activeTitleColor});

}