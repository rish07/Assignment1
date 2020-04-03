import 'package:intl/intl.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';

class RecalculatePremiumReqModel {
  ProposerDetails proposerDetails;
  List<InsuredDetails> insuredDetails;

  RecalculatePremiumReqModel({this.proposerDetails, this.insuredDetails});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['proposerDetails'] = this.proposerDetails.toJson();

    final List<Map<String, dynamic>> list = List();
    this.insuredDetails.forEach((item) {
      list.add(item.toJson());
    });
    data['insuredDetails'] = list;
    return data;
  }
}

class ProposerDetails {
  String policy_type;
  String title;
  String firstName;
  String lastName;
  String dob;
  DobFormat dobFormat;
  String gender;
  String mobileNumber;
  String emailId;
  String policystart_date;
  String policystart_end;

  String plotno;
  String address;
  String buildingName;
  String streetName;
  String city;
  String pinCode;
  String location;
  String state;
  String districtName;
  String countryName;
  String addressType;

  String insuredId;
  String quoteNo;
  String expiryDate;
  String policyID;
  String effectiveDate;
  String ppId;
  String childCount;
  String adultCount;

  String cityCode;
  String stateCode;
  String pinCodeId;
  String districtCode;

  String nomineeRelationWithPrimaryInsured;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_type'] = this.policy_type;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dob'] = this.dob;
    if(this.dobFormat != null) data['dobFormat'] = this.dobFormat;
    data['gender'] = this.gender;
    data['mobileNumber'] = this.mobileNumber;
    data['emailId'] = this.emailId;
    data['policystart_date'] = this.policystart_date;
    data['policystart_end'] = this.policystart_end;
    data['childCount'] = this.childCount;
    data['adultCount'] = this.adultCount;

    if(this.plotno != null) data['plotno'] = this.plotno;
    if(this.address != null) data['address'] = this.address;
    if(this.buildingName != null) data['buildingName'] = this.buildingName;
    if(this.streetName != null) data['streetName'] = this.streetName;
    if(this.city != null) data['city'] = this.city;
    if(this.pinCode != null) data['pinCode'] = this.pinCode;
    if(this.location != null) data['location'] = this.location;
    if(this.state != null) data['state'] = this.state;
    if(this.districtName != null) data['districtName'] = this.districtName;
    if(this.countryName != null) data['countryName'] = this.countryName;
    if(this.addressType != null) data['addressType'] = this.addressType;
    if(this.insuredId != null) data['insuredId'] = this.insuredId;
    if(this.quoteNo != null) data['quoteNo'] = this.quoteNo;
    if(this.insuredId != null) data['insuredId'] = this.insuredId;
    if(this.expiryDate != null) data['expiryDate'] = this.expiryDate;
    if(this.policyID != null) data['policyID'] = this.policyID;
    if(this.effectiveDate != null) data['effectiveDate'] = this.effectiveDate;
    if(this.ppId != null) data['ppId'] = this.ppId;
    if(this.cityCode != null) data['cityCode'] = this.cityCode;
    if(this.stateCode != null) data['stateCode'] = this.stateCode;
    if(this.pinCodeId != null) data['pinCodeId'] = this.pinCodeId;
    if(this.districtCode != null) data['districtCode'] = this.districtCode;
    if(this.nomineeRelationWithPrimaryInsured != null) data['nomineeRelationWithPrimaryInsured'] = this.nomineeRelationWithPrimaryInsured;
    return data;
  }

  ProposerDetails(
      {this.policy_type,
      this.title,
      this.firstName,
      this.lastName,
      this.dob,
      this.gender,
      this.mobileNumber,
      this.emailId,
      this.policystart_date,
      this.policystart_end});
}

class InsuredDetails {
  String name;
  String firstname;
  String lastname;
  String dob;
  String age;
  String gender;
  String year;
  String siPerYear;
  String sumInsured;
  String opd;
  String nomineeRelationWithPrimaryInsured;
  String realtionshipWithProposer;
  String appointeeName;
  String nomineeRelationWithAppointee;
  String premiumBeforeServiceTax;
  String coverId;
  OtherDetails otherDetails;
  NomineeDetails nomineeDetails;
  String insuredId;
  String maritalStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if(this.firstname != null) data['firstname'] = this.firstname;
    if(this.lastname != null) data['lastname'] = this.lastname;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['siPerYear'] = this.siPerYear;
    data['year'] = this.year;
    data['sumInsured'] = this.sumInsured;
    data['opd'] = this.opd;
    data['premiumBeforeServiceTax'] = this.premiumBeforeServiceTax;
    if(this.coverId !=null) data['coverId'] = this.coverId;
    if(this.nomineeRelationWithPrimaryInsured != null) {
      data['nomineeRelationWithPrimaryInsured'] =
          this.nomineeRelationWithPrimaryInsured;
    }
    if(this.realtionshipWithProposer != null) {
      data['realtionshipWithProposer'] =
          this.realtionshipWithProposer;
    }
    data['otherDetails'] = this.otherDetails.toJson();
    if(this.nomineeDetails != null) {
      data['nomineeDetails'] = this.nomineeDetails.toJson();
    }
    if(appointeeName != null){
      data['appointeeName'] = this.appointeeName;
    }
    if(nomineeRelationWithAppointee != null){
      data['nomineeRelationWithAppointee'] = this.nomineeRelationWithAppointee;
    }
    if(this.insuredId != null){
      data['insuredId'] = this.insuredId;
    }
    if(this.maritalStatus != null) {
      data['maritalStatus'] = this.maritalStatus;
    }
    return data;
  }

  InsuredDetails(
      {this.name,
      this.dob,
      this.gender,
      this.year,
      this.sumInsured,
      this.opd,
      this.otherDetails});
}

class OtherDetails {
  //yes means 2 no means 1
  String doyouConsumeTobacco;
  String smokerStatus;
  String alcoholStatus;
  String diabeticStatus;
  String hypertensionStatus;
  String ashtmaStatus;
  String otherImpairment;
  String impairmentReason;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doyouConsumeTobacco'] = this.doyouConsumeTobacco;
    data['smokerStatus'] = this.smokerStatus;
    data['alcoholStatus'] = this.alcoholStatus;
    data['diabeticStatus'] = this.diabeticStatus;
    data['hypertensionStatus'] = this.hypertensionStatus;
    data['ashtmaStatus'] = this.ashtmaStatus;
    data['otherImpairment'] = this.otherImpairment;
    data['impairmentReason'] = this.impairmentReason;
    return data;
  }

  OtherDetails(
      {this.doyouConsumeTobacco = "2",
      this.smokerStatus = "2",
      this.alcoholStatus = "2",
      this.diabeticStatus = "2",
      this.hypertensionStatus = "2",
      this.ashtmaStatus = "2",
      this.otherImpairment = "2",
      this.impairmentReason = ""});
}

class NomineeDetails {
  String name;
  String dob;
  String age;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['age'] = this.age;
    return data;
  }

  NomineeDetails({this.name, this.dob, this.age});
}


class RecalculatePremiumResModel {
  bool status;
  TimePeriod data;
  SbiResponse sbiResponse;
  ApiErrorModel apiErrorModel;
  String partyholderrole;
  String coverId;

  RecalculatePremiumResModel({this.status, this.data, this.apiErrorModel});

  RecalculatePremiumResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if(json['data'] != null) {
      data = TimePeriod.fromJson(json['data']);
    }
    sbiResponse = SbiResponse.fromJson(json['sbi_res']);
    partyholderrole = json['partyholderrole'];
    coverId = json['insuredDetails'];
  }
}

class SbiResponse {
  QuoteResponse quoteResponse;

  SbiResponse.fromJson(Map<String, dynamic> json) {
    quoteResponse = QuoteResponse.fromJson(json['quoteResponse']);
  }
}

class QuoteResponse {
  Response_ response;

  QuoteResponse.fromJson(Map<String, dynamic> json) {
    response = Response_.fromJson(json['response']);
  }
}

class Response_ {
  Payload payload;

  Response_.fromJson(Map<String, dynamic> json) {
    payload = Payload.fromJson(json['payload']);
  }
}

class Payload {
  CreateQuoteResponse createQuoteResponse;

  Payload.fromJson(Map<String, dynamic> json) {
    createQuoteResponse =
        CreateQuoteResponse.fromJson(json['createQuoteResponse']);
  }
}

class CreateQuoteResponse {
  String quoteNumber;
  PolicyTerms policyTerms;
  List<SbiInsuredDetails> insuredDetails;
  //ProposerDetailsObj proposerDetails;
  String partyId;

  CreateQuoteResponse.fromJson(Map<String, dynamic> json) {
    quoteNumber = json['quoteNumber'];

    if(json['policyTerms'] != null) {
      policyTerms = PolicyTerms.fromJson(json['policyTerms']);
    }

    if(json['partyId'] != null) {
      partyId = json['partyId'];
    }

//    if(json['proposerDetails'] != null) {
//      proposerDetails = ProposerDetailsObj.fromJson(json['proposerDetails']);
//    }

    if (json['insuredDetails'] != null) {
      final List<SbiInsuredDetails> list = List();
      json['insuredDetails'].forEach((item) {
        list.add(SbiInsuredDetails.fromJson(item));
      });
      insuredDetails = list;
    }
  }
}

class ProposerDetailsObj{
  String partyID;
  ProposerDetailsObj.fromJson(Map<String, dynamic> json) {
    partyID = json['partyID'];
  }
}

class PolicyTerms {
  String policyId;
  String quoteDate;
  String effectiveDate;
  String expiryDate;
  //String customerCode;
  String ppId;

  PolicyTerms(
      {this.policyId,
        this.quoteDate,
        this.effectiveDate,
        this.expiryDate,
        //this.customerCode,
        this.ppId});

  PolicyTerms.fromJson(Map<String, dynamic> json) {
    policyId = json['policyId'];
    quoteDate = json['quoteDate'];
    effectiveDate = json['effectiveDate'];
    expiryDate = json['expiryDate'];
    //customerCode = json['customerCode'];
    ppId = json['ppId'];
  }
}

class SbiInsuredDetails{
  String insuredName;
  String insuredId;
  String coverId;

  SbiInsuredDetails.fromJson(Map<String, dynamic> json) {
    insuredName = json['insuredName'];
    insuredId = json['insuredId'];
    if (json['coverDetails'] != null) {
      final List<CoverDetails> list = List();
      json['coverDetails'].forEach((item) {
        coverId = CoverDetails.fromJson(item).coverId;
      });
    }
  }

}

class CoverDetails{
  String coverTypeName;
  String coverTypeId;
  String coverPremiumAmount;
  String coverId;

  CoverDetails.fromJson(Map<String, dynamic> json) {
    coverTypeName = json['coverTypeName'];
    coverTypeId = json['coverTypeId'];
    coverPremiumAmount = json['coverPremiumAmount'];
    coverId = json['coverId'];
  }

}