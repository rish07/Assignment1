import 'package:sbig_app/src/models/api_models/home/critical_illness/question_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

import 'other_policies.dart';

class QuickQuoteReqModel {
  //yes means 2 no means 1
  // yes means 1 , No means  0
  String effectiveDate;
  String expiryDate;
  String mobile;
  String email;
  String firstname;
  String lastname;
  String dateOfBirth;
  String income;
  String sumInsured;
  String employmentDetails;
  String genderCode;
  String duration;
  List<Questionnaire> questionnaire;
  List<OtherPolicies> otherPolicies;

  QuickQuoteReqModel(
      {this.effectiveDate,
      this.expiryDate,
      this.mobile,
      this.email,
      this.firstname,
      this.lastname,
      this.dateOfBirth,
      this.questionnaire,
        this.otherPolicies,
        this.income,
        this.sumInsured,
        this.employmentDetails,
        this.genderCode,
        this.duration
      });

  QuickQuoteReqModel.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
    mobile = json['Mobile'];
    email = json['Email'];
    firstname = json['Firstname'];
    lastname = json['Lastname'];
    income = json['Income'];
    dateOfBirth = json['DateOfBirth'];
    sumInsured = json['SumInsured'];
    employmentDetails = json['EmploymentDetails'];
    genderCode = json['GenderCode'];
    duration = json['Duration'];
    if (json['Questionnaire'] != null) {
      questionnaire = new List<Questionnaire>();
      json['Questionnaire'].forEach((v) {
        questionnaire.add(new Questionnaire.fromJson(v));
      });
    }
    if (json['other_policies'] != null) {
      otherPolicies = new List<OtherPolicies>();
      json['other_policies'].forEach((v) {
        otherPolicies.add(new OtherPolicies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['Firstname'] = this.firstname;
    data['Lastname'] = this.lastname;
    data['Income'] = this.income;
    data['DateOfBirth'] = this.dateOfBirth;
    data['SumInsured'] = this.sumInsured;
    data['EmploymentDetails'] = this.employmentDetails;
    data['GenderCode'] = this.genderCode;
    data['Duration'] = this.duration;
    if (this.questionnaire != null) {
      data['Questionnaire'] =
          this.questionnaire.map((v) => v.toJson()).toList();
    }
    if (this.otherPolicies != null) {
      data['other_policies'] =
          this.otherPolicies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuickQuoteResModel {
  bool success;
  String message;
  Data data;
  ApiErrorModel apiErrorModel;

  QuickQuoteResModel({this.success, this.message, this.data});

  QuickQuoteResModel.fromJson(Map<String, dynamic> json) {
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
  int duePremium;
  String year;
  int discountPercentage;
  int tax;
  double taxAmount;
  int grossPremium;
  int discountValue;
  int premiumWithdiscount;
  int sumInsured;
  String adultCount;
  String childCount;
  double premiumBeforeServiceTax;

  Data(
      {this.duePremium,
        this.year,
        this.discountPercentage,
        this.tax,
        this.taxAmount,
        this.grossPremium,
        this.discountValue,
        this.premiumWithdiscount,
        this.sumInsured,
        this.adultCount,
        this.childCount,
        this.premiumBeforeServiceTax});

  Data.fromJson(Map<String, dynamic> json) {
    duePremium = json['DuePremium'];
    year = json['year'];
    discountPercentage = json['discount_percentage'];
    tax = json['tax'];
    taxAmount = json['tax_amount'];
    grossPremium = json['GrossPremium'];
    discountValue = json['discount_value'];
    premiumWithdiscount = json['premium_withdiscount'];
    sumInsured = json['sumInsured'];
    adultCount = json['adultCount'];
    childCount = json['childCount'];
    premiumBeforeServiceTax = json['premiumBeforeServiceTax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DuePremium'] = this.duePremium;
    data['year'] = this.year;
    data['discount_percentage'] = this.discountPercentage;
    data['tax'] = this.tax;
    data['tax_amount'] = this.taxAmount;
    data['GrossPremium'] = this.grossPremium;
    data['discount_value'] = this.discountValue;
    data['premium_withdiscount'] = this.premiumWithdiscount;
    data['sumInsured'] = this.sumInsured;
    data['adultCount'] = this.adultCount;
    data['childCount'] = this.childCount;
    data['premiumBeforeServiceTax'] = this.premiumBeforeServiceTax;
    return data;
  }
}
