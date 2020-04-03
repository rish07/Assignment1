import 'package:sbig_app/src/models/common/failure_model.dart';

class CoverMemberResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  CoverMemberResModel({this.success, this.data});

  CoverMemberResModel.fromJson(Map<String, dynamic> json) {
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
  List<Body> body;

  Data({this.body});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      body = new List<Body>();
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
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
class Body {
  String slugType;
  String title;
  int priority;
  String description;
  bool status;
  String layout;
  String imagePath1;
  String imagePath2;
  JsonCondition jsonCondition;

  Body(
      {this.slugType,
        this.title,
        this.priority,
        this.description,
        this.status,
        this.layout,
        this.imagePath1,
        this.imagePath2,
        this.jsonCondition});

  Body.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    description = json['description'];
    status = json['status'];
    layout = json['layout'];
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
    jsonCondition = json['json_condition'] != null
        ? new JsonCondition.fromJson(json['json_condition'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug_type'] = this.slugType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['status'] = this.status;
    data['layout'] = this.layout;
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    if (this.jsonCondition != null) {
      data['json_condition'] = this.jsonCondition.toJson();
    }
    return data;
  }
}

class JsonCondition {
  List<int> age;
  String employed;
  bool isMarried;
  String gender;

  JsonCondition({this.age, this.employed, this.isMarried, this.gender});

  JsonCondition.fromJson(Map<String, dynamic> json) {
    age = json['age'].cast<int>();
    employed = json['employed'];
    isMarried = json['is_married'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['employed'] = this.employed;
    data['is_married'] = this.isMarried;
    data['gender'] = this.gender;
    return data;
  }
}