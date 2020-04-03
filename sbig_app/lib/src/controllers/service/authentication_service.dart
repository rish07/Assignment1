import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/listeners/api_response_listener.dart';
import 'package:sbig_app/src/controllers/networking/base_api_provider.dart';
import 'package:sbig_app/src/controllers/routes/url_constants.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/text_utils.dart';

class AuthenticationService extends ApiResponseListenerDio {
  final SharedPrefsHelper _prefsHelper;

  AuthenticationService(this._prefsHelper);

  Future<AuthResponse> authenticate() async {
    Response tokenResponse = await BaseApiProvider.postApiCall(UrlConstants.TOKEN_API, {}, isAuthorizationRequired: false);
    if(tokenResponse != null && tokenResponse.statusCode == ApiResponseListenerDio.HTTP_OK) {
      String newToken = tokenResponse?.data['token'];
      if(TextUtils.isEmpty(newToken)) {
        return AuthResponse.failure("Token is not supplied from server");
      } else {
        await _prefsHelper.setToken(newToken);
        return AuthResponse.success(newToken);
      }
    } else {
      ApiErrorModel apiError = onHttpFailure(tokenResponse);
      return AuthResponse.failure(apiError.message, apiError.statusCode);
    }
  }

  @override
  onHttpSuccess(Response response, {int diff = -1}) {
    return null;
  }
}

class AuthResponse {
  bool _status;
  bool get status => _status;

  int _statusCode = ApiResponseListenerDio.UNKNOWN;
  int get statusCode => _statusCode;

  String _message;
  String get message => _message;

  String _token;
  String get token => _token;

  AuthResponse._internal();

  AuthResponse.success(this._token) {
    this._status = true;
    _statusCode = ApiResponseListenerDio.HTTP_OK;
  }

  AuthResponse.failure(this._message, [int statusCode = ApiResponseListenerDio.UNKNOWN]) {
    this._status = false;
    _statusCode = statusCode;
  }

}