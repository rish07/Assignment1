import 'package:sbig_app/src/models/common/failure_model.dart';

class CriticalSumInsuredReqModel {
  int age;
  String employed;
  int grossIncome;
  String gender;

  CriticalSumInsuredReqModel({this.age, this.employed, this.grossIncome, this.gender});

  CriticalSumInsuredReqModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    employed = json['employed'];
    grossIncome = json['gross_income'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['employed'] = this.employed;
    data['gross_income'] = this.grossIncome;
    data['gender'] = this.gender;
    return data;
  }
}

class CriticalSumInsuredResModel {
  bool status;
  List<Data> data;
  ApiErrorModel apiErrorModel;

  CriticalSumInsuredResModel({this.status, this.data});

  CriticalSumInsuredResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int suminsured;
  int year1Premium;
  int year3Premium;

  Data({this.suminsured, this.year1Premium, this.year3Premium});

  Data.fromJson(Map<String, dynamic> json) {
    suminsured = json['suminsured'];
    year1Premium = json['year1_premium'];
    year3Premium = json['year3_premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suminsured'] = this.suminsured;
    data['year1_premium'] = this.year1Premium;
    data['year3_premium'] = this.year3Premium;
    return data;
  }
}