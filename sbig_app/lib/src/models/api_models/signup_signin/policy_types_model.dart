import 'package:sbig_app/src/models/common/failure_model.dart';

class PolicyTypesResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  PolicyTypesResModel({this.success, this.data, this.apiErrorModel});

  PolicyTypesResModel.fromJson(Map<String, dynamic> json) {
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
  List<PolicyTypeBody> body;

  Data({this.body});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = new List<PolicyTypeBody>();
      json['body'].forEach((v) {
        body.add(new PolicyTypeBody.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PolicyTypeBody {
  String slugType;
  String title;
  int priority;
  String description;
  bool status;
  String layout;
  JsonCondition jsonCondition;
  String imagePath1;
  String imagePath2;

  PolicyTypeBody(
      {this.slugType,
        this.title,
        this.priority,
        this.description,
        this.status,
        this.layout,
        this.jsonCondition,
        this.imagePath1,
        this.imagePath2});

  PolicyTypeBody.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    description = json['description'];
    status = json['status'];
    layout = json['layout'];
    jsonCondition = json['json_condition'] != null
        ? new JsonCondition.fromJson(json['json_condition'])
        : null;
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug_type'] = this.slugType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['status'] = this.status;
    data['layout'] = this.layout;
    if (this.jsonCondition != null) {
      data['json_condition'] = this.jsonCondition.toJson();
    }
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    return data;
  }
}

class JsonCondition {
  String policyType;
  String productCode;
  String policyTypeName;
  int navigateId;

  JsonCondition({this.policyType, this.productCode, this.navigateId});

  JsonCondition.fromJson(Map<String, dynamic> json) {
    policyType = json['policyType'];
    productCode = json['productCode'];
    navigateId = json['navigateId'];
    policyTypeName = json['policyTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyType'] = this.policyType;
    data['productCode'] = this.productCode;
    data['navigateId'] = this.navigateId;
    data['policyTypeName'] = this.policyTypeName;
    return data;
  }
}