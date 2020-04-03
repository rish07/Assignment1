import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/critical_illness/critical_product_info_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class ProductInfoApiProvider extends ApiResponseListenerDio {
  static ProductInfoApiProvider _instance;

  static ProductInfoApiProvider getInstance() {
    if (_instance == null) {
      return ProductInfoApiProvider();
    }
    return _instance;
  }

  Future<ProductInfoResModel> getProductInfo(int isFrom ) async {
    return await BaseApiProvider.getApiCall(
            getUrls(isFrom))
        .then((response) {
      ProductInfoResModel productInfoResModel =
          ProductInfoResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            productInfoResModel = ProductInfoResModel.fromJson(response.data);
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

  String getUrls(int isFrom){
    switch(isFrom){
      case StringConstants.FROM_CRITICAL_ILLNESS:
        return UrlConstants.PRODUCT_INFO_CRITICAL_ILLNESS_URL;
        break;
      case StringConstants.FROM_AROGYA_PREMIER:
        return UrlConstants.PRODUCT_INFO_AROGYA_PREMIER_URL;
        break;
        case StringConstants.FROM_AROGYA_TOP_UP:
        return UrlConstants.PRODUCT_INFO_AROGYA_TOP_UP_URL;
        break;
      default :
        return UrlConstants.PRODUCT_INFO_CRITICAL_ILLNESS_URL;
    }
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    // TODO: implement onHttpSuccess
    return null;
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }
}
