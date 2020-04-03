
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';

class PedQuestionsModel{
  String question;
  String answer;
  bool isYes;
  String yesActiveIcon;
  String noActiveIcon;
  String yesIcon;
  String noIcon;
  List<GeneralListModel> policyMembers;
  List<PolicyCoverMemberModel> arogyaMembers;
  Set<int> selectedMembers;

  PedQuestionsModel({this.question, this.answer, this.isYes, this.yesActiveIcon,
      this.noActiveIcon, this.yesIcon, this.noIcon, this.policyMembers,this.arogyaMembers,
      this.selectedMembers});


}