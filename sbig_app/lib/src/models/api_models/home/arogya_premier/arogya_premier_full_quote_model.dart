import 'package:sbig_app/src/models/common/failure_model.dart';

import '../../common_buy_journey/arogya_policy_risk.dart';

class ArogyaPremierFullQuoteReqModel {
  String arogyaPolicyType;
  String effectiveDate;
  String expiryDate;
  String customerName;
  String firstName;
  String middleName;
  String lastName;
  String genderCode;
  String dateOfBirth;
  String buildingHouseName;
  String streetName;
  String postCode;
  String city;
  String state;
  String mobile;
  String email;
  String plotNo;
  String eIANumber;
  String duration;
  String policyType;
  String agentCode;
  List<PolicyRiskList> policyRiskList;

  ArogyaPremierFullQuoteReqModel(
      {this.arogyaPolicyType,
        this.effectiveDate,
        this.expiryDate,
        this.customerName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.genderCode,
        this.dateOfBirth,
        this.buildingHouseName,
        this.streetName,
        this.postCode,
        this.city,
        this.state,
        this.mobile,
        this.email,
        this.plotNo,
        this.eIANumber,
        this.duration,
        this.policyRiskList,
        this.policyType,
        this.agentCode,});

  ArogyaPremierFullQuoteReqModel.fromJson(Map<String, dynamic> json) {
    arogyaPolicyType = json['ArogyaPolicyType'];
    effectiveDate = json['EffectiveDate'];
    expiryDate = json['ExpiryDate'];
    customerName = json['CustomerName'];
    firstName = json['FirstName'];
    middleName = json['MiddleName'];
    lastName = json['LastName'];
    genderCode = json['GenderCode'];
    dateOfBirth = json['DateOfBirth'];
    buildingHouseName = json['BuildingHouseName'];
    streetName = json['StreetName'];
    postCode = json['PostCode'];
    city = json['City'];
    state = json['State'];
    mobile = json['Mobile'];
    email = json['Email'];
    plotNo = json['PlotNo'];
    eIANumber = json['EIANumber'];
    duration = json['Duration'];
    policyType = json['policy_type'];
    agentCode = json['agentCode'];
    if (json['PolicyRiskList'] != null) {
      policyRiskList = new List<PolicyRiskList>();
      json['PolicyRiskList'].forEach((v) {
        policyRiskList.add(new PolicyRiskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ArogyaPolicyType'] = this.arogyaPolicyType;
    data['EffectiveDate'] = this.effectiveDate;
    data['ExpiryDate'] = this.expiryDate;
    data['CustomerName'] = this.customerName;
    data['FirstName'] = this.firstName;
    data['MiddleName'] = this.middleName;
    data['LastName'] = this.lastName;
    data['GenderCode'] = this.genderCode;
    data['DateOfBirth'] = this.dateOfBirth;
    data['BuildingHouseName'] = this.buildingHouseName;
    data['StreetName'] = this.streetName;
    data['PostCode'] = this.postCode;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['PlotNo'] = this.plotNo;
    data['EIANumber'] = this.eIANumber;
    data['Duration'] = this.duration;
    data['policy_type'] = this.policyType;
    data['agentCode'] = this.agentCode;
    if (this.policyRiskList != null) {
      data['PolicyRiskList'] =
          this.policyRiskList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class ArogyaPremierFullQuoteResModel {
  bool success;
  String message;
  Data data;
  ApiErrorModel apiErrorModel;

  ArogyaPremierFullQuoteResModel({this.success, this.message, this.data});

  ArogyaPremierFullQuoteResModel.fromJson(Map<String, dynamic> json) {
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
  PolicyDetails policyDetails;
  InsuranceProposerDetails insuranceProposerDetails;
  List<InsuredMemberDetails> insuredMemberDetails;
  String quotationNumber;

  Data(
      {this.policyDetails,
        this.insuranceProposerDetails,
        this.insuredMemberDetails,
        this.quotationNumber});

  Data.fromJson(Map<String, dynamic> json) {
    policyDetails = json['policy_details'] != null
        ? new PolicyDetails.fromJson(json['policy_details'])
        : null;
    insuranceProposerDetails = json['insurance_proposer_details'] != null
        ? new InsuranceProposerDetails.fromJson(
        json['insurance_proposer_details'])
        : null;
    if (json['insured_member_details'] != null) {
      insuredMemberDetails = new List<InsuredMemberDetails>();
      json['insured_member_details'].forEach((v) {
        insuredMemberDetails.add(new InsuredMemberDetails.fromJson(v));
      });
    }
    quotationNumber = json['quotation_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policyDetails != null) {
      data['policy_details'] = this.policyDetails.toJson();
    }
    if (this.insuranceProposerDetails != null) {
      data['insurance_proposer_details'] =
          this.insuranceProposerDetails.toJson();
    }
    if (this.insuredMemberDetails != null) {
      data['insured_member_details'] =
          this.insuredMemberDetails.map((v) => v.toJson()).toList();
    }
    data['quotation_number'] = this.quotationNumber;
    return data;
  }
}

class PolicyDetails {
  dynamic sumInsured;
  dynamic grossPremium;
  dynamic applicationTax;
  dynamic totalPremium;

  PolicyDetails(
      {this.sumInsured,
        this.grossPremium,
        this.applicationTax,
        this.totalPremium});

  PolicyDetails.fromJson(Map<String, dynamic> json) {
    sumInsured = json['sum_insured'];
    grossPremium = json['gross_premium'];
    applicationTax = json['application_tax'];
    totalPremium = json['total_premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum_insured'] = this.sumInsured;
    data['gross_premium'] = this.grossPremium;
    data['application_tax'] = this.applicationTax;
    data['total_premium'] = this.totalPremium;
    return data;
  }
}

class InsuranceProposerDetails {
  String name;
  String yourAddress;
  String emailId;
  String mobileNo;
  String nomineeName;
  String nomineeRelation;
  String nomineeGender;

  InsuranceProposerDetails(
      {this.name,
        this.yourAddress,
        this.emailId,
        this.mobileNo,
        this.nomineeName,
        this.nomineeRelation,
        this.nomineeGender});

  InsuranceProposerDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    yourAddress = json['your_address'];
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    nomineeName = json['nominee_name'];
    nomineeRelation = json['nominee_relation'];
    nomineeGender = json['nominee_gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['your_address'] = this.yourAddress;
    data['email_id'] = this.emailId;
    data['mobile_no'] = this.mobileNo;
    data['nominee_name'] = this.nomineeName;
    data['nominee_relation'] = this.nomineeRelation;
    data['nominee_gender'] = this.nomineeGender;
    return data;
  }
}

class InsuredMemberDetails {
  String name;
  String rel;
  String dob;
  String startPolicyDate;
  String endPolicyDate;
  dynamic policyDuration;

  InsuredMemberDetails(
      {this.name,
        this.rel,
        this.dob,
        this.startPolicyDate,
        this.endPolicyDate,
        this.policyDuration});

  InsuredMemberDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    rel = json['rel'];
    dob = json['dob'];
    startPolicyDate = json['start_policy_date'];
    endPolicyDate = json['end_policy_date'];
    policyDuration = json['policy_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['rel'] = this.rel;
    data['dob'] = this.dob;
    data['start_policy_date'] = this.startPolicyDate;
    data['end_policy_date'] = this.endPolicyDate;
    data['policy_duration'] = this.policyDuration;
    return data;
  }
}