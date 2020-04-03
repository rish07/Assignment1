import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/health_question/health_question_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/premium_details/critical_premium_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_illness_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/health_question_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/other_policies.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/question_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/quick_quote_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/health_question_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/other_critical_illness_details_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/widgets/common/circle_button.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/common/triangle_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import '../home_screen.dart';
import 'critical_illness_insurance_buyer_details.dart';

class CriticalHealthQuestionsScreen extends StatelessWidget {
  static const ROUTE_NAME = "/critical_illness/health_questions_screen";
  final CriticalIllnessModel criticalIllnessModel;

  CriticalHealthQuestionsScreen(this.criticalIllnessModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      bloc: HealthQuestionBloc(),
      child: CriticalHealthQuestionsScreenWidget(this.criticalIllnessModel),
    );
  }
}

class CriticalHealthQuestionsScreenWidget extends StatefulWidgetBase {
  final CriticalIllnessModel criticalIllnessModel;

  CriticalHealthQuestionsScreenWidget(this.criticalIllnessModel);

  @override
  _CriticalHealthQuestionsScreenState createState() =>
      _CriticalHealthQuestionsScreenState();
}

class _CriticalHealthQuestionsScreenState
    extends State<CriticalHealthQuestionsScreenWidget> with CommonWidget {
  List<HealthQuestionModel> healthQuestionsList;
  String selectReasonTitle = "";
  String erroString = '';
  bool isAlertVisible = false;
  String buttonText = "";
  HealthQuestionResModel healthQuestionResModel;
  CriticalIllnessModel criticalIllnessModel;
  ScrollController _controller;
  bool _isVisible = true;
  bool allowPolicyBuying = true;
  bool isValidBMI=true;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    criticalIllnessModel = widget.criticalIllnessModel;
    healthQuestionResModel = criticalIllnessModel.healthQuestionResModel;
    createHealthModel(healthQuestionResModel);

    super.initState();
  }

  _scrollListener() {
    if (_controller.offset > 30) {
      setState(() {
        _isVisible = false;
      });
    } else {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    selectReasonTitle = S.of(context).select_reason;
    buttonText = S.of(context).next.toUpperCase();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.arogya_plus_bg_color,
        appBar: getAppBar(
            context, S.of(context).health_questionnaire.toUpperCase()),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /// 1st List view - Main question with YES/NO widgets
                    Expanded(
                      child: CustomScrollView(
                        controller: _controller,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        slivers: <Widget>[
                          SliverList(
                            delegate:
                                SliverChildListDelegate(_buildChildList()),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  List<Container> _buildChildList() {
    List<Container> list = List();
    int i = 0;

    healthQuestionsList.forEach((b) {
      list.add(buildListItem(b, i));
      i++;
    });
    Container bottomPaddingContainer = Container(
      height: 200,
    );
    list.add(bottomPaddingContainer);
    return list;
  }

  Widget buildListItem(HealthQuestionModel healthQuestionModel, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///question no
                Text(
                  '${index + 1}. ',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),

                /// Question
                Expanded(
                  child: Text(
                    healthQuestionModel.question,
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

          /// YES or NO button widgets
          Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    /// YES ON CLICK
                    if (isAlertVisible) isAlertVisible = false;
                    healthQuestionsList[index].isYes = true;
                    if (healthQuestionsList[index].yesSubQuestions != null &&
                        healthQuestionsList[index].yesSubQuestions.length > 0) {
                      healthQuestionsList[index].isYesSubQuestion = true;
                      healthQuestionsList[index].isNoQuestion = false;
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
                      borderRadius: borderRadius(
                          radius: 0.0, topLeft: 0.0, topRight: 10.0),
                      gradient: (healthQuestionModel.isYes != null &&
                              healthQuestionModel.isYes)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.east_bay,
                                  ColorConstants.disco,
                                  ColorConstants.disco
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
                            child: (healthQuestionModel.isYes != null && healthQuestionModel.isYes)
                                ? (healthQuestionModel.yesActiveIcon == null || healthQuestionModel.yesActiveIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_selected) : Image(image: NetworkImage(UrlConstants.ICON +healthQuestionModel.yesActiveIcon),)
                                : (healthQuestionModel.yesIcon == null || healthQuestionModel.yesIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine) : Image(image: NetworkImage(UrlConstants.ICON +healthQuestionModel.yesIcon),),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            S.of(context).yes.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: (healthQuestionModel.isYes != null &&
                                        healthQuestionModel.isYes)
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
                    /// NO ON CLICK
                    if (isAlertVisible) isAlertVisible = false;
                    healthQuestionsList[index].isYes = false;
                    if (healthQuestionsList[index].noSubQuestions != null &&
                        healthQuestionsList[index].noSubQuestions.length > 0) {
                      healthQuestionsList[index].isYesSubQuestion = false;
                      healthQuestionsList[index].isNoQuestion = true;
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
                      borderRadius: borderRadius(
                          radius: 0.0, topLeft: 0.0, topRight: 10.0),
                      gradient: (healthQuestionModel.isYes != null &&
                              !healthQuestionModel.isYes)
                          ? LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                  ColorConstants.east_bay,
                                  ColorConstants.disco,
                                  ColorConstants.disco
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
                              child:
                              (healthQuestionModel.isYes != null && !healthQuestionModel.isYes)
                                  ? (healthQuestionModel.noActiveIcon == null || healthQuestionModel.noActiveIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_white_selected) : Image(image: NetworkImage(UrlConstants.ICON +healthQuestionModel.noActiveIcon),)
                                  : (healthQuestionModel.noIcon == null || healthQuestionModel.noIcon.length == 0) ? Image.asset(AssetConstants.ic_medicine_white_selected) : Image(image: NetworkImage(UrlConstants.ICON +healthQuestionModel.noIcon),),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            S.of(context).no.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: (healthQuestionModel.isYes != null &&
                                        !healthQuestionModel.isYes)
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
          if (healthQuestionModel.isYesSubQuestion &&
              (healthQuestionModel.isYes != null && healthQuestionModel.isYes))
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 10.0),
                    child: Container(
                        color: Colors.white,
                        child: subPointWidget(
                            healthQuestionsList[index].yesSubQuestions)),
                  ),
                  Align(
                    child: Triangle(
                      color: Colors.white,
                    ),
                    alignment: Alignment(-0.6, -1),
                  ),
                ],
              ),
            ),
          if (healthQuestionModel.isNoQuestion && (healthQuestionModel == null))
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 10.0),
                    child: Container(
                        color: Colors.white,
                        child: subPointWidget(
                            healthQuestionsList[index].noSubQuestions)),
                  ),
                  Align(
                    child: Triangle(
                      color: Colors.white,
                    ),
                    alignment: Alignment(0.2, -1),
                  ),
                ],
              ),
            ),
          if (healthQuestionModel.isNoQuestion && (!healthQuestionModel.isYes))
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 10.0),
                    child: Container(
                        color: Colors.white,
                        child: subPointWidget(
                            healthQuestionsList[index].noSubQuestions)),
                  ),
                  Align(
                    child: Triangle(
                      color: Colors.white,
                    ),
                    alignment: Alignment(0.2, -1),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget subPointWidget(List<SubQuestionModel> subQuestions) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        //  physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: subQuestions.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: buildSubQuestions(subQuestions[index]),
          );
        });
  }

  Widget buildSubQuestions(SubQuestionModel subQuestion) {
    List<SubPointsModel> subPoints = subQuestion.subPoints;

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20.0,
          ),
          if (subQuestion.question != null && subQuestion.question.length > 0)
            Text(
              subQuestion.question,
              style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.normal),
            ),
          SizedBox(
            width: 20.0,
          ),
          if (subQuestion.isTextField)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextField(
                //controller: ,
                onChanged: (String value) {
                  subQuestion.answer = value;
                },
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp('[0-9]')),
                 // LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: 10.0),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.shiraz),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[500]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstants.fuchsia_pink),
                  ),
                  labelText: subQuestion.hintText ?? 'Enter the Value',
                  labelStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 1.0),
                ),
              ),
            ),
          if (subPoints != null && subPoints.length > 0)
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: subPoints.length,
                itemBuilder: (BuildContext context, int pointIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: buildPoints(subPoints[pointIndex]),
                  );
                }),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget buildPoints(SubPointsModel subPoint) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 10.0,
            ),
            CircleButton(
              onTap: () {
                setState(() {
                  if (subPoint.isSelected != null && !subPoint.isSelected) {
                    subPoint.isSelected = true;
                  } else {
                    subPoint.isSelected = false;
                  }
                });
              },
              image: AssetConstants.ic_tick,
              isGardientApplicable: subPoint.isSelected ?? false,
              color1: ColorConstants.east_bay,
              color2: ColorConstants.disco,
              color3: ColorConstants.disco,
              iconColor: Colors.white,
              circleSize: 30.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Text(
                subPoint.point,
                overflow: TextOverflow.ellipsis,
                maxLines: 20,
                style:
                    TextStyle(color: Colors.black, fontStyle: FontStyle.normal),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  _getQuoteButton(BuildContext context) {
    return BlackButtonWidget(
      onClick,
      buttonText,
      isNormal: false,
      bottomBgColor: ColorConstants.arogya_plus_bg_color,
    );
  }

  void doApiCall(QuickQuoteReqModel quickQuoteReqModel) async {
    Map<String, dynamic> body = quickQuoteReqModel.toJson();
    showLoaderDialog(context);
    var response = await CriticalPremiumApiProvider.getInstance()
        .calculateQuickQuote(body);
    if (null == response.apiErrorModel) {
      hideLoaderDialog(context);
      _navigate();
    } else {
      print('response.apiErrorModel?.errorCode ${response.apiErrorModel?.errorCode}');
      hideLoaderDialog(context);
      if(response.apiErrorModel?.errorCode !=null ){
        if(response.apiErrorModel.errorCode == StringConstants.ERROR_CODE_QUESTION){
          _navigate();
        }else{
          handleApiError(context, 0, (int retryIdentifier) {
            onClick();
          }, response.apiErrorModel.statusCode);
        }
      }else{
        handleApiError(context, 0, (int retryIdentifier) {
          onClick();
        }, response.apiErrorModel.statusCode);
      }

    }
  }

  onClick() {
    try {
      double bmi=0;
      allowPolicyBuying = true; // initially make the policy buying true. Based on the answer make it false.
      isValidBMI=true;//Initially make the BMI valid true.Based on the BMI value make it false.
      QuickQuoteReqModel quickQuoteReqModel = QuickQuoteReqModel();

      for (int i = 0; i < healthQuestionsList.length; i++) {
        print("healthQuestionsList[i].isYes " +
            healthQuestionsList[i].isYes.toString());
        if (healthQuestionsList[i].isYes == null) {
          erroString = erroString = S.of(context).answer_all_questions_error;
          setState(() {
            isAlertVisible = true;
          });
          return;
        }
      }
      setState(() {
        isAlertVisible = false;
      });

      for (int i = 0; i < healthQuestionsList.length; i++) {
        var answer = (healthQuestionsList[i].isYes != null &&
                healthQuestionsList[i].isYes)
            ? 'yes'
            : 'no';
        var validAnswer = healthQuestionsList[i].eligibleAnswer;
        if (!answer.toLowerCase().startsWith(validAnswer.toLowerCase())) {
          allowPolicyBuying = false;
        }
      }
      MemberDetailsModel memberDetailsModel =
          criticalIllnessModel.policyCoverMemberModel.memberDetailsModel;

      bmi=CommonUtil.instance.calculateBMI(memberDetailsModel.heightInInch, memberDetailsModel.heightInFeet,memberDetailsModel.weight);
      criticalIllnessModel.bmi=bmi;
      if(bmi<18 || bmi>28){
        isValidBMI=false;
      }

      List<OtherCriticalIllnessDetailsModel> otherCriticalIllnessDetails =
          criticalIllnessModel.otherCriticalIllnessDetails;
      PolicyTimePeriod policyPeriod = criticalIllnessModel.policyTimePeriod;
      DateTime startDate = policyPeriod.startDate;
      DateTime endDate = policyPeriod.endDate;

      quickQuoteReqModel.effectiveDate = CommonUtil.instance
          .convertTo_yyyy_MM_dd(startDate); //policy start date
      quickQuoteReqModel.expiryDate = CommonUtil.instance.convertTo_yyyy_MM_dd(endDate); //policy end date
      quickQuoteReqModel.email = widget.criticalIllnessModel.personalDetails.email;
      quickQuoteReqModel.mobile = widget.criticalIllnessModel.personalDetails.mobile;
      quickQuoteReqModel.firstname = memberDetailsModel.firstName;
      quickQuoteReqModel.lastname = memberDetailsModel.lastName;
      quickQuoteReqModel.dateOfBirth = memberDetailsModel.ageGenderModel.dob_yyyy_mm_dd;
      quickQuoteReqModel.sumInsured = widget.criticalIllnessModel.sumInsuredModel.amount.toString();
      var amt = criticalIllnessModel.grossIncome.replaceAll(',', '') ?? '0';
      quickQuoteReqModel.income = amt;
      quickQuoteReqModel.employmentDetails = (memberDetailsModel.isEmployed) ? 'yes' : 'no';
      quickQuoteReqModel.genderCode = memberDetailsModel.ageGenderModel.gender;
      quickQuoteReqModel.duration=criticalIllnessModel.timePeriodModel.year.toString();
      Questionnaire questionnaire;

      List<Questionnaire> questionnaireList = [];

      for (var k = 0; k < healthQuestionsList.length; k++) {
        questionnaire = Questionnaire();

        if (healthQuestionsList[k] != null) {
          questionnaire.priority = healthQuestionsList[k].priority ?? 0;
          questionnaire.questionnaire = (healthQuestionsList[k].isYes != null &&
                  healthQuestionsList[k].isYes)
              ? '1'
              : '0';
          questionnaire.validAnswer =
              (healthQuestionsList[k].eligibleAnswer != null &&
                      healthQuestionsList[k]
                          .eligibleAnswer
                          .toLowerCase()
                          .startsWith('yes'))
                  ? '1'
                  : '0';

          List<SubQuestionnaire> subQuestionnaireList = [];

          if (healthQuestionsList[k].noSubQuestions != null) {
            List<SubQuestionModel> subQuestionModel =
                healthQuestionsList[k].noSubQuestions;

            SubQuestionnaire sub;

            for (var i = 0; i < subQuestionModel.length; i++) {
              sub = SubQuestionnaire();

              if (subQuestionModel[i].isTextField) {
                sub.priority = subQuestionModel[i].priority ?? 0;
                sub.questionnaire = subQuestionModel[i].answer;
                subQuestionnaireList.add(sub);
              } else {
                if (subQuestionModel[i].subPoints != null) {
                  for (var j = 0;
                      j < subQuestionModel[i].subPoints.length;
                      j++) {
                    sub = SubQuestionnaire();
                    sub.priority =
                        subQuestionModel[i].subPoints[j].priority ?? 0;

                    ///Selected yes =1 , No = 0
                    sub.questionnaire =
                        (subQuestionModel[i].subPoints[j].isSelected != null &&
                                subQuestionModel[i].subPoints[j].isSelected)
                            ? '1'
                            : '0';
                    subQuestionnaireList.add(sub);
                  }
                }
              }
            }
          } else if (healthQuestionsList[k].yesSubQuestions != null) {
            List<SubQuestionModel> subQuestionModel =
                healthQuestionsList[k].yesSubQuestions;

            SubQuestionnaire sub;
            for (var i = 0; i < subQuestionModel.length; i++) {
              sub = SubQuestionnaire();

              if (subQuestionModel[i].isTextField) {
                sub.priority = subQuestionModel[i].priority ?? 0;
                sub.questionnaire = subQuestionModel[i].answer;
                subQuestionnaireList.add(sub);
              } else {
                if (subQuestionModel[i].subPoints != null) {
                  for (var j = 0;
                      j < subQuestionModel[i].subPoints.length;
                      j++) {
                    sub = SubQuestionnaire();
                    sub.priority =
                        subQuestionModel[i].subPoints[j].priority ?? 0;

                    ///Selected yes = 1, No = 0
                    sub.questionnaire =
                        (subQuestionModel[i].subPoints[j].isSelected != null &&
                                subQuestionModel[i].subPoints[j].isSelected)
                            ? '1'
                            : '0';
                    subQuestionnaireList.add(sub);
                  }
                }
              }
              //subQuestionnaireList.add(sub);
            }
          }
          questionnaire.subQuestionnaire = subQuestionnaireList;
        }
        questionnaireList.add(questionnaire);
      }
      quickQuoteReqModel.questionnaire = questionnaireList;

      List<OtherPolicies> otherPoliciesList = [];
      if (otherCriticalIllnessDetails != null) {
        OtherPolicies otherPolicies;
        for (var i = 0; i < otherCriticalIllnessDetails.length; i++) {
          otherPolicies = OtherPolicies();
          otherPolicies.policyType = otherCriticalIllnessDetails[i].policyType;
          otherPolicies.policyStart = otherCriticalIllnessDetails[i].startDate;
          otherPolicies.policyEnd = otherCriticalIllnessDetails[i].endDate;
          otherPolicies.sumInsured = otherCriticalIllnessDetails[i].sumInsured;
          otherPolicies.insuranceCompany =
              otherCriticalIllnessDetails[i].insuranceCompany;
          otherPolicies.policyNo = otherCriticalIllnessDetails[i].policyNumber;
          otherPolicies.specialCondition =
              otherCriticalIllnessDetails[i].specialConditions;
          otherPoliciesList.add(otherPolicies);
        }
      }
      quickQuoteReqModel.otherPolicies = otherPoliciesList;

      //_navigate();
      criticalIllnessModel.quickQuoteReqModel = quickQuoteReqModel;
      doApiCall(quickQuoteReqModel);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _navigate() {
    if (allowPolicyBuying && isValidBMI) {
      Navigator.of(context).pushNamed(
          CriticalIllnessInsuranceBuyerDetailsScreen.ROUTE_NAME,
          arguments: widget.criticalIllnessModel);
    } else {
      showCustomerRepresentativeWidget(context);
    }
  }

  void showCustomerRepresentativeWidget(BuildContext context) {
    onClick(int from) {
      Navigator.popUntil(context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
    }

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick,title: (isValidBMI)?'':S.of(context).medical_check_up,subTitle: (isValidBMI)?"":S.of(context).critical_contact_sbi_content,)));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => WillPopScope(
              onWillPop: () {
                return Future<bool>.value(true);
              },
              child: CustomerRepresentativeWidget(onClick,title: (isValidBMI)?'':S.of(context).medical_check_up,subTitle: (isValidBMI)?"":S.of(context).critical_contact_sbi_content,)));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void createHealthModel(HealthQuestionResModel healthQuestionResModel) {
    healthQuestionsList = [];
    String iconPath = UrlConstants.ICON;
    HealthQuestionModel healthQuestionModel;
    if (healthQuestionResModel != null) {
      var data = healthQuestionResModel.data.body;
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          var value = data[i];
          if (value.slugType.compareTo(StringDescription.SLUG_FAQ) == 0) {
            healthQuestionModel = HealthQuestionModel();
            healthQuestionModel.question = value.title;
            healthQuestionModel.eligibleAnswer =
                value?.jsonCondition?.eligibleAnswer ?? 'no';
            healthQuestionModel.priority = value.priority ?? 0;
            if (value.points != null) {
              for (var j = 0; j < value.points.length; j++) {
                var point = value.points[j];
                // healthQuestionModel.priority = point.priority ?? 0;
                if (point.title == 'Yes') {
               //   healthQuestionModel.yesActiveIcon = (point.imagePath2 == null || point.imagePath2.length == 0) ? "": iconPath + point.imagePath2;
              //    healthQuestionModel.yesIcon = (point.imagePath1 == null || point.imagePath1.length == 0) ? AssetConstants.ic_medicine : iconPath + point.imagePath1;
                  healthQuestionModel.yesIcon =point?.imagePath1 ?? null;
                  healthQuestionModel.yesActiveIcon = point?.imagePath2 ??null;
                  healthQuestionModel.yesSubQuestions = (point?.subPoints != null) ? getSubQuestions(point.subPoints) : null;
                  /*healthQuestionModel.isYesSubQuestion =
                      (point?.subPoints != null)
                          ? (point.subPoints.length>0)?true:false
                          : false;*/
                } else {
                 // healthQuestionModel.noActiveIcon = (point.imagePath2 == null || point.imagePath2.length == 0) ? AssetConstants.ic_medicine_white : iconPath + point.imagePath2;
                 // healthQuestionModel.noIcon = (point.imagePath1 == null || point.imagePath1.length == 0) ? AssetConstants.ic_medicine_white_selected : iconPath + point.imagePath1;
                  healthQuestionModel.noIcon = point?.imagePath1 ?? null;
                  healthQuestionModel.noActiveIcon = point?.imagePath2??null;
                  healthQuestionModel.noSubQuestions = (point?.subPoints != null) ? getSubQuestions(point.subPoints) : null;
                  /* healthQuestionModel.isNoQuestion =
                  (point?.subPoints != null )
                      ? (point.subPoints.length>0)?true:false
                      : false;*/
                }
              }
            }
            healthQuestionsList.add(healthQuestionModel);
          }
        }
      }
    }
  }

  List<SubQuestionModel> getSubQuestions(List<SubPoints> subPoint) {
    List<SubQuestionModel> subQuestions = [];
    SubQuestionModel subQuestionModel;

    for (var k = 0; k < subPoint.length; k++) {
      subQuestionModel = SubQuestionModel();
      if (subPoint[k].subPointType == StringDescription.SLUG_RADIO_BUTTON) {
        subQuestionModel.question = subPoint[k].title;
        subQuestionModel.isTextField = false;

        if (subPoint[k]?.jsonCondition?.value != null) {
          var value = subPoint[k]?.jsonCondition?.value;
          List<SubPointsModel> subPoints = [];
          for (var l = 0; l < value.length; l++) {
            subPoints.add(SubPointsModel(
                point: value[l].title,
                isSelected: false,
                priority: value[l].priority));
          }
          subQuestionModel.subPoints = subPoints;
        }
      } else if (subPoint[k].subPointType ==
          StringDescription.SLUG_TEXT_FIELD) {
        subQuestionModel.hintText = subPoint[k].jsonCondition.hint;
        subQuestionModel.question = subPoint[k].title;
        subQuestionModel.isTextField = true;
        subQuestionModel.priority = subPoint[k].priority ?? 0;
      }
      subQuestions.add(subQuestionModel);
    }

    return subQuestions;
  }
}

/*list = [
      SubPointsModel(
          point: "High Blood Pressure/ Heart Attack/ Cardiovascular disease, Diabetes, Tuberculosis, Asthma,"
              " or other Respiratory Disease, Kidney disorder, Bladder disorder, urine abnormality, renal stones or genital organ disorder, "
              "Cancer or any form of tumour or lump, cyst growth, Liver and gall bladder disorder, Stomach or duodenal disorder, Fistula,"
              " Piles, Hernia, Eye, Ear, Nose,"
              " Throat or Endocrine diseases, Diseases of bones, joints or spine, Stroke, epilepsy or "
              "any other disorder of brain, spinal cord or nerves",
          isSelected: null),
      SubPointsModel(
          point: "Have you ever been tested positive for HIV / AIDS , Hepatitis B or C or sexually transmitted diseases?",
          isSelected: null),
      SubPointsModel(
          point: " Any other illness / injury requiring investigation or treatment?",
          isSelected: null),
    ];

    list2 = [
      SubPointsModel(point: "Less than 40 Cig", isSelected: null),
      SubPointsModel(point: "More than 40 Cig", isSelected: null),

    ];

    subQuestion1 = [
      SubQuestionModel(
          subPoints: list
      ),
    ];

    subQuestion2 = [
      SubQuestionModel(subPoints: list2),
      SubQuestionModel(isTextField: true,question: 'b. Consuming for past number of years',hintText: 'Enter here in years'),
      SubQuestionModel(isTextField: true,question: 'b. If you have stopped smoking or using tobacco products then please provide when? ',hintText: 'Enter here in years'),
    ];


    healthQuestionsList = [
      HealthQuestionModel(
        question: StringDescription.ped_question1,
        isYes: null,
        yesIcon: AssetConstants.ic_medicine,
        yesActiveIcon: AssetConstants.ic_medicine_selected,
        noIcon: AssetConstants.ic_medicine_white,
        noActiveIcon: AssetConstants.ic_medicine_white_selected,
        isSubQuestions: true,
        subQuestions
        :subQuestion1,
      ),
      HealthQuestionModel(
        question: StringDescription.ped_question2,
        isYes: null,
        yesIcon: AssetConstants.ic_smoke,
        yesActiveIcon: AssetConstants.ic_smoke_selected,
        noIcon: AssetConstants.ic_smoke_white,
        noActiveIcon: AssetConstants.ic_smoke_white_selected,
        isSubQuestions: false,
        subQuestions: null,),
      HealthQuestionModel(
        question: StringDescription.ped_question3,
        isYes: null,
        yesIcon: AssetConstants.ic_tobacco,
        yesActiveIcon: AssetConstants.ic_tobacco_selected,
        noIcon: AssetConstants.ic_tobacco_white,
        noActiveIcon: AssetConstants.ic_tobacco_white_selected,
        isSubQuestions: true,
        subQuestions: subQuestion2,),
      HealthQuestionModel(
          question: StringDescription.ped_question4,
          isYes: null,
          yesIcon: AssetConstants.ic_alcohol,
          yesActiveIcon: AssetConstants.ic_alcohol_selected,
          noIcon: AssetConstants.ic_alcohol_white,
          noActiveIcon: AssetConstants.ic_alcohol_white_selected,
          isSubQuestions: false,
          subQuestions: null),
    ];*/

/*   if (healthQuestionsList[healthIndex].isYes != null && healthQuestionsList[healthIndex].isYes) {
                    if (healthQuestionsList[healthIndex].yesSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected != null &&
                        !healthQuestionsList[healthIndex].yesSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected) {
                      healthQuestionsList[healthIndex].yesSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected = true;
                      isClicked = true;
                    } else {
                      healthQuestionsList[healthIndex].yesSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected = false;
                      isClicked = false;
                    }
                  } else {
                    if (healthQuestionsList[healthIndex].noSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected != null &&
                        !healthQuestionsList[healthIndex].noSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected) {
                      healthQuestionsList[healthIndex].noSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected = true;
                      isClicked = true;
                    } else {
                      healthQuestionsList[healthIndex].noSubQuestions[subQuestionIndex].subPoints[pointIndex].isSelected = false;
                      isClicked = false;
                    }
                  }*/
