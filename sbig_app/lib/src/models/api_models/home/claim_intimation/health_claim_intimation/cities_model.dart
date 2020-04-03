import 'package:sbig_app/src/models/common/failure_model.dart';

class CitiesResponseModel {
  String status;
  Data data;
  ApiErrorModel apiErrorModel;


  CitiesResponseModel({this.status, this.data});

  CitiesResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<String> cities;
  String selectedCity;

  Data({this.cities, this.selectedCity});

  Data.fromJson(Map<String, dynamic> json) {
    cities = json['cities'].cast<String>();
    selectedCity = json['selected_city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cities'] = this.cities;
    data['selected_city'] = this.selectedCity;
    return data;
  }
}