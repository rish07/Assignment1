
import 'package:sbig_app/src/models/common/failure_model.dart';

class HealthQuestionResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  HealthQuestionResModel({this.success, this.data});

  HealthQuestionResModel.fromJson(Map<String, dynamic> json) {
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
  bool status;
  String layout;
  JsonCondition jsonCondition;
  String imagePath1;
  String imagePath2;
  List<Points> points;

  Body(
      {this.slugType,
      this.title,
      this.priority,
      this.status,
      this.layout,
      this.jsonCondition,
      this.imagePath1,
      this.imagePath2,
      this.points});

  Body.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    status = json['status'];
    layout = json['layout'];
    jsonCondition = json['json_condition'] != null
        ? new JsonCondition.fromJson(json['json_condition'])
        : null;
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
    if (json['points'] != null) {
      points = new List<Points>();
      json['points'].forEach((v) {
        points.add(new Points.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug_type'] = this.slugType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['layout'] = this.layout;
    if (this.jsonCondition != null) {
      data['json_condition'] = this.jsonCondition.toJson();
    }
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    if (this.points != null) {
      data['points'] = this.points.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Points {
  String pointType;
  String title;
  int priority;
  String imagePath1;
  String imagePath2;
  List<SubPoints> subPoints;

  Points(
      {this.pointType,
      this.title,
      this.priority,
      this.imagePath1,
      this.imagePath2,
      this.subPoints});

  Points.fromJson(Map<String, dynamic> json) {
    pointType = json['point_type'];
    title = json['title'];
    priority = json['priority'];
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
    if (json['sub_points'] != null) {
      subPoints = new List<SubPoints>();
      json['sub_points'].forEach((v) {
        subPoints.add(new SubPoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['point_type'] = this.pointType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    if (this.subPoints != null) {
      data['sub_points'] = this.subPoints.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubPoints {
  String subPointType;
  String title;
  int priority;
  JsonCondition jsonCondition;
  String imagePath1;
  String imagePath2;

  SubPoints(
      {this.subPointType,
      this.title,
      this.priority,
      this.jsonCondition,
      this.imagePath1,
      this.imagePath2});

  SubPoints.fromJson(Map<String, dynamic> json) {
    subPointType = json['sub_point_type'];
    title = json['title'];
    priority = json['priority'];
    jsonCondition = json['json_condition'] != null
        ? new JsonCondition.fromJson(json['json_condition'])
        : null;
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_point_type'] = this.subPointType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    if (this.jsonCondition != null) {
      data['json_condition'] = this.jsonCondition.toJson();
    }
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    return data;
  }
}

class JsonCondition {
  List<Value> value;
  String hint;
  String eligibleAnswer;

  JsonCondition({this.value, this.hint, this.eligibleAnswer});

  JsonCondition.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = new List<Value>();
      json['value'].forEach((v) {
        value.add(new Value.fromJson(v));
      });
    }
    hint = json['hint'];
    eligibleAnswer = json['eligible_answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    data['hint'] = this.hint;
    data['eligible_answer'] = this.eligibleAnswer;
    return data;
  }
}

class Value {
  int priority;
  String title;

  Value({this.priority, this.title});

  Value.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['title'] = this.title;
    return data;
  }
}
