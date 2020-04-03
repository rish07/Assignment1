
import 'package:sbig_app/src/models/api_models/home/arogya_plus/agent_receipt_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';

class SelectedMemberDetails{
  int isFrom;
  CalculatePremiumReqModel calculatePremiumReqModel;
  List<GeneralListModel> policyMembers;
  PolicyType policyType;
  Set<int> selectedMemberIds;
  PersonalDetails personalDetails;
  CalculatedPremiumResModel calculatedPremiumResModel;
  //Default 1 Year
  TimePeriod selectedYearAndPremium;
  SumInsuredModel selectedSumInsured;
  // Final selected
  TimePeriodModel finalSelectedYearAndPremium;
  PolicyPeriod policyPeriod;
  String quoteNumber;
  RecalculatePremiumReqModel recalculatePremiumReqModel;
  RecalculatePremiumResModel recalculatePremiumResModel;
  BuyerDetails buyerDetails;
  bool isProposerSelf;
  AgentReceiptModel agentReceiptModel;

  SelectedMemberDetails({this.isFrom, this.calculatePremiumReqModel, this.policyMembers,
      this.selectedMemberIds, this.personalDetails, this.calculatedPremiumResModel, this.selectedSumInsured, this.policyPeriod, this.quoteNumber, this.recalculatePremiumReqModel, this.recalculatePremiumResModel, this.buyerDetails, this.isProposerSelf, this.agentReceiptModel});

}

class PolicyType{
  int id;
  String policyTypeString;

  PolicyType(this.id, this.policyTypeString);
}

class PolicyPeriod{
  DateTime startDate;
  DateTime endDate;

  PolicyPeriod({this.startDate, this.endDate});
}

class BuyerDetails{
  ProposerDetailsModel proposerDetails;
  CommunicationDetailsModel communicationDetailsModel;
  NomineeDetailsModel nomineeDetailsModel;
  bool isNomineeMinor;
  AppointeeDetailsModel appointeeDetailsModel;

  BuyerDetails({this.proposerDetails, this.communicationDetailsModel,
      this.nomineeDetailsModel, this.isNomineeMinor,
      this.appointeeDetailsModel});


}