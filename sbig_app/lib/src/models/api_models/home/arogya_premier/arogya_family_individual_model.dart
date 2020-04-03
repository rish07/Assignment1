import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';

class ArogyaFamilyIndividualModel{

  int age;
  String gender;
  int sumInsured;
  dynamic premium;
  int memberIndex;
  MemberDetailsModel memberDetails;
  SumInsuredResModel sumInsuredResModel;

  ArogyaFamilyIndividualModel({this.age, this.gender, this.sumInsured,
    this.premium, this.memberDetails, this.sumInsuredResModel,this.memberIndex});


}