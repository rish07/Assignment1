import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/insured_item.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/proposer_item.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class MemberDetailsReqModel{

  String policy_no;
  String product_code;

  MemberDetailsReqModel({this.policy_no, this.product_code});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_no'] = this.policy_no;
    data['product_code'] = this.product_code;
    return data;
  }
}

class MemberDetailsResModel{
  bool status;
  ApiErrorModel apiErrorModel;
  PolicyMemberDetails memberDetails;

  MemberDetailsResModel({this.status, this.apiErrorModel, this.memberDetails});

  MemberDetailsResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if(json['memberDetails'] != null) {
      memberDetails = PolicyMemberDetails.fromJson(json['memberDetails']);
    }
    if(json['member_details'] != null) {
      memberDetails = PolicyMemberDetails.fromJson(json['member_details']);
    }
  }
}


class PolicyMemberDetails{

  ProposerListItem proposer_details;
  List<InsuredListItem> insured_members_list;

  PolicyMemberDetails({this.proposer_details, this.insured_members_list});

  PolicyMemberDetails.fromJson(Map<String, dynamic> json) {
    if(json['proposer_details'] != null) {
      proposer_details = ProposerListItem.fromJson(json['proposer_details']);
    }
    if (json['insured_members_list'] != null) {
      insured_members_list = List<InsuredListItem>();
      json['insured_members_list'].forEach((v) { insured_members_list.add(InsuredListItem.fromJson(v)); });
    }
  }
}