import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/quote_creation/quote_creation_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/verify_otp/otp_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/otp_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/payment.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/selected_member_details.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insuree_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/otp_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/arogya_plus_thank_you_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class PolicySummeryScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_plus/policy_summery_screen";

  final SelectedMemberDetails selectedMemberDetails;

  PolicySummeryScreen(this.selectedMemberDetails);

  @override
  _PolicySummeryScreenState createState() => _PolicySummeryScreenState();
}

class _PolicySummeryScreenState extends State<PolicySummeryScreen>
    with CommonWidget {
  List<MapModel> premiumList, buyerDetails, coverDetails;
  bool isInsuranceDetailsEditable = true;
  bool isCoverDetailsEditable = true;

  NomineeDetailsModel nomineeDetailsModel;
  List<GeneralListModel> policyMembers;
  TimePeriodModel timePeriodModel;
  CommunicationDetailsModel communicationDetailsModel;
  SumInsuredModel sumInsuredModel;
  PersonalDetails personalDetails;
  ProposerDetailsModel proposerDetails;
  double deviceWidth;
  PolicyPeriod policyPeriod;
  PolicyType policyType;

  String firstName = "";
  String lastName = "";
  String receiptNo = "";
  String quoteNo = "";
  String phone = "";
  String email = "";
  String description = "receipt no: ";
  int amount;

  PaymentController _paymentController;

  BehaviorSubject<bool> _isOtpVerifiedSC = BehaviorSubject.seeded(false);

  Observable<bool> get _isOtpVerifiedStream =>
      _isOtpVerifiedSC.asBroadcastStream();

  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    try {
      timePeriodModel =
          widget.selectedMemberDetails.finalSelectedYearAndPremium;
      if (timePeriodModel.total_premium is! int) {
        timePeriodModel.total_premium =
            double.parse(timePeriodModel.total_premium.toString()).floor();
      }

      amount = timePeriodModel.total_premium;

      nomineeDetailsModel =
          widget.selectedMemberDetails.buyerDetails.nomineeDetailsModel;
      communicationDetailsModel =
          widget.selectedMemberDetails.buyerDetails.communicationDetailsModel;
      proposerDetails =
          widget.selectedMemberDetails.buyerDetails.proposerDetails;
      personalDetails = widget.selectedMemberDetails.personalDetails;
      policyMembers = widget.selectedMemberDetails.policyMembers;
      sumInsuredModel = widget.selectedMemberDetails.selectedSumInsured;
      policyPeriod = widget.selectedMemberDetails.policyPeriod;
      policyType = widget.selectedMemberDetails.policyType;

      firstName = proposerDetails.firstName;
      lastName = proposerDetails.lastName;
      quoteNo = widget.selectedMemberDetails.quoteNumber;
      phone = widget.selectedMemberDetails.personalDetails.mobile;
      email = widget.selectedMemberDetails.personalDetails.email;
    } catch (e) {
      debugPrint(e.toString());
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    deviceWidth = ScreenUtil.getInstance(context).screenWidthDp - 78;
    coverDetails = [];

    premiumList = [
      MapModel((policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL)?S.of(context).sum_insured_title_each:S.of(context).sum_insured_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(sumInsuredModel.amount)),
      MapModel(S.of(context).gross_premium,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.discountedPremium)),
      MapModel(S.of(context).applicable_tax_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.tax_amount)),

    ];

    if(policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL){

      int insertPosition = 2;

      if(!TextUtils.isEmpty(timePeriodModel.member_discount_percentage.toString()) && timePeriodModel.member_discount_percentage.toString().compareTo("0") != 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .family_discount_title +
            "(${timePeriodModel.member_discount_percentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.member_discount_value)));
        insertPosition = 3;
      }

      if(timePeriodModel.discountPercentage > 0) {
        premiumList.insert(insertPosition, MapModel(S
            .of(context)
            .long_term_discount_title +
            "(${timePeriodModel.discountPercentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.discount_value)));
      }
    }


    buyerDetails = [
      MapModel(S.of(context).name_title,
          value: "${proposerDetails.firstName} ${proposerDetails.lastName}"),
      MapModel(S.of(context).your_address,
          value: communicationDetailsModel.address),
      MapModel(S.of(context).email_id, value: personalDetails.email),
      MapModel(S.of(context).mobile_no, value: personalDetails.mobile),
      MapModel(S.of(context).nominee_name,
          value:
              "${nomineeDetailsModel.firstName} ${nomineeDetailsModel.lastName}"),
      MapModel(S.of(context).date_of_birth,
          value: CommonUtil.instance
              .convertTo_dd_MMM_yyyy(nomineeDetailsModel.dobFormat.dateTime)),
      MapModel(S.of(context).nominee_relation,
          value: nomineeDetailsModel.relationshipWith),
      MapModel(S.of(context).nominee_gender,
          value: nomineeDetailsModel.gender.compareTo("M") == 0
              ? "Male"
              : "Female"),
    ];

    for (GeneralListModel item in policyMembers) {
      MemberDetailsModel memberDetailsModel = item.memberDetailsModel;
      AgeGenderModel ageGenderModel = memberDetailsModel.ageGenderModel;

      MapModel name = MapModel(S.of(context).name_title,
          value:
              "${memberDetailsModel.firstName} ${memberDetailsModel.lastName}");
      MapModel dob = MapModel(S.of(context).date_of_birth,
          value: CommonUtil.instance
              .convertTo_dd_MMM_yyyy(ageGenderModel.dateTime));
      MapModel relation = MapModel(S.of(context).relation_with_proposer,
          value: memberDetailsModel.relation);

      coverDetails.add(name);
      coverDetails.add(dob);
      coverDetails.add(relation);
    }

    MapModel policyStartPeriod = MapModel(S.of(context).policy_start_date,
        value:
            CommonUtil.instance.convertTo_dd_MMM_yyyy(policyPeriod.startDate));
    MapModel policyEndPeriod = MapModel(S.of(context).policy_end_date,
        value: CommonUtil.instance.convertTo_dd_MMM_yyyy(policyPeriod.endDate));

    coverDetails.add(policyStartPeriod);
    coverDetails.add(policyEndPeriod);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                    ColorConstants.policy_type_gradient_color2,
                    ColorConstants.policy_type_gradient_color1
                  ])),
            ),
            Column(
              children: <Widget>[
                getAppBar(
                    context, S.of(context).policy_summery_title.toUpperCase(),
                    titleColor: Colors.white),
                Container(
                  height: ScreenUtil.getInstance(context).screenHeightDp - 150,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      policySummeryWidget(),
                      StreamBuilder<bool>(
                          stream: _isOtpVerifiedStream,
                          builder: (context, snapshot) {
                            String tncMessageText =
                                S.of(context).verify_otp_button_t_n_c_message;
                            if (snapshot != null) {
                              if (snapshot.hasData && snapshot.data) {
                                tncMessageText =
                                    S.of(context).payment_t_n_c_message;
                              }
                            }
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                    children: <TextSpan>[
                                      TextSpan(text: tncMessageText),
                                      TextSpan(text: '\n'),
                                      TextSpan(
                                          text: S
                                              .of(context)
                                              .terms_and_conditions,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap =
                                                _termsAndConditionsClicked)
                                    ]),
                              ),
                            );
                          }),
                      SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(alignment: Alignment.bottomCenter, child: _showButton()),
          ],
        ),
      ),
    );
  }

  policySummeryWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          premiumDetailsCard(),
          SizedBox(
            height: 20,
          ),
          nomineeDetailsCard(),
          SizedBox(
            height: 20,
          ),
          coverMemberDetailsCard(),
        ],
      ),
    );
  }

  premiumDetailsCard() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  borderRadius:
                      borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius(
                                radius: 5.0, topLeft: 5.0, topRight: 40.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 4))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius(
                            radius: 0.0, topLeft: 5.0, topRight: 40.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 3,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            S
                                .of(context)
                                .policy_summery_subtitle1
                                .toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                                letterSpacing: 1.0),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: premiumList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildPremiumDetailsValueItem(
                        premiumList[index], 150, true, false);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                height: 0.5,
                color: Colors.grey.shade200,
                width: double.maxFinite,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    S.of(context).total_premium_title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Text(
                      '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.total_premium)}',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  nomineeDetailsCard() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  borderRadius:
                      borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius(
                                radius: 5.0, topLeft: 5.0, topRight: 40.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 6.0,
                                  offset: Offset(0.0, 4))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius(
                            radius: 0.0, topLeft: 5.0, topRight: 40.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 3,
                            height: 30,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              S
                                  .of(context)
                                  .policy_summery_subtitle2
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.0,
                                  letterSpacing: 1.0),
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 60,
                            child: OutlineButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                setState(() {
                                  isInsuranceDetailsEditable =
                                      !isInsuranceDetailsEditable;
                                });
                              },
                              child: Text(
                                isInsuranceDetailsEditable
                                    ? S.of(context).edit_title.toUpperCase()
                                    : S.of(context).done_title.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buyerDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildPremiumDetailsValueItem(
                        buyerDetails[index], 130, false, true);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  coverMemberDetailsCard() {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
      ),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    borderRadius(radius: 5.0, topLeft: 5.0, topRight: 40.0),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius(
                              radius: 5.0, topLeft: 5.0, topRight: 40.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6.0,
                                offset: Offset(0.0, 4))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(
                          radius: 0.0, topLeft: 5.0, topRight: 40.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 3,
                          height: 30,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            S
                                .of(context)
                                .policy_summery_subtitle3
                                .toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                                letterSpacing: 1.0),
                          ),
                        ),
                        Container(
                          height: 25,
                          width: 60,
                          child: OutlineButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              setState(() {
                                isCoverDetailsEditable =
                                    !isCoverDetailsEditable;
                                Navigator.popUntil(
                                    context,
                                    ModalRoute.withName(
                                        InsureeDetailsScreen.ROUTE_NAME));
                              });
                            },
                            child: Text(
                              isCoverDetailsEditable
                                  ? S.of(context).edit_title.toUpperCase()
                                  : S.of(context).done_title.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: coverDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildPremiumDetailsValueItem(
                        coverDetails[index], 130, false, false);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  buildPremiumDetailsValueItem(MapModel mapItem, double keyWidth,
      bool isFromPremiumDetails, bool isFromNomineeDetails) {
    bool isValueEditable =
        ((mapItem.key.compareTo(S.of(context).your_address) == 0 ||
            mapItem.key.compareTo(S.of(context).nominee_name) == 0 ||
            mapItem.key.compareTo(S.of(context).nominee_relation) == 0 ||
            mapItem.key.compareTo(S.of(context).nominee_gender) == 0));

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: keyWidth,
            child: Text(
              isFromPremiumDetails ? mapItem.key : "${mapItem.key}:",
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          isFromPremiumDetails
              ? Expanded(
                  child: Text(
                    mapItem.value,
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black, fontSize: 14.0),
                  ),
                )
              : Container(
                  width:
                      mapItem.value.length > 20 ? deviceWidth - keyWidth : null,
                  decoration: (isFromNomineeDetails &&
                          !isInsuranceDetailsEditable &&
                          isValueEditable)
                      ? BoxDecoration(
                          color: ColorConstants.arogya_plus_si_edit_color,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)))
                      : null,
                  child: InkWell(
                    onTap: isValueEditable
                        ? () {
                            int redirection = (mapItem.key.compareTo(
                                        S.of(context).your_address) ==
                                    0)
                                ? InsuranceBuyerDetailsScreen
                                    .COMMUNICATION_DETAILS_WIDGET
                                : InsuranceBuyerDetailsScreen
                                    .NOMINEE_DETAILS_WIDGET;
                            prefsHelper
                                .setRedirection(redirection)
                                .then((done) {
                              Navigator.popUntil(
                                  context,
                                  ModalRoute.withName(
                                      InsuranceBuyerDetailsScreen.ROUTE_NAME));
                            });
                          }
                        : null,
                    child: Padding(
                      padding: (isFromNomineeDetails &&
                              !isInsuranceDetailsEditable &&
                              isValueEditable)
                          ? EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 2.0, bottom: 2.0)
                          : EdgeInsets.all(0.0),
                      child: Text(
                        mapItem.value,
                        textAlign: isFromPremiumDetails
                            ? TextAlign.end
                            : TextAlign.start,
                        style: TextStyle(
                            color: (isFromNomineeDetails &&
                                    !isInsuranceDetailsEditable &&
                                    isValueEditable)
                                ? ColorConstants.opd_amount_text_color
                                : Colors.black,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

//  getAgentReceipt() {
//    try {
//      String customerCode = widget
//          .selectedMemberDetails
//          .recalculatePremiumResModel
//          .sbiResponse
//          .quoteResponse
//          .response
//          .payload
//          .createQuoteResponse
//          .policyTerms
//          .customerCode;
//      Map<String, String> body = {
//        "quoteno": widget.selectedMemberDetails.quoteNumber,
//        "customerCode": customerCode,
//        "amount":
//            "${timePeriodModel.total_premium}"
//      };
//
//      QuoteCreationApiProvider.getInstance()
//          .agentReceipt(body)
//          .then((response) {
//        hideLoaderDialog(context);
//        if (null == response.apiErrorModel) {
//          widget.selectedMemberDetails.agentReceiptModel = response;
//          receiptNo =
//              response.data.agentReceiptDetailsResponseBody.payload.receiptNo;
//          description = description + receiptNo;
//          if (_isOtpVerifiedSC.value) {
//            _initiatePayment();
//          } else {
//            _makeOTPApiCall(widget.selectedMemberDetails.personalDetails.mobile,
//                widget.selectedMemberDetails.quoteNumber);
//          }
//        } else {
//          if (response.apiErrorModel.statusCode ==
//              ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
//            showNoInternetDialog(context, 0, (int retryIdentifier) {
//              showLoaderDialog(context);
//              getAgentReceipt();
//            });
//          } else {
//            showServerErrorDialog(
//              context,
//              0,
//              (int retryIdentifier) {
//                showLoaderDialog(context);
//                getAgentReceipt();
//              },
//            );
//          }
//        }
//      });
//    } catch (e) {
//      debugPrint(e.toString());
//    }
//  }

  _showButton() {
    onProceedBuy() {
      try {
        RecalculatePremiumReqModel recalculatePremiumReqModel =
            widget.selectedMemberDetails.recalculatePremiumReqModel;
        RecalculatePremiumResModel recalculatePremiumResModel =
            widget.selectedMemberDetails.recalculatePremiumResModel;
        CreateQuoteResponse createQuoteResponse = recalculatePremiumResModel
            .sbiResponse.quoteResponse.response.payload.createQuoteResponse;
        PolicyTerms policyTerms = createQuoteResponse.policyTerms;

        BuyerDetails buyerDetails = widget.selectedMemberDetails.buyerDetails;
        NomineeDetailsModel nomineeDetailsModel =
            buyerDetails.nomineeDetailsModel;
        AppointeeDetailsModel appointeeDetailsModel =
            buyerDetails.appointeeDetailsModel;
        CommunicationDetailsModel communicationDetailsModel =
            buyerDetails.communicationDetailsModel;
        PinCodeData pinCodeData = communicationDetailsModel.seletedAreaData;
        List<GeneralListModel> policyMembers =
            widget.selectedMemberDetails.policyMembers;

        ProposerDetails proposerDetailsObj = ProposerDetails();
        proposerDetailsObj.firstName = proposerDetails.firstName;
        proposerDetailsObj.lastName = proposerDetails.lastName;
        proposerDetailsObj.gender = proposerDetails.gender;
        //proposerDetailsObj.dobFormat = proposerDetails.dobFormat;
        proposerDetailsObj.dob = proposerDetails.dobFormat.dob_yyyy_mm_dd;
        proposerDetailsObj.policy_type =
            recalculatePremiumReqModel.proposerDetails.policy_type;
        proposerDetailsObj.policystart_end =
            recalculatePremiumReqModel.proposerDetails.policystart_end;
        proposerDetailsObj.policystart_date =
            recalculatePremiumReqModel.proposerDetails.policystart_date;
        proposerDetailsObj.mobileNumber =
            recalculatePremiumReqModel.proposerDetails.mobileNumber;
        proposerDetailsObj.emailId =
            recalculatePremiumReqModel.proposerDetails.emailId;

        if (proposerDetails.gender.compareTo("M") == 0) {
          proposerDetailsObj.title = "Mr";
        } else {
          proposerDetailsObj.title = "Mrs";
        }

        proposerDetailsObj.pinCode = communicationDetailsModel.pinCode;
        proposerDetailsObj.plotno = communicationDetailsModel.plotNo;
        proposerDetailsObj.buildingName =
            communicationDetailsModel.buildingName;
        proposerDetailsObj.location = pinCodeData.LCLTY_SUBRB_TALUK_TEHSL_NM;
        proposerDetailsObj.streetName = communicationDetailsModel.streetName;
        proposerDetailsObj.countryName = "India";
        proposerDetailsObj.districtName = pinCodeData.DISTRICT_NM;
        proposerDetailsObj.city = pinCodeData.CITY_NM;
        proposerDetailsObj.state = pinCodeData.STATE_NM;
        proposerDetailsObj.cityCode = pinCodeData.CITY_CD;
        proposerDetailsObj.stateCode = pinCodeData.STATE_CD;
        proposerDetailsObj.pinCodeId = pinCodeData.PIN_CD_ID;
        proposerDetailsObj.districtCode = pinCodeData.DISTRICT_CD;
        proposerDetailsObj.address = communicationDetailsModel.address;
        proposerDetailsObj.quoteNo = createQuoteResponse.quoteNumber;
        proposerDetailsObj.policyID = policyTerms.policyId;
        proposerDetailsObj.ppId = policyTerms.ppId;
        proposerDetailsObj.effectiveDate = policyTerms.effectiveDate;
        proposerDetailsObj.expiryDate = policyTerms.expiryDate;
        proposerDetailsObj.addressType = "CurrentAddress";

        if (nomineeDetailsModel.relationshipWith.startsWith("Child")) {
          proposerDetailsObj.nomineeRelationWithPrimaryInsured =
              nomineeDetailsModel.gender == "M" ? "Son" : "Daughter";
        } else if (nomineeDetailsModel.relationshipWith
                .compareTo(S.of(context).father_in_law_title) ==
            0) {
          proposerDetailsObj.nomineeRelationWithPrimaryInsured =
              "Father_In_Law";
        } else if (nomineeDetailsModel.relationshipWith
                .compareTo(S.of(context).mother_in_law_title) ==
            0) {
          proposerDetailsObj.nomineeRelationWithPrimaryInsured =
              "Mother_In_Law";
        } else {
          proposerDetailsObj.nomineeRelationWithPrimaryInsured =
              nomineeDetailsModel.relationshipWith;
        }

        proposerDetailsObj.childCount =
            recalculatePremiumReqModel.proposerDetails.childCount;
        proposerDetailsObj.adultCount =
            recalculatePremiumReqModel.proposerDetails.adultCount;
        if (null != createQuoteResponse.insuredDetails &&
            createQuoteResponse.insuredDetails.length > 0) {
          proposerDetailsObj.insuredId =
              createQuoteResponse.insuredDetails[0].insuredId;
        } else {
          debugPrint("Empty Insurer ID");
        }

        recalculatePremiumReqModel.proposerDetails = proposerDetailsObj;

        List<InsuredDetails> insuredDetails =
            recalculatePremiumReqModel.insuredDetails;

        for (int i = 0; i < policyMembers.length; i++) {
          MemberDetailsModel memberDetailsModel =
              policyMembers[i].memberDetailsModel;
          for (int i = 0; i < insuredDetails.length; i++) {
            InsuredDetails item = insuredDetails[i];
            String firstName = memberDetailsModel.firstName;
            String lastName = memberDetailsModel.lastName;
            insuredDetails[i].coverId =
                createQuoteResponse.insuredDetails[0].coverId;


            if (item.name.compareTo("$firstName $lastName") == 0) {
              insuredDetails[i].firstname = firstName;
              insuredDetails[i].lastname = lastName;
              insuredDetails[i].maritalStatus = memberDetailsModel.isMarried ? "1" : "2";
              break;
            }
          }
        }

        for (int i = 0; i < insuredDetails.length; i++) {
          InsuredDetails item = insuredDetails[i];

          if (appointeeDetailsModel != null) {
            insuredDetails[i].appointeeName =
                "${appointeeDetailsModel.firstName} ${appointeeDetailsModel.lastName}";
            insuredDetails[i].nomineeRelationWithAppointee =
                appointeeDetailsModel.relationshipWith;
          }

          NomineeDetails nomineeDetails = NomineeDetails();
          nomineeDetails.name =
              "${nomineeDetailsModel.firstName} ${nomineeDetailsModel.lastName}";
          nomineeDetails.dob =
              "${nomineeDetailsModel.dobFormat.dob_yyyy_mm_dd}";
          Duration duration =
              DateTime.now().difference(nomineeDetailsModel.dobFormat.dateTime);
          int years = ((duration.inDays) / 365).floor();
          nomineeDetails.age = "$years";
          item.nomineeDetails = nomineeDetails;

          createQuoteResponse.insuredDetails.forEach((item){
            print("item.insuredName. "+item.insuredName);
            print("insuredDetails[i].name. "+insuredDetails[i].name);
            if(item.insuredName.compareTo(insuredDetails[i].name) == 0){
              insuredDetails[i].insuredId = item.insuredId;
            }
          });


          insuredDetails[i] = item;
        }

        recalculatePremiumReqModel.insuredDetails = insuredDetails;

        showLoaderDialog(context);
        QuoteCreationApiProvider.getInstance()
            .quoteCreation(recalculatePremiumReqModel.toJson())
            .then((response) {
          if (null == response.apiErrorModel) {
            response.data =
                widget.selectedMemberDetails.recalculatePremiumResModel.data;
            widget.selectedMemberDetails.recalculatePremiumResModel = response;
            print("SUCCESS");
            CreateQuoteResponse finalCreateQuoteResponse = response
                .sbiResponse.quoteResponse.response.payload.createQuoteResponse;
            //getAgentReceipt();
            if (_isOtpVerifiedSC.value) {
              _initiatePayment();
            } else {
              _makeOTPApiCall(
                  widget.selectedMemberDetails.personalDetails.mobile,
                  widget.selectedMemberDetails.quoteNumber,
                  finalCreateQuoteResponse.partyId);
            }
          } else {
            hideLoaderDialog(context);
            handleApiError(context,0,(int retryIdentifier) {
              onProceedBuy();
            },response.apiErrorModel.statusCode);

         /*   if (response.apiErrorModel.statusCode ==
                ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
              showNoInternetDialog(context, 0, (int retryIdentifier) {
                onProceedBuy();
              });
            } else {
              showServerErrorDialog(
                context,
                0,
                (int retryIdentifier) {
                  onProceedBuy();
                },
              );
            }*/
          }
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return StreamBuilder<bool>(
        stream: _isOtpVerifiedStream,
        initialData: false,
        builder: (context, snapshot) {
          String buttonText = S.of(context).verify_otp.toUpperCase();
          if (snapshot != null) {
            if (snapshot.hasData && snapshot.data) {
              buttonText = S.of(context).make_payment.toUpperCase();
            }
          }
          return BlackButtonWidget(
            onProceedBuy,
            buttonText,
            bottomBgColor: Colors.transparent,
          );
        });
  }

  void _termsAndConditionsClicked() {
    BaseApiProvider.isInternetConnected().then((isConnected) {
      if (isConnected) {
        showDialog(
            context: context,
            builder: (context) {
              return WebViewDialog(UrlConstants.TERMS_N_CONDITIONS_WEBVIEW_URL,
                  S.of(context).terms_and_conditions, DialogKind.T_n_C);
            });
      } else {
        showNoInternetDialog(context, 0, (int retryIdentifier) {
          _termsAndConditionsClicked();
        });
      }
    });
  }

  _makeOTPApiCall(String mobileNo, String quoteNo, String partyID) async {
    retryIdentifier(int identifier) {
      _makeOTPApiCall(mobileNo, quoteNo, partyID);
    }

    OTPRequestModel otpRequestModel =
        OTPRequestModel(mobile: mobileNo, quoteno: quoteNo, partyID: partyID);
    final response = await OTPApiProvider.getInstance().getOTP(otpRequestModel);
    hideLoaderDialog(context);
    if (null != response.apiErrorModel) {
      handleApiError(context,0,retryIdentifier,response.apiErrorModel.statusCode);
  /*    if (response.apiErrorModel.statusCode ==
          ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
        showNoInternetDialog(context, 0, retryIdentifier);
      } else {
        showServerErrorDialog(
          context,
          0,
          (int retryIdentifier) {
            _makeOTPApiCall(mobileNo, quoteNo, partyID);
          },
        );
      }*/
    } else {
      if (response.success) {
        String otp = response.otp ?? '';
        _navigateToOptScreen(mobileNo, otp, quoteNo, partyID);
        /*Future.delayed(Duration(milliseconds: 100)).then((onValue) {
          //Navigator.pushNamed(context, OTPScreen.ROUTE_NAME,arguments: OTPScreenArguments(mobileNo,otp, widget.selectedMemberDetails));
          _navigateToOptScreen(mobileNo, otp, quoteNo, partyID);
        });*/
      }
    }
  }

  void _navigateToOptScreen(
      String mobileNo, String otp, String quoteNo, String partyID) async {
    final returnData = await Navigator.pushNamed(context, OTPScreen.ROUTE_NAME,
        arguments: OTPScreenArguments(
            mobileNo, quoteNo, partyID, widget.selectedMemberDetails));
    if (returnData != null) {
      OtpScreenReturnDataModel returnDataFromOtp =
          returnData as OtpScreenReturnDataModel;
      if (returnDataFromOtp.isSuccess) {
        _isOtpVerifiedSC.add(true);
        //otp verify is definitely success
        _initiatePayment();
        return;
      }
    }
    _isOtpVerifiedSC.add(false);
  }

  void _initiatePayment() {
    showLoaderDialog(context);
//    String customerCode = widget
//          .selectedMemberDetails
//          .recalculatePremiumResModel
//          .sbiResponse
//          .quoteResponse
//          .response
//          .payload
//          .createQuoteResponse
//          .policyTerms
//          .customerCode;
    String customerCode =
        widget.selectedMemberDetails.recalculatePremiumResModel.partyholderrole;
    if (TextUtils.isEmpty(customerCode)) {
      customerCode = "";
    }
    PaymentControllerDataModel _pcDataModel = PaymentControllerDataModel(
        amount: amount, firstName: firstName, lastName: lastName, quoteNo: quoteNo, phone: phone, email: email, desc: "", customerCode: customerCode);
    _paymentController = PaymentController(
        _pcDataModel, _handlePaymentSuccess, _handlePaymentFailure);
    _paymentController.initiatePayment();
  }

  void _handlePaymentSuccess(dynamic successResponse) {
    hideLoaderDialog(context);
    _showPurchaseSuccessDialog(successResponse as PaymentStatusCheckResponse);
  }

  void _handlePaymentFailure(ApiErrorModel errorModel) {

    retry(int from){
      _initiatePayment();
    }

    hideLoaderDialog(context);
    if (errorModel.statusCode ==
        ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
      showNoInternetDialog(context, 2, (id) {
        if(_paymentController.currentStep == PaymentSteps.PAYMENT_VERIFICATION) {
          _paymentController.callPaymentVerificationApi();
        } else {
          _initiatePayment();
        }
      });
    } else{
      int statusCode = errorModel.statusCode;
      handleApiError(context, 1, retry, statusCode, message: errorModel.message ?? S.of(context).payment_failure, title: (statusCode == 400) ? "Payment Error" : "");
    }

//    else if (errorModel.statusCode ==
//        PaymentController.PAYMENT_VERIFICATION_FAILED) {
//      _showPurchaseSuccessDialog(null);
//    }  else {
//      _scaffoldState.currentState.showSnackBar(SnackBar(
//        content: Text(S.of(context).payment_failure),
//      ));
//    }
  }

  void _showPurchaseSuccessDialog(PaymentStatusCheckResponse successResponse) {
    List<MapModel> dataMapToShowInDialog = [];
    String policyId = "";
    String description;
    if (successResponse != null) {
      policyId =
          successResponse.data.policyIssueResponseBody.payload.policyNumber;
    }
    if (TextUtils.isEmpty(policyId)) {
      description = S.of(context).thank_you_description_purchase_unsuccess;
      dataMapToShowInDialog.add(MapModel(S.of(context).quotation_no, value: quoteNo));
    } else {
      description = S.of(context).thank_you_description_purchase_success;
      dataMapToShowInDialog.add(MapModel(S.of(context).policy_no, value: policyId));
    }
    dataMapToShowInDialog.add(MapModel(S.of(context).policy_period,
        value:
            '${CommonUtil.instance.convertTo_dd_MM_yyyy(policyPeriod.startDate)} to ${CommonUtil.instance.convertTo_dd_MM_yyyy(policyPeriod.endDate)}'));

    dataMapToShowInDialog.add(MapModel(S.of(context).sum_insured_title,
        value: CommonUtil.instance
            .getCurrencyFormat()
            .format(sumInsuredModel.amount)));
    dataMapToShowInDialog.add(MapModel(S.of(context).amount_paid,
        value: CommonUtil.instance
            .getCurrencyFormat()
            .format(timePeriodModel.total_premium)));

    if(Platform.isIOS){
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return ArogyaPlusThankYouWidget((inf) {
              Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
            }, dataMapToShowInDialog, policyId, description);
          });
    }else{
      showDialog(
          context: context,
          builder: (context) {
            return ArogyaPlusThankYouWidget((inf) {
              Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
            }, dataMapToShowInDialog, policyId, description);
          });
    }
  }
}
