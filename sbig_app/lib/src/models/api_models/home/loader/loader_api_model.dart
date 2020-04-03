import 'package:sbig_app/src/models/common/failure_model.dart';

class LoaderResponseModel {
  String status;
  Data data;
  ApiErrorModel apiErrorModel;

  LoaderResponseModel({this.status, this.data});

  LoaderResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Loadermsg> loadermsg;

  Data({this.loadermsg});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['loadermsg'] != null) {
      loadermsg = new List<Loadermsg>();
      json['loadermsg'].forEach((v) {
        loadermsg.add(new Loadermsg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.loadermsg != null) {
      data['loadermsg'] = this.loadermsg.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Loadermsg {
  int id;
  String loaderMsg;

  Loadermsg({this.id, this.loaderMsg});

  Loadermsg.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loaderMsg = json['loader_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['loader_msg'] = this.loaderMsg;
    return data;
  }
}
