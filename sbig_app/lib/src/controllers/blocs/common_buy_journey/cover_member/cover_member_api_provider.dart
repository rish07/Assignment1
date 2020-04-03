import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/api_models/common_buy_journey/cover_member_model.dart';

import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/ui/screens/home/arogya_plus/policy_type_screen.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class CoverMemberApiProvider extends ApiResponseListenerDio {
  static CoverMemberApiProvider _instance;

  static CoverMemberApiProvider getInstance() {
    if (_instance == null) {
      return CoverMemberApiProvider();
    }
    return _instance;
  }

  Future<CoverMemberResModel> getCoverMembers(int isFrom ,{int policyType}) async {
    return await BaseApiProvider.getApiCall(getUrls(isFrom,policyType: policyType))
        .then((response) {
      CoverMemberResModel productInfoResModel = CoverMemberResModel();
      try {
        if (response != null) {
          if (response.statusCode == ApiResponseListenerDio.HTTP_OK) {
            productInfoResModel = CoverMemberResModel.fromJson(response.data);
            return Future.value(productInfoResModel);
          }
        }
        productInfoResModel.apiErrorModel = onHttpFailure(response);
        return productInfoResModel;
      } catch (e) {
        productInfoResModel.apiErrorModel = ApiErrorModel(e.toString());
        debugPrint("PremiumApiProvider " + e.toString());
        return productInfoResModel;
      }
    });
  }

  String getUrls(int isFrom, {int policyType}){
    switch(isFrom){
      case StringConstants.FROM_CRITICAL_ILLNESS:
        return UrlConstants.COVER_MEMBER_CRITICAL_ILLNESS_URL;
        break;
      case StringConstants.FROM_AROGYA_PREMIER:
        if(policyType == PolicyTypeScreen.INDIVIDUAL){
          return UrlConstants.COVER_MEMBER_AROGYA_PREMIER_INDIVIDUAL_URL;
        }else {
          return UrlConstants.COVER_MEMBER_AROGYA_PREMIER_FAMILY_URL;
        }
        break;
      case StringConstants.FROM_AROGYA_TOP_UP:
        if(policyType == PolicyTypeScreen.INDIVIDUAL){
          return UrlConstants.COVER_MEMBER_AROGYA_TOP_UP_INDIVIDUAL_URL;
        }else {
          return UrlConstants.COVER_MEMBER_AROGYA_TOP_UP_FAMILY_URL;
        }
        break;
      default :
        return '';
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
