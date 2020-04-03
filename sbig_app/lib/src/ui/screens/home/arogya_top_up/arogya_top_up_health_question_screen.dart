import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/premium_details/premium_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/premium_details/arogya_premier_premium_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_top_up/premium_details/arogya_top_up_premium_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_period.dart';

import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';

import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/arogya_policy_risk.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_quick_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/health_question_model.dart';

import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';

import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_top_up/arogya_topup_premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ArogyaTopUpHealthQuestion extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_top_up/health_questions_screen";

  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpHealthQuestion(this.arogyaTopUpModel);

  @override
  _HealthQuestionsScreenState createState() => _HealthQuestionsScreenState();
}

class _HealthQuestionsScreenState extends State<ArogyaTopUpHealthQuestion>
    with CommonWidget {
  List<PedQuestionsModel> pedQuestionsList;
  TextEditingController textEditingController;
  String selectReasonTitle = "", selectedReason = null;
  String erroString = '';
  bool isAlertVisible = false;

  String buttonText = "";

  @override
  void initState() {
    textEditingController = TextEditingController();
    HealthQuestionResModel pedQuestionItem = widget.arogyaTopUpModel.healthQuestionResModel;
    createHealthModel(pedQuestionItem);
    /* pedQuestionsList = [
      PedQuestionsModel(
          question: StringDescription.ped_question1,
          isYes: null,
          yesIcon: AssetConstants.ic_medicine,
          yesActiveIcon: AssetConstants.ic_medicine_selected,
          noIcon: AssetConstants.ic_medicine_white,
          noActiveIcon: AssetConstants.ic_medicine_white_selected),
      PedQuestionsModel(
          question: StringDescription.ped_question2,
          isYes: null,
          yesIcon: AssetConstants.ic_smoke,
          yesActiveIcon: AssetConstants.ic_smoke_selected,
          noIcon: AssetConstants.ic_smoke_white,
          noActiveIcon: AssetConstants.ic_smoke_white_selected),
      PedQuestionsModel(
          question: StringDescription.ped_question3,
          isYes: null,
          yesIcon: AssetConstants.ic_tobacco,
          yesActiveIcon: AssetConstants.ic_tobacco_selected,
          noIcon: AssetConstants.ic_tobacco_white,
          noActiveIcon: AssetConstants.ic_tobacco_white_selected),
      PedQuestionsModel(
          question: StringDescription.ped_question4,
          isYes: null,
          yesIcon: AssetConstants.ic_alcohol,
          yesActiveIcon: AssetConstants.ic_alcohol_selected,
          noIcon: AssetConstants.ic_alcohol_white,
          noActiveIcon: AssetConstants.ic_alcohol_white_selected),
    ];*/
    super.initState();
  }

  @override
  void didChangeDependencies() {
    List<PolicyCoverMemberModel> _policyMembers = widget.arogyaTopUpModel.policyMembers;
    for (int i = 0; i < pedQuestionsList.length; i++) {
      pedQuestionsList[i].arogyaMembers = _policyMembers;
      pedQuestionsList[i].selectedMembers = Set();
    }

    pedQuestionsList[0].selectedMembers.add(0);

    selectReasonTitle = S.of(context).select_reason;
    buttonText = S.of(context).next.toUpperCase();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(
            context, S.of(context).health_questionnaire.toUpperCase()),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: pedQuestionsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return buildListItem(
                                pedQuestionsList[index], index);
                          }),
                      SizedBox(
                        height: 150,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 25.0 + 8.0 - 20.0, left: 12.0, right: 12.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AlertWidget(erroString, isAlertVisible ? 168 : 0),
                ),
              ),
              _getQuoteButton(context),
            ],
          ),
        ));
  }

  Widget buildListItem(PedQuestionsModel pedQuestionItem, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${index + 1}. ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              Expanded(
                child: Text(
                  pedQuestionItem.question,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (isAlertVisible) isAlertVisible = false;
                  pedQuestionsList[index].isYes = true;
                  if (index == 0) {
                    buttonText = S.of(context).next.toUpperCase();
                  }
                });
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  borderRadius(radius: 0.0, topLeft: 0.0, topRight: 10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    borderRadius(radius: 0.0, topLeft: 0.0, topRight: 10.0),
                    gradient:
                    (pedQuestionItem.isYes != null && pedQuestionItem.isYes)
                        ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_type_gradient_color1,
                          ColorConstants.policy_type_gradient_color2
                        ])
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 20.0, right: 20.0, bottom: 8.0),
                    child: Center(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                              height: 30,
                              child:(pedQuestionItem.isYes != null && pedQuestionItem.isYes)
                                  ? (pedQuestionItem.yesActiveIcon == null || pedQuestionItem.yesActiveIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_selected) : Image(image: NetworkImage(UrlConstants.ICON +pedQuestionItem.yesActiveIcon),)
                                  : (pedQuestionItem.yesIcon == null || pedQuestionItem.yesIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine) : Image(image: NetworkImage(UrlConstants.ICON +pedQuestionItem.yesIcon),),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "YES",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: (pedQuestionItem.isYes != null &&
                                      pedQuestionItem.isYes)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (isAlertVisible) isAlertVisible = false;
                  pedQuestionsList[index].selectedMembers.clear();
                  pedQuestionsList[index].isYes = false;
                  if (index == 0) {
                    buttonText =
                        S.of(context).recalculated_premium_title.toUpperCase();
                  }
                });
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  borderRadius(radius: 0.0, topLeft: 0.0, topRight: 10.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    borderRadius(radius: 0.0, topLeft: 0.0, topRight: 10.0),
                    gradient: (pedQuestionItem.isYes != null &&
                        !pedQuestionItem.isYes)
                        ? LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          ColorConstants.policy_type_gradient_color1,
                          ColorConstants.policy_type_gradient_color2
                        ])
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 25.0, right: 25.0, bottom: 8.0),
                    child: Center(
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                              height: 30,
                              child:   (pedQuestionItem.isYes != null && !pedQuestionItem.isYes)
                                  ? (pedQuestionItem.noActiveIcon == null || pedQuestionItem.noActiveIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_white_selected) : Image(image: NetworkImage(UrlConstants.ICON +pedQuestionItem.noActiveIcon),)
                                  : (pedQuestionItem.noIcon == null || pedQuestionItem.noIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_white) : Image(image: NetworkImage(UrlConstants.ICON +pedQuestionItem.noIcon),),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "NO",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: (pedQuestionItem.isYes != null &&
                                      !pedQuestionItem.isYes)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: (pedQuestionsList[index].isYes != null &&
              pedQuestionsList[index].isYes) &&
              index == 0,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.grey[800],
                  accentColor: Colors.grey[800],
                  hintColor: Colors.grey[800]),
              child: TextField(
                controller: textEditingController,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9-,.():/ ]")),
                  LengthLimitingTextInputFormatter(50),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[800])),
                  labelText: S.of(context).specify_reason,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
//                onSubmitted: (value){
//                  textEditingController.text = value;
//                },
              ),
            ),
            //child: getReasonWidget(),
          ),
        ),
        Visibility(
          visible: (pedQuestionsList[index].isYes != null &&
              pedQuestionsList[index].isYes &&
              index != 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  S.of(context).specify_person.toUpperCase(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 20.0),
                child: Container(
                  height: 80,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: pedQuestionsList[index].arogyaMembers.length,
                      itemBuilder: (BuildContext context, int subIndex) {
                        return buildMemberListItem(
                            pedQuestionsList[index].arogyaMembers[subIndex],
                            subIndex,
                            index);
                      }),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  getReasonWidget() {
    onSelection(String value, int position) {
      if (value != null) {
        selectedReason = value;
        setState(() {
          isAlertVisible = false;
        });
      }
    }

    return DropDownWidget(selectReasonTitle, StringDescription.reasonsList,
        onSelection, selectedReason);
  }

  onClick() {
    try {

      for(var i=0;i<pedQuestionsList.length;i++){
        if(pedQuestionsList[i].isYes == null){
          erroString = S.of(context).answer_all_questions_error;
          setState(() {
            isAlertVisible = true;
          });
          return;
        }

        if(pedQuestionsList.length >= 1){
          if (null != pedQuestionsList[0].isYes && pedQuestionsList[0].isYes) {
            if (textEditingController.text == null ||
                textEditingController.text.isEmpty) {
              erroString = S.of(context).specify_reason_error;
              setState(() {
                isAlertVisible = true;
              });
              return;
            }
          }
        }
      }


      for (int i = 1; i < pedQuestionsList.length; i++) {
        print("pedQuestionsList[i].isYes " + pedQuestionsList[i].isYes.toString());
        if (pedQuestionsList[i].isYes) {
          print("pedQuestionsList[i].selectedMembers.length " + pedQuestionsList[i].selectedMembers.length.toString());
          if (pedQuestionsList[i].selectedMembers.length == 0) {
            erroString = S.of(context).choose_member_error + "Question No:${i + 1}";
            setState(() {
              isAlertVisible = true;
            });
            return;
          }
        }
      }
      setState(() {
        isAlertVisible = false;
      });

      PersonalDetails personalDetails = widget.arogyaTopUpModel.personalDetails;
      List<PolicyCoverMemberModel> policyMembers = widget.arogyaTopUpModel.policyMembers;
      ArogyaTimePeriodModel timePeriodModel = widget.arogyaTopUpModel.selectedTimePeriodModel;
      ArogyaSumInsuredModel sumInsuredModel = widget.arogyaTopUpModel.selectedSumInsured;
      PolicyPeriod policyPeriod = widget.arogyaTopUpModel.policyPeriod;
      DateTime startDate = policyPeriod.startDate;
      DateTime endDate = policyPeriod.endDate;
      int policyType = widget.arogyaTopUpModel.policyType.id;

      List<PolicyRiskList> list =[];

      ArogyaTopUpQuickQuoteReqModel arogyaTopUpQuickQuoteReqModel =ArogyaTopUpQuickQuoteReqModel();
      arogyaTopUpQuickQuoteReqModel.arogyaPolicyType=StringConstants.AROGYA_TOP_UP;
      arogyaTopUpQuickQuoteReqModel.mobile=personalDetails.mobile;
      arogyaTopUpQuickQuoteReqModel.email=personalDetails.email;
      arogyaTopUpQuickQuoteReqModel.duration=timePeriodModel.year.toString();
      if(widget.arogyaTopUpModel.policyType.id ==PolicyTypeScreen.INDIVIDUAL){
        arogyaTopUpQuickQuoteReqModel.policyType="individual";
      }else if(widget.arogyaTopUpModel.policyType.id ==PolicyTypeScreen.FAMILY_FLOATER){
        arogyaTopUpQuickQuoteReqModel.policyType="family_floater";
      }else if(widget.arogyaTopUpModel.policyType.id==PolicyTypeScreen.FAMILY_INDIVIDUAL){
        arogyaTopUpQuickQuoteReqModel.policyType="family_individual";
      }
      arogyaTopUpQuickQuoteReqModel.effectiveDate= CommonUtil.instance.convertTo_yyyy_MM_dd(startDate);
      arogyaTopUpQuickQuoteReqModel.expiryDate= CommonUtil.instance.convertTo_yyyy_MM_dd(endDate);


      for (PolicyCoverMemberModel item in policyMembers) {

        PolicyRiskList policyRiskList = PolicyRiskList();
        PolicyCoverageList otherDetails = PolicyCoverageList();

        MemberDetailsModel member = item.memberDetailsModel;
        AgeGenderModel ageGenderModel = member.ageGenderModel;

        policyRiskList.dateOfBirth=ageGenderModel.dob_yyyy_mm_dd;
        policyRiskList.genderCode=ageGenderModel.gender;
        policyRiskList.nomineeDOB="";
        policyRiskList.nomineeRelToProposer="";
        policyRiskList.sumInsured=sumInsuredModel.amount.toString();
        //policyRiskList.deductible=sumInsuredModel.deduction.toString()??'';
        policyRiskList.deductible='100000';


        if (member.relation.startsWith("Child")) {
          policyRiskList.argInsuredRelToProposer = member.ageGenderModel.gender == "M" ? "Son" : "Daughter";
        } else if (member.relation.compareTo(S.of(context).father_in_law_title) == 0) {
          policyRiskList.argInsuredRelToProposer = "Father_In_Law";
        } else if (member.relation.compareTo(S.of(context).mother_in_law_title) == 0) {
          policyRiskList.argInsuredRelToProposer = "Mother_In_Law";
        } else {
          policyRiskList.argInsuredRelToProposer= member.relation;
        }

        int j = 0;
        for (PedQuestionsModel pedQuestionsModel in pedQuestionsList) {
          Set<int> selectedMembers = pedQuestionsModel.selectedMembers;
          List<PolicyCoverMemberModel> policyMembers = pedQuestionsModel.arogyaMembers;
          if (selectedMembers.isEmpty && (policyRiskList.argInsuredRelToProposer.compareTo("Self") == 0 || policyType == PolicyTypeScreen.INDIVIDUAL)) {
            if (pedQuestionsList[0].isYes) {
              policyRiskList.otherImpairment = "1";
              policyRiskList.otherImpairmentReason = textEditingController.text;
            }
          } else {
            for (int i in selectedMembers) {
              if (policyMembers[i].memberDetailsModel.relation.compareTo(member.relation) == 0) {
                switch (j) {
                  case 0:
                    policyRiskList.otherImpairment = "1";
                    policyRiskList.otherImpairmentReason = textEditingController.text;
                    break;
                  case 1:
                    policyRiskList.smokerStatus = "1";
                    break;
                  case 2:
                    policyRiskList.tobacoStatus = "1";
                    break;
                  case 3:
                    policyRiskList.alcoholStatus = "1";
                    break;
                }
              }
            }
          }
          j++;
        }
        List<PolicyCoverageList> policyCoverageList=[];
        policyCoverageList = [
          PolicyCoverageList(effectiveDate:  CommonUtil.instance.convertTo_yyyy_MM_dd(startDate),
              expiryDate:  CommonUtil.instance.convertTo_yyyy_MM_dd(endDate))
        ];
        policyRiskList.policyCoverageList=policyCoverageList;

        list.add(policyRiskList);
      }
      arogyaTopUpQuickQuoteReqModel.policyRiskList=list;
      doApiCall(arogyaTopUpQuickQuoteReqModel, pedQuestionsList[0].isYes,policyType);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _getQuoteButton(BuildContext context) {
    return BlackButtonWidget(
      onClick,
      buttonText,
      isNormal: false,
      bottomBgColor: ColorConstants.arogya_plus_bg_color,
    );
  }

  void doApiCall(ArogyaTopUpQuickQuoteReqModel recalculatePremium, bool isFirstQuestionyes, int policyType) async {

    Map<String, dynamic> body = recalculatePremium.toJson();
    showLoaderDialog(context);
    var response = await ArogyaTopUpPremiumApiProvider.getInstance().calculateQuickQuote(body,policyType);
    if (null == response.apiErrorModel) {
      hideLoaderDialog(context);
      if (isFirstQuestionyes) {
        showCustomerRepresentativeWidget(context);
      } else {
        ArogyaTimePeriodModel timePeriodModel = widget.arogyaTopUpModel.selectedTimePeriodModel;
        ArogyaTopUpQuickQuoteResModel resModel = response;
        timePeriodModel.totalPremium = resModel?.data?.premiumDetails?.totalPremium ?? '0';
        timePeriodModel.actualPremium = resModel?.data?.premiumDetails?.basePremium ?? '0';
        //timePeriodModel.opd = timePeriod.opd;
        timePeriodModel.taxAmount = resModel?.data?.premiumDetails?.tax ?? '0';
        //  timePeriodModel.tax = timePeriod.tax;
        /// timePeriodModel.discountedPremium = timePeriod.premium_withdiscount;
        // timePeriodModel.discountPercentage = timePeriod.discount_percentage;
        widget.arogyaTopUpModel.isPremiumFrom = PremiumBreakupScreen.FROM_HEALTH_QUESTIONNAIRE;
        widget.arogyaTopUpModel.selectedTimePeriodModel = timePeriodModel;

        //  widget.arogyaPremierModel.quoteNumber = response.sbiResponse.quoteResponse.response.payload.createQuoteResponse.quoteNumber;

        widget.arogyaTopUpModel.arogyaTopUpQuickQuoteReqModel = recalculatePremium;
        widget.arogyaTopUpModel.arogyaTopUpQuickQuoteResModel = resModel;

        if(Platform.isIOS){
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => WillPopScope(
                  onWillPop: () {
                    return Future<bool>.value(true);
                  },
                  child: ArogyaTopUpPremiumBreakupScreen(widget.arogyaTopUpModel)));
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context) => WillPopScope(
                  onWillPop: () {
                    return Future<bool>.value(true);
                  },
                  child: ArogyaTopUpPremiumBreakupScreen(widget.arogyaTopUpModel)));
        }
      }
    } else {
      hideLoaderDialog(context);
      handleApiError(context,0, (int retryIdentifier) {
        onClick();
      }, response.apiErrorModel.statusCode);

    }
  }

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if(Platform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick)));
    }
  }

  Widget buildMemberListItem(PolicyCoverMemberModel policyMember, int subIndex, int mainIndex) {
    bool isSelected =
    pedQuestionsList[mainIndex].selectedMembers.contains(subIndex);

    return InkWell(
      onTap: () {
        setState(() {
          if (isAlertVisible) isAlertVisible = false;
          if (pedQuestionsList[mainIndex].selectedMembers.contains(subIndex)) {
            pedQuestionsList[mainIndex].selectedMembers.remove(subIndex);
          } else {
            pedQuestionsList[mainIndex].selectedMembers.add(subIndex);
          }
        });
      },
      child: Card(
        elevation: 3.0,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              gradient: isSelected
                  ? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorConstants.policy_type_gradient_color1,
                    ColorConstants.policy_type_gradient_color2
                  ])
                  : null),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    width: 30,
                    height: 30,
                    child: isSelected
                        ?  (policyMember.activeIcon ==null || policyMember.activeIcon.length==0)?  Image.asset(AssetConstants.ic_self_white): Image(image: NetworkImage(UrlConstants.ICON +policyMember.activeIcon),)
                        : (policyMember.icon ==null || policyMember.icon.length==0)?Image.asset(AssetConstants.ic_self): Image(image: NetworkImage(  UrlConstants.ICON + policyMember.icon),)),
                SizedBox(height: 5),
                Text(
                  policyMember.title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void createHealthModel(HealthQuestionResModel healthQuestionResModel) {
    pedQuestionsList = [];
    String iconPath = UrlConstants.ICON;
    PedQuestionsModel pedQuestionItem;
    if (healthQuestionResModel != null) {
      var data = healthQuestionResModel.data.body;
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          var value = data[i];
          if (value.slugType.compareTo(StringDescription.SLUG_FAQ) == 0) {
            pedQuestionItem = PedQuestionsModel();
            pedQuestionItem.question = value.title;

            if (value.points != null) {
              for (var j = 0; j < value.points.length; j++) {
                var point = value.points[j];
                if (point.title == 'Yes') {
                  // pedQuestionItem.yesActiveIcon = (point.imagePath2 == null || point.imagePath2.length == 0) ? AssetConstants.ic_medicine_selected : iconPath + point.imagePath2;
                  // pedQuestionItem.yesIcon = (point.imagePath1 == null || point.imagePath1.length == 0) ? AssetConstants.ic_medicine : iconPath + point.imagePath1;
                  pedQuestionItem.yesIcon =point?.imagePath1 ?? null;
                  pedQuestionItem.yesActiveIcon = point?.imagePath2 ??null;

                } else {
                  //pedQuestionItem.noActiveIcon = (point.imagePath2 == null || point.imagePath2.length == 0) ? AssetConstants.ic_medicine_white : iconPath + point.imagePath2;
                  //pedQuestionItem.noIcon = (point.imagePath1 == null || point.imagePath1.length == 0) ? AssetConstants.ic_medicine_white_selected : iconPath + point.imagePat
                  pedQuestionItem.noIcon = point?.imagePath1 ?? null;
                  pedQuestionItem.noActiveIcon = point?.imagePath2??null;

                }
              }
            }
            pedQuestionsList.add(pedQuestionItem);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
