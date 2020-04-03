import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/blocs/home/arogya_plus/mics/arogya_plus_thankyou_widget_api_provider.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/download_models.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/get_policy_service_details.dart';
import 'package:sbig_app/src/models/api_models/home/services_tab/policies_services_details/member_details.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class HomeApiProvider extends ApiResponseListenerDio {
  static HomeApiProvider _instance;
  static const int POLICIES_SERVICES_DIFF = 1;
  static const int DOWNLOAD_PDF_DIFF = 2;
  static const int MEMBER_DETAILS_DIFF = 3;
  static const int PRODUCT_INFO = 6;

  static HomeApiProvider getInstance() {
    if (_instance == null) {
      return HomeApiProvider();
    }
    return _instance;
  }

  Future<PoliciesServicesRes> getPolicyServiceDetails() async {
    return await BaseApiProvider.getApiCall(
            UrlConstants.GET_POLICY_SERVICE_DETAILS_URL)
        .then((response) {
      PoliciesServicesRes policiesServicesRes = PoliciesServicesRes();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            policiesServicesRes =
                onHttpSuccess(response, diff: POLICIES_SERVICES_DIFF);
            return Future.value(policiesServicesRes);
          }
        }
        policiesServicesRes.apiErrorModel = onHttpFailure(response);
        return policiesServicesRes;
      } catch (e) {
        policiesServicesRes.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("HomeApiProvider-Policydetails " + e.toString());
        return policiesServicesRes;
      }
    });
  }

  Future<DownloadResponse> download(DocType docType, String policyId) async {
    String url;
    if (docType == DocType.POLICY_DOCUMENT) {
      url = UrlConstants.POLICY_DOCUMENT_DOWNLOAD_API;
    } else if (docType == DocType.HEALTH_CARD) {
      url = UrlConstants.HEALTH_CARD_DOWNLOAD_API;
    } else {
      throw Exception("Unknown doctype ($docType) provided");
    }
    return await BaseApiProvider.getApiCall(
        url,
        qParam: {"policyid": policyId}).then((response) {
      DownloadResponse downloadResponse = DownloadResponse();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            downloadResponse = onHttpSuccess(response, diff: DOWNLOAD_PDF_DIFF);
            return Future.value(downloadResponse);
          }
        }
        downloadResponse.apiErrorModel = onHttpFailure(response);
        return downloadResponse;
      } catch (e) {
        downloadResponse.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("HomeApiProvider-Download " + e.toString());
        return downloadResponse;
      }
    });
  }

  Future<MemberDetailsResModel> getMemberDetails(Map<String, dynamic> body) async {
    return await BaseApiProvider.getApiCall(
        UrlConstants.GET_POLICY_MEMBER_DETAILS_URL, qParam: body)
        .then((response) {
      MemberDetailsResModel memberDetailsResModel = MemberDetailsResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            memberDetailsResModel =
                onHttpSuccess(response, diff: MEMBER_DETAILS_DIFF);
            return Future.value(memberDetailsResModel);
          }
        }
        memberDetailsResModel.apiErrorModel = onHttpFailure(response);
        return memberDetailsResModel;
      } catch (e) {
        memberDetailsResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("HomeApiProvider-MemberDetails " + e.toString());
        return memberDetailsResModel;
      }
    });
  }

  Future<ProductInfoResModel> getProductInfo(String tag) async {
    return await BaseApiProvider.getApiCall(
        UrlConstants.TAG_BASED_PRODUCT_INFO_URL+tag)
        .then((response) {
      ProductInfoResModel productInfoResModel =
      ProductInfoResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            productInfoResModel = onHttpSuccess(response, diff: PRODUCT_INFO);
            return Future.value(productInfoResModel);
          }
        }
        productInfoResModel.apiErrorModel = onHttpFailure(response);
        return productInfoResModel;
      } catch (e) {
        productInfoResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("ProductApiProvider " + e.toString());
        return productInfoResModel;
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
      case POLICIES_SERVICES_DIFF:
        return PoliciesServicesRes.fromJson(response.data);
        break;
      case DOWNLOAD_PDF_DIFF:
        return DownloadResponse.fromJson(response.data);
        break;
      case MEMBER_DETAILS_DIFF:
        return MemberDetailsResModel.fromJson(response.data);
        break;
      case PRODUCT_INFO:
        return ProductInfoResModel.fromJson(response.data);
        break;
    }
  }
}
