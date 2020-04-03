import 'package:sbig_app/src/models/common/failure_model.dart';

class AgentReceiptModel {
  bool success;
  ReceiptData data;
  ApiErrorModel apiErrorModel;

  AgentReceiptModel({this.success, this.data});

  AgentReceiptModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? ReceiptData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ReceiptData {
  AgentReceiptDetailsResponseBody agentReceiptDetailsResponseBody;

  ReceiptData({this.agentReceiptDetailsResponseBody});

  ReceiptData.fromJson(Map<String, dynamic> json) {
    agentReceiptDetailsResponseBody =
    json['agentReceiptDetailsResponseBody'] != null
        ? new AgentReceiptDetailsResponseBody.fromJson(
        json['agentReceiptDetailsResponseBody'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.agentReceiptDetailsResponseBody != null) {
      data['agentReceiptDetailsResponseBody'] =
          this.agentReceiptDetailsResponseBody.toJson();
    }
    return data;
  }
}

class AgentReceiptDetailsResponseBody {
  ReceiptPayload payload;

  AgentReceiptDetailsResponseBody({this.payload});

  AgentReceiptDetailsResponseBody.fromJson(Map<String, dynamic> json) {
    payload =
    json['payload'] != null ? ReceiptPayload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }
}

class ReceiptPayload {
  String receiptNo;
  String status;

  ReceiptPayload({this.receiptNo, this.status});

  ReceiptPayload.fromJson(Map<String, dynamic> json) {
    receiptNo = json['ReceiptNo'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ReceiptNo'] = this.receiptNo;
    data['Status'] = this.status;
    return data;
  }
}