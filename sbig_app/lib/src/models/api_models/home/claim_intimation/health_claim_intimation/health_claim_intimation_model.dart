import 'package:sbig_app/src/models/common/failure_model.dart';

class HealthClaimIntimationRequestModel {
  String memberId;
  String patientName;
  String policyNo;
  String contactNo;
  String email;
  String hospitilisationDate;
  String dischargeDate;
  String hospitalName;
  String hospitalisationReason;
  String doctorName;
  String amount;
  String tPA;
  String otherDetails;
  String city;
  String roomType;
  String claimType;

  HealthClaimIntimationRequestModel(
      {this.memberId,
      this.patientName,
      this.policyNo,
      this.contactNo,
      this.email,
      this.hospitilisationDate,
      this.dischargeDate,
      this.hospitalName,
      this.hospitalisationReason,
      this.doctorName,
      this.amount,
      this.tPA,
      this.otherDetails,
      this.city,
      this.roomType,
      this.claimType});

  HealthClaimIntimationRequestModel.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    patientName = json['patient_name'];
    policyNo = json['policy_no'];
    contactNo = json['contact_no'];
    email = json['email'];
    hospitilisationDate = json['hospitilisation_date'];
    dischargeDate = json['discharge_date'];
    hospitalName = json['hospital_name'];
    hospitalisationReason = json['hospitalisation_reason'];
    doctorName = json['doctor_name'];
    amount = json['amount'];
    tPA = json['TPA'];
    otherDetails = json['other_details'];
    city = json['city'];
    roomType = json['room_type'];
    claimType = json['claim_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['patient_name'] = this.patientName;
    data['policy_no'] = this.policyNo;
    data['contact_no'] = this.contactNo;
    data['email'] = this.email;
    data['hospitilisation_date'] = this.hospitilisationDate;
    data['discharge_date'] = this.dischargeDate;
    data['hospital_name'] = this.hospitalName;
    data['hospitalisation_reason'] = this.hospitalisationReason;
    data['doctor_name'] = this.doctorName;
    data['amount'] = this.amount;
    data['TPA'] = this.tPA;
    data['other_details'] = this.otherDetails;
    data['city'] = this.city;
    data['room_type'] = this.roomType;
    data['claim_type'] = this.claimType;
    return data;
  }
}

class HealthClaimIntimationResponseModel {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  HealthClaimIntimationResponseModel({this.success, this.data});

  HealthClaimIntimationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String intimationNo;
  bool isSuccess;
  String errorMessage;

  Data({this.intimationNo, this.isSuccess, this.errorMessage});

  Data.fromJson(Map<String, dynamic> json) {
    intimationNo = json['intimationNo'];
    isSuccess = json['isSuccess'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intimationNo'] = this.intimationNo;
    data['isSuccess'] = this.isSuccess;
    data['errorMessage'] = this.errorMessage;
    return data;
  }
}
