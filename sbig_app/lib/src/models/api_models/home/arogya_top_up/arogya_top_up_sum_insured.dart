import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class ArogyaTopUpSumInsuredReqModel {
  List<Members> members;

  ArogyaTopUpSumInsuredReqModel({this.members});

  ArogyaTopUpSumInsuredReqModel.fromJson(Map<String, dynamic> json) {
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

class ArogyaTopUpSumInsuredResModel {
  bool success;
  String message;
  List<Data> data;
  ApiErrorModel apiErrorModel;

  ArogyaTopUpSumInsuredResModel({this.success, this.message, this.data});

  ArogyaTopUpSumInsuredResModel.fromJson(Map<String, dynamic> json) {
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
  List<DeductionList> deductionList;

  Data({this.suminsured, this.deductionList});

  Data.fromJson(Map<String, dynamic> json) {
    suminsured = json['suminsured'];
    if (json['deductionList'] != null) {
      deductionList = new List<DeductionList>();
      json['deductionList'].forEach((v) {
        deductionList.add(new DeductionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suminsured'] = this.suminsured;
    if (this.deductionList != null) {
      data['deductionList'] =
          this.deductionList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeductionList {
  String premium;
  String deduction;
  bool isSelected ;

  DeductionList({this.premium, this.deduction,this.isSelected=false});

  DeductionList.fromJson(Map<String, dynamic> json) {
    premium = json['premium'];
    deduction = json['deduction'];
    isSelected=false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['premium'] = this.premium;
    data['deduction'] = this.deduction;
    return data;
  }
}