import 'package:sbig_app/src/models/common/failure_model.dart';

class OtherInsuranceCompanyList {
  bool status;
  List<String> data;
  ApiErrorModel apiErrorModel;

  OtherInsuranceCompanyList({this.status, this.data});

  OtherInsuranceCompanyList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}