class BannersApiResponseModel {
  String status;
  Data data;

  BannersApiResponseModel({this.status, this.data});

  BannersApiResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Banners> banners;

  Data({this.banners});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = new List<Banners>();
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  String imagepath;
  String title;

  Banners({this.imagepath, this.title});

  Banners.fromJson(Map<String, dynamic> json) {
    imagepath = json['imagepath'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagepath'] = this.imagepath;
    data['title'] = this.title;
    return data;
  }
}
