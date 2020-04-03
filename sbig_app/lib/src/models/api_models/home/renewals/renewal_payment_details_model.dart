
import 'package:sbig_app/src/models/common/failure_model.dart';

class PaymentIdGenerationReqModel{

  String amount;
  String receipt;

  PaymentIdGenerationReqModel({this.amount, this.receipt});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['receipt'] = this.receipt;
    return data;
  }
}

class PaymentIdGenerationResModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  PaymentIdGenerationResModel({this.success, this.data, this.apiErrorModel});

  PaymentIdGenerationResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  String id;
  String entity;
  dynamic amount;
  dynamic amountPaid;
  dynamic amountDue;
  String currency;
  String receipt;

  Data(
      {this.id,
        this.entity,
        this.amount,
        this.amountPaid,
        this.amountDue,
        this.currency,
        this.receipt,});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    receipt = json['receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['amount'] = this.amount;
    data['amount_paid'] = this.amountPaid;
    data['amount_due'] = this.amountDue;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    return data;
  }
}
class Autogenerated {
  bool success;
  Data data;

  Autogenerated({this.success, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
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