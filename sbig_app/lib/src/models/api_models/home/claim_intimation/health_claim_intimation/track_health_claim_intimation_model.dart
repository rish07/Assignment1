import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class TrackHealthClaimIntimationRequestModel {
  String policyNo;

  TrackHealthClaimIntimationRequestModel({this.policyNo});

  TrackHealthClaimIntimationRequestModel.fromJson(Map<String, dynamic> json) {
    policyNo = json['policy_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['policy_no'] = this.policyNo;
    return data;
  }
}

class TrackHealthClaimIntimationResponseModel {
  bool success;
  List<Data> data;
  ApiErrorModel apiErrorModel;


  TrackHealthClaimIntimationResponseModel({this.success, this.data});

  TrackHealthClaimIntimationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String claimStatus;
  String policyNumber;
  String tpaClaimNumber;
  String sbigClaimNumbere;
  String claimType;
  String amountClaimed;
  String patientName;
  String hospitalName;
  String addmissionDate;
  String paymentRefNo;
  String paymentDate;
  String approvedAmount;

  Data(
      {this.claimStatus,
        this.policyNumber,
        this.tpaClaimNumber,
        this.sbigClaimNumbere,
        this.claimType,
        this.amountClaimed,
        this.patientName,
        this.hospitalName,
        this.addmissionDate,
        this.paymentRefNo,
        this.paymentDate,
        this.approvedAmount});

  Data.fromJson(Map<String, dynamic> json) {
    claimStatus = json['claim_status'];
    policyNumber = json['policy_number'];
    tpaClaimNumber = json['tpa_claim_number'];
    sbigClaimNumbere = json['sbig_claim_numbere'];
    claimType = json['claim_type'];
    amountClaimed = json['amount_claimed'];
    patientName = json['patient_name'];
    hospitalName = json['hospital_name'];
    addmissionDate = json['addmission_date'];
    paymentRefNo = json['payment_ref_no'];
    paymentDate = json['payment_date'];
    approvedAmount = json['approved_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claim_status'] = this.claimStatus;
    data['policy_number'] = this.policyNumber;
    data['tpa_claim_number'] = this.tpaClaimNumber;
    data['sbig_claim_numbere'] = this.sbigClaimNumbere;
    data['claim_type'] = this.claimType;
    data['amount_claimed'] = this.amountClaimed;
    data['patient_name'] = this.patientName;
    data['hospital_name'] = this.hospitalName;
    data['addmission_date'] = this.addmissionDate;
    data['payment_ref_no'] = this.paymentRefNo;
    data['payment_date'] = this.paymentDate;
    data['approved_amount'] = this.approvedAmount;
    return data;
  }
}