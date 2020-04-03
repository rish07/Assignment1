import 'package:sbig_app/src/models/common/failure_model.dart';

class RenewalPaymentStatusCheckRequest {
  String transactionId;
  String policyNumber;
  String amount;
  String name;
  String quote_no;

  RenewalPaymentStatusCheckRequest(
      {this.transactionId,
      this.policyNumber,
      this.amount,
      this.name,
      this.quote_no});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['policyNumber'] = this.policyNumber;
    data['amount'] = this.amount;
    data['name'] = this.name;
    data['quote_no'] = this.quote_no;
    return data;
  }
}

class RenewalPaymentStatusCheckResponse {
  bool success;
  String message;
  RenewalData data;
  ApiErrorModel apiErrorModel;

  RenewalPaymentStatusCheckResponse({this.success, this.message, this.data});

  RenewalPaymentStatusCheckResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new RenewalData.fromJson(json['data']) : null;
  }
}

class RenewalData {
  String renewalStatus;
  String statusCode;
  String customerOrderNo;
  String payorCode;
  String receiptNo;
  String renewedPolicyNo;
  String renewalTime;
  String productName;
  String transactionId;
  String amount;
  String source;
  String insuredName;
  String processId;
  String policyNo;
  String quoteNo;

  RenewalData(
      {this.renewalStatus,
      this.statusCode,
      this.customerOrderNo,
      this.payorCode,
      this.receiptNo,
      this.renewedPolicyNo,
      this.renewalTime,
      this.productName,
      this.transactionId,
      this.amount,
      this.source,
      this.insuredName,
      this.processId,
      this.policyNo,
      this.quoteNo});

  RenewalData.fromJson(Map<String, dynamic> json) {
    renewalStatus = json['renewal_status'];
    statusCode = json['status_code'];
    customerOrderNo = json['customer_order_no'];
    payorCode = json['payor_code'];
    receiptNo = json['receipt_no'];
    renewedPolicyNo = json['renewed_policy_no'];
    renewalTime = json['renewal_time'];
    productName = json['product_name'];
    transactionId = json['transaction_id'];
    amount = json['amount'];
    source = json['source'];
    insuredName = json['insured_name'];
    processId = json['process_id'];
    policyNo = json['policy_no'];
    quoteNo = json['quote_no'];
  }
}
