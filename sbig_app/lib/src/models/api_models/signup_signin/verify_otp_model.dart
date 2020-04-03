import 'package:sbig_app/src/models/common/failure_model.dart';


class VerifyOTPReqModel {
  String mobile;
  String otp;

  VerifyOTPReqModel(this.mobile, this.otp);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    return data;
  }
}

class VerifyOTPResModel {
  bool status;
  String message;
  bool is_registered;
  String token;
  String customer_name;
  String verifyHash;
  ApiErrorModel apiErrorModel;


  VerifyOTPResModel({this.status, this.message, this.is_registered, this.token,
      this.verifyHash, this.apiErrorModel});

  VerifyOTPResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    is_registered = json['is_registered'];
    if(json['customer_name'] != null) {
      customer_name = json['customer_name'];
    }
    token = json['token'];
    verifyHash = json['verifyHash'];
  }
}