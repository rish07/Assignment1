import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/other_insurance_company_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/critical_time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/other_critical_illness_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/eia_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';

class CriticalIllnessModel {
  String grossIncome;
  double bmi;
  PolicyTimePeriod policyTimePeriod;
  PersonalDetails personalDetails;
  PolicyCoverMemberModel policyCoverMemberModel;
  OtherCriticalIllness otherCriticalIllness;
  List<OtherCriticalIllnessDetailsModel> otherCriticalIllnessDetails;
  OtherInsuranceCompanyList otherInsuranceCompanyList;
  EIAModel eiaModel;
  bool isProposerSelf;
  CriticalIllnessBuyerDetails buyerDetails;
  String quoteNumber;
  String policyTpeString;

  CriticalSumInsuredReqModel criticalSumInsuredReqModel;
  CriticalSumInsuredResModel criticalSumInsuredResModel;

  CriticalSumInsuredModel sumInsuredModel; //final selected
  CriticalTimePeriodModel timePeriodModel; // final selected

  CriticalPremiumReqModel premiumReqModel;
  CriticalPremiumResModel premiumResModel;

  QuickQuoteReqModel quickQuoteReqModel;
  QuickQuoteResModel quoteResModel;

  FullQuoteReqModel fullQuoteReqModel;
  FullQuoteResModel fullQuoteResModel;

  HealthQuestionResModel healthQuestionResModel;

  CriticalIllnessModel(
      {this.grossIncome,
      this.policyTimePeriod,
      this.personalDetails,
      this.policyCoverMemberModel,
      this.otherCriticalIllness,
      this.otherCriticalIllnessDetails,
      this.eiaModel,
      this.sumInsuredModel,
      this.isProposerSelf,
      this.buyerDetails,
      this.quoteNumber,
      this.policyTpeString,
      this.timePeriodModel,
      this.premiumResModel,
      this.premiumReqModel,
      this.healthQuestionResModel,
      this.quickQuoteReqModel,
      this.quoteResModel,
      this.fullQuoteResModel,
      this.fullQuoteReqModel,
      this.bmi});
}

class PolicyTimePeriod {
  DateTime startDate;
  DateTime endDate;

  PolicyTimePeriod({this.startDate, this.endDate});
}

class CriticalIllnessBuyerDetails {
  ProposerDetailsModel proposerDetails;
  CommunicationDetailsModel communicationDetailsModel;
  NomineeDetailsModel nomineeDetailsModel;
  bool isNomineeMinor;
  AppointeeDetailsModel appointeeDetailsModel;

  CriticalIllnessBuyerDetails(
      {this.proposerDetails,
      this.communicationDetailsModel,
      this.nomineeDetailsModel,
      this.isNomineeMinor,
      this.appointeeDetailsModel});
}

class OtherCriticalIllness {
  bool otherCriticalIllnessAvailable;
  bool isOtherCriticalIllnessClaimed;

  OtherCriticalIllness(
      {this.otherCriticalIllnessAvailable, this.isOtherCriticalIllnessClaimed});
}
