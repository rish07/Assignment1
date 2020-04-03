import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/download_models.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class ArogyaPlusThankYouWidgetApiProvider extends ApiResponseListenerDio {
  Future<ParsedResponse<DownloadResponse>> download(DocType docType, String policyId) async {
    String url;
    if(docType == DocType.POLICY_DOCUMENT) {
      url = UrlConstants.POLICY_DOCUMENT_DOWNLOAD_API;
    } else if(docType == DocType.HEALTH_CARD) {
      url = UrlConstants.HEALTH_CARD_DOWNLOAD_API;
    } else {
      throw Exception("Unknown doctype ($docType) provided");
    }
    return BaseApiProvider.getApiCall(url, qParam: {"policyid": policyId}).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        return ParsedResponse.addData(DownloadResponse.fromJson(response.data));
      } else {
        return ParsedResponse.addError(onHttpFailure(response));
      }
    });
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }

}

enum DocType {HEALTH_CARD, POLICY_DOCUMENT}
