import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/renewals/renewals_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_update_details_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class RenewalPaymentController extends PaymentController {
  String policyNumber;
  PaymentControllerDataModel _dataModel;
  OrderIdGenerationResponse _orderIdResponseData;
  int amount;
  Function(ApiErrorModel) _handlePaymentFailure;
  Function(RenewalUpdateDetailsResModel) handleRenewalJourneyError;
  RenewalUpdateDetailsReqModel renewalUpdateDetailsReqModel;
  PaymentSuccessResponse response;
  PaymentSteps _currentStep = PaymentSteps.INITIAL;

  RenewalPaymentController(
      PaymentControllerDataModel dataModel,
      handlePaymentSuccess,
      handlePaymentFailure,
      String policyNumber,
      OrderIdGenerationResponse _orderIdResponseData,
      int amount,
      RenewalUpdateDetailsReqModel renewalUpdateDetailsReqModel, Function(RenewalUpdateDetailsResModel) handleRenewalJourneyError)
      : super(dataModel, handlePaymentSuccess, handlePaymentFailure,
            isPaymentSuccessOverridden: true) {
    this.policyNumber = policyNumber;
    this._dataModel = _dataModel;
    this.amount;
    this._orderIdResponseData = _orderIdResponseData;
    this._handlePaymentFailure = _handlePaymentFailure;
    this.renewalUpdateDetailsReqModel = renewalUpdateDetailsReqModel;
    this.handleRenewalJourneyError = handleRenewalJourneyError;
  }

  RenewalPaymentStatusCheckRequest renewalPaymentStatusCheckRequest;

  void initiatePayment() {
    getRazorPay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    _initiatePayment();
  }

  /// Payment process starts here
  /// **** Step 1 ****
  void _initiatePayment() async {
//    //_currentStep = PaymentSteps.ORDER_ID;
//    ParsedResponse<OrderIdGenerationResponse> orderIdResponse =
//    await getPaymentApiProvider.callOrderIdGenerationApi(_dataModel.quoteNo, _dataModel.amount*100);
//
//    if (orderIdResponse.hasData) {
//      _orderIdData = orderIdResponse.data.data;
//      int amountToPass = (_orderIdData.amountDue * 100);
//      print("amountToPass "+amountToPass.toString());
//
//      openCheckout(
//          _orderIdData.id,
//          amountToPass,
//          _orderIdData.currency,
//          _dataModel.phone,
//          _dataModel.email,
//          _dataModel.desc,
//          orderIdResponse.data.razorPayKey);
//    } else {
//      _handlePaymentFailure(orderIdResponse.error);
//    }
    var _orderIdData = _orderIdResponseData.data;
    openCheckout(
        _orderIdData.id,
        amount,
        _orderIdData.currency,
        renewalUpdateDetailsReqModel.mobile,
        renewalUpdateDetailsReqModel.email,
        "",
        _orderIdResponseData.razorPayKey);
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint(
        "RENEWAL PAYMENT SUCCESS FROM GATEWAY -> Payment id: ${response.paymentId} | Order id: ${response.orderId} | Signature: ${response.signature}");

    this.response = response;
    renewalUpdateDetailsReqModel.transactionId = response.paymentId;
    callRenewalJourney();
  }

  void callRenewalJourney(){
    renewalPaymentStatusCheckRequest = RenewalPaymentStatusCheckRequest(
        transactionId: response.paymentId,
        policyNumber: policyNumber,
        name: getDataModel.firstName,
        quote_no: getDataModel.quoteNo,
        amount: getDataModel.amount.toString());

    RenewalsPolicyDetailsApiProvider.getInstance()
        .updateRenewalPolicyDetails(renewalUpdateDetailsReqModel.toJson())
        .then((response) {
      if (null != response.apiErrorModel) {
        handleRenewalJourneyError(response);
      } else {
        callRenewalPaymentVerificationApi();
      }
    });
  }

  void callRenewalPaymentVerificationApi() async {
    setCurrentStep = PaymentSteps.PAYMENT_VERIFICATION;

    RenewalsPolicyDetailsApiProvider.getInstance()
        .doPaymentVerification(renewalPaymentStatusCheckRequest.toJson())
        .then((response) {
      if (response.apiErrorModel != null) {
        getPaymentFailure(ApiErrorModel(response.apiErrorModel.message,
            PaymentController.PAYMENT_VERIFICATION_FAILED));
      } else {
        getPaymentSuccess(response.data);
      }
    });
  }
}
