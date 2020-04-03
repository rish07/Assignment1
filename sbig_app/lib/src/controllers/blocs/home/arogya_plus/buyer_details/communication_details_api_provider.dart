

import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/home/arogya_plus/pincode_model.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CommunicationDetailsApiProvider extends ApiResponseListenerDio{
  static CommunicationDetailsApiProvider _instance;
  static const int PINCODE_AREAS_DIFF = 1;

  static CommunicationDetailsApiProvider getInstance(){
    if(_instance == null){
      return CommunicationDetailsApiProvider();
    }
    return _instance;
  }

  Future<PinCodeResModel> getAreas(Map<String, dynamic> body) async{
    return await BaseApiProvider.postApiCall(UrlConstants.PINCODE_AREAS_URL, body).then((response){
      PinCodeResModel pinCodeResModel = PinCodeResModel();
      try {
        if(response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            pinCodeResModel = onHttpSuccess(response, diff : PINCODE_AREAS_DIFF);
            return Future.value(pinCodeResModel);
          }
        }
        pinCodeResModel.apiErrorModel =
            onHttpFailure(response);
        return pinCodeResModel;

      }catch(e){
        pinCodeResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " +e.toString());
        return pinCodeResModel;
      }
    });
  }

  @override
  ApiErrorModel onHttpFailure(Response response) {
    return super.onHttpFailure(response);
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    switch(diff){
      case PINCODE_AREAS_DIFF:
        return PinCodeResModel.fromJson(response.data);
        break;
    }
  }

}