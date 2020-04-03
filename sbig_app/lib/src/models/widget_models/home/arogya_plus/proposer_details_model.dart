

import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';

class ProposerDetailsModel{
  String gender;
  String firstName;
  String lastName;
  DobFormat dobFormat;
  String agentCode;

  ProposerDetailsModel({this.gender, this.firstName, this.lastName,
      this.dobFormat,this.agentCode});

}