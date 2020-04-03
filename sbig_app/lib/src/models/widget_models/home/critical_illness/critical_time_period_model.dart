class CriticalTimePeriodModel{

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
  // mem dis per
  //mem dis val
  //mem ind pre

CriticalTimePeriodModel({this.year, this.yearString,this.actualPremium,this.discountedPremium,this.basicPremium,this.sumInsured,
  this.tax,this.taxAmount,this.totalPremium,this.discountPercentage,this.discountValue,this.isDiscountApplicable,this.adultCount,this.childCount});

}