class InsuredListItem {
  String numberofInsured;
  String insuredStatus;
  String policyId;
  String insuredCategory;
  String insuredId;
  String insuredName;
  String age;
  String relationshipProposer;
  String gender;
  String nomineeNamesIn;
  String dtBirth;
  String relationshipWithTheProposerIn;
  String maritalstatus;
  String contactNoIn;

  InsuredListItem(
      {this.numberofInsured,
        this.insuredStatus,
        this.policyId,
        this.insuredCategory,
        this.insuredId,
        this.insuredName,
        this.age,
        this.relationshipProposer,
        this.gender,
        this.nomineeNamesIn,
        this.dtBirth,
        this.relationshipWithTheProposerIn,
        this.maritalstatus,
        this.contactNoIn});

  InsuredListItem.fromJson(Map<String, dynamic> json) {
    numberofInsured = json['numberofInsured'];
    insuredStatus = json['insuredStatus'];
    policyId = json['policyId'];
    insuredCategory = json['insuredCategory'];
    insuredId = json['insuredId'];
    insuredName = json['insuredName'];
    age = json['age'];
    relationshipProposer = json['Relationship_Proposer'];
    gender = json['Gender'];
    nomineeNamesIn = json['Nominee_Names_In'];
    dtBirth = json['dt_birth'];
    relationshipWithTheProposerIn = json['Relationship_with_the_Proposer_In'];
    maritalstatus = json['maritalstatus'];
    contactNoIn = json['Contact_No_In'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numberofInsured'] = this.numberofInsured;
    data['insuredStatus'] = this.insuredStatus;
    data['policyId'] = this.policyId;
    data['insuredCategory'] = this.insuredCategory;
    data['insuredId'] = this.insuredId;
    data['insuredName'] = this.insuredName;
    data['age'] = this.age;
    data['Relationship_Proposer'] = this.relationshipProposer;
    data['Gender'] = this.gender;
    data['Nominee_Names_In'] = this.nomineeNamesIn;
    data['dt_birth'] = this.dtBirth;
    data['Relationship_with_the_Proposer_In'] =
        this.relationshipWithTheProposerIn;
    data['maritalstatus'] = this.maritalstatus;
    data['Contact_No_In'] = this.contactNoIn;
    return data;
  }
}