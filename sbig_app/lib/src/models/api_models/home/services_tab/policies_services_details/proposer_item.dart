class ProposerListItem {
  int age;
  String birthday;
  String maritalStatus;
  String address;
  String gender;
  String mobile;
  String email;
  String propserName;
  String expiryDate;
  String effectiveDate;
  String registerNumber;
  String model;
  String company_name;
  String Variant_In;

  ProposerListItem(
      {this.age,
        this.birthday,
        this.maritalStatus,
        this.address,
        this.gender,
        this.mobile,
        this.email,
        this.propserName,
        this.expiryDate,
        this.effectiveDate, this.registerNumber, this.model, this.company_name, this.Variant_In});

  ProposerListItem.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    birthday = json['birthday'];
    maritalStatus = json['maritalStatus'];
    address = json['address'];
    gender = json['gender'];
    mobile = json['mobile'];
    email = json['email'];
    propserName = json['propserName'];
    expiryDate = json['expiry_date'];
    effectiveDate = json['effective_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['birthday'] = this.birthday;
    data['maritalStatus'] = this.maritalStatus;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['propserName'] = this.propserName;
    data['expiry_date'] = this.expiryDate;
    data['effective_date'] = this.effectiveDate;
    return data;
  }
}