class NetworkHospitalListModel {
  bool success;
  String message;
  int totalHospital;
  List<ResponseData> responseData;
  Data data;

  NetworkHospitalListModel(
      {this.success,
        this.message,
        this.totalHospital,
        this.responseData,
        this.data});

  NetworkHospitalListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalHospital = json['total_hospital'];
    if (json['response_data'] != null) {
      responseData = new List<ResponseData>();
      json['response_data'].forEach((v) {
        responseData.add(new ResponseData.fromJson(v));
      });
    }
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class ResponseData {
  int id;
  int hospID;
  String location;
  String hospitalName;
  String isHospital;
  String registrationNumber;
  String registrationAuthority;
  String hospitalCategory;
  String tPACategory;
  String tPAHospitalCode;
  String sBIGeneralHospitalCode;
  String hospitalAddress1;
  String hospitalAddress2;
  String hospitalArea;
  String hospitalCity;
  String hospitalState;
  String hospitalCountry;
  String hospitalPincode;
  String emailAddress1;
  String emailAddress2;
  String hospitalWebsite;
  String contactPerson;
  String fax;
  String phone;
  String mobile;
  String longitude;
  String latitude;
  String mobileNo1;
  String mobileNo2;
  String createdAt;
  String createdBy;

  ResponseData(
      {this.id,
        this.hospID,
        this.location,
        this.hospitalName,
        this.isHospital,
        this.registrationNumber,
        this.registrationAuthority,
        this.hospitalCategory,
        this.tPACategory,
        this.tPAHospitalCode,
        this.sBIGeneralHospitalCode,
        this.hospitalAddress1,
        this.hospitalAddress2,
        this.hospitalArea,
        this.hospitalCity,
        this.hospitalState,
        this.hospitalCountry,
        this.hospitalPincode,
        this.emailAddress1,
        this.emailAddress2,
        this.hospitalWebsite,
        this.contactPerson,
        this.fax,
        this.phone,
        this.mobile,
        this.longitude,
        this.latitude,
        this.mobileNo1,
        this.mobileNo2,
        this.createdAt,
        this.createdBy});

  ResponseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hospID = json['HospID'];
    location = json['Location'];
    hospitalName = json['Hospital_Name'];
    isHospital = json['Is_Hospital'];
    registrationNumber = json['Registration_Number'];
    registrationAuthority = json['Registration_Authority'];
    hospitalCategory = json['Hospital_Category'];
    tPACategory = json['TPA_Category'];
    tPAHospitalCode = json['TPA_Hospital_Code'];
    sBIGeneralHospitalCode = json['SBI_General_Hospital_Code'];
    hospitalAddress1 = json['Hospital_Address_1'];
    hospitalAddress2 = json['Hospital_Address_2'];
    hospitalArea = json['Hospital_Area'];
    hospitalCity = json['Hospital_City'];
    hospitalState = json['Hospital_State'];
    hospitalCountry = json['Hospital_Country'];
    hospitalPincode = json['Hospital_Pincode'];
    emailAddress1 = json['Email_Address1'];
    emailAddress2 = json['Email_Address2'];
    hospitalWebsite = json['Hospital_Website'];
    contactPerson = json['Contact_Person'];
    fax = json['Fax'];
    phone = json['Phone'];
    mobile = json['Mobile'];
    longitude = json['Longitude'];
    latitude = json['Latitude'];
    mobileNo1 = json['MobileNo1'];
    mobileNo2 = json['MobileNo2'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['HospID'] = this.hospID;
    data['Location'] = this.location;
    data['Hospital_Name'] = this.hospitalName;
    data['Is_Hospital'] = this.isHospital;
    data['Registration_Number'] = this.registrationNumber;
    data['Registration_Authority'] = this.registrationAuthority;
    data['Hospital_Category'] = this.hospitalCategory;
    data['TPA_Category'] = this.tPACategory;
    data['TPA_Hospital_Code'] = this.tPAHospitalCode;
    data['SBI_General_Hospital_Code'] = this.sBIGeneralHospitalCode;
    data['Hospital_Address_1'] = this.hospitalAddress1;
    data['Hospital_Address_2'] = this.hospitalAddress2;
    data['Hospital_Area'] = this.hospitalArea;
    data['Hospital_City'] = this.hospitalCity;
    data['Hospital_State'] = this.hospitalState;
    data['Hospital_Country'] = this.hospitalCountry;
    data['Hospital_Pincode'] = this.hospitalPincode;
    data['Email_Address1'] = this.emailAddress1;
    data['Email_Address2'] = this.emailAddress2;
    data['Hospital_Website'] = this.hospitalWebsite;
    data['Contact_Person'] = this.contactPerson;
    data['Fax'] = this.fax;
    data['Phone'] = this.phone;
    data['Mobile'] = this.mobile;
    data['Longitude'] = this.longitude;
    data['Latitude'] = this.latitude;
    data['MobileNo1'] = this.mobileNo1;
    data['MobileNo2'] = this.mobileNo2;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    return data;
  }
}

class Data {
  int totalCount;
  String nextPage;
  String previousPage;

  Data({this.totalCount, this.nextPage, this.previousPage});

  Data.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_count'] = this.totalCount;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    return data;
  }
}

