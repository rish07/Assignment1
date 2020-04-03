import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:sbig_app/src/controllers/blocs/base_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/personal_details/personal_details_bloc.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewal_payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_bloc.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_req_res_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_update_details_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/models/common/map_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/communication_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/proposer_details_model.dart';
import 'package:sbig_app/src/models/widget_models/home/arogya_plus/sum_insured_model.dart';
import 'package:sbig_app/src/models/widget_models/home/general_list_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/insurance_buyer_details.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/otp_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/personal_details_screen.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/tax_benefits_dialog.dart';
import 'package:sbig_app/src/ui/screens/home/home_screen.dart';
import 'package:sbig_app/src/ui/screens/home/renewals/renewal_eia_number_screen.dart';
import 'package:sbig_app/src/ui/widgets/common/common_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/arogya_plus_thank_you_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/arogya_plus/black_button_widget.dart';
import 'package:sbig_app/src/ui/widgets/home/home_tab/renewals/renewal_update_details_dialog.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';
import 'package:sbig_app/src/utilities/screen_util.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class RenewalPolicySummeryScreen extends StatelessWidget {
  static const ROUTE_NAME = "/renewals/policy_summery_screen";

  final RenewalReqResModel renewalReqResModel;

  RenewalPolicySummeryScreen(this.renewalReqResModel);

  @override
  Widget build(BuildContext context) {
    return SbiBlocProvider(
      child: RenewalPolicySummeryScreenWidget(renewalReqResModel),
      bloc: RenewalsBloc(),
    );
  }
}

class RenewalPolicySummeryScreenWidget extends StatefulWidgetBase {
  final RenewalReqResModel renewalReqResModel;

  RenewalPolicySummeryScreenWidget(this.renewalReqResModel);

  @override
  _RenewalPolicySummeryScreenWidgetState createState() =>
      _RenewalPolicySummeryScreenWidgetState();
}

class _RenewalPolicySummeryScreenWidgetState
    extends State<RenewalPolicySummeryScreenWidget> with CommonWidget {
  List<MapModel> premiumList, buyerDetails, coverDetails;
  bool isInsuranceDetailsEditable = true;

  List<GeneralListModel> policyMembers;
  CommunicationDetailsModel communicationDetailsModel;
  SumInsuredModel sumInsuredModel;
  PersonalDetails personalDetails;
  ProposerDetailsModel proposerDetails;
  double deviceWidth;

  String quoteNo = "";
  String phone = "";
  String email = "";
  String description = "receipt no: ";
  int amount;

  //bool isRenewalApplicable = false;

  RenewalPaymentController _paymentController;

  final _scaffoldState = GlobalKey<ScaffoldState>();

  RenewalPolicyData renewalPolicyData;
  RenewalPolicyDetailsReqModel renewalPolicyDetailsReqModel;

  RenewalsBloc _renewalsBloc;

  @override
  void initState() {
    try {
      _renewalsBloc = SbiBlocProvider.of<RenewalsBloc>(context);
      renewalPolicyData =
          widget.renewalReqResModel.renewalPolicyDetailsResModel;
      renewalPolicyDetailsReqModel =
          widget.renewalReqResModel.renewalPolicyDetailsReqModel;

      //firstName = proposerDetails.firstName;
      //lastName = proposerDetails.lastName;
      quoteNo = renewalPolicyData.renewalQuoteNumber;
      phone = renewalPolicyData.mobile ?? "";
      email = renewalPolicyData.email ?? "";
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
      MapModel(S.of(context).product_name,
          value: renewalPolicyData.productName),
      MapModel(S.of(context).sum_insured_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(double.parse(renewalPolicyData.sumInsured))),
      MapModel(S.of(context).gross_premium,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(double.parse(renewalPolicyData.annualGrossPremium))),
      MapModel(S.of(context).applicable_tax_title,
          value: CommonUtil.instance
              .getCurrencyFormat()
              .format(double.parse(renewalPolicyData.GST))),
    ];

    buyerDetails = [
      MapModel(S.of(context).email_id, value: email),
      MapModel(S.of(context).mobile_no, value: phone),
    ];

    MapModel customerNameModel = MapModel(S.of(context).customer_name,
        value: renewalPolicyData.customerName);

    DateTime renewalDueDate = CommonUtil.instance
        .parseDateYYYY_MM_DD_TIME(renewalPolicyData.renewalDueDate);

    MapModel renewalDueDateModel = MapModel(S.of(context).renewal_due_date,
        value: CommonUtil.instance.convertTo_dd_MMM_yyyy(renewalDueDate));

    MapModel policyNumberModel = MapModel(S.of(context).renewal_policy_number,
        value: renewalPolicyData.previousPolicyNo);

    coverDetails.add(customerNameModel);
    coverDetails.add(renewalDueDateModel);
    coverDetails.add(policyNumberModel);

//    bool isBefore = renewalDueDate.isBefore(DateTime.now());
//    Duration duration = renewalDueDate.difference(DateTime.now());
//    int difference = duration.inDays;
//
//    if(isBefore){
//      if(difference >=0  && difference <=60){
//        isRenewalApplicable = true;
//      }
//    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      resizeToAvoidBottomPadding: false,
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
                    context, S.of(context).renewal_title.toUpperCase(),
                    titleColor: Colors.white),
                Container(
                  height: ScreenUtil.getInstance(context).screenHeightDp -  150,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      policySummeryWidget(),
                      SizedBox(
                        height: 50,
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
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                            S.of(context).premium_details_title.toUpperCase(),
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
                      '${CommonUtil.instance.getCurrencyFormat().format(double.parse(renewalPolicyData.renewalPremiumAmount))}',
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
                                  .communication_details_title
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
                                RenewalUpdateDetailsDialog()
                                    .showRenewalUpdateDetailsDialog(context,
                                        phone, email, PersonalDetailsBloc(),
                                        (String mobile, String emailAddress) {
                                  this.email = emailAddress;
                                  this.phone = mobile;
                                  setState(() {
                                    this.email = emailAddress;
                                    this.phone = mobile;
                                  });
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
                        buyerDetails[index], 100, false, true);
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
                            S.of(context).policy_details_title.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                                letterSpacing: 1.0),
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
                        coverDetails[index], 115, false, false);
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
              isFromPremiumDetails ? mapItem.key : "${mapItem.key}",
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

  _apiCallToUpdateRenewalPolicyDetails() {

    Navigator.of(context).pushNamed(RenewalEIANumberScreen.ROUTE_NAME,
        arguments: EiaScreenArguments(
            navigateToOtpScreen: _navigateToOptScreen,
            policyNumber: renewalPolicyDetailsReqModel.policyNumber,
            quoteNumber: quoteNo,
            mobileNumber: phone));


//    onRetry(int from) {
//      _apiCallToUpdateRenewalPolicyDetails();
//    }
//
//    showLoaderDialog(context);
//    RenewalUpdateDetailsReqModel renewalUpdateDetailsReqModel =
//    RenewalUpdateDetailsReqModel();
//    renewalUpdateDetailsReqModel.policyNumber =
//        renewalPolicyDetailsReqModel.policyNumber;
//    renewalUpdateDetailsReqModel.policytype = "Health";
//    renewalUpdateDetailsReqModel.productCode =
//        renewalPolicyDetailsReqModel.productCode;
//    renewalUpdateDetailsReqModel.email = email;
//    renewalUpdateDetailsReqModel.mobile = phone;
//    renewalUpdateDetailsReqModel.source = "razorpay";
//    renewalUpdateDetailsReqModel.amount =
//        renewalPolicyData.renewalPremiumAmount;
//
//    _renewalsBloc
//        .updatePolicyDetails(renewalUpdateDetailsReqModel.toJson())
//        .then((response) {
//      hideLoaderDialog(context);
//      //***************************************************************CHANGE TO != ***************************************************************
//      if (null != response.apiErrorModel) {
//        handleApiError(context, 0, onRetry, response.apiErrorModel.statusCode,
//            message: response.apiErrorModel.message);
//      } else {
//        Navigator.of(context).pushNamed(RenewalEIANumberScreen.ROUTE_NAME,
//            arguments: EiaScreenArguments(
//                navigateToOtpScreen: _navigateToOptScreen,
//                policyNumber: renewalPolicyDetailsReqModel.policyNumber,
//                quoteNumber: quoteNo,
//                mobileNumber: phone));
//      }
//    });
  }

  handleRenewalJourneyUpdateError(RenewalUpdateDetailsResModel response){
    onRetry(int from) {
      _apiCallToUpdateRenewalPolicyDetails();
    }
    handleApiError(context, 0, onRetry, response.apiErrorModel.statusCode,
        message: response.apiErrorModel.message);
  }

//  _apiCallToUpdateRenewalPolicyDetails() {
//    onRetry(int from) {
//      _apiCallToUpdateRenewalPolicyDetails();
//    }
//
//    showLoaderDialog(context);
//    RenewalUpdateDetailsReqModel renewalUpdateDetailsReqModel =
//        RenewalUpdateDetailsReqModel();
//    renewalUpdateDetailsReqModel.policyNumber =
//        renewalPolicyDetailsReqModel.policyNumber;
//    renewalUpdateDetailsReqModel.policytype = "Health";
//    renewalUpdateDetailsReqModel.productCode =
//        renewalPolicyDetailsReqModel.productCode;
//    renewalUpdateDetailsReqModel.email = email;
//    renewalUpdateDetailsReqModel.mobile = phone;
//    renewalUpdateDetailsReqModel.source = "razorpay";
//    renewalUpdateDetailsReqModel.amount =
//        renewalPolicyData.renewalPremiumAmount;
//
//    _renewalsBloc
//        .updatePolicyDetails(renewalUpdateDetailsReqModel.toJson())
//        .then((response) {
//      hideLoaderDialog(context);
//      //***************************************************************CHANGE TO != ***************************************************************
//      if (null != response.apiErrorModel) {
//        handleApiError(context, 0, onRetry, response.apiErrorModel.statusCode,
//            message: response.apiErrorModel.message);
//      } else {
//        Navigator.of(context).pushNamed(RenewalEIANumberScreen.ROUTE_NAME,
//            arguments: EiaScreenArguments(
//                navigateToOtpScreen: _navigateToOptScreen,
//                policyNumber: renewalPolicyDetailsReqModel.policyNumber,
//                quoteNumber: quoteNo,
//                mobileNumber: phone));
//      }
//    });
//  }

//  Future<ApiErrorModel> _callBackFromEIAScreen(String eiaNumber) {
//    return _makeOTPApiCall(phone, quoteNo);
//  }

  _showButton() {
    onProceedBuy() {
      _apiCallToUpdateRenewalPolicyDetails();
    }

    return BlackButtonWidget(
      onProceedBuy,
      S.of(context).proceed_to_buy.toUpperCase(),
      bottomBgColor: Colors.transparent,
    );
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

//  Future<ApiErrorModel> _makeOTPApiCall(String mobileNo, String quoteNo) async {
//    retryIdentifier(int identifier) {
//      _makeOTPApiCall(mobileNo, quoteNo);
//    }
//
//    OTPRequestModel otpRequestModel =
//        OTPRequestModel(mobile: mobileNo, quoteno: quoteNo);
//    final response = await OTPApiProvider.getInstance().getOTP(otpRequestModel);
//    //hideLoaderDialog(context);
//    if (null != response.apiErrorModel) {
//      return Future.value(response.apiErrorModel);
////      handleApiError(
////          context, 0, retryIdentifier, response.apiErrorModel.statusCode, message: response.apiErrorModel.message);
//    } else {
//      if (response.success) {
//        String otp = response.otp ?? '';
//        _navigateToOptScreen(mobileNo, otp, quoteNo);
//      }
//    }
//    return null;
//  }

  void _navigateToOptScreen(String mobileNo, String otp, String quoteNo) async {
    final returnData = await Navigator.pushNamed(context, OTPScreen.ROUTE_NAME,
        arguments: OTPScreenArguments(mobileNo, quoteNo, null, null));
    if (returnData != null) {
      OtpScreenReturnDataModel returnDataFromOtp =
          returnData as OtpScreenReturnDataModel;
      if (returnDataFromOtp.isSuccess) {
        //_isOtpVerifiedSC.add(true);
        //otp verify is definitely success
        _initiatePayment();
        return;
      }
    }
    //_isOtpVerifiedSC.add(false);
  }

  void _initiatePayment() async{
    showLoaderDialog(context);

    String customerCode = "";
    if (TextUtils.isEmpty(customerCode)) {
      customerCode = "";
    }
    PaymentControllerDataModel _pcDataModel = PaymentControllerDataModel(
        amount: int.parse(renewalPolicyData.renewalPremiumAmount),
        firstName: renewalPolicyData.customerName,
        lastName: "",
        quoteNo: quoteNo,
        phone: phone,
        email: email,
        desc: "",
        customerCode: customerCode);

    ParsedResponse<OrderIdGenerationResponse> orderIdResponse =
        await PaymentApiProvider().callOrderIdGenerationApi(quoteNo, int.parse(renewalPolicyData.renewalPremiumAmount)*100);

    if (orderIdResponse.hasData) {
//      onRetry(int from) {
//       // _apiCallToUpdateRenewalPolicyDetails();
//        _initiatePayment();
//      }

      showLoaderDialog(context);
      RenewalUpdateDetailsReqModel renewalUpdateDetailsReqModel =
      RenewalUpdateDetailsReqModel();
      renewalUpdateDetailsReqModel.policyNumber =
          renewalPolicyDetailsReqModel.policyNumber;
      renewalUpdateDetailsReqModel.policytype = "Health";
      renewalUpdateDetailsReqModel.productCode =
          renewalPolicyDetailsReqModel.productCode;
      renewalUpdateDetailsReqModel.email = email;
      renewalUpdateDetailsReqModel.mobile = phone;
      renewalUpdateDetailsReqModel.source = "razorpay";
      renewalUpdateDetailsReqModel.amount =
          renewalPolicyData.renewalPremiumAmount;

      _paymentController = RenewalPaymentController(
          _pcDataModel,
          _handlePaymentSuccess,
          _handlePaymentFailure,
          renewalPolicyData.previousPolicyNo, orderIdResponse.data, int.parse(renewalPolicyData.renewalPremiumAmount)*100, renewalUpdateDetailsReqModel, handleRenewalJourneyError);

      _paymentController.initiatePayment();

//      _renewalsBloc
//          .updatePolicyDetails(renewalUpdateDetailsReqModel.toJson())
//          .then((response) {
//        hideLoaderDialog(context);
//        //***************************************************************CHANGE TO != ***************************************************************
//        if (null != response.apiErrorModel) {
//          handleApiError(context, 0, onRetry, response.apiErrorModel.statusCode,
//              message: response.apiErrorModel.message);
//        } else {
//          _paymentController = RenewalPaymentController(
//              _pcDataModel,
//              _handlePaymentSuccess,
//              _handlePaymentFailure,
//              renewalPolicyData.previousPolicyNo, orderIdResponse as OrderIdGenerationResponse, int.parse(renewalPolicyData.renewalPremiumAmount)*100);
//
//          _paymentController.initiatePayment();
//        }
      //});
    }else{
      hideLoaderDialog(context);
      _handlePaymentFailure(orderIdResponse.error);
    }
  }

  void handleRenewalJourneyError(RenewalUpdateDetailsResModel response){
    hideLoaderDialog(context);
    retry(int from){
      _paymentController.callRenewalJourney();
    }
    handleApiError(context, 0, retry, response.apiErrorModel.statusCode,
        message: response.apiErrorModel.message);
  }

  void _handlePaymentSuccess(dynamic successResponse) {
    hideLoaderDialog(context);
    _showPurchaseSuccessDialog(successResponse as RenewalData);
  }

  void _handlePaymentFailure(ApiErrorModel errorModel) {
    retry(int from) {
      _initiatePayment();
    }

    hideLoaderDialog(context);
    if (errorModel.statusCode ==
        ApiResponseListenerDio.NO_INTERNET_CONNECTION) {
      showNoInternetDialog(context, 2, (id) {
        if (_paymentController.currentStep ==
            PaymentSteps.PAYMENT_VERIFICATION) {
          _paymentController.callRenewalPaymentVerificationApi();
        } else {
          _initiatePayment();
        }
      });
//    } else if (errorModel.statusCode ==
//        PaymentController.PAYMENT_VERIFICATION_FAILED) {
//      //_showPurchaseSuccessDialog(null);
//
    } else {
//      _scaffoldState.currentState.showSnackBar(SnackBar(
//        content: Text(errorModel.message ?? S.of(context).payment_failure),
//      ));
      int statusCode = errorModel.statusCode;
      handleApiError(context, 1, retry, statusCode,
          message: errorModel.message ?? S.of(context).payment_failure,
          title: (statusCode == 400) ? "Payment Error" : "");
    }
  }

  void _showPurchaseSuccessDialog(RenewalData successResponse) {
    List<MapModel> dataMapToShowInDialog = [];
    String policyId = "";
    String description;
    if (successResponse != null) {
      policyId = successResponse.renewedPolicyNo;

      description = S.of(context).thank_you_description_purchase_success;
      dataMapToShowInDialog
          .add(MapModel(S.of(context).policy_no, value: policyId));
      // }
//    dataMapToShowInDialog.add(MapModel(S.of(context).policy_period,
//        value:
//            '${CommonUtil.instance.convertTo_dd_MM_yyyy(DateTime.now())} to ${CommonUtil.instance.convertTo_dd_MM_yyyy(DateTime.now())}'));

      dataMapToShowInDialog.add(MapModel(S.of(context).sum_insured_title,
          value: CommonUtil.instance.getCurrrencyFormattedString(
              double.parse(renewalPolicyData.sumInsured))));

      dataMapToShowInDialog.add(MapModel(S.of(context).amount_paid,
          value: CommonUtil.instance.getCurrrencyFormattedString(
              double.parse(successResponse.amount))));

      dataMapToShowInDialog.add(MapModel(S.of(context).product_name,
          value: successResponse.productName));

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
}
