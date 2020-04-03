import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sbig_app/src/controllers/blocs/common_buy_journey/full_quote/full_quote_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/verify_otp/otp_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/payment/arogya_premier_payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_top_up/payment/arogya_top_up_payment_controller.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/arogya_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_period.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/policy_type.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/otp_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/payment.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_model.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/arogya_policy_risk.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/arogya_premier_quick_quote.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_full_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_top_up/arogya_top_up_quick_quote_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/insurance_payment.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/common_buy_journey/arogya_time_period_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/appointee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/member_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/nominee_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/critical_illness/policy_cover_member_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/otp_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insurance_buyer_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_premier/arogya_premier_insure_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/arogya_plus_thank_you_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class ArogyaTopUpPolicySummeryScreen extends StatefulWidgetBase {
  static const ROUTE_NAME = "/arogya_top_up/policy_summery_screen";

  final ArogyaTopUpModel arogyaTopUpModel;

  ArogyaTopUpPolicySummeryScreen(this.arogyaTopUpModel);

  @override
  _PolicySummeryScreenState createState() => _PolicySummeryScreenState();
}

class _PolicySummeryScreenState extends State<ArogyaTopUpPolicySummeryScreen>
    with CommonWidget {
  List<MapModel> premiumList, buyerDetails, coverDetails;
  bool isInsuranceDetailsEditable = true;
  bool isCoverDetailsEditable = true;

  NomineeDetailsModel nomineeDetailsModel;
  List<PolicyCoverMemberModel> policyMembers;
  ArogyaTimePeriodModel timePeriodModel;
  CommunicationDetailsModel communicationDetailsModel;
  ArogyaSumInsuredModel sumInsuredModel;
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

  ArogyaTopUpPaymentController _paymentController;

  BehaviorSubject<bool> _isOtpVerifiedSC = BehaviorSubject.seeded(false);

  Observable<bool> get _isOtpVerifiedStream =>
      _isOtpVerifiedSC.asBroadcastStream();

  final _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    try {
      timePeriodModel = widget.arogyaTopUpModel.selectedTimePeriodModel;
      if (timePeriodModel.totalPremium is! int) {
        timePeriodModel.totalPremium =
            double.parse(timePeriodModel.totalPremium.toString()).floor();
      }

      amount = timePeriodModel.totalPremium;

      nomineeDetailsModel =
          widget.arogyaTopUpModel.buyerDetails.nomineeDetailsModel;
      communicationDetailsModel =
          widget.arogyaTopUpModel.buyerDetails.communicationDetailsModel;
      proposerDetails = widget.arogyaTopUpModel.buyerDetails.proposerDetails;
      personalDetails = widget.arogyaTopUpModel.personalDetails;
      policyMembers = widget.arogyaTopUpModel.policyMembers;
      sumInsuredModel = widget.arogyaTopUpModel.selectedSumInsured;
      policyPeriod = widget.arogyaTopUpModel.policyPeriod;
      policyType = widget.arogyaTopUpModel.policyType;

      firstName = proposerDetails.firstName;
      lastName = proposerDetails.lastName;
      quoteNo = widget.arogyaTopUpModel.quoteNumber;
      phone = widget.arogyaTopUpModel.personalDetails.mobile;
      email = widget.arogyaTopUpModel.personalDetails.email;
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
      MapModel(
         S.of(context).sum_insured_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(sumInsuredModel.amount)),
      MapModel(
          S.of(context).base_premium_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.basicPremium)),
      if(!TextUtils.isEmpty(timePeriodModel.discountPercentage.toString()) && timePeriodModel.discountPercentage.toString().compareTo("0") != 0)
        MapModel(
            S.of(context).tenure_discount_title+'(${timePeriodModel.discountPercentage}%)',
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(sumInsuredModel.amount)),
      if (!TextUtils.isEmpty(timePeriodModel.member_discount_percentage.toString()) && timePeriodModel.member_discount_percentage.toString().compareTo("0") != 0)
        MapModel(
            S.of(context).family_discount_title +
                "(${timePeriodModel.member_discount_percentage}%)",
            value: CommonUtil.instance
                .getCurrencyFormat()
                .format(timePeriodModel.member_discount_value)),
      MapModel(S.of(context).net_premium_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.discountedPremium)),
      MapModel(S.of(context).applicable_tax_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(timePeriodModel.taxAmount)),
    ];

  /*  if (policyType.id == PolicyTypeScreen.FAMILY_INDIVIDUAL) {
      int insertPosition = 2;

      if (!TextUtils.isEmpty(
          timePeriodModel.member_discount_percentage.toString()) &&
          timePeriodModel.member_discount_percentage
              .toString()
              .compareTo("0") !=
              0) {
        premiumList.insert(
            insertPosition,
            MapModel(
                S.of(context).family_discount_title +
                    "(${timePeriodModel.member_discount_percentage}%)",
                value: CommonUtil.instance
                    .getCurrencyFormat()
                    .format(timePeriodModel.member_discount_value)));
        insertPosition = 3;
      }

      if (timePeriodModel.discountPercentage > 0) {
        premiumList.insert(
            insertPosition,
            MapModel(
                S.of(context).long_term_discount_title +
                    "(${timePeriodModel.discountPercentage}%)",
                value: CommonUtil.instance
                    .getCurrencyFormat()
                    .format(timePeriodModel.discountValue)));
      }
    }*/

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

    for (PolicyCoverMemberModel item in policyMembers) {
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
    MapModel policyDuration = MapModel(S
        .of(context)
        .policy_duration,
        value: (timePeriodModel.year==1)?timePeriodModel.year.toString()+' year':timePeriodModel.year.toString()+" years");

    coverDetails.add(policyStartPeriod);
    coverDetails.add(policyEndPeriod);
    coverDetails.add(policyDuration);

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
                                .arogya_top_up_policy
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
                      '${CommonUtil.instance.getCurrencyFormat().format(timePeriodModel.totalPremium)}',
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
                                .insured_member_details
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
                                        ArogyaInsureDetailsScreen.ROUTE_NAME));
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
                          ArogyaPremierInsuranceBuyerDetailsScreen
                              .ROUTE_NAME));
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
//      String customerCode = widgetf
//          .arogyaPremierModel
//          .recalculatePremiumResModel
//          .sbiResponse
//          .quoteResponse
//          .response
//          .payload
//          .createQuoteResponse
//          .policyTerms
//          .customerCode;
//      Map<String, String> body = {
//        "quoteno": widget.arogyaPremierModel.quoteNumber,
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
//          widget.arogyaPremierModel.agentReceiptModel = response;
//          receiptNo =
//              response.data.agentReceiptDetailsResponseBody.payload.receiptNo;
//          description = description + receiptNo;
//          if (_isOtpVerifiedSC.value) {
//            _initiatePayment();
//          } else {
//            _makeOTPApiCall(widget.arogyaPremierModel.personalDetails.mobile,
//                widget.arogyaPremierModel.quoteNumber);
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
        /// API Integration for the Full quote and initiate Payment class
        ArogyaTopUpQuickQuoteReqModel quickQuoteReqModele =
            widget.arogyaTopUpModel.arogyaTopUpQuickQuoteReqModel;
        ArogyaTopUpQuickQuoteResModel quickQuoteResModel =
            widget.arogyaTopUpModel.arogyaTopUpQuickQuoteResModel;

        BuyerDetails buyerDetails = widget.arogyaTopUpModel.buyerDetails;
        NomineeDetailsModel nomineeDetailsModel =
            buyerDetails.nomineeDetailsModel;
        AppointeeDetailsModel appointeeDetailsModel =
            buyerDetails.appointeeDetailsModel;
        CommunicationDetailsModel communicationDetailsModel =
            buyerDetails.communicationDetailsModel;
        PinCodeData pinCodeData = communicationDetailsModel.seletedAreaData;
        List<PolicyCoverMemberModel> policyMembers =
            widget.arogyaTopUpModel.policyMembers;

        ArogyaTopUpFullQuoteReqModel arogyaTopUpFullQuoteReqModel =
        ArogyaTopUpFullQuoteReqModel();
        arogyaTopUpFullQuoteReqModel.arogyaPolicyType = StringConstants.AROGYA_TOP_UP;
        arogyaTopUpFullQuoteReqModel.effectiveDate = quickQuoteReqModele.effectiveDate;
        arogyaTopUpFullQuoteReqModel.expiryDate = quickQuoteReqModele.expiryDate;
        arogyaTopUpFullQuoteReqModel.customerName = proposerDetails.firstName + ' ' + proposerDetails.lastName;
        arogyaTopUpFullQuoteReqModel.firstName = proposerDetails.firstName;
        arogyaTopUpFullQuoteReqModel.middleName = '';
        arogyaTopUpFullQuoteReqModel.lastName = proposerDetails.lastName;
        arogyaTopUpFullQuoteReqModel.genderCode = proposerDetails.gender;
        arogyaTopUpFullQuoteReqModel.dateOfBirth =
            proposerDetails.dobFormat.dob_yyyy_mm_dd;
        arogyaTopUpFullQuoteReqModel.buildingHouseName =
            communicationDetailsModel.buildingName;
        arogyaTopUpFullQuoteReqModel.streetName =
            communicationDetailsModel.streetName;
        arogyaTopUpFullQuoteReqModel.postCode =
            communicationDetailsModel.pinCode;
        arogyaTopUpFullQuoteReqModel.city = pinCodeData.CITY_NM;
        arogyaTopUpFullQuoteReqModel.state = pinCodeData.STATE_CD;
        arogyaTopUpFullQuoteReqModel.mobile = quickQuoteReqModele.mobile;
        arogyaTopUpFullQuoteReqModel.email = quickQuoteReqModele.email;
        arogyaTopUpFullQuoteReqModel.plotNo = communicationDetailsModel.plotNo;
        arogyaTopUpFullQuoteReqModel.eIANumber = widget.arogyaTopUpModel.eiaModel.eiaNumber;
        arogyaTopUpFullQuoteReqModel.duration = quickQuoteReqModele.duration;
        arogyaTopUpFullQuoteReqModel.policyType = quickQuoteReqModele.policyType;
        arogyaTopUpFullQuoteReqModel.agentCode=proposerDetails.agentCode??'';


        List<PolicyRiskList> list = quickQuoteReqModele.policyRiskList;
        if (list != null) {
          for (var i = 0; i < list.length; i++) {
            PolicyRiskList policyRiskList = list[i];
            policyRiskList.insuredName =
                proposerDetails.firstName + ' ' + proposerDetails.lastName;

            if (nomineeDetailsModel.relationshipWith.startsWith("Child")) {
              policyRiskList.nomineeRelToProposer =
              nomineeDetailsModel.gender == "M" ? "Son" : "Daughter";
            } else if (nomineeDetailsModel.relationshipWith
                .compareTo(S.of(context).father_in_law_title) ==
                0) {
              policyRiskList.nomineeRelToProposer = "Father_In_Law";
            } else if (nomineeDetailsModel.relationshipWith
                .compareTo(S.of(context).mother_in_law_title) ==
                0) {
              policyRiskList.nomineeRelToProposer = "Mother_In_Law";
            } else {
              policyRiskList.nomineeRelToProposer =
                  nomineeDetailsModel.relationshipWith;
            }

            policyRiskList.nomineeName =
            "${nomineeDetailsModel.firstName} ${nomineeDetailsModel.lastName}";
            policyRiskList.nomineeDOB =
            "${nomineeDetailsModel.dobFormat.dob_yyyy_mm_dd}";
            policyRiskList.nomineeGender = nomineeDetailsModel.gender;
            if (appointeeDetailsModel != null) {
              policyRiskList.appointeeName =
              "${appointeeDetailsModel.firstName} ${appointeeDetailsModel.lastName}";
              policyRiskList.appointeeRelToNominee =
                  appointeeDetailsModel.relationshipWith;
            }
          }
        }
        arogyaTopUpFullQuoteReqModel.policyRiskList=list;

        showLoaderDialog(context);
        FullQuoteApiProvider.getInstance()
            .calculateArogyaTopUpFullQuote(
            arogyaTopUpFullQuoteReqModel.toJson())
            .then((response) {
          if (null == response.apiErrorModel) {

            widget.arogyaTopUpModel.arogyaTopUpFullQuoteResModel = response;
            widget.arogyaTopUpModel.quoteNumber = response.data.quotationNumber;
            quoteNo=widget.arogyaTopUpModel.quoteNumber;

            if (_isOtpVerifiedSC.value) {

              _initiatePayment();
            } else {
              _makeOTPApiCall(widget.arogyaTopUpModel.personalDetails.mobile,
                  widget.arogyaTopUpModel.quoteNumber ?? '', null);
            }
          } else {
            hideLoaderDialog(context);
            handleApiError(context, 0, (int retryIdentifier) {
              onProceedBuy();
            }, response.apiErrorModel.statusCode);

            if (response.apiErrorModel.statusCode ==
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
            }
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
      handleApiError(
          context, 0, retryIdentifier, response.apiErrorModel.statusCode);
    } else {
      if (response.success) {
        String otp = response.otp ?? '';
        _navigateToOptScreen(mobileNo, otp, quoteNo, partyID);
        /*Future.delayed(Duration(milliseconds: 100)).then((onValue) {
          //Navigator.pushNamed(context, OTPScreen.ROUTE_NAME,arguments: OTPScreenArguments(mobileNo,otp, widget.arogyaPremierModel));
          _navigateToOptScreen(mobileNo, otp, quoteNo, partyID);
        });*/
      }
    }
  }

  void _navigateToOptScreen(String mobileNo, String otp, String quoteNo, String partyID) async {
    final returnData = await Navigator.pushNamed(context, OTPScreen.ROUTE_NAME,
        arguments: OTPScreenArguments(mobileNo, quoteNo, partyID, null));
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

    PaymentControllerDataModel _pcDataModel = PaymentControllerDataModel(
      amount: amount,
      firstName: firstName,
      lastName: lastName,
      quoteNo: quoteNo,
      phone: phone,
      email: email,
      desc: "",
      customerCode: '',
    );
    _paymentController = ArogyaTopUpPaymentController(
        _pcDataModel, _handlePaymentSuccess , _handlePaymentFailure);
    _paymentController.initiatePayment();
  }

  _handlePaymentSuccess( dynamic successResponse) {
    hideLoaderDialog(context);
    InsurancePaymentResModel response= successResponse;
    _showPurchaseSuccessDialog(response);
  }

  _handlePaymentFailure(ApiErrorModel errorModel) {
    hideLoaderDialog(context);
    if (errorModel.statusCode ==
        ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
      showNoInternetDialog(context, 2, (id) {
        if (_paymentController.currentStep ==
            PaymentSteps.PAYMENT_VERIFICATION) {
          _paymentController.callPaymentVerificationApi();
        } else {
          _initiatePayment();
        }
      });
    } else if (errorModel.statusCode ==
        PaymentController.PAYMENT_VERIFICATION_FAILED) {
      _showPurchaseSuccessDialog(null);
    } else {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: Text(S.of(context).payment_failure),
      ));
    }
  }

  void _showPurchaseSuccessDialog(InsurancePaymentResModel successResponse) {
    List<MapModel> dataMapToShowInDialog = [];
    String policyId = "";
    String description;
    if (successResponse != null) {
      policyId =
          successResponse.data.policyNo;
      policyId =
          successResponse.data.policyId.toString();
    }
    if (TextUtils.isEmpty(policyId)) {
      description = S.of(context).thank_you_description_purchase_unsuccess;
      dataMapToShowInDialog
          .add(MapModel(S.of(context).quotation_no, value: quoteNo));
    } else {
      description = S.of(context).thank_you_description_purchase_success;
      dataMapToShowInDialog
          .add(MapModel(S.of(context).policy_no, value: policyId));
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
            .format(timePeriodModel.totalPremium)));

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return ArogyaPlusThankYouWidget((inf) {
              Navigator.popUntil(
                  context, ModalRoute.withName(HomeScreen.ROUTE_NAME));
            }, dataMapToShowInDialog, policyId, description);
          });
    } else {
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
