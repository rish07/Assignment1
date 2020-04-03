import 'package:dio/dio.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_eia_model.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/calculate_premium_model.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/recalculate_premium.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_payment.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_payment_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_policy_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/renewals/renewal_update_details_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class RenewalsPolicyDetailsApiProvider extends ApiResponseListenerDio {
  static RenewalsPolicyDetailsApiProvider _instance;
  static const int RENEWAL_POLICY_DETAILS_DIFF = 1;
  static const int RENEWAL_UPDATE_DETAILS_DIFF = 2;
  static const int PAYMENT_ID_GENERATION_DIFF = 3;
  static const int PAYMENT_VERIFICATION_DIFF = 4;
  static const int STORE_EIA_DIFF = 5;

  static RenewalsPolicyDetailsApiProvider getInstance() {
    if (_instance == null) {
      return RenewalsPolicyDetailsApiProvider();
    }
    return _instance;
  }

  Future<RenewalPolicyDetailsResModel> getRenewalPolicyDetails(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
            UrlConstants.RENEWAL_POLICY_DETAILS_URL, body)
        .then((response) {
      RenewalPolicyDetailsResModel renewalPolicyDetailsResModel =
      RenewalPolicyDetailsResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            renewalPolicyDetailsResModel =
                onHttpSuccess(response, diff: RENEWAL_POLICY_DETAILS_DIFF);
            return Future.value(renewalPolicyDetailsResModel);
          }
        }
        renewalPolicyDetailsResModel.apiErrorModel = onHttpFailure(response);
        return renewalPolicyDetailsResModel;
      } catch (e) {
        renewalPolicyDetailsResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("RenewalsPolicyDetailsApiProvider " + e.toString());
        return renewalPolicyDetailsResModel;
      }
    });
  }


  Future<RenewalUpdateDetailsResModel> updateRenewalPolicyDetails(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.RENEWAL_UPDATE_POLICY_DETAILS_URL, body)
        .then((response) {
      RenewalUpdateDetailsResModel renewalUpdateDetailsResModel = RenewalUpdateDetailsResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            renewalUpdateDetailsResModel =
                onHttpSuccess(response, diff: RENEWAL_UPDATE_DETAILS_DIFF);
            return Future.value(renewalUpdateDetailsResModel);
          }
        }
        renewalUpdateDetailsResModel.apiErrorModel = onHttpFailure(response);
        return renewalUpdateDetailsResModel;
      } catch (e) {
        renewalUpdateDetailsResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("RenewalsUpdateDetailsApiProvider " + e.toString());
        return renewalUpdateDetailsResModel;
      }
    });
  }

  Future<PaymentIdGenerationResModel> getPaymentID(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.RENEWAL_PAYMENT_ID_GENERATION, body)
        .then((response) {
      PaymentIdGenerationResModel paymentIdGenerationResModel = PaymentIdGenerationResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            paymentIdGenerationResModel =
                onHttpSuccess(response, diff: PAYMENT_ID_GENERATION_DIFF);
            return Future.value(paymentIdGenerationResModel);
          }
        }
        paymentIdGenerationResModel.apiErrorModel = onHttpFailure(response);
        return paymentIdGenerationResModel;
      } catch (e) {
        paymentIdGenerationResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("RenewalsPaymentIdGenerationApiProvider " + e.toString());
        return paymentIdGenerationResModel;
      }
    });
  }

  Future<RenewalPaymentStatusCheckResponse> doPaymentVerification(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.getApiCall(
        UrlConstants.RENEWAL_PAYMENT_VERIFICATION, qParam: body, isAuthorizationRequired: true)
        .then((response) {
      RenewalPaymentStatusCheckResponse paymentStatusCheckResponse = RenewalPaymentStatusCheckResponse();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            paymentStatusCheckResponse =
                onHttpSuccess(response, diff: PAYMENT_VERIFICATION_DIFF);
            return Future.value(paymentStatusCheckResponse);
          }
        }
        paymentStatusCheckResponse.apiErrorModel = onHttpFailure(response);
        return paymentStatusCheckResponse;
      } catch (e) {
        paymentStatusCheckResponse.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("RenewalsPaymentIdGenerationApiProvider " + e.toString());
        return paymentStatusCheckResponse;
      }
    });
  }

  Future<RenewalStoreEIAResModel> storeEIA(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.RENEWAL_STORE_EIA, body)
        .then((response) {
      RenewalStoreEIAResModel renewalStoreEIAResModel = RenewalStoreEIAResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            renewalStoreEIAResModel =
                onHttpSuccess(response, diff: STORE_EIA_DIFF);
            return Future.value(renewalStoreEIAResModel);
          }
        }
        renewalStoreEIAResModel.apiErrorModel = onHttpFailure(response);
        return renewalStoreEIAResModel;
      } catch (e) {
        renewalStoreEIAResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("RenewalStoreEIAResModel " + e.toString());
        return renewalStoreEIAResModel;
      }
    });
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    switch (diff) {
      case RENEWAL_POLICY_DETAILS_DIFF:
        return RenewalPolicyDetailsResModel.fromJson(response.data);
        break;
      case RENEWAL_UPDATE_DETAILS_DIFF:
        return RenewalUpdateDetailsResModel.fromJson(response.data);
        break;
      case PAYMENT_ID_GENERATION_DIFF:
        return PaymentIdGenerationResModel.fromJson(response.data);
        break;
      case PAYMENT_VERIFICATION_DIFF:
        return RenewalPaymentStatusCheckResponse.fromJson(response.data);
        break;
      case STORE_EIA_DIFF:
        return RenewalStoreEIAResModel.fromJson(response.data);
        break;
    }
  }
}
