import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/member_details.dart';

class PolicyListItem {
  String policyNo;
  String policyType;
  String flag;
  String customerName;
  String annualGrossPremium;
  String renewalDueDate;
  String renewalQuoteNumber;
  String renewalPremiumAmount;
  String sumInsured;
  String productName;
  String previousPolicyNo;
  String productCode;
  String sub_product_code;
  PolicyMemberDetails memberDetails;
  int apiHit = 0;

  PolicyListItem(
      {this.policyNo, this.policyType, this.flag, this.customerName, this.annualGrossPremium, this.renewalDueDate, this.renewalQuoteNumber, this.renewalPremiumAmount, this.sumInsured, this.productName, this.previousPolicyNo, this.productCode, this.memberDetails});

  PolicyListItem.fromJson(Map<String, dynamic> json) {
    policyNo = json['policy_no'];
    policyType = json['policy_type'];
    flag = json['flag'];
    customerName = json['customerName'];
    annualGrossPremium = json['annualGrossPremium'];
    renewalDueDate = json['renewalDueDate'];
    renewalQuoteNumber = json['renewalQuoteNumber'];
    renewalPremiumAmount = json['renewalPremiumAmount'];
    sumInsured = json['sumInsured'];
    productName = json['productName'];
    previousPolicyNo = json['previousPolicyNo'];
    productCode = json['product_code'];
    sub_product_code = json['sub_product_code'];
    if(null != json['memberDetails']) {
      memberDetails = PolicyMemberDetails.fromJson(json['memberDetails']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_no'] = this.policyNo;
    data['policy_type'] = this.policyType;
    data['flag'] = this.flag;
    data['customerName'] = this.customerName;
    data['annualGrossPremium'] = this.annualGrossPremium;
    data['renewalDueDate'] = this.renewalDueDate;
    data['renewalQuoteNumber'] = this.renewalQuoteNumber;
    data['renewalPremiumAmount'] = this.renewalPremiumAmount;
    data['sumInsured'] = this.sumInsured;
    data['productName'] = this.productName;
    data['previousPolicyNo'] = this.previousPolicyNo;
    data['product_code'] = this.productCode;
    data['sub_product_code'] = this.sub_product_code;
    data['memberDetails'] = this.memberDetails;
    return data;
  }
}