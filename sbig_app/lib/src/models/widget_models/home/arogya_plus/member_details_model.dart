class MemberDetailsModel {
  final String relation;
  final String icon;
  AgeGenderModel ageGenderModel;
  final List<String> ageList;
  String firstName;
  String lastName;
  bool isMarried;
  bool maritalStatusIsFixed;
  /// Added below 4  parameter for Critical Illness Product
  int heightInFeet;
  int heightInInch;
  int weight;
  bool isEmployed;
  /// Added for ArogyaPremier FamilyIndividual
  String sumInsuredString;
  ///Added for ArogyaTopUp FamilyIndividual
  String deduction;
  String deductionString;

  MemberDetailsModel({this.relation, this.icon, this.ageGenderModel,this.deduction,
      this.ageList, this.firstName, this.lastName, this.isMarried, this.maritalStatusIsFixed,this.heightInFeet,this.heightInInch,this.weight,this.isEmployed,this.sumInsuredString,this.deductionString});
}

class AgeGenderModel {
  String defaultGender;
  String gender;
  int age;
  String ageString;
  String dob;
  String dob_yyyy_mm_dd;
  DateTime dateTime;

  AgeGenderModel(
      {this.defaultGender, this.gender, this.age, this.ageString, this.dob, this.dob_yyyy_mm_dd, this.dateTime});
}
