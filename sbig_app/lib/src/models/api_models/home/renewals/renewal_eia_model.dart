
import 'package:sbig_app/src/models/common/failure_model.dart';

class RenewalStoreEIAReqModel{
  String policyNumber;
  String quoteNumber;
  String ref_type;
  String mobile;
  String email;
  String EIA;

  RenewalStoreEIAReqModel({this.policyNumber, this.quoteNumber, this.ref_type, this.mobile, this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.policyNumber != null) {
      data['policyNumber'] = this.policyNumber;
    }
    if(this.quoteNumber != null) {
      data['quoteNumber'] = this.quoteNumber;
    }
    data['ref_type'] = this.ref_type;
    if(this.mobile != null) {
      data['mobile'] = this.mobile;
    }

    if(this.email != null) {
      data['email'] = this.email;
    }
    data['EIA'] = this.EIA;
    return data;
  }
}

class RenewalStoreEIAResModel{
  bool status;
  String message;
  ApiErrorModel apiErrorModel;

  RenewalStoreEIAResModel({this.status, this.message, this.apiErrorModel});

  RenewalStoreEIAResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}