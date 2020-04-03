class Questionnaire {
  int priority;
  String questionnaire;
  String validAnswer;
  List<SubQuestionnaire> subQuestionnaire;

  Questionnaire(
      {this.priority,
        this.questionnaire,
        this.validAnswer,
        this.subQuestionnaire});

  Questionnaire.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    questionnaire = json['Questionnaire'];
    validAnswer = json['valid_answer'];
    if (json['SubQuestionnaire'] != null) {
      subQuestionnaire = new List<SubQuestionnaire>();
      json['SubQuestionnaire'].forEach((v) {
        subQuestionnaire.add(new SubQuestionnaire.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['Questionnaire'] = this.questionnaire;
    data['valid_answer'] = this.validAnswer;
    if (this.subQuestionnaire != null) {
      data['SubQuestionnaire'] =
          this.subQuestionnaire.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubQuestionnaire {
  int priority;
  String questionnaire;


  SubQuestionnaire({this.priority, this.questionnaire,});

  SubQuestionnaire.fromJson(Map<String, dynamic> json) {
    priority = json['priority'];
    questionnaire = json['Questionnaire'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['priority'] = this.priority;
    data['Questionnaire'] = this.questionnaire;
    return data;
  }
}
