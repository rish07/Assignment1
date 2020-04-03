import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/cities_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/health_claim_intimation_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/hospital_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/policy_health_details_model.dart';
import 'package:sbig_app/src/models/api_models/home/claim_intimation/health_claim_intimation/track_health_claim_intimation_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class HealthClaimIntimationApiProvider extends ApiResponseListenerDio {
  static HealthClaimIntimationApiProvider _instance;

  static HealthClaimIntimationApiProvider getInstance() {
    if (_instance == null) {
      return HealthClaimIntimationApiProvider();
    }
    return _instance;
  }

  Future<PolicyDetailsResponseModel> postPolicyDetails(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.POLICY_HEALTH_DETAILS_BY_POLICY_NO, body)
        .then((response) {
      PolicyDetailsResponseModel responseModel =
      PolicyDetailsResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            responseModel =
                PolicyDetailsResponseModel.fromJson(response.data);
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


  Future<CitiesResponseModel> getCities(String latitude, String longitude ) async {
    String url=UrlConstants.CITIES+"?lat="+latitude+"&long="+longitude;
    return BaseApiProvider.getApiCall(UrlConstants.CITIES+"?lat="+latitude+"&long="+longitude).then((response) {
      CitiesResponseModel citiesResponseModel = CitiesResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            citiesResponseModel = CitiesResponseModel.fromJson(response.data);
            return citiesResponseModel;
          }
        }
        citiesResponseModel.apiErrorModel = onHttpFailure(response);
        return citiesResponseModel;
      } catch (e) {
        citiesResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return citiesResponseModel;
      }
    });
  }

  Future<HospitalResponseModel> getHospital(String city ) async {
    String url=UrlConstants.HOSPITAL_LIST_BY_CITY+"?city="+city;
    return BaseApiProvider.getApiCall(UrlConstants.HOSPITAL_LIST_BY_CITY+"?city="+city).then((response) {
      HospitalResponseModel hospitalResponseModel = HospitalResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            hospitalResponseModel = HospitalResponseModel.fromJson(response.data);
            return hospitalResponseModel;
          }
        }
        hospitalResponseModel.apiErrorModel = onHttpFailure(response);
        return hospitalResponseModel;
      } catch (e) {
        hospitalResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return hospitalResponseModel;
      }
    });
  }

  Future<HealthClaimIntimationResponseModel> postHealthClaimIntimation(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.HEALTH_CLAIM_INTIMATION, body)
        .then((response) {
      HealthClaimIntimationResponseModel responseModel =
      HealthClaimIntimationResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            responseModel =
                HealthClaimIntimationResponseModel.fromJson(response.data);
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


  Future<TrackHealthClaimIntimationResponseModel> postTrackHealthClaimIntimation(
      Map<String, dynamic> body) async {
    return await BaseApiProvider.postApiCall(
        UrlConstants.TRACK_HEALTH_CLAIM_INTIMATION, body)
        .then((response) {
      TrackHealthClaimIntimationResponseModel responseModel =
      TrackHealthClaimIntimationResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            responseModel =
                TrackHealthClaimIntimationResponseModel.fromJson(response.data);
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
