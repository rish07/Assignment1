import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_period.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/sum_insured_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/agent_receipt_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/eia_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';

import 'arogya_family_individual_model.dart';

class ArogyaModel {
  int isPremiumFrom;
  PersonalDetails personalDetails;
  PolicyType policyType;
  List<PolicyCoverMemberModel> policyMembers;
  Set<int> selectedMemberIds;
  SumInsuredResModel sumInsuredResModel;
  List<ArogyaFamilyIndividualModel> arogyaFamilyIndividualModel;
  HealthQuestionResModel healthQuestionResModel;
  EIAModel eiaModel;
  PolicyPeriod policyPeriod;
  bool isProposerSelf;
  BuyerDetails buyerDetails;
  AgentReceiptModel agentReceiptModel;
  String quoteNumber;

  ArogyaModel({
    this.isPremiumFrom,
    this.policyMembers,
    this.policyType,
    this.selectedMemberIds,
    this.personalDetails,
    this.policyPeriod,
    this.quoteNumber,
    this.buyerDetails,
    this.isProposerSelf,
    this.agentReceiptModel,
    this.sumInsuredResModel,
    this.healthQuestionResModel,
    this.eiaModel,
  });
}

class BuyerDetails {
  ProposerDetailsModel proposerDetails;
  CommunicationDetailsModel communicationDetailsModel;
  NomineeDetailsModel nomineeDetailsModel;
  bool isNomineeMinor;
  AppointeeDetailsModel appointeeDetailsModel;

  BuyerDetails(
      {this.proposerDetails,
      this.communicationDetailsModel,
      this.nomineeDetailsModel,
      this.isNomineeMinor,
      this.appointeeDetailsModel});
}
