class LeadCreationReqeust{
  String phone;
  String email;
  String campaignID;
  String  additionalRemarks;

  LeadCreationReqeust({this.phone, this.email, this.campaignID, this.additionalRemarks});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['campaignID'] = this.campaignID;
    if(additionalRemarks!=null) data['additionalRemarks'] = this.additionalRemarks;
    return data;
  }
}

class LeadCreationResponse {
  String msg;
  String status;

  LeadCreationResponse({this.msg, this.status});

  factory LeadCreationResponse.fromJson(Map<String, dynamic> json) {
    return LeadCreationResponse(
      msg: json['msg'],
      status: json['status'],
    );
  }
}
