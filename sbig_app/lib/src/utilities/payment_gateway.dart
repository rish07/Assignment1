import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class PaymentGateway {
  Razorpay _razorpay;

  final Function(PaymentSuccessResponse) _paymentSuccessCallback;
  final Function(PaymentFailureResponse) _paymentFailureCallback;
  final Function(ExternalWalletResponse) _externalWalletResponseCallback;
  PaymentGateway(this._paymentSuccessCallback, this._paymentFailureCallback, this._externalWalletResponseCallback) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(String orderId,int amount, String currency, String phone, String email,String description ) {
    var options = {
      'key': 'rzp_test_TNM7NAj5tr8DiY',
      'currency': currency,
      'amount': amount,
      'order_id': orderId,
      'name': 'SBIG',
      'description': description,
      'prefill': {
        'contact': phone,
        'email': email
      }
    };

    _razorpay.open(options);
  }

  void clear() {
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("PAYMENT SUCCESS -> Payment id: ${response.paymentId} | Order id: ${response.orderId} | Signature: ${response.signature}");
    _paymentSuccessCallback(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("PAYMENT ERROR => Code: ${response.code} | Message: ${response.message}");
    _paymentFailureCallback(response);

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("PAYMENT EXTERNAL WALLET=> Wallet name: ${response.walletName}");
    _externalWalletResponseCallback(response);
  }
}
