import 'package:sbig_app/src/models/common/failure_model.dart';

class RegisterReqModel {
  String name;
  String mobile;
  String otp;

  RegisterReqModel(this.name, this.mobile, this.otp);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['otp'] = this.otp;
    return data;
  }
}

class RegisterResModel {
  bool status;
  String message;
  String token;
  String customer_name;
  String verifyHash;
  ApiErrorModel apiErrorModel;

  RegisterResModel(
      {this.status,
      this.message,
      this.token,
      this.verifyHash,
      this.apiErrorModel});

  RegisterResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    if(json['customer_name'] != null) {
      customer_name = json['customer_name'];
    }
    verifyHash = json['verifyHash'];
  }
}
