import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/premium_details/premium_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/dob_format_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/ped_questions.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/string_description.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/premium_breakup_screen.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/alert_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/contact_nearest_branch_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/dropdown_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

import 'insurance_buyer_details.dart';

class PedQuestionsScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_plus/ped_questions_screen";

  final SelectedMemberDetails selectedMemberDetails;

  PedQuestionsScreen(this.selectedMemberDetails);

  @override
  _PedQuestionsScreenState createState() => _PedQuestionsScreenState();
}

class _PedQuestionsScreenState extends State<PedQuestionsScreen>
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
    pedQuestionsList = [
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
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    List<GeneralListModel> _policyMembers =
        widget.selectedMemberDetails.policyMembers;
    for (int i = 0; i < pedQuestionsList.length; i++) {
      pedQuestionsList[i].policyMembers = _policyMembers;
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
                            child: Image.asset((pedQuestionItem.isYes != null &&
                                    pedQuestionItem.isYes)
                                ? pedQuestionItem.yesActiveIcon
                                : pedQuestionItem.yesIcon)),
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
                            child: Image.asset((pedQuestionItem.isYes != null &&
                                    !pedQuestionItem.isYes)
                                ? pedQuestionItem.noIcon
                                : pedQuestionItem.noActiveIcon)),
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
                      itemCount: pedQuestionsList[index].policyMembers.length,
                      itemBuilder: (BuildContext context, int subIndex) {
                        return buildMemberListItem(
                            pedQuestionsList[index].policyMembers[subIndex],
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
      if (null == pedQuestionsList[0].isYes ||
          null == pedQuestionsList[1].isYes ||
          null == pedQuestionsList[2].isYes ||
          null == pedQuestionsList[3].isYes) {
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

        erroString = S.of(context).answer_all_questions_error;
        setState(() {
          isAlertVisible = true;
        });
        return;
      }

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

      //   if(!pedQuestionsList[0].isYes){
      for (int i = 1; i < pedQuestionsList.length; i++) {
        print("pedQuestionsList[i].isYes " +
            pedQuestionsList[i].isYes.toString());
        if (pedQuestionsList[i].isYes) {
          print("pedQuestionsList[i].selectedMembers.length " +
              pedQuestionsList[i].selectedMembers.length.toString());
          if (pedQuestionsList[i].selectedMembers.length == 0) {
            erroString =
                S.of(context).choose_member_error + "Question No:${i + 1}";
            setState(() {
              isAlertVisible = true;
            });
            return;
          }
        }
      }
//    } else{
//      if(textEditingController.text == null || textEditingController.text.isEmpty){
//        erroString = S.of(context).specify_reason_error;
//        setState(() {
//          isAlertVisible = true;
//        });
//        return;
//      }
//    }

      setState(() {
        isAlertVisible = false;
      });

      PersonalDetails personalDetails =
          widget.selectedMemberDetails.personalDetails;
      List<GeneralListModel> policyMembers =
          widget.selectedMemberDetails.policyMembers;
      TimePeriodModel timePeriodModel =
          widget.selectedMemberDetails.finalSelectedYearAndPremium;
      SumInsuredModel sumInsuredModel =
          widget.selectedMemberDetails.selectedSumInsured;
      PolicyPeriod policyPeriod = widget.selectedMemberDetails.policyPeriod;
      DateTime startDate = policyPeriod.startDate;
      DateTime endDate = policyPeriod.endDate;
      int policyType = widget.selectedMemberDetails.policyType.id;

      ProposerDetails proposerDetails = ProposerDetails();
      List<InsuredDetails> insuredDetailsList = List();

      proposerDetails.mobileNumber = personalDetails.mobile;
      proposerDetails.emailId = personalDetails.email;
      print("timePeriodModel.childCount " +
          timePeriodModel.childCount.toString());
      proposerDetails.childCount = timePeriodModel.childCount.toString();
      proposerDetails.adultCount = timePeriodModel.adultCount.toString();
      proposerDetails.insuredId = "";

      for (GeneralListModel item in policyMembers) {
        InsuredDetails insuredDetails = InsuredDetails();
        OtherDetails otherDetails = OtherDetails();

        MemberDetailsModel member = item.memberDetailsModel;
        AgeGenderModel ageGenderModel = member.ageGenderModel;

        if (policyType == PolicyTypeScreen.INDIVIDUAL) {
          proposerDetails.policy_type = "individual";
          proposerDetails.gender = ageGenderModel.gender;
          proposerDetails.firstName = member.firstName;
          proposerDetails.lastName = member.lastName;
          proposerDetails.dob = ageGenderModel.dob_yyyy_mm_dd;
          if (ageGenderModel.gender.compareTo("M") == 0) {
            proposerDetails.title = "Mr";
          } else if (ageGenderModel.gender.compareTo("F") == 0 &&
              member.isMarried) {
            proposerDetails.title = "Mrs";
          } else if (ageGenderModel.gender.compareTo("F") == 0 &&
              !member.isMarried) {
            proposerDetails.title = "Ms";
          }
          proposerDetails.policystart_date =
              CommonUtil.instance.convertTo_yyyy_MM_dd(startDate);
          proposerDetails.policystart_end =
              CommonUtil.instance.convertTo_yyyy_MM_dd(endDate);

          widget.selectedMemberDetails.isProposerSelf =
              (member.relation.compareTo(S.of(context).self_title) == 0);
        } else {
          if (member.relation.compareTo(S.of(context).self_title) == 0) {
            if (policyType == PolicyTypeScreen.FAMILY_FLOATER) {
              proposerDetails.policy_type = "family_floater";
            } else {
              proposerDetails.policy_type = "family_individual";
            }
            proposerDetails.gender = ageGenderModel.gender;
            proposerDetails.firstName = member.firstName;
            proposerDetails.lastName = member.lastName;
            proposerDetails.dob = ageGenderModel.dob_yyyy_mm_dd;
            //proposerDetails.dobFormat = DobFormat(dob: ageGenderModel.dob, dob_yyyy_mm_dd: ageGenderModel.dob_yyyy_mm_dd, dateTime: ageGenderModel.dateTime);
            if (ageGenderModel.gender.compareTo("M") == 0) {
              proposerDetails.title = "Mr";
            } else if (ageGenderModel.gender.compareTo("F") == 0 &&
                member.isMarried) {
              proposerDetails.title = "Mrs";
            } else if (ageGenderModel.gender.compareTo("F") == 0 &&
                !member.isMarried) {
              proposerDetails.title = "Ms";
            }
            proposerDetails.policystart_date =
                CommonUtil.instance.convertTo_yyyy_MM_dd(startDate);
            proposerDetails.policystart_end =
                CommonUtil.instance.convertTo_yyyy_MM_dd(endDate);
            widget.selectedMemberDetails.isProposerSelf = true;
          }
        }

        insuredDetails.name = "${member.firstName} ${member.lastName}";
//        insuredDetails.firstname = member.firstName;
//        insuredDetails.lastname = member.lastName;
        insuredDetails.gender = ageGenderModel.gender;
        insuredDetails.dob = ageGenderModel.dob_yyyy_mm_dd;
        insuredDetails.age = ageGenderModel.age.toString();
        insuredDetails.sumInsured = sumInsuredModel.amount.toString();
        insuredDetails.opd = timePeriodModel.opd.toString();
        insuredDetails.year = timePeriodModel.year.toString();
        insuredDetails.siPerYear = timePeriodModel.year.toString();
        //insuredDetails.premiumBeforeServiceTax = timePeriodModel.basicpremium.toString();
        if(policyType ==PolicyTypeScreen.FAMILY_INDIVIDUAL){
          insuredDetails.premiumBeforeServiceTax = timePeriodModel.member_individual_premium.toString();
        }else {
          insuredDetails.premiumBeforeServiceTax = timePeriodModel.basicpremium.toString();
        }

        if (member.relation.startsWith("Child")) {
          insuredDetails.realtionshipWithProposer =
              member.ageGenderModel.gender == "M" ? "Son" : "Daughter";
        } else if (member.relation
                .compareTo(S.of(context).father_in_law_title) ==
            0) {
          insuredDetails.realtionshipWithProposer = "Father_In_Law";
        } else if (member.relation
                .compareTo(S.of(context).mother_in_law_title) ==
            0) {
          insuredDetails.realtionshipWithProposer = "Mother_In_Law";
        } else {
          insuredDetails.realtionshipWithProposer = member.relation;
        }

        int j = 0;
        for (PedQuestionsModel pedQuestionsModel in pedQuestionsList) {
          Set<int> selectedMembers = pedQuestionsModel.selectedMembers;
          List<GeneralListModel> policyMembers =
              pedQuestionsModel.policyMembers;
          if (selectedMembers.isEmpty &&
              (insuredDetails.realtionshipWithProposer.compareTo("Self") == 0 ||
                  policyType == PolicyTypeScreen.INDIVIDUAL)) {
            if (pedQuestionsList[0].isYes) {
              otherDetails.otherImpairment = "1";
              otherDetails.impairmentReason = textEditingController.text;
            }
          } else {
            for (int i in selectedMembers) {
              if (policyMembers[i]
                      .memberDetailsModel
                      .relation
                      .compareTo(member.relation) ==
                  0) {
                switch (j) {
                  case 0:
                    otherDetails.otherImpairment = "1";
                    otherDetails.impairmentReason = textEditingController.text;
                    break;
                  case 1:
                    otherDetails.smokerStatus = "1";
                    break;
                  case 2:
                    otherDetails.doyouConsumeTobacco = "1";
                    break;
                  case 3:
                    otherDetails.alcoholStatus = "1";
                    break;
                }
              }
            }
          }
          j++;
        }

        insuredDetails.otherDetails = otherDetails;
        insuredDetailsList.add(insuredDetails);
      }

      RecalculatePremiumReqModel recalculatePremium =
          RecalculatePremiumReqModel();
      recalculatePremium.insuredDetails = insuredDetailsList;
      recalculatePremium.proposerDetails = proposerDetails;
      doApiCall(recalculatePremium, pedQuestionsList[0].isYes);
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

  void doApiCall(RecalculatePremiumReqModel recalculatePremium, bool isFirstQuestionyes) async {
//    Navigator.of(context).pushNamed(InsuranceBuyerDetailsScreen.ROUTE_NAME,
//        arguments: widget.selectedMemberDetails);
//    return;

    Map<String, dynamic> body = recalculatePremium.toJson();
    showLoaderDialog(context);
    var response =
        await PremiumApiProvider.getInstance().reCalculatePremium(body);
    if (null == response.apiErrorModel) {
      hideLoaderDialog(context);
      if (isFirstQuestionyes) {
        showCustomerRepresentativeWidget(context);
      } else {
        TimePeriodModel timePeriodModel =
            widget.selectedMemberDetails.finalSelectedYearAndPremium;
        TimePeriod timePeriod = response.data;
        timePeriodModel.total_premium = timePeriod.total_premium;
        timePeriodModel.actualPremium = timePeriod.premium;
        timePeriodModel.opd = timePeriod.opd;
        timePeriodModel.tax_amount = timePeriod.tax_amount;
        timePeriodModel.tax = timePeriod.tax;
        timePeriodModel.discountedPremium = timePeriod.premium_withdiscount;
       // timePeriodModel.discountPercentage = timePeriod.discount_percentage;
        widget.selectedMemberDetails.isFrom =
            PremiumBreakupScreen.FROM_HEALTH_QUESTIONNAIRE;
        widget.selectedMemberDetails.finalSelectedYearAndPremium =
            timePeriodModel;

        widget.selectedMemberDetails.quoteNumber = response.sbiResponse
            .quoteResponse.response.payload.createQuoteResponse.quoteNumber;

        widget.selectedMemberDetails.recalculatePremiumReqModel =
            recalculatePremium;
        widget.selectedMemberDetails.recalculatePremiumResModel = response;

        if(Platform.isIOS){
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) => WillPopScope(
                  onWillPop: () {
                    return Future<bool>.value(true);
                  },
                  child: PremiumBreakupScreen(widget.selectedMemberDetails)));
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context) => WillPopScope(
                  onWillPop: () {
                    return Future<bool>.value(true);
                  },
                  child: PremiumBreakupScreen(widget.selectedMemberDetails)));
        }
      }
    } else {
      hideLoaderDialog(context);
      handleApiError(context,0, (int retryIdentifier) {
        onClick();
      }, response.apiErrorModel.statusCode);

     /* if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        showNoInternetDialog(
          context,
          0,
          (int retryIdentifier) {
            onClick();
          },
        );
      } else {
        showServerErrorDialog(context, 0, (int retryIdentifier) {
          onClick();
        });
      }*/
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

  Widget buildMemberListItem(GeneralListModel policyMember, int subIndex, int mainIndex) {
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
                    child: Image.asset(isSelected
                        ? policyMember.activeIcon
                        : policyMember.icon)),
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

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
