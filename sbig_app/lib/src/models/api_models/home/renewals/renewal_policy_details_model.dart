import 'package:sbig_app/src/models/common/failure_model.dart';

class RenewalPolicyDetailsReqModel {
  String policyNumber;
  String policytype;
  String productCode;
  String primaryInsuredDOB;
  String registrationNumber;


  RenewalPolicyDetailsReqModel({this.policyNumber, this.policytype, this.productCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyNumber'] = this.policyNumber;
    data['policytype'] = this.policytype;
    data['productCode'] = this.productCode;

    if(this.primaryInsuredDOB != null){
      data['primaryInsuredDOB'] = this.primaryInsuredDOB;
    }
    if(this.registrationNumber != null){
      data['registrationNumber'] = this.registrationNumber;
    }
    return data;
  }
}


class RenewalPolicyDetailsResModel {
  bool status;
  RenewalPolicyData data;
  ApiErrorModel apiErrorModel;

  RenewalPolicyDetailsResModel({this.status, this.data, this.apiErrorModel});

  RenewalPolicyDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new RenewalPolicyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class RenewalPolicyData {
  String annualGrossPremium;
  String renewalDueDate;
  String renewalQuoteNumber;
  String customerName;
  String startTime;
  String renewalPremiumAmount;
  String email;
  String sumInsured;
  String productName;
  String previousPolicyNo;
  String mobile;
  String GST;

  RenewalPolicyData({this.annualGrossPremium, this.renewalDueDate, this.renewalQuoteNumber,
      this.customerName, this.startTime, this.renewalPremiumAmount, this.email,
      this.sumInsured, this.productName, this.previousPolicyNo, this.mobile, this.GST});

  RenewalPolicyData.fromJson(Map<String, dynamic> json) {
    annualGrossPremium = json['annualGrossPremium'];
    renewalDueDate = json['renewalDueDate'];
    renewalQuoteNumber = json['renewalQuoteNumber'];
    customerName = json['customerName'];
    startTime = json['startTime'];
    renewalPremiumAmount = json['renewalPremiumAmount'];
    email = json['email'];
    sumInsured = json['sumInsured'];
    productName = json['productName'];
    previousPolicyNo = json['previousPolicyNo'];
    mobile = json['mobile'];
    GST = json['GST'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['annualGrossPremium'] = this.annualGrossPremium;
    data['renewalDueDate'] = this.renewalDueDate;
    data['renewalQuoteNumber'] = this.renewalQuoteNumber;
    data['customerName'] = this.customerName;
    data['startTime'] = this.startTime;
    data['email'] = this.email;
    data['sumInsured'] = this.sumInsured;
    data['productName'] = this.productName;
    data['previousPolicyNo'] = this.previousPolicyNo;
    data['mobile'] = this.mobile;
    data['GST'] = this.GST;
    return data;
  }
}