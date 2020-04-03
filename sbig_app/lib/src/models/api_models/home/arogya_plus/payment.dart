import 'package:sbig_app/src/models/common/failure_model.dart';

class PaymentStatusCheckRequest {
  String firstName;
  String lastName;
  String email;
  String phone;
  int amount;
  String quote_no;
  String recieptNo;
  String hash;
  String paymentId;
  String orderId;
  String customerCode;

  PaymentStatusCheckRequest(
      {this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.amount,
        this.quote_no,
        this.recieptNo,
        this.hash,
        this.paymentId,
        this.orderId, this.customerCode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['amount'] = this.amount;
    data['quote_no'] = this.quote_no;
    data['reciept_no'] = this.recieptNo;
    data['razorpay_hash_key'] = this.hash;
    data['razorpay_payment_id'] = this.paymentId;
    data['razorpay_order_id'] = this.orderId;
    data['customerCode'] = this.customerCode;
    return data;
  }
}


class PaymentStatusCheckResponse {
  bool success;
  String message;
  Data data;
  ApiErrorModel apiErrorModel;

  PaymentStatusCheckResponse({this.success, this.message, this.data});

  PaymentStatusCheckResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  PolicyIssueResponseBody policyIssueResponseBody;

  Data({this.policyIssueResponseBody});

  Data.fromJson(Map<String, dynamic> json) {
    policyIssueResponseBody = json['policyIssueResponseBody'] != null
        ? new PolicyIssueResponseBody.fromJson(json['policyIssueResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.policyIssueResponseBody != null) {
      data['policyIssueResponseBody'] = this.policyIssueResponseBody.toJson();
    }
    return data;
  }
}

class PolicyIssueResponseBody {
  Payload payload;

  PolicyIssueResponseBody({this.payload});

  PolicyIssueResponseBody.fromJson(Map<String, dynamic> json) {
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }
}

class Payload {
  String policyNumber;

  Payload({this.policyNumber});

  Payload.fromJson(Map<String, dynamic> json) {
    policyNumber = json['policyNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policyNumber'] = this.policyNumber;
    return data;
  }
}



class OrderIdGenerationResponse {
  bool success;
  String razorPayKey;
  OrderIdData data;

  OrderIdGenerationResponse({this.success, this.data, this.razorPayKey});

  OrderIdGenerationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    razorPayKey = json['razor_pay_key'];
    data = json['data'] != null ? OrderIdData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['razor_pay_key'] = this.razorPayKey;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OrderIdData {
  String id;
  String entity;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  String offerId;
  String status;
  int attempts;
  List<String> notes;
  int createdAt;

  OrderIdData(
      {this.id,
        this.entity,
        this.amount,
        this.amountPaid,
        this.amountDue,
        this.currency,
        this.receipt,
        this.offerId,
        this.status,
        this.attempts,
        this.notes,
        this.createdAt});

  OrderIdData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    receipt = json['receipt'];
    offerId = json['offer_id'];
    status = json['status'];
    attempts = json['attempts'];
    notes = json['notes'].cast<String>();
    createdAt = json['created_at'];

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
    data['offer_id'] = this.offerId;
    data['status'] = this.status;
    data['attempts'] = this.attempts;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    return data;
  }
}


class OrderIdGenerationRequest {
  int amount;
  String quoteNo;

  OrderIdGenerationRequest({this.amount, this.quoteNo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['quote_no'] = this.quoteNo;
    return data;
  }
}

