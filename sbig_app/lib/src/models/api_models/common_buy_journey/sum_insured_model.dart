import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class SumInsuredReqModel {
  List<Members> members;

  SumInsuredReqModel({this.members});

  SumInsuredReqModel.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SumInsuredResModel {
  bool success;
  String message;
  List<Data> data;
  ApiErrorModel apiErrorModel;

  SumInsuredResModel({this.success, this.message, this.data});

  SumInsuredResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String suminsured;
  String premium;
  String deduction;

  Data({this.suminsured, this.premium, this.deduction});

  Data.fromJson(Map<String, dynamic> json) {
    suminsured = json['suminsured'];
    premium = json['premium'];
    deduction = json['deduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suminsured'] = this.suminsured;
    data['premium'] = this.premium;
    data['deduction'] = this.deduction;
    return data;
  }
}

/*class Data {
  String suminsured;
  String premium;

  Data({this.suminsured, this.premium});

  Data.fromJson(Map<String, dynamic> json) {
    suminsured = json['suminsured'];
    premium = json['premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suminsured'] = this.suminsured;
    data['premium'] = this.premium;
    return data;
  }
}*/
