import 'package:sbig_app/src/models/common/failure_model.dart';

import '../../common_buy_journey/arogya_policy_risk.dart';

class ArogyaPremierQuickQuoteReqModel {
  String arogyaPolicyType;
  String mobile;
  String email;
  String policyDuration;
  String effectiveDate;
  String expiryDate;
  String policyType;
  List<PolicyRiskList> policyRiskList;

  ArogyaPremierQuickQuoteReqModel(
      {this.arogyaPolicyType,
        this.mobile,
        this.email,
        this.policyDuration,
        this.effectiveDate,
        this.expiryDate,
        this.policyRiskList,
      this.policyType});

  ArogyaPremierQuickQuoteReqModel.fromJson(Map<String, dynamic> json) {
    arogyaPolicyType = json['ArogyaPolicyType'];
    mobile = json['Mobile'];
    email = json['Email'];
    policyDuration = json['PolicyDuration'];
    policyType = json['policy_type'];
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
    if (json['PolicyRiskList'] != null) {
      policyRiskList = new List<PolicyRiskList>();
      json['PolicyRiskList'].forEach((v) {
        policyRiskList.add(new PolicyRiskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArogyaPolicyType'] = this.arogyaPolicyType;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['PolicyDuration'] = this.policyDuration;
    data['policy_type'] = this.policyType;
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    if (this.policyRiskList != null) {
      data['PolicyRiskList'] =
          this.policyRiskList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class ArogyaPremierQuickQuoteResModel {
  bool success;
  String message;
  Data data;
ApiErrorModel apiErrorModel;
  ArogyaPremierQuickQuoteResModel({this.success, this.message, this.data});

  ArogyaPremierQuickQuoteResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  PolicyDetails policyDetails;
  PremiumDetails premiumDetails;
  List<MemberDetails> memberDetails;

  Data({this.policyDetails, this.premiumDetails, this.memberDetails});

  Data.fromJson(Map<String, dynamic> json) {
    policyDetails = json['policy_details'] != null
        ? new PolicyDetails.fromJson(json['policy_details'])
        : null;
    premiumDetails = json['premium_details'] != null
        ? new PremiumDetails.fromJson(json['premium_details'])
        : null;
    if (json['member_details'] != null) {
      memberDetails = new List<MemberDetails>();
      json['member_details'].forEach((v) {
        memberDetails.add(new MemberDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policyDetails != null) {
      data['policy_details'] = this.policyDetails.toJson();
    }
    if (this.premiumDetails != null) {
      data['premium_details'] = this.premiumDetails.toJson();
    }
    if (this.memberDetails != null) {
      data['member_details'] =
          this.memberDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyDetails {
  String policy;
  String policyType;
  int sumInsured;
  int duration;

  PolicyDetails({this.policy, this.policyType, this.sumInsured, this.duration});

  PolicyDetails.fromJson(Map<String, dynamic> json) {
    policy = json['policy'];
    policyType = json['policy_type'];
    sumInsured = json['sum_insured'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy'] = this.policy;
    data['policy_type'] = this.policyType;
    data['sum_insured'] = this.sumInsured;
    data['duration'] = this.duration;
    return data;
  }
}

class PremiumDetails {
  double basePremium;
  int discount;
  double tax;
  int totalPremium;

  PremiumDetails(
      {this.basePremium, this.discount, this.tax, this.totalPremium});

  PremiumDetails.fromJson(Map<String, dynamic> json) {
    basePremium = json['base_premium'];
    discount = json['discount'];
    tax = json['tax'];
    totalPremium = json['total_premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_premium'] = this.basePremium;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['total_premium'] = this.totalPremium;
    return data;
  }
}

class MemberDetails {
  String relation;
  String gender;
  int age;

  MemberDetails({this.relation, this.gender, this.age});

  MemberDetails.fromJson(Map<String, dynamic> json) {
    relation = json['Relation'];
    gender = json['Gender'];
    age = json['Age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Relation'] = this.relation;
    data['Gender'] = this.gender;
    data['Age'] = this.age;
    return data;
  }
}