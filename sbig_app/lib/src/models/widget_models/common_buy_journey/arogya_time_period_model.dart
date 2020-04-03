class ArogyaTimePeriodModel{

  final int year;
  final String yearString;
  dynamic basicPremium;
  dynamic actualPremium;
  dynamic discountedPremium;
  dynamic totalPremium;
  dynamic tax;
  dynamic taxAmount;
  dynamic discountPercentage;
  dynamic discountValue;
  bool isDiscountApplicable;
  int childCount;
  int adultCount;
  final int sumInsured;
  dynamic member_discount_percentage;
  dynamic member_discount_value;
  dynamic member_individual_premium;

  ArogyaTimePeriodModel({this.year, this.yearString,this.actualPremium,this.discountedPremium,this.basicPremium,this.sumInsured,
    this.tax,this.taxAmount,this.totalPremium,this.discountPercentage,this.discountValue,this.isDiscountApplicable,this.adultCount,this.childCount, this.member_discount_percentage, this.member_discount_value,this.member_individual_premium});

}