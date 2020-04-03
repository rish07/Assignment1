
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';

class NomineeDetailsModel{
  String gender;
  String firstName;
  String lastName;
  String relationshipWith;
  DobFormat dobFormat;

  NomineeDetailsModel({this.gender, this.firstName, this.lastName,
      this.relationshipWith, this.dobFormat});


}