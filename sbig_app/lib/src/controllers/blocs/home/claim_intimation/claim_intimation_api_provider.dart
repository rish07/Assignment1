import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/city_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/product_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class ClaimIntimationApiProvider extends ApiResponseListenerDio {
  static ClaimIntimationApiProvider _instance;

  static ClaimIntimationApiProvider getInstance() {
    if (_instance == null) {
      return ClaimIntimationApiProvider();
    }
    return _instance;
  }

  Future<CityResponseModel> getCity() async {
    return await BaseApiProvider.getApiCall(UrlConstants.CITY).then((response) {
      CityResponseModel cityResponseModel = CityResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            cityResponseModel = CityResponseModel.fromJson(response.data);
            return cityResponseModel;
          }
        }
        cityResponseModel.apiErrorModel = onHttpFailure(response);
        return cityResponseModel;
      } catch (e) {
        cityResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return cityResponseModel;
      }
    });
  }

  Future<ProductResponseModel> getProduct() async {
    return await BaseApiProvider.getApiCall(UrlConstants.PRODUCT)
        .then((response) {
      ProductResponseModel productResponseModel = ProductResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            productResponseModel = ProductResponseModel.fromJson(response.data);
            return productResponseModel;
          }
        }
        productResponseModel.apiErrorModel = onHttpFailure(response);
        return productResponseModel;
      } catch (e) {
        productResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return productResponseModel;
      }
    });
  }

  Future<ClaimIntimationResponseModel> postClaimIntimation(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
            UrlConstants.CLAIM_INTIMATION, body)
        .then((response) {
      ClaimIntimationResponseModel responseModel =
          ClaimIntimationResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            responseModel =
                ClaimIntimationResponseModel.fromJson(response.data);
            return responseModel;
          }
        }
        responseModel.apiErrorModel = onHttpFailure(response);
        return responseModel;
      } catch (e) {
        responseModel.apiErrorModel = ApiErrorModel(e.toString());
        return responseModel;
      }
    });
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }
}
