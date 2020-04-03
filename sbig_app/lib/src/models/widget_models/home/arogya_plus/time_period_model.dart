
class TimePeriodModel{
  final int year;
  final String yearString;
  dynamic actualPremium;
  dynamic discountedPremium;
  dynamic discountPercentage;
  dynamic discount_value;
  dynamic opd;
  dynamic total_premium;
  dynamic tax;
  dynamic tax_amount;
  dynamic basicpremium;
  int childCount;
  int adultCount;
  dynamic member_discount_percentage;
  dynamic member_discount_value;
  dynamic member_individual_premium;

  TimePeriodModel({this.year, this.yearString, this.actualPremium,
      this.discountedPremium, this.discountPercentage, this.discount_value, this.opd,
      this.total_premium, this.tax, this.tax_amount, this.basicpremium, this.childCount, this.adultCount, this.member_discount_percentage, this.member_discount_value,this.member_individual_premium});

}