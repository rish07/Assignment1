import 'package:sbig_app/src/models/api_models/common_buy_journey/data_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/member_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';


class ArogyaTopUpPremiumReqModel {
  int memberCount;
  List<Members> members;

  ArogyaTopUpPremiumReqModel({this.memberCount, this.members});

  ArogyaTopUpPremiumReqModel.fromJson(Map<String, dynamic> json) {
    memberCount = json['memberCount'];
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberCount'] = this.memberCount;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArogyaTopUpPremiumResModel {
  bool status;
  Data data;
  ApiErrorModel apiErrorModel;
  ArogyaTopUpPremiumResModel({this.status, this.data});

  ArogyaTopUpPremiumResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}




