import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes//url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_list_response.dart';
import 'package:sbig_app/src/models/api_models/home/network_hospital/network_hospital_suggestion.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class NetworkHospitalListAPiProvider extends ApiResponseListenerDio {

  Future<ParsedResponse<NetworkHospitalListModel>> getHospitalListApi(String pinCode, int page, {String tpaCategory : ""}) async {
    Map<String, dynamic> qParams = {};
    qParams["pincode"] = pinCode;
    qParams["page"] = page;
    if(!TextUtils.isEmpty(tpaCategory)) {
      qParams["tpa_category"] = tpaCategory;
    }
    return BaseApiProvider.getApiCall(UrlConstants.HOSPITAL_LIST, qParam: qParams).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        NetworkHospitalListModel model = NetworkHospitalListModel.fromJson(response.data);
        return ParsedResponse.addData(model);
      } else {
        ApiErrorModel errorModel = onHttpFailure(response);
        return ParsedResponse.addError(errorModel);
      }
    });
  }


  Future<ParsedResponse<NetworkHospitalListModel>> getHospitalListApiNew (String keyword, int page, {String tpaCategory : "",String latitude :"",String longitude :""}) async {
    Map<String, dynamic> qParams = {};
    qParams["page"] = page;
    if(!TextUtils.isEmpty(tpaCategory)) {
      qParams["tpa_category"] = tpaCategory;
    }
    if(latitude ==null || TextUtils.isEmpty(latitude)) {
      qParams["keywords"] = keyword;
    }else {
      qParams["latitude"] = latitude;
      qParams["longitude"] = longitude;
    }

    return BaseApiProvider.getApiCall(UrlConstants.HOSPITAL_LIST_NEW, qParam: qParams).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        NetworkHospitalListModel model = NetworkHospitalListModel.fromJson(response.data);
        return ParsedResponse.addData(model);
      } else {
        ApiErrorModel errorModel = onHttpFailure(response);
        return ParsedResponse.addError(errorModel);
      }
    });
  }

  Future<ParsedResponse<NetworkHospitalSuggestionListModel>> getSuggestion (String character) async {

    Map<String, dynamic> body = {};
    body["characters"] = character;
    return BaseApiProvider.postApiCall(UrlConstants.HOSPITAL_LIST_SUGGESTION,body).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        NetworkHospitalSuggestionListModel model = NetworkHospitalSuggestionListModel.fromJson(response.data);
        return ParsedResponse.addData(model);
      } else {
        ApiErrorModel errorModel = onHttpFailure(response);
        return ParsedResponse.addError(errorModel);
      }
    });
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }
  
}