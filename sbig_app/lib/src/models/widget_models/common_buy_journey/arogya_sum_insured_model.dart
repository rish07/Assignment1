

import 'package:sbig_app/src/models/api_models/common_buy_journey/data_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_sum_insured.dart' as sumInsured ;


class ArogyaSumInsuredModel {
  int amount;
  String amountString;
  dynamic premium ;
  dynamic deduction;
  List<sumInsured.DeductionList> deductionList;
  bool isSelected ;
  bool isRecommended ;
  Data timePeriod;
  ArogyaPremierPremiumReqModel arogyaPremierPremiumReqModel;
  ArogyaPremierPremiumResModel arogyaPremierPremiumResModel;
  ArogyaTopUpPremiumReqModel arogyaTopUpPremiumReqModel;
  ArogyaTopUpPremiumResModel arogyaTopUpPremiumResModel;

  ArogyaSumInsuredModel({
    this.amount,
    this.amountString,
    this.timePeriod,
    this.isSelected=false,
    this.arogyaPremierPremiumResModel,
    this.arogyaPremierPremiumReqModel,
    this.premium,
    this.isRecommended=false,
    this.deduction,
    this.arogyaTopUpPremiumResModel,
    this.arogyaTopUpPremiumReqModel,
    this.deductionList
  });
}