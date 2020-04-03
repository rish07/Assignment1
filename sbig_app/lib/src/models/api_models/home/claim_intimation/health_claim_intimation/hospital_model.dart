import 'package:sbig_app/src/models/common/failure_model.dart';

class HospitalResponseModel {
  bool status;
  List<Data> data;
  ApiErrorModel apiErrorModel;


  HospitalResponseModel({this.status, this.data});

  HospitalResponseModel.fromJson(Map<String, dynamic> json) {
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
  String hospitalName;
  List<String> tPACategory;
  String hospitalCity;

  Data({this.hospitalName, this.tPACategory, this.hospitalCity});

  Data.fromJson(Map<String, dynamic> json) {
    hospitalName = json['Hospital_Name'];
    tPACategory = json['TPA_Category'].cast<String>();
    hospitalCity = json['Hospital_City'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Hospital_Name'] = this.hospitalName;
    data['TPA_Category'] = this.tPACategory;
    data['Hospital_City'] = this.hospitalCity;
    return data;
  }
}