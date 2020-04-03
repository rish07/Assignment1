import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/banner/banner_api_models.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/utilities/parsed_response.dart';

class BannerApiProvider extends ApiResponseListenerDio {
//http://www.mocky.io/v2/5ddba5ae3400004f00eadcf4
  Future<ParsedResponse<BannersApiResponseModel>> bannersApiCall() async {
    return BaseApiProvider.getApiCall(UrlConstants.BANNERS_API).then((response) {
      if(response != null && response.statusCode == ApiResponseListenerDio.HTTP_OK) {
        return ParsedResponse.addData(BannersApiResponseModel.fromJson(response.data));
      } else {
        ApiErrorModel error = onHttpFailure(response);
        return ParsedResponse.addError(error);
      }
    });
  }
  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }

}