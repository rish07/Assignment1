import 'package:sbig_app/src/models/api_models/home/critical_illness/question_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

import 'other_policies.dart';

class FullQuoteReqModel{
  String effectiveDate;
  String expiryDate;
  String mobile;
  String email;
  String state;
  String address;
  String buildingname;
  String streetname;
  String city;
  String firstname;
  String lastname;
  String dateOfBirth;
  String agentCode;
  List<Questionnaire> questionnaire;
  String duration;
  List<PolicyRiskList> policyRiskList;
  List<OtherPolicies> otherPolicies;

  FullQuoteReqModel(
      {this.effectiveDate,
        this.expiryDate,
        this.mobile,
        this.email,
        this.state,
        this.address,
        this.buildingname,
        this.streetname,
        this.city,
        this.firstname,
        this.lastname,
        this.dateOfBirth,
        this.agentCode,
        this.questionnaire,
        this.duration,
        this.policyRiskList,
        this.otherPolicies});

  FullQuoteReqModel.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
    mobile = json['Mobile'];
    email = json['Email'];
    state = json['State'];
    address = json['Address'];
    buildingname = json['Buildingname'];
    streetname = json['Streetname'];
    city = json['City'];
    firstname = json['Firstname'];
    lastname = json['Lastname'];
    dateOfBirth = json['DateOfBirth'];
    agentCode = json['agentCode'];
    if (json['Questionnaire'] != null) {
      questionnaire = new List<Questionnaire>();
      json['Questionnaire'].forEach((v) {
        questionnaire.add(new Questionnaire.fromJson(v));
      });
    }
    duration = json['Duration'];
    if (json['PolicyRiskList'] != null) {
      policyRiskList = new List<PolicyRiskList>();
      json['PolicyRiskList'].forEach((v) {
        policyRiskList.add(new PolicyRiskList.fromJson(v));
      });
    }
    if (json['other_policies'] != null) {
      otherPolicies = new List<OtherPolicies>();
      json['other_policies'].forEach((v) {
        otherPolicies.add(new OtherPolicies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['State'] = this.state;
    data['Address'] = this.address;
    data['Buildingname'] = this.buildingname;
    data['Streetname'] = this.streetname;
    data['City'] = this.city;
    data['Firstname'] = this.firstname;
    data['Lastname'] = this.lastname;
    data['DateOfBirth'] = this.dateOfBirth;
    data['agentCode'] = this.agentCode;
    if (this.questionnaire != null) {
      data['Questionnaire'] =
          this.questionnaire.map((v) => v.toJson()).toList();
    }
    data['Duration'] = this.duration;
    if (this.policyRiskList != null) {
      data['PolicyRiskList'] =
          this.policyRiskList.map((v) => v.toJson()).toList();
    }
    if (this.otherPolicies != null) {
      data['other_policies'] =
          this.otherPolicies.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyRiskList {
  String income;
  String employmentDetails;
  String insuredName;
  String genderCode;
  String dateOfBirth;
  String height;
  String weight;
  String argInsuredRelToProposer;
  String nomineeDOB;//
  String nomineeRelToProposer;//
  String nomineeName;//
  String nomineeGender;//
  String appointeeRelToNominee;
  String appointeeName;
  List<PolicyCoverageList> policyCoverageList;

  PolicyRiskList(
      {this.income,
        this.employmentDetails,
        this.insuredName,
        this.genderCode,
        this.dateOfBirth,
        this.height,
        this.weight,
        this.argInsuredRelToProposer,
        this.nomineeDOB,
        this.nomineeRelToProposer,
        this.nomineeName,
        this.nomineeGender,
        this.appointeeRelToNominee='',
        this.appointeeName='',
        this.policyCoverageList});

  PolicyRiskList.fromJson(Map<String, dynamic> json) {
    income = json['Income'];
    employmentDetails = json['EmploymentDetails'];
    insuredName = json['InsuredName'];
    genderCode = json['GenderCode'];
    dateOfBirth = json['DateOfBirth'];
    height = json['Height'];
    weight = json['Weight'];
    argInsuredRelToProposer = json['ArgInsuredRelToProposer'];
    nomineeDOB = json['NomineeDOB'];
    nomineeRelToProposer = json['NomineeRelToProposer'];
    nomineeName = json['NomineeName'];
    nomineeGender = json['NomineeGender'];
    appointeeRelToNominee = json['AppointeeRelToNominee'];
    appointeeName = json['AppointeeName'];
    if (json['PolicyCoverageList'] != null) {
      policyCoverageList = new List<PolicyCoverageList>();
      json['PolicyCoverageList'].forEach((v) {
        policyCoverageList.add(new PolicyCoverageList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Income'] = this.income;
    data['EmploymentDetails'] = this.employmentDetails;
    data['InsuredName'] = this.insuredName;
    data['GenderCode'] = this.genderCode;
    data['DateOfBirth'] = this.dateOfBirth;
    data['Height'] = this.height;
    data['Weight'] = this.weight;
    data['ArgInsuredRelToProposer'] = this.argInsuredRelToProposer;
    data['NomineeDOB'] = this.nomineeDOB;
    data['NomineeRelToProposer'] = this.nomineeRelToProposer;
    data['NomineeName'] = this.nomineeName;
    data['NomineeGender'] = this.nomineeGender;
    data['AppointeeRelToNominee'] = this.appointeeRelToNominee;
    data['AppointeeName'] = this.appointeeName;
    if (this.policyCoverageList != null) {
      data['PolicyCoverageList'] =
          this.policyCoverageList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyCoverageList {
  String sumInsured;
  String effectiveDate;
  String expiryDate;

  PolicyCoverageList({this.sumInsured,this.effectiveDate, this.expiryDate});

  PolicyCoverageList.fromJson(Map<String, dynamic> json) {
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EffectiveDate'] = this.effectiveDate;
    data['SumInsured'] = this.sumInsured;
    data['ExpiryDate'] = this.expiryDate;
    return data;
  }
}

class FullQuoteResModel{
  bool success;
  String message;
  Data data;
  ApiErrorModel apiErrorModel;

  FullQuoteResModel({this.success, this.message, this.data});

  FullQuoteResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  CriticalIllness criticalIllness;
  ProposerDetails proposerDetails;
  InsuredDetails insuredDetails;
  String quotationNo;

  Data(
      {this.criticalIllness,
        this.proposerDetails,
        this.insuredDetails,
        this.quotationNo});

  Data.fromJson(Map<String, dynamic> json) {
    criticalIllness = json['CriticalIllness'] != null
        ? new CriticalIllness.fromJson(json['CriticalIllness'])
        : null;
    proposerDetails = json['ProposerDetails'] != null
        ? new ProposerDetails.fromJson(json['ProposerDetails'])
        : null;
    insuredDetails = json['InsuredDetails'] != null
        ? new InsuredDetails.fromJson(json['InsuredDetails'])
        : null;
    quotationNo = json['QuotationNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.criticalIllness != null) {
      data['CriticalIllness'] = this.criticalIllness.toJson();
    }
    if (this.proposerDetails != null) {
      data['ProposerDetails'] = this.proposerDetails.toJson();
    }
    if (this.insuredDetails != null) {
      data['InsuredDetails'] = this.insuredDetails.toJson();
    }
    data['QuotationNo'] = this.quotationNo;
    return data;
  }
}

class CriticalIllness {
  dynamic sumInsured;
  dynamic grossPremium;
  dynamic tax;

  CriticalIllness({this.sumInsured, this.grossPremium, this.tax});

  CriticalIllness.fromJson(Map<String, dynamic> json) {
    sumInsured = json['SumInsured'];
    grossPremium = json['GrossPremium'];
    tax = json['Tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SumInsured'] = this.sumInsured;
    data['GrossPremium'] = this.grossPremium;
    data['Tax'] = this.tax;
    return data;
  }
}

class ProposerDetails {
  String name;
  String address;
  String email;
  String mobile;
  String nomineeName;
  String dateOfBirth;
  String nomineeRelToInsured;
  String nomineeGender;

  ProposerDetails(
      {this.name,
        this.address,
        this.email,
        this.mobile,
        this.nomineeName,
        this.dateOfBirth,
        this.nomineeRelToInsured,
        this.nomineeGender});

  ProposerDetails.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    address = json['Address'];
    email = json['Email'];
    mobile = json['Mobile'];
    nomineeName = json['NomineeName'];
    dateOfBirth = json['DateOfBirth'];
    nomineeRelToInsured = json['NomineeRelToInsured'];
    nomineeGender = json['NomineeGender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Address'] = this.address;
    data['Email'] = this.email;
    data['Mobile'] = this.mobile;
    data['NomineeName'] = this.nomineeName;
    data['DateOfBirth'] = this.dateOfBirth;
    data['NomineeRelToInsured'] = this.nomineeRelToInsured;
    data['NomineeGender'] = this.nomineeGender;
    return data;
  }
}

class InsuredDetails {
  String name;
  String relToProposer;
  String dateOfBirth;
  String effectiveDate;
  String expiryDate;
  dynamic duration;

  InsuredDetails(
      {this.name,
        this.relToProposer,
        this.dateOfBirth,
        this.effectiveDate,
        this.expiryDate,
        this.duration});

  InsuredDetails.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    relToProposer = json['RelToProposer'];
    dateOfBirth = json['DateOfBirth'];
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
    duration = json['Duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['RelToProposer'] = this.relToProposer;
    data['DateOfBirth'] = this.dateOfBirth;
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    data['Duration'] = this.duration;
    return data;
  }

}