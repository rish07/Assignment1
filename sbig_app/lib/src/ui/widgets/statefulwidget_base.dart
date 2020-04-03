import 'package:flutter/material.dart';
export 'package:flutter/material.dart';

import 'package:sbig_app/src/resources/string_constants.dart';
export 'package:sbig_app/src/resources/string_constants.dart';

import 'package:sbig_app/generated/i18n.dart';
export 'package:sbig_app/generated/i18n.dart';

import 'package:shared_preferences/shared_preferences.dart';
export 'package:shared_preferences/shared_preferences.dart';

import 'package:sbig_app/src/resources/asset_constants.dart';
export 'package:sbig_app/src/resources/asset_constants.dart';

import 'package:sbig_app/src/resources/color_constants.dart';
export 'package:sbig_app/src/resources/color_constants.dart';

import 'package:sbig_app/src/utilities/common_util.dart';
export 'package:sbig_app/src/utilities/common_util.dart';

abstract class StatefulWidgetBase extends StatefulWidget {
  static const int FROM_HOME_SCREEN = 1;
  const StatefulWidgetBase({ Key key }) : super(key: key);
}
