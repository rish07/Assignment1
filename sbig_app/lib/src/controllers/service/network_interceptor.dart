
import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/misc/ui_events.dart';
import 'package:sbig_app/src/controllers/service/authentication_service.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';
import 'package:sbig_app/src/utilities/device_util.dart';

class EDioInterceptor extends InterceptorsWrapper {

  static const String retryKey = "retry";

  SharedPrefsHelper _sharedPrefsHelper;
  Dio previousDio;
  Dio newDio;
  DeviceUtil deviceUtil;
  int retryCount;
  Duration retryDelay;
  bool isAuthorizationRequired;

  EDioInterceptor(this._sharedPrefsHelper, this.previousDio, {this.isAuthorizationRequired = true, this.retryCount = 3, this.retryDelay = const Duration(seconds: 1)}) {
    newDio = Dio();
    deviceUtil = DeviceUtil.instance;
  }

  @override
  Future onRequest(RequestOptions options) async {
    //debugPrint("NETWORK INTERCEPTOR: IN ON REQUEST");
    if(isAuthorizationRequired) {
      String accessToken = _prepareAndGetAuthTokenFromToken(_getTokenFromStorage());
      options.headers["Authorization"] = accessToken;
    }

    //options.headers["BASIC_AUTH"] = "sbisecuredkeyf3xowm3";
    options.headers["BASIC-AUTH"] = "sbisecuredkeyf3xowm3";

    if(deviceUtil != null) {
      options.headers["PLATFORM"] = deviceUtil.platform;

      options.headers["OS-VERSION"] = deviceUtil.osVersion;

      options.headers["MANUFACTURER"] = deviceUtil.manufacturer;

      options.headers["MODEL"] = deviceUtil.model;

      options.headers["APP-VERSION"] = deviceUtil.appVersion;

      options.headers["BUILD-NUMBER"] = deviceUtil.buildNumber;
    }else{
      options.headers["APP-VERSION"] = "";
    }

    options.headers[Headers.contentTypeHeader] = Headers.jsonContentType;

    options.headers[Headers.acceptHeader] = Headers.jsonContentType;

    //debugPrint("NETWORK INTERCEPTOR headers: ${options.headers}");

    return options;
  }

  @override
  Future onResponse(Response response) async => response;


  @override
  Future onError(DioError err) async {
    if(err.response?.statusCode == 401 && isAuthorizationRequired) {
      int remainingRetries = err.request.extra[retryKey] ?? retryCount;
      if(remainingRetries > 0) {
        //debugPrint("NETWORK INTERCEPTOR: Retrying due to auth error. Retry remains $remainingRetries");
        Future.delayed(retryDelay);
        err.request.extra[retryKey] = --remainingRetries;
        RequestOptions requestOptions = err.request;

        // Lock to block the incoming request until the token updated
        previousDio.lock();
        previousDio.interceptors.responseLock.lock();
        previousDio.interceptors.errorLock.lock();

        try{
          AuthResponse authResponse = await AuthenticationService(_sharedPrefsHelper).authenticate();
          if(authResponse.status) {
            requestOptions.headers["Authorization"] = _prepareAndGetAuthTokenFromToken(authResponse.token);

            previousDio.unlock();
            previousDio.interceptors.responseLock.unlock();
            previousDio.interceptors.errorLock.unlock();
          }
          //repeating the request even if the auth response fails to retry the auth again itself
          return previousDio.request(requestOptions.path, options: requestOptions);
        } catch(e) {
          return err;
        }
      } else {
        return err;
      }
    }
    return err;
  }

  String _getTokenFromStorage() {
    return _sharedPrefsHelper.getToken();
  }


  String _prepareAndGetAuthTokenFromToken(String token) {
    if(_sharedPrefsHelper.isUserLoggedIn()) {
      return "bearer $token";
    } else {
      return token;
    }
  }
}