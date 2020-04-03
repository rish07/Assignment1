import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/policy_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/service_item.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class PoliciesServicesRes {
  bool status;
  ResultData resultData;
  ApiErrorModel apiErrorModel;

  PoliciesServicesRes({this.status, this.resultData});

  PoliciesServicesRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    resultData = json['result_data'] != null ? new ResultData.fromJson(json['result_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.resultData != null) {
      data['result_data'] = this.resultData.toJson();
    }
    return data;
  }
}

class ResultData {
  List<PolicyListItem> policyList;
  List<ServicesListItem> servicesList;

  ResultData({this.policyList, this.servicesList});

  ResultData.fromJson(Map<String, dynamic> json) {
    if (json['policy_list'] != null) {
      policyList = new List<PolicyListItem>();
      json['policy_list'].forEach((v) { policyList.add(PolicyListItem.fromJson(v)); });
    }
    if (json['services_list'] != null) {
      servicesList = new List<ServicesListItem>();
      json['services_list'].forEach((v) { servicesList.add(ServicesListItem.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.policyList != null) {
      data['policy_list'] = this.policyList.map((v) => v.toJson()).toList();
    }
    if (this.servicesList != null) {
      data['services_list'] = this.servicesList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}