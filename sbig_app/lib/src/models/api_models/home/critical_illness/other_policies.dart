class OtherPolicies {
  String policyType;
  String insuranceCompany;
  String policyStart;
  String policyEnd;
  String sumInsured;
  String policyNo;
  String specialCondition;

  OtherPolicies(
      {this.policyType,
        this.insuranceCompany,
        this.policyStart,
        this.policyEnd,
        this.sumInsured,
        this.policyNo,
        this.specialCondition});

  OtherPolicies.fromJson(Map<String, dynamic> json) {
    policyType = json['policy_type'];
    insuranceCompany = json['insurance_company'];
    policyStart = json['policy_start'];
    policyEnd = json['policy_end'];
    sumInsured = json['sum_insured'];
    policyNo = json['policy_no'];
    specialCondition = json['special_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_type'] = this.policyType;
    data['insurance_company'] = this.insuranceCompany;
    data['policy_start'] = this.policyStart;
    data['policy_end'] = this.policyEnd;
    data['sum_insured'] = this.sumInsured;
    data['policy_no'] = this.policyNo;
    data['special_condition'] = this.specialCondition;
    return data;
  }
}