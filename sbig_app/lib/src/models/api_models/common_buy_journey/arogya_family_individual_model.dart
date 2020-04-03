import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_sum_insured_screen.dart';

class ArogyaFamilyIndividualModel {
  int age;
  String gender;
  int sumInsured;
  dynamic premium;
  dynamic deduction;
  int memberIndex;
  MemberDetailsModel memberDetails;
  SumInsuredResModel sumInsuredResModel;
  ArogyaTopUpSumInsuredResModel arogyaTopUpSumInsuredResModel;

  ArogyaFamilyIndividualModel(
      {this.age,
      this.gender,
      this.sumInsured,
      this.premium,
      this.memberDetails,
      this.sumInsuredResModel,
      this.memberIndex,
      this.deduction,
      this.arogyaTopUpSumInsuredResModel});
}
