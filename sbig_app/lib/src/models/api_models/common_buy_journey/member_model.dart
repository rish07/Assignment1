/*class Members {
  int age;
  int sumInsured;

  Members({this.age, this.sumInsured});

  Members.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    sumInsured = json['sumInsured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['sumInsured'] = this.sumInsured;
    return data;
  }
}*/
class Members {
  int age;
  int sumInsured;
  dynamic deduction;

  Members({this.age, this.sumInsured, this.deduction});

  Members.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    sumInsured = json['sumInsured'];
    deduction = json['deduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['sumInsured'] = this.sumInsured;
    data['deduction'] = this.deduction;
    return data;
  }
}