import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';

class SumInsuredModel {
  int amount;
  String amountString;
  List<TimePeriod> timePeriodList;
  CalculatePremiumReqModel calculatePremiumReqModel;
  CalculatedPremiumResModel calculatedPremiumResModel;

  SumInsuredModel({
      this.amount,
      this.amountString,
      this.timePeriodList, this.calculatePremiumReqModel, this.calculatedPremiumResModel});
}
