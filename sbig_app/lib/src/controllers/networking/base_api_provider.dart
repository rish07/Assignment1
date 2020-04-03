import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:sbig_app/src/controllers/service/network_interceptor.dart';
import 'package:sbig_app/src/controllers//listeners/api_response_listener.dart';
import 'package:sbig_app/src/resources/log_storage.dart';
import 'package:sbig_app/src/resources/sharedpreference_helper.dart';
import 'package:sbig_app/src/ui/widgets/statefulwidget_base.dart';

class BaseApiProvider {
  static CounterStorage log_storage = CounterStorage();
  /// pass 'isAuthorizationRequired = false' when Authorization token is not
  /// required in api call.
  /// 'isAuthorizationRequired = true' by default
  static Future<Response> postApiCall(String url, Map<String, dynamic> body,
      {bool isAuthorizationRequired = true}) async {
    debugPrint("SBIG REQUEST: " + json.encode(body), wrapWidth: 1024);
    debugPrint("SBIG URL: $url");

    log_storage.writeData("\nURL, REQUEST $url\n"+json.encode(body));

    bool isConnected = await isInternetConnected();

    if (!isConnected) {
      return Future.value(Response(
          data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
    }

    if (_isDdosEffect()) {
      debugPrint("DDOS EFFECT: TRUE");
      log_storage.writeData("DOS EFFECT TRUE\n");
      return Future.value(Response(
          data: "",
          statusCode: ApiResponseListenerDio.DDOS_ERROR));
    }else{
      debugPrint("DDOS EFFECT: FALSE");
    }

    Response response;
    try {
      Dio dio = _getDio(prefsHelper, isAuthorizationRequired);
      response = await dio.post(
        url,
        data: body,
      );
      debugPrint("SBIG RESPONSE CODE: ${response.statusCode}");
      debugPrint(
          "SBIG RESPONSE: ${json.encode(response.data)}", wrapWidth: 1024);

      log_storage.writeData("\nRESPONSE CODE ${response.statusCode}");
      log_storage.writeData("\nRESPONSE ${json.encode(response.data)}");

      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("ERROR RESPONSE: ${e.response.data}");
        debugPrint("ERROR RESPONSE CODE: ${e.response.statusCode}");

        log_storage.writeData("\nERROR RESPONSE CODE ${e.response.data}");
        log_storage.writeData("\nERROR RESPONSE ${e.response.statusCode}");

        return e.response;
      } else {
        print(e.message);
        log_storage.writeData("\nException ${e.message}");
        if (e.toString().contains('SocketException')) {
          if(e.toString().contains('Network is unreachable')){
            return Future.value(Response(
                data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
          }
          return Future.value(Response(
              data: "",
              statusCode: ApiResponseListenerDio.INTERNAL_SERVER_ERROR));
        }
        return null;
      }
    }
  }

  static Future<Response> getApiCall(String url,
      {Map<String,
          dynamic> qParam, bool isAuthorizationRequired = true}) async {
    bool isConnected = await isInternetConnected();
    debugPrint("URL: $url");

    log_storage.writeData("\n");
    log_storage.writeData("URL: $url\n");
    if (qParam != null) {
      debugPrint("SBIG QUERY PARAMS: $qParam");
      log_storage.writeData("\nQUERY PARAMS: $qParam\n");
    }

    if (!isConnected) {
      return Future.value(Response(
          data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
    }

    if (_isDdosEffect()) {
      debugPrint("DDOS EFFECT: TRUE");
      log_storage.writeData("DDOS EFFECT TRUE\n");
      return Future.value(Response(
          data: "",
          statusCode: ApiResponseListenerDio.DDOS_ERROR));
    }else{
      debugPrint("DDOS EFFECT: FALSE");
    }

    Response response;
    try {
      Dio dio = _getDio(prefsHelper, isAuthorizationRequired);
      response = await dio.get(url, queryParameters: qParam);
      debugPrint("SBIG RESPONSE CODE: ${response.statusCode}");
      debugPrint(
          "SBIG RESPONSE: ${json.encode(response.data)}", wrapWidth: 1024);

      log_storage.writeData("\nRESPONSE CODE ${response.statusCode}");
      log_storage.writeData("\nRESPONSE ${json.encode(response.data)}\n");

      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("ERROR RESPONSE: ${e.response.data}");
        debugPrint("ERROR RESPONSE CODE: ${e.response.statusCode}");

        log_storage.writeData("\nERROR RESPONSE CODE ${e.response.data}");
        log_storage.writeData("\nERROR RESPONSE ${e.response.statusCode}");

        return e.response;
      } else {
        print(e.message);

        log_storage.writeData("\nException ${e.message}");
        
        if (e.toString().contains('SocketException')) {
          if(e.toString().contains('Network is unreachable')){
            return Future.value(Response(
                data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
          }
          return Future.value(Response(
              data: "",
              statusCode: ApiResponseListenerDio.INTERNAL_SERVER_ERROR));
        }
        return null;
      }
    }
  }

  static Future<Response> postUploadApiCall(String url, File file, String name,
      String reqFieldName, {bool isAuthorizationRequired = true}) async {
    bool isConnected = await isInternetConnected();
    debugPrint("SBIG REQUEST: " + "FILE UPLOAD");
    debugPrint("URL: $url");

    if (!isConnected) {
      return Future.value(Response(
          data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
    }

    Response response;
    try {
      Dio dio = _getDio(prefsHelper, isAuthorizationRequired);
      final formData = FormData.fromMap({
        "$reqFieldName":
        await MultipartFile.fromFile(file.path, filename: name),
      });
      response = await dio.post(url, data: formData);
      debugPrint("SBIG RESPONSE CODE: ${response.statusCode}");
      debugPrint("SBIG RESPONSE: ${json.encode(response.data)}");
      return response;
    } on DioError catch (e) {
      if (e.response != null) {
        debugPrint("ERROR RESPONSE: ${e.response.data}");
        debugPrint("ERROR RESPONSE CODE: ${e.response.statusCode}");
        return e.response;
      } else {
        print(e.message);
        if (e.toString().contains('SocketException')) {
          if(e.toString().contains('Network is unreachable')){
            return Future.value(Response(
                data: "", statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
          }
          return Future.value(Response(
              data: "",
              statusCode: ApiResponseListenerDio.NO_INTERNET_CONNECTION));
        }
        return null;
      }
    }
  }

//  static Future<Map<String, String>> _getHeaders() async {
//    Map<String, String> headers = {};
//
//    var prefs = SharedPrefsHelper();
//    if (prefs.getToken() != null) {
//      if(prefs.isUserLoggedIn()) {
//        headers["Authorization"] = "Bearer ${prefs.getToken()}";
//      } else {
//        headers["Authorization"] = "${prefs.getToken()}";
//
//      }
//    }
//
//    headers[Headers.contentTypeHeader] = Headers.jsonContentType;
//
//    headers[Headers.acceptHeader] = Headers.jsonContentType;
//
//    //headers["x-api-key"] = API_KEY;
//
//    debugPrint("SBIG REQUEST HEADERS: " + headers.toString());
//    return headers;
//  }

  static Future<bool> isInternetConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return true;
    }
    return false;
  }

  static Dio _getDio(SharedPrefsHelper prefsHelper,
      bool isAuthorizationRequired) {
    Dio dio = new Dio();
    dio.interceptors.add(EDioInterceptor(
        prefsHelper, dio, isAuthorizationRequired: isAuthorizationRequired));
//    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
//      client.findProxy = (uri) {
//        return "PROXY 10.22.20.13:9090";
//      };
//    };

    BaseOptions options = dio.options;
    options.receiveTimeout = 0;
    //options.connectTimeout = 30000;
    dio.options = options;
    return dio;
  }

  static bool _isDdosEffect() {
    String previousDateTimeString = prefsHelper.getApiHitDateTime();
    int count = prefsHelper.getApiHitCount();
    print("--count-- " + count.toString());

    if (count == 0 || count == null) {
      prefsHelper.setApiHitDateTime(DateTime.now());
      prefsHelper.setApiHitCount(1);
      return false;
    } else if (count > 10 && previousDateTimeString != null) {
      print("previousDateTimeString " + previousDateTimeString.toString());
      print("count " + count.toString());

      DateTime previousDateTime = DateTime.parse(previousDateTimeString);
      Duration duration = DateTime.now().difference(previousDateTime);
      print("seconds duration " + duration.inSeconds.toString());
      if (duration.inSeconds <= 10) {
        return true;
      } else if(duration.inSeconds > 10){
        prefsHelper.setApiHitCount(1);
        prefsHelper.setApiHitDateTime(DateTime.now());
        return false;
      }
    } else {
      print("--INCREMENT-- " + count.toString());
      prefsHelper.setApiHitCount(count + 1);
    }
    return false;
  }
}
