import 'package:sbig_app/src/models/common/failure_model.dart';

class ProductResponseModel {
  String status;
  Data data;
  ApiErrorModel apiErrorModel;

  ProductResponseModel({this.status, this.data});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<ProductList> productlist;

  Data({this.productlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['productlist'] != null) {
      productlist = new List<ProductList>();
      json['productlist'].forEach((v) {
        productlist.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productlist != null) {
      data['productlist'] = this.productlist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  int id;
  String slug;
  String productName;

  ProductList({this.id, this.slug, this.productName});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['product_name'] = this.productName;
    return data;
  }
}
