
import 'package:sbig_app/src/models/common/failure_model.dart';

class RenewalUpdateDetailsReqModel{
  String policyNumber;
  String policytype;
  String amount;
  String source;
  String productCode;
  String mobile;
  String email;
  String transactionId;

  RenewalUpdateDetailsReqModel({this.policyNumber, this.policytype, this.amount, this.source, this.productCode, this.mobile, this.email, this.transactionId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyNo'] = this.policyNumber;
    data['policyType'] = this.policytype;
    data['amount'] = this.amount;
    data['source'] = this.source;
    data['productCode'] = this.productCode;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['transactionId'] = this.transactionId;
    return data;
  }
}

class RenewalUpdateDetailsResModel{
  bool status;
  String quote_no;
  String status_message;
  Error error;
  ApiErrorModel apiErrorModel;

  RenewalUpdateDetailsResModel({this.status, this.quote_no, this.status_message,
      this.error, this.apiErrorModel});

  RenewalUpdateDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    quote_no = json['quote_no'] ?? null;
    status_message = json['status_message'] ?? null;
    if (json['error'] != null) {
      error = Error.fromJson(json['error']);
    };
  }
}

class Error{
  String code;
  String message;

  Error.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? null;
    message = json['message'] ?? null;
  }
}