  import 'package:sbig_app/src/models/common/failure_model.dart';

class InsurancePayment{
    String quotationNo;
    String amount;
    String paymentReferNo;

    InsurancePayment({this.quotationNo, this.amount, this.paymentReferNo});

    InsurancePayment.fromJson(Map<String, dynamic> json) {
      quotationNo = json['QuotationNo'];
      amount = json['Amount'];
      paymentReferNo = json['PaymentReferNo'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['QuotationNo'] = this.quotationNo;
      data['Amount'] = this.amount;
      data['PaymentReferNo'] = this.paymentReferNo;
      return data;
    }
  }
  class InsurancePaymentResModel {
    bool success;
    String message;
    Data data;

    InsurancePaymentResModel({this.success, this.message, this.data});

    InsurancePaymentResModel.fromJson(Map<String, dynamic> json) {
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
    int policyDuration;
    int policyElementId;
    int policyId;
    String policyNo;
    int policyStatus;
    String policyType;
    String productCode;
    int productId;
    String productName;
    String proposalNo;
    String quotationNo;

    Data(
        {this.policyDuration,
          this.policyElementId,
          this.policyId,
          this.policyNo,
          this.policyStatus,
          this.policyType,
          this.productCode,
          this.productId,
          this.productName,
          this.proposalNo,
          this.quotationNo});

    Data.fromJson(Map<String, dynamic> json) {
      policyDuration = json['PolicyDuration'];
      policyElementId = json['PolicyElementId'];
      policyId = json['PolicyId'];
      policyNo = json['PolicyNo'];
      policyStatus = json['PolicyStatus'];
      policyType = json['PolicyType'];
      productCode = json['ProductCode'];
      productId = json['ProductId'];
      productName = json['ProductName'];
      proposalNo = json['ProposalNo'];
      quotationNo = json['QuotationNo'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['PolicyDuration'] = this.policyDuration;
      data['PolicyElementId'] = this.policyElementId;
      data['PolicyId'] = this.policyId;
      data['PolicyNo'] = this.policyNo;
      data['PolicyStatus'] = this.policyStatus;
      data['PolicyType'] = this.policyType;
      data['ProductCode'] = this.productCode;
      data['ProductId'] = this.productId;
      data['ProductName'] = this.productName;
      data['ProposalNo'] = this.proposalNo;
      data['QuotationNo'] = this.quotationNo;
      return data;
    }
  }