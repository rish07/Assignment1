import 'package:sbig_app/src/models/common/failure_model.dart';

class ProductInfoResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  ProductInfoResModel({this.success, this.data});

  ProductInfoResModel.fromJson(Map<String, dynamic> json) {
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
  List<Header> header;
  List<Body> body;

  Data({this.header, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['header'] != null) {
      header = new List<Header>();
      json['header'].forEach((v) {
        header.add(new Header.fromJson(v));
      });
    }
    if (json['body'] != null) {
      body = new List<Body>();
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.map((v) => v.toJson()).toList();
    }
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Header {
  String slugType;
  String title;
  int priority;
  bool status;
  String layout;
  String imagePath1;
  String imagePath2;

  Header(
      {this.slugType,
        this.title,
        this.priority,
        this.status,
        this.layout,
        this.imagePath1,
        this.imagePath2});

  Header.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    status = json['status'];
    layout = json['layout'];
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug_type'] = this.slugType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['layout'] = this.layout;
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
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
  List<Points> points;

  Body(
      {this.slugType,
        this.title,
        this.priority,
        this.description,
        this.status,
        this.layout,
        this.imagePath1,
        this.imagePath2,
        this.points});

  Body.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    description = json['description'];
    status = json['status'];
    layout = json['layout'];
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
    data['description'] = this.description;
    data['status'] = this.status;
    data['layout'] = this.layout;
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
  String imagePath1;
  String imagePath2;

  SubPoints(
      {this.subPointType,
        this.title,
        this.priority,
        this.imagePath1,
        this.imagePath2});

  SubPoints.fromJson(Map<String, dynamic> json) {
    subPointType = json['sub_point_type'];
    title = json['title'];
    priority = json['priority'];
    imagePath1 = json['image_path_1'];
    imagePath2 = json['image_path_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_point_type'] = this.subPointType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['image_path_1'] = this.imagePath1;
    data['image_path_2'] = this.imagePath2;
    return data;
  }
}

/*
class Data {
  List<Header> header;
  List<Body> body;

  Data({this.header, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['header'] != null) {
      header = new List<Header>();
      json['header'].forEach((v) {
        header.add(new Header.fromJson(v));
      });
    }
    if (json['body'] != null) {
      body = new List<Body>();
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.header != null) {
      data['header'] = this.header.map((v) => v.toJson()).toList();
    }
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Header {
  String slugType;
  String title;
  int priority;
  bool status;
  String layout;

  Header({this.slugType, this.title, this.priority, this.status, this.layout});

  Header.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    status = json['status'];
    layout = json['layout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slug_type'] = this.slugType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    data['status'] = this.status;
    data['layout'] = this.layout;
    return data;
  }
}

class Body {
  String slugType;
  String title;
  int priority;
  bool status;
  String layout;
  List<Points> points;

  Body(
      {this.slugType,
        this.title,
        this.priority,
        this.status,
        this.layout,
        this.points});

  Body.fromJson(Map<String, dynamic> json) {
    slugType = json['slug_type'];
    title = json['title'];
    priority = json['priority'];
    status = json['status'];
    layout = json['layout'];
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
  List<SubPoints> subPoints;

  Points({this.pointType, this.title, this.priority, this.subPoints});

  Points.fromJson(Map<String, dynamic> json) {
    pointType = json['point_type'];
    title = json['title'];
    priority = json['priority'];
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

  SubPoints({this.subPointType, this.title, this.priority});

  SubPoints.fromJson(Map<String, dynamic> json) {
    subPointType = json['sub_point_type'];
    title = json['title'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_point_type'] = this.subPointType;
    data['title'] = this.title;
    data['priority'] = this.priority;
    return data;
  }
}*/
