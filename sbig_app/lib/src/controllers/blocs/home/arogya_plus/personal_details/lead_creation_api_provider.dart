import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/lead_creation_response.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class LeadCreationApiProvider extends ApiResponseListenerDio {
  static LeadCreationApiProvider _instance;

  LeadCreationApiProvider._internal();

  static LeadCreationApiProvider getInstance() {
    if (_instance == null) {
      _instance = LeadCreationApiProvider._internal();
    }
    return _instance;
  }

  Future<ParsedResponse<LeadCreationResponse>> callLeadCreationApi(
      String email, String mobile, String campaignID) async {
    Map<String, dynamic> data =
        LeadCreationReqeust(phone: mobile, email: email, campaignID: campaignID).toJson();

    Response response =
        await BaseApiProvider.postApiCall(UrlConstants.LEAD_CREATION_API, data);
    if (response != null &&
        response.statusCode == ApiResponseListenerDio.HTTP_OK) {
      LeadCreationResponse leadCreationResponse =
          LeadCreationResponse.fromJson(response.data);
      return ParsedResponse.addData(leadCreationResponse);
    } else {
      ApiErrorModel apiErrorModel = onHttpFailure(response);
      return ParsedResponse.addError(apiErrorModel);
    }
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }
}
