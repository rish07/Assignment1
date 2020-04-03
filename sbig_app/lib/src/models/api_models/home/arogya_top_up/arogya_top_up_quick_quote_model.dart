import 'package:sbig_app/src/models/common/failure_model.dart';

import '../../common_buy_journey/arogya_policy_risk.dart';

class ArogyaTopUpQuickQuoteReqModel {
  String arogyaPolicyType;
  String policyType;
  String mobile;
  String email;
  String duration;
  String effectiveDate;
  String expiryDate;
  List<PolicyRiskList> policyRiskList;

  ArogyaTopUpQuickQuoteReqModel(
      {this.arogyaPolicyType,
      this.policyType,
      this.mobile,
      this.email,
      this.duration,
      this.effectiveDate,
      this.expiryDate,
      this.policyRiskList});

  ArogyaTopUpQuickQuoteReqModel.fromJson(Map<String, dynamic> json) {
    arogyaPolicyType = json['ArogyaPolicyType'];
    policyType = json['policy_type'];
    mobile = json['Mobile'];
    email = json['Email'];
    duration = json['Duration'];
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
    data['policy_type'] = this.policyType;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['Duration'] = this.duration;
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    if (this.policyRiskList != null) {
      data['PolicyRiskList'] =
          this.policyRiskList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArogyaTopUpQuickQuoteResModel {
  bool success;
  String message;
  Data data;
  ApiErrorModel apiErrorModel;

  ArogyaTopUpQuickQuoteResModel({this.success, this.message, this.data});

  ArogyaTopUpQuickQuoteResModel.fromJson(Map<String, dynamic> json) {
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

  PolicyDetails({this.policy, this.policyType, this.sumInsured});

  PolicyDetails.fromJson(Map<String, dynamic> json) {
    policy = json['policy'];
    policyType = json['policy_type'];
    sumInsured = json['sum_insured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy'] = this.policy;
    data['policy_type'] = this.policyType;
    data['sum_insured'] = this.sumInsured;
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
