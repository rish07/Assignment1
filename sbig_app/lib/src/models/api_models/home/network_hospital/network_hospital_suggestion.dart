class NetworkHospitalSuggestionListModel {
  bool status;
  List<SuggestionData> data;

  NetworkHospitalSuggestionListModel({this.status, this.data});

  NetworkHospitalSuggestionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<SuggestionData>();
      json['data'].forEach((v) {
        data.add(new SuggestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SuggestionData {
  dynamic pincode;
  dynamic area;
  dynamic city;
  dynamic state;
  String autoCompleteSearch;

  SuggestionData({this.pincode="", this.area="", this.city="", this.state="",this.autoCompleteSearch=""});

  SuggestionData.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'] ?? '';
    area = json['area']??'';
    city = json['city'] ??'';
    state = json['state']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}


