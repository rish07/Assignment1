import 'package:sbig_app/src/models/common/failure_model.dart';

class DownloadResponse {
  bool success;
  Data data;
  ApiErrorModel apiErrorModel;

  DownloadResponse({this.success, this.data, this.apiErrorModel});

  DownloadResponse.fromJson(Map<String, dynamic> json) {
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
  Payload payload;
  ErrorTag errorTag;

  Data({this.payload, this.errorTag});

  Data.fromJson(Map<String, dynamic> json) {
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    errorTag = json['errorTag'] != null
        ? new ErrorTag.fromJson(json['errorTag'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    if (this.errorTag != null) {
      data['errorTag'] = this.errorTag.toJson();
    }
    return data;
  }
}

class Payload {
  String pDFStream;

  Payload({this.pDFStream});

  Payload.fromJson(Map<String, dynamic> json) {
    pDFStream = json['PDFStream'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PDFStream'] = this.pDFStream;
    return data;
  }
}

class ErrorTag {
  List<String> exceptions;

  ErrorTag({this.exceptions});

  ErrorTag.fromJson(Map<String, dynamic> json) {
    exceptions = json['exceptions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exceptions'] = this.exceptions;
    return data;
  }
}
