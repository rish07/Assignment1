import 'package:sbig_app/src/models/common/failure_model.dart';

class PaymentReqModel {
  String firstName;
  String lastName;
  String email;
  dynamic razorpayOrderId;
  dynamic razorpayPaymentId;
  String phone;
  String amount;
  String quoteNo;
  String recieptNo;
  String razorpayHashKey;
  String customerCode;

  PaymentReqModel(
      {this.firstName,
        this.lastName,
        this.email,
        this.razorpayOrderId,
        this.razorpayPaymentId,
        this.phone,
        this.amount,
        this.quoteNo,
        this.recieptNo,
        this.razorpayHashKey,
        this.customerCode});

  PaymentReqModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    razorpayOrderId = json['razorpay_order_id'];
    razorpayPaymentId = json['razorpay_payment_id'];
    phone = json['phone'];
    amount = json['amount'];
    quoteNo = json['quote_no'];
    recieptNo = json['reciept_no'];
    razorpayHashKey = json['razorpay_hash_key'];
    customerCode = json['customerCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['razorpay_order_id'] = this.razorpayOrderId;
    data['razorpay_payment_id'] = this.razorpayPaymentId;
    data['phone'] = this.phone;
    data['amount'] = this.amount;
    data['quote_no'] = this.quoteNo;
    data['reciept_no'] = this.recieptNo;
    data['razorpay_hash_key'] = this.razorpayHashKey;
    data['customerCode'] = this.customerCode;
    return data;
  }
}

class PaymentResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  PaymentResModel({this.success, this.data});

  PaymentResModel.fromJson(Map<String, dynamic> json) {
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
  String hash;
  Request request;

  Data({this.hash, this.request});

  Data.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hash'] = this.hash;
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    return data;
  }
}

class Request {
  String firstName;
  String lastName;
  String email;
  String phone;
  String amount;
  String quoteNo;

  Request(
      {this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.amount,
        this.quoteNo});

  Request.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    amount = json['amount'];
    quoteNo = json['quote_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['amount'] = this.amount;
    data['quote_no'] = this.quoteNo;
    return data;
  }
}