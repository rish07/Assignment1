

import 'package:sbig_app/src/models/common/failure_model.dart';

class CriticalPremiumReqModel {
  int age;
  String employed;
  int grossIncome;
  int sumInsured;
  String gender;

  CriticalPremiumReqModel(
      {this.age,
      this.employed,
      this.grossIncome,
      this.sumInsured,
      this.gender});

  CriticalPremiumReqModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    employed = json['employed'];
    grossIncome = json['gross_income'];
    sumInsured = json['sum_insured'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['employed'] = this.employed;
    data['gross_income'] = this.grossIncome;
    data['sum_insured'] = this.sumInsured;
    data['gender'] = this.gender;
    return data;
  }
}

class CriticalPremiumResModel {
  bool status;
  List<Data> data;
  ApiErrorModel apiErrorModel;

  CriticalPremiumResModel({this.status, this.data});

  CriticalPremiumResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int duePremium;
  String year;
  int discountPercentage;
  int tax;
  int taxAmount;
  int grossPremium;
  int discountValue;
  int premiumWithdiscount;
  int sumInsured;
  String adultCount;
  String childCount;
  int premiumBeforeServiceTax;

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
