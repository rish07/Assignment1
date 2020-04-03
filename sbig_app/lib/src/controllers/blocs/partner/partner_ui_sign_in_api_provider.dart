import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/partner/partner_ui_api_models.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class PartnerUiSignInApiProvider extends ApiResponseListenerDio {
  Future<ParsedResponse<PartnerUiSignInResponse>> callPartnerUiSignInApi(PartnerUiSignInRequest request) async {
    assert(request != null);
    return BaseApiProvider.postApiCall(UrlConstants.PARTNER_UI_SIGN_IN, request.toJson()).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        return ParsedResponse.addData(PartnerUiSignInResponse.fromJson(response.data));
      } else {
        return ParsedResponse.addError(onHttpFailure(response));
      }
    });
  }
  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }

}