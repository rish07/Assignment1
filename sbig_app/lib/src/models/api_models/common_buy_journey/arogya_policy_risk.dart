class PolicyRiskList {
  String insuredName;
  String genderCode;
  String dateOfBirth;
  String argInsuredRelToProposer;
  String tobacoStatus;
  String smokerStatus;
  String alcoholStatus;
  String otherImpairment;
  String otherImpairmentReason;
  String nomineeName;
  String nomineeGender;
  String nomineeDOB;
  String nomineeRelToProposer;
  String sumInsured;
  String appointeeRelToNominee;
  String appointeeName;
  String deductible;
  List<PolicyCoverageList> policyCoverageList;

  PolicyRiskList(
      {this.insuredName='',
        this.genderCode,
        this.dateOfBirth,
        this.argInsuredRelToProposer,
        this.tobacoStatus='0',
        this.smokerStatus='0',
        this.alcoholStatus='0',
        this.otherImpairment='0',
        this.otherImpairmentReason,
        this.nomineeName='',
        this.nomineeGender='',
        this.nomineeDOB,
        this.nomineeRelToProposer,
        this.appointeeRelToNominee='',
        this.appointeeName='',
        this.policyCoverageList,
        this.deductible,
      this.sumInsured});

  PolicyRiskList.fromJson(Map<String, dynamic> json) {
    insuredName = json['InsuredName'];
    genderCode = json['GenderCode'];
    dateOfBirth = json['DateOfBirth'];
    argInsuredRelToProposer = json['ArgInsuredRelToProposer'];
    tobacoStatus = json['TobacoStatus'];
    smokerStatus = json['SmokerStatus'];
    alcoholStatus = json['AlcoholStatus'];
    otherImpairment = json['OtherImpairment'];
    otherImpairmentReason = json['OtherImpairmentReason'];
    nomineeName = json['NomineeName'];
    nomineeGender = json['NomineeGender'];
    nomineeDOB = json['NomineeDOB'];
    nomineeRelToProposer = json['NomineeRelToProposer'];
    appointeeRelToNominee = json['AppointeeRelToNominee'];
    appointeeName = json['AppointeeName'];
    deductible = json['Deductible'];
    sumInsured = json['SumInsured'];
    if (json['PolicyCoverageList'] != null) {
      policyCoverageList = new List<PolicyCoverageList>();
      json['PolicyCoverageList'].forEach((v) {
        policyCoverageList.add(new PolicyCoverageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InsuredName'] = this.insuredName;
    data['GenderCode'] = this.genderCode;
    data['DateOfBirth'] = this.dateOfBirth;
    data['ArgInsuredRelToProposer'] = this.argInsuredRelToProposer;
    data['TobacoStatus'] = this.tobacoStatus;
    data['SmokerStatus'] = this.smokerStatus;
    data['AlcoholStatus'] = this.alcoholStatus;
    data['OtherImpairment'] = this.otherImpairment;
    data['OtherImpairmentReason'] = this.otherImpairmentReason;
    data['NomineeName'] = this.nomineeName;
    data['NomineeGender'] = this.nomineeGender;
    data['NomineeDOB'] = this.nomineeDOB;
    data['NomineeRelToProposer'] = this.nomineeRelToProposer;
    data['SumInsured'] = this.sumInsured;
    data['AppointeeRelToNominee'] = this.appointeeRelToNominee;
    data['AppointeeName'] = this.appointeeName;
    data['Deductible'] = this.deductible;
    if (this.policyCoverageList != null) {
      data['PolicyCoverageList'] =
          this.policyCoverageList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyCoverageList {
  String effectiveDate;
  String expiryDate;

  PolicyCoverageList({this.effectiveDate, this.expiryDate});

  PolicyCoverageList.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    return data;
  }
}