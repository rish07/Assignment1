import 'package:sbig_app/src/models/common/failure_model.dart';

class PinCodeResModel {
  String status;
  List<PinCodeData> data;
  ApiErrorModel apiErrorModel;

  PinCodeResModel({this.status, this.data});

  PinCodeResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<PinCodeData>();
      json['data'].forEach((v) {
        data.add(new PinCodeData.fromJson(v));
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

class PinCodeData {
  String PIN_CD_ID;
  String LCLTY_SUBRB_TALUK_TEHSL_NM;
  String DISTRICT_CD;
  String DISTRICT_NM;
  String CITY_CD;
  String CITY_NM;
  String STATE_CD;
  String STATE_NM;
  String COUNTRY_CD;
  String STATE_CAPITAL;

  PinCodeData({this.PIN_CD_ID, this.LCLTY_SUBRB_TALUK_TEHSL_NM, this.DISTRICT_CD,
      this.DISTRICT_NM, this.CITY_CD, this.CITY_NM, this.STATE_CD,
      this.STATE_NM, this.COUNTRY_CD, this.STATE_CAPITAL});

  PinCodeData.fromJson(Map<String, dynamic> json) {
    PIN_CD_ID = json['PIN_CD_ID'];
    LCLTY_SUBRB_TALUK_TEHSL_NM = json['LCLTY_SUBRB_TALUK_TEHSL_NM'];
    DISTRICT_CD = json['DISTRICT_CD'];
    DISTRICT_NM = json['DISTRICT_NM'];
    CITY_CD = json['CITY_CD'];
    CITY_NM = json['CITY_NM'];
    STATE_CD = json['STATE_CD'];
    STATE_NM = json['STATE_NM'];
    COUNTRY_CD = json['COUNTRY_CD'];
    STATE_CAPITAL = json['STATE_CAPITAL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LCLTY_SUBRB_TALUK_TEHSL_NM'] = this.LCLTY_SUBRB_TALUK_TEHSL_NM;
    data['DISTRICT_CD'] = this.DISTRICT_CD;
    data['DISTRICT_NM'] = this.DISTRICT_NM;
    data['CITY_CD'] = this.CITY_CD;
    data['CITY_NM'] = this.CITY_NM;
    data['STATE_CD'] = this.STATE_CD;
    data['STATE_NM'] = this.STATE_NM;
    data['COUNTRY_CD'] = this.COUNTRY_CD;
    data['STATE_CAPITAL'] = this.STATE_CAPITAL;
    return data;
  }
}
