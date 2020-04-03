class PartnerUiSignInResponse {
  bool success;
  String message;
  String token;
  Data data;

  PartnerUiSignInResponse({this.success, this.message, this.token, this.data});

  PartnerUiSignInResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  int id;
  String email;

  Data({this.id, this.email});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
  }
}


class PartnerUiSignInRequest {
  String email;
  String googleAuthKey;
  String firstName;
  String lastName;
  String phone;

  PartnerUiSignInRequest(
      {this.email,
        this.googleAuthKey,
        this.firstName,
        this.lastName,
        this.phone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['google_auth_key'] = this.googleAuthKey;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    return data;
  }
}
