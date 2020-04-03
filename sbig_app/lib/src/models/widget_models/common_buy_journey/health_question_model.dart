import 'package:sbig_app/src/models/common/failure_model.dart';

class HealthQuestionModel {
  // yes =1 , No = 0
  String question;
  String answer;
  bool isYes;
  bool isYesSubQuestion;
  bool isNoQuestion;
  String yesActiveIcon;
  String noActiveIcon;
  String yesIcon;
  String noIcon;
  String eligibleAnswer;
  int priority;
  List<SubQuestionModel> yesSubQuestions;
  List<SubQuestionModel> noSubQuestions;
  ApiErrorModel apiErrorModel;

  HealthQuestionModel(
      {this.question,
      this.answer,
      this.isYes,
      this.yesActiveIcon,
      this.noActiveIcon,
      this.yesIcon,
      this.noIcon,
      this.eligibleAnswer,
      this.yesSubQuestions,
      this.noSubQuestions,
      this.isNoQuestion=false,
      this.isYesSubQuestion=false});
}

class SubQuestionModel {
  String question;
  List<SubPointsModel> subPoints;
  bool isTextField;
  String hintText;
  String answer;
  int priority;

  SubQuestionModel(
      {this.question,
      this.subPoints,
      this.isTextField,
      this.hintText,
      this.answer});
}

class SubPointsModel {
  int priority;
  String point;
  bool isSelected;

  SubPointsModel({this.point, this.isSelected,this.priority});
}
