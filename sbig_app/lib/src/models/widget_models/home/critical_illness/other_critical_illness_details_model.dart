

class OtherCriticalIllnessDetailsModel {
  bool isPreviousPolicy;
  String policyType;
  String insuranceCompany;
  String policyNumber;
  String startDate;
  String endDate;
  String sumInsured;
  String specialConditions;

  OtherCriticalIllnessDetailsModel(
      {this.isPreviousPolicy,
        this.policyType='',
        this.insuranceCompany='',
        this.policyNumber='',
        this.startDate='',
        this.endDate='',
        this.sumInsured='',
      this.specialConditions=''});
}
