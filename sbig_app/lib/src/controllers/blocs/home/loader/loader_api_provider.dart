import 'package:dio/src/response.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/loader/loader_api_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

class LoaderApiProvider extends ApiResponseListenerDio {


  Future<LoaderResponseModel> getLoaderMessageDetails() async {
    return await BaseApiProvider.getApiCall(UrlConstants.LOADER_MSG_API)
        .then((response) {
      LoaderResponseModel loaderResponseModel = LoaderResponseModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            loaderResponseModel = LoaderResponseModel.fromJson(response.data);
            return loaderResponseModel;
          }
        }
        loaderResponseModel.apiErrorModel = onHttpFailure(response);
        return loaderResponseModel;
      } catch (e) {
        loaderResponseModel.apiErrorModel = ApiErrorModel(e.toString());
        return loaderResponseModel;
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
