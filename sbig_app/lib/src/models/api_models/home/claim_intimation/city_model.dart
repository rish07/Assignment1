import 'package:sbig_app/src/models/common/failure_model.dart';

class CityResponseModel {
  String status;
  Data data;
  ApiErrorModel apiErrorModel;

  CityResponseModel({this.status, this.data});

  CityResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<CityList> cityList;

  Data({this.cityList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['citylist'] != null) {
      cityList = new List<CityList>();
      json['citylist'].forEach((v) {
        cityList.add(new CityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cityList != null) {
      data['citylist'] = this.cityList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityList {
  int id;
  String cityName;

  CityList({this.id, this.cityName});

  CityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['city_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.cityName;
    return data;
  }
}
