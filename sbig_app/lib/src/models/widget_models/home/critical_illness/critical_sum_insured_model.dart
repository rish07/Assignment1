import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';

class CriticalSumInsuredModel {
  int amount;
  String amountString;
  bool isSelected ;
  dynamic premium;
  List<Data> timePeriodList;
  CriticalPremiumReqModel premiumReqModel;
  CriticalPremiumResModel premiumResModel;

  CriticalSumInsuredModel({
    this.amount,
    this.amountString,
    this.timePeriodList,
    this.premiumResModel,
    this.premiumReqModel,
    this.isSelected=false,
    this.premium
  });
}