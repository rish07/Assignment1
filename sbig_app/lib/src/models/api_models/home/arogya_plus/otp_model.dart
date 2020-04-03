import 'package:sbig_app/src/models/common/failure_model.dart';

class OTPRequestModel {
  String mobile;
  String quoteno;
  String partyID;
  ApiErrorModel apiErrorModel;

  OTPRequestModel({this.mobile, this.quoteno, this.partyID});

  OTPRequestModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    quoteno = json['quoteno'];
    if(json['partyID'] != null) {
      partyID = json['partyID'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['quoteno'] = this.quoteno;
    if(this.partyID != null) {
      data['partyID'] = this.partyID;
    }
    return data;
  }

}

class OTPResponseModel {

  bool success;
  String otp;
  ApiErrorModel apiErrorModel;
  String verifyHash;

  OTPResponseModel({this.success, this.otp});

  OTPResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    otp = json['otp'];
    verifyHash = json['verifyHash'] ?? null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['otp'] = this.otp;
    return data;
  }

}

class OTPVerifyRequestModel {
  String mobile;
  String otp;
  String quoteno;
  String partyID;

  OTPVerifyRequestModel({this.mobile, this.otp,this.quoteno, this.partyID});

  OTPVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    otp = json['otp'];
    quoteno = json['quoteno'];
    partyID = json['c'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['quoteno'] = this.quoteno;
    data['partyID'] = this.partyID;
    return data;
  }
}