import 'package:sbig_app/src/models/common/failure_model.dart';

class ClaimIntimationRequestModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String policyNo;
  String city;
  String product;
  String remarks;

  ClaimIntimationRequestModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.policyNo,
      this.city,
      this.product,
      this.remarks});

  ClaimIntimationRequestModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    policyNo = json['policy_no'];
    city = json['city'];
    product = json['product'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['policy_no'] = this.policyNo;
    data['city'] = this.city;
    data['product'] = this.product;
    data['remarks'] = this.remarks;
    return data;
  }
}

class ClaimIntimationResponseModel {
  String status;
  String msg;
  Data data;
  ApiErrorModel apiErrorModel;

  ClaimIntimationResponseModel({this.status, this.msg, this.data});

  ClaimIntimationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int claimId;
  ClaimData claimData;

  Data({this.claimId, this.claimData});

  Data.fromJson(Map<String, dynamic> json) {
    claimId = json['claim_id'];
    claimData = json['claimdata'] != null
        ? new ClaimData.fromJson(json['claimdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claim_id'] = this.claimId;
    if (this.claimData != null) {
      data['claimdata'] = this.claimData.toJson();
    }
    return data;
  }
}

class ClaimData {
  String activityNumber;
  List<String> errorSpcCode;
  List<String> errorSpcMessage;

  ClaimData({this.activityNumber, this.errorSpcCode, this.errorSpcMessage});

  ClaimData.fromJson(Map<String, dynamic> json) {
    activityNumber = json['ActivityNumber'];
    errorSpcCode = json['Error_spcCode'].cast<String>();
    errorSpcMessage = json['Error_spcMessage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityNumber'] = this.activityNumber;
    data['Error_spcCode'] = this.errorSpcCode;
    data['Error_spcMessage'] = this.errorSpcMessage;
    return data;
  }
}
