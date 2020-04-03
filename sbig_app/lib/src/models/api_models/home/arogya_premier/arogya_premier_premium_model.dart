import 'package:sbig_app/src/models/api_models/common_buy_journey/data_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';


class ArogyaPremierPremiumReqModel {
  int memberCount;
  List<Members> members;

  ArogyaPremierPremiumReqModel({this.memberCount, this.members});

  ArogyaPremierPremiumReqModel.fromJson(Map<String, dynamic> json) {
    memberCount = json['memberCount'];
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberCount'] = this.memberCount;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArogyaPremierPremiumResModel {
  bool status;
  Data data;
ApiErrorModel apiErrorModel;
  ArogyaPremierPremiumResModel({this.status, this.data});

  ArogyaPremierPremiumResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
/*

class Data {
  Year year1;
  Year year2;
  Year year3;

  Data({this.year1, this.year2, this.year3});

  Data.fromJson(Map<String, dynamic> json) {
    year1 = json['year1'] != null ? new Year.fromJson(json['year1']) : null;
    year2 = json['year2'] != null ? new Year.fromJson(json['year2']) : null;
    year3 = json['year3'] != null ? new Year.fromJson(json['year3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.year1 != null) {
      data['year1'] = this.year1.toJson();
    }
    if (this.year2 != null) {
      data['year2'] = this.year2.toJson();
    }
    if (this.year3 != null) {
      data['year3'] = this.year3.toJson();
    }
    return data;
  }
}

class Year {
  dynamic discountPercentage;
  dynamic basePremium;
  int tax;
  dynamic memberDiscountPercentage;
  dynamic memberDiscountValue;
  dynamic discountedValue;
  dynamic premiumWithdiscount;
  dynamic taxAmount;
  dynamic totalPremium;
  Year(
      {this.discountPercentage,
        this.basePremium,
        this.tax,
        this.memberDiscountPercentage,
        this.discountedValue,
        this.premiumWithdiscount,
        this.taxAmount,
        this.totalPremium,
      this.memberDiscountValue});

  Year.fromJson(Map<String, dynamic> json) {
    discountPercentage = json['discount_percentage'];
    basePremium = json['base_premium'];
    tax = json['tax'];
    memberDiscountPercentage = json['member_discount_percentage']??0;
    memberDiscountValue = json['member_discount_value'] ?? 0;
    discountedValue = json['discounted_value'];
    premiumWithdiscount = json['premium_withdiscount'];
    taxAmount = json['tax_amount'];
    totalPremium = json['total_premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discount_percentage'] = this.discountPercentage;
    data['base_premium'] = this.basePremium;
    data['tax'] = this.tax;
    data['member_discount_percentage'] = this.memberDiscountPercentage;
    data['member_discount_value'] = this.memberDiscountValue;
    data['discounted_value'] = this.discountedValue;
    data['premium_withdiscount'] = this.premiumWithdiscount;
    data['tax_amount'] = this.taxAmount;
    data['total_premium'] = this.totalPremium;
    return data;
  }
}
*/
