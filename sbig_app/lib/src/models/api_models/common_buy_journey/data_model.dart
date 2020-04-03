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