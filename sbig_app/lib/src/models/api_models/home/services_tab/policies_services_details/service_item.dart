class ServicesListItem {
  String serviceName;
  String serviceCode;
  String serviceImage;
  List<IsApplicable> isApplicable;

  ServicesListItem({this.serviceName, this.serviceCode, this.serviceImage, this.isApplicable});

  ServicesListItem.fromJson(Map<String, dynamic> json) {
    serviceName = json['service_name'];
    serviceCode = json['service_code'];
    serviceImage = json['service_image'];
    if (json['is_applicable'] != null) {
      isApplicable = new List<IsApplicable>();
      json['is_applicable'].forEach((v) { isApplicable.add(new IsApplicable.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_name'] = this.serviceName;
    data['service_code'] = this.serviceCode;
    data['service_image'] = this.serviceImage;
    if (this.isApplicable != null) {
      data['is_applicable'] = this.isApplicable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IsApplicable {
  String productCode;
  bool isEnabled;
  String product_tag_name;
  String product_name;
  String sub_product_code;

  IsApplicable({this.productCode, this.isEnabled, this.product_tag_name});

  IsApplicable.fromJson(Map<String, dynamic> json) {
    productCode = json['product_code'];
    isEnabled = json['is_enabled'];
    product_tag_name = json['product_tag_name'];
    product_name = json['product_name'];
    sub_product_code = json['sub_product_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_code'] = this.productCode;
    data['is_enabled'] = this.isEnabled;
    data['product_tag_name'] = this.product_tag_name;
    data['product_name'] = this.product_name;
    data['sub_product_code'] = this.sub_product_code;
    return data;
  }
}