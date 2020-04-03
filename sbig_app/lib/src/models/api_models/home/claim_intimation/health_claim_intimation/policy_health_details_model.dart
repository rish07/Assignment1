import 'package:sbig_app/src/models/common/failure_model.dart';

class PolicyDetailsRequestModel {
  String policyNo;

  PolicyDetailsRequestModel({this.policyNo});

  PolicyDetailsRequestModel.fromJson(Map<String, dynamic> json) {
    policyNo = json['policy_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_no'] = this.policyNo;
    return data;
  }
}

class PolicyDetailsResponseModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;


  PolicyDetailsResponseModel({this.success, this.data});

  PolicyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String policyNo;
  String mobileNo;
  String policyType;
  List<String> members;

  Data({this.policyNo, this.mobileNo, this.policyType, this.members});

  Data.fromJson(Map<String, dynamic> json) {
    policyNo = json['policy_no'];
    mobileNo = json['mobile_no'];
    policyType = json['policy_type'];
    members = json['members'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_no'] = this.policyNo;
    data['mobile_no'] = this.mobileNo;
    data['policy_type'] = this.policyType;
    data['members'] = this.members;
    return data;
  }
}