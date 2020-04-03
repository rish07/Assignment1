import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/payment/payment_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_payment.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class PaymentController {

  static const PAYMENT_VERIFICATION_FAILED = 11;

  final Function(dynamic) _handlePaymentSuccess;

  //final Function(Data) _handleRenewalPaymentSuccess;
  Function(dynamic) get getPaymentSuccess => _handlePaymentSuccess;

  final Function(ApiErrorModel) _handlePaymentFailure;

  Function(ApiErrorModel) get getPaymentFailure => _handlePaymentFailure;

  final PaymentControllerDataModel _dataModel;

  PaymentControllerDataModel get getDataModel => _dataModel;

  OrderIdData _orderIdData;

  OrderIdData get getOrderIdData => _orderIdData;

  PaymentApiProvider _paymentApiProvider;

  PaymentApiProvider get getPaymentApiProvider => _paymentApiProvider;

  Razorpay _razorpay;

  Razorpay get getRazorPay => _razorpay;

  PaymentSteps _currentStep = PaymentSteps.INITIAL;
  PaymentSteps get currentStep => _currentStep;

  set setCurrentStep(PaymentSteps step) =>  _currentStep = step;

  PaymentStatusCheckRequest _paymentStatusCheckOldRequest;

  PaymentController(
      this._dataModel, this._handlePaymentSuccess, this._handlePaymentFailure, {isPaymentSuccessOverridden = false}) {
    _paymentApiProvider = PaymentApiProvider();
    _razorpay = Razorpay();

    if(!isPaymentSuccessOverridden) {
      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
    }
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
  }

  void initiatePayment() {
    _initiatePayment();
  }

  /// Payment process starts here
  /// **** Step 1 ****
  void _initiatePayment() async {
//    double var0 = double.tryParse(_dataModel.amount);
//    if(var0 == null) {
//      Crashlytics.instance.log("Unable to proceed to payment cause unable to parse amount string (${_dataModel.amount} to double)");
//      _handlePaymentFailure(ApiErrorModel("Error"));
//      return;
//    }
//
//    int amountToPass = (var0 * 100).floor();
    _currentStep = PaymentSteps.ORDER_ID;
    ParsedResponse<OrderIdGenerationResponse> orderIdResponse =
    await _paymentApiProvider.callOrderIdGenerationApi(_dataModel.quoteNo, _dataModel.amount*100);

    if (orderIdResponse.hasData) {
      /// ***** Step 2 *****
      /// Opening checkout with the order id
      _orderIdData = orderIdResponse.data.data;

      print("_orderIdData "+_orderIdData.receipt.toString());
      print("_orderIdData "+_orderIdData.currency.toString());
//      double var0 = double.tryParse(_orderIdData.amountDue);
//      if(var0 == null) {
//        Crashlytics.instance.log("Unable to proceed to payment cause unable to parse amount string (${_dataModel.amount} to double)");
//        _handlePaymentFailure(ApiErrorModel("Error"));
//        return;
//      }

      int amountToPass = (_orderIdData.amountDue * 100);
      print("amountToPass "+amountToPass.toString());
      openCheckout(
          _orderIdData.id,
          amountToPass,
          _orderIdData.currency,
          _dataModel.phone,
          _dataModel.email,
          _dataModel.desc,
          orderIdResponse.data.razorPayKey);
    } else {
      _handlePaymentFailure(orderIdResponse.error);
    }
  }

  void openCheckout(String orderId, int amount, String currency, String phone,
      String email, String description, String razorPayKey) {
    var options = {
      'key': razorPayKey,
      'currency': currency,
      'amount': amount,
      'order_id': orderId,
      'name': 'SBI General Insurance',
      'description': description,
      'prefill': {'contact': phone, 'email': email}
    };

    print(options["key"]);
    print(options["currency"]);
    print(options["amount"]);
    print(options["order_id"]);
    print(options["name"]);
    print(options["description"]);

    _currentStep = PaymentSteps.PAYMENT_GATEWAY;

    _razorpay.open(options);
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) async {
//    debugPrint(
//        "PAYMENT SUCCESS FROM GATEWAY -> Payment id: ${response.paymentId} | Order id: ${response.orderId} | Signature: ${response.signature}");

    /// **** Step 3 ****
    /// Verifying payment status
    _paymentStatusCheckOldRequest = PaymentStatusCheckRequest(
        firstName: _dataModel.firstName,
        lastName: _dataModel.lastName,
        email: _dataModel.email,
        phone: _dataModel.phone,
        amount: _orderIdData.amountDue,
        quote_no: _dataModel.quoteNo,
        recieptNo: _orderIdData.receipt,
        hash: response.signature,
        paymentId: response.paymentId,
        orderId: response.orderId,
        customerCode: _dataModel.customerCode);

    callPaymentVerificationApi();
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
//    debugPrint(
//        "PAYMENT ERROR => Code: ${response.code} | Message: ${response.message}");
    _handlePaymentFailure(ApiErrorModel(response.message, response.code));
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    //debugPrint("PAYMENT EXTERNAL WALLET=> Wallet name: ${response.walletName}");
    _handlePaymentFailure(ApiErrorModel("Sorry! Payment failed. Please try another payment method", 20));
  }

  /// API call to verify is payment is valid or not.
  void callPaymentVerificationApi() async {
    _currentStep = PaymentSteps.PAYMENT_VERIFICATION;
    if(_paymentStatusCheckOldRequest != null) {
      ParsedResponse<PaymentStatusCheckResponse> parsedResponse =
      await _paymentApiProvider.paymentStatusCheckApiCall(_paymentStatusCheckOldRequest);

      if(parsedResponse.hasData) {
        if(parsedResponse.data.success) {
          _handlePaymentSuccess(parsedResponse.data);
        } else {
          _handlePaymentFailure(ApiErrorModel(parsedResponse.data.message, PAYMENT_VERIFICATION_FAILED));
        }
      } else {
        ApiErrorModel _aem = parsedResponse.error;
        _aem.statusCode = _aem.statusCode ?? 400;
        _handlePaymentFailure(_aem);
      }
    } else {
      _handlePaymentFailure(ApiErrorModel("", ApiResponseListenerDio.UNKNOWN));
    }
  }
}

class PaymentControllerDataModel {
  final String firstName, lastName, quoteNo, phone, email, desc;
  final int amount;
  final String customerCode;

  PaymentControllerDataModel({this.amount, this.firstName, this.lastName,
      this.quoteNo, this.phone, this.email, this.desc, this.customerCode});
}

enum PaymentSteps {INITIAL, ORDER_ID, PAYMENT_GATEWAY, PAYMENT_VERIFICATION}