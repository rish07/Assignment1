import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_controller.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_premier/payment/arogya_premier_payment_api_provider.dart';
import 'package:sbig_app/src/controllers/blocs/home/critical_illness/payment/critical_payment_api_provider.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_premier/payment_model.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/insurance_payment.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class ArogyaPremierPaymentController extends PaymentController {
  ArogyaPremierPaymentController(PaymentControllerDataModel dataModel,
      handlePaymentSuccess, handlePaymentFailure)
      : super(dataModel, handlePaymentSuccess, handlePaymentFailure,
            isPaymentSuccessOverridden: true);

  InsurancePayment _paymentInsuranceOldRequest;

  void initiatePayment() {
    getRazorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    super.initiatePayment();
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) async {
    PaymentSuccessResponse _response = response;
    debugPrint(
        "RENEWAL PAYMENT SUCCESS FROM GATEWAY -> Payment id: ${response.paymentId} | Order id: ${response.orderId} | Signature: ${response.signature}");
    _paymentInsuranceOldRequest = InsurancePayment(
        quotationNo: getDataModel.quoteNo,
        amount: getDataModel.amount.toString(),
        paymentReferNo: _response.orderId);
    callPaymentVerificationApi();
  }

  void callPaymentVerificationApi() async {
    setCurrentStep = PaymentSteps.PAYMENT_VERIFICATION;
    if (_paymentInsuranceOldRequest != null) {
      ParsedResponse<InsurancePaymentResModel> response = await ArogyaPremierPaymentApiProvider()
          .paymentStatusCheckApiCall(
          _paymentInsuranceOldRequest);

      if (response.hasData) {
        if (response.data.success) {
          dynamic data = response.data;
          getPaymentSuccess(data);
        } else {
          getPaymentFailure(ApiErrorModel(response.error.message,
              PaymentController.PAYMENT_VERIFICATION_FAILED));
        }
      } else {
        getPaymentFailure(ApiErrorModel(response.error.message,
            PaymentController.PAYMENT_VERIFICATION_FAILED));
      }
    } else {
      getPaymentFailure(
          ApiErrorModel('', PaymentController.PAYMENT_VERIFICATION_FAILED));
    }
  }


}
