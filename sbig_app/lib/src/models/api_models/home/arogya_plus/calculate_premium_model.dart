import 'package:sbig_app/src/models/common/failure_model.dart';

class CalculatePremiumReqModel {
  int age;
  int adultCount;
  int childCount;
  int sumInsured;
  String policy_type;

  CalculatePremiumReqModel(
      {this.age, this.adultCount, this.childCount, this.sumInsured});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['adultCount'] = this.adultCount;
    data['childCount'] = this.childCount;
    data['sumInsured'] = this.sumInsured;
    return data;
  }
}

class CalculatedPremiumResModel {
  bool status;
  Opd opd;
  ApiErrorModel apiErrorModel;

  CalculatedPremiumResModel({this.status, this.opd});

  CalculatedPremiumResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    opd = Opd.fromJson(json['opd']);
  }
}

class Opd {
  List<TimePeriod> year1;
  List<TimePeriod> year2;
  List<TimePeriod> year3;

  Opd.fromJson(Map<String, dynamic> json) {
    if (json['year1'] != null) {
      year1 = List<TimePeriod>();
      json['year1'].forEach((v) {
        year1.add(TimePeriod.fromJson(v));
      });
    }
    if (json['year2'] != null) {
      year2 = List<TimePeriod>();
      json['year2'].forEach((v) {
        year2.add(TimePeriod.fromJson(v));
      });
    }
    if (json['year3'] != null) {
      year3 = List<TimePeriod>();
      json['year3'].forEach((v) {
        year3.add(TimePeriod.fromJson(v));
      });
    }
  }
}

class TimePeriod {
  dynamic total_premium;
  dynamic opd;
  dynamic year;
  dynamic discount_percentage;
  int tax;
  dynamic tax_amount;
  dynamic premium;
  dynamic discount_value;
  dynamic premium_withdiscount;
  dynamic basicpremium;
  dynamic adultCount;
  dynamic childCount;
  dynamic member_discount_percentage;
  dynamic member_discount_value;
  dynamic member_individual_premium;

  TimePeriod.fromJson(Map<String, dynamic> json) {
    total_premium = json['total_premium'];
    opd = json['opd'];
    year = json['year'];
    discount_percentage = json['discount_percentage'];
    tax = json['tax'];
    tax_amount = json['tax_amount'];
    premium = json['premium'];
    basicpremium = json['basicpremium'];
    discount_value = json['discount_value'].toDouble();
    premium_withdiscount = json['premium_withdiscount'];
    adultCount = json['adultCount'];
    childCount = json['childCount'];

    member_discount_percentage = json['member_discount_percentage'] ?? 0;
    member_discount_value = json['member_discount_value'] ?? 0;
    member_individual_premium = json['member_individual_premium'] ?? 0;
  }
}
