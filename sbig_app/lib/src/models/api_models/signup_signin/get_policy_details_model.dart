import 'package:sbig_app/src/models/common/failure_model.dart';

class GetPolicyDetailsRequestModel {
  String policyNumber;
  String policytype;
  String productCode;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyNumber'] = this.policyNumber;
    data['policytype'] = this.policytype;
    data['productCode'] = this.productCode;
    return data;
  }
}

class LoginRequestModel {
  String mobile;

  LoginRequestModel(this.mobile);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    return data;
  }
}

class GetPolicyDetailsResponseModel {
  String status;
  String Name;
  String Mobile;
  String otp;
  String message;
  ApiErrorModel apiErrorModel;

  GetPolicyDetailsResponseModel({this.status, this.Name, this.Mobile, this.otp,
      this.message, this.apiErrorModel});

  GetPolicyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    Name = json['Name'];
    Mobile = json['Mobile'];
    status = json['status'];
    otp = json['otp'];
    message = json['message'];
    apiErrorModel = json['apiErrorModel'];
  }
}