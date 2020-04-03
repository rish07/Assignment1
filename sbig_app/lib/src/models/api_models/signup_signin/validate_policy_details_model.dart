
import 'package:sbig_app/src/models/common/failure_model.dart';

class ValidatePolicyDetailsReqModel {
  String policyNumber;
  String policytype;
  String productCode;
  String primaryInsuredDOB;
  String startDate;
  String policytypename;
  String verifyHash;

  ValidatePolicyDetailsReqModel({this.policyNumber, this.policytype,
      this.productCode, this.primaryInsuredDOB, this.startDate});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyNumber'] = this.policyNumber;
    data['policytype'] = this.policytype;
    data['productCode'] = this.productCode;
    data['policytypename'] = this.policytypename;

    if(null != this.primaryInsuredDOB) {
      data['primaryInsuredDOB'] = this.primaryInsuredDOB;
    }

    if(null != this.startDate) {
      data['startDate'] = this.startDate;
    }

    if(null != this.verifyHash) {
      data['verifyHash'] = this.verifyHash;
    }
    return data;
  }
}

class ValidatePolicyDetailsResModel {
  bool status;
  String message;
  String policyIdHash;
  String verifyHash;
  ApiErrorModel apiErrorModel;

  ValidatePolicyDetailsResModel({this.status, this.message});

  ValidatePolicyDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if(json['policyIdHash'] != null) {
      policyIdHash = json['policyIdHash'];
    }
    if(json['verifyHash'] != null) {
      verifyHash = json['verifyHash'];
    }
  }
}