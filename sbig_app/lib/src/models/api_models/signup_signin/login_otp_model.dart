import 'package:sbig_app/src/models/common/failure_model.dart';


class LoginOTPReqModel {
  String mobile;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    return data;
  }
}

class LoginOTPResModel {
  bool status;
  String message;
  String otp;
  ApiErrorModel apiErrorModel;

  LoginOTPResModel({this.status, this.message, this.otp, this.apiErrorModel});

  LoginOTPResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['otp'];
  }
}