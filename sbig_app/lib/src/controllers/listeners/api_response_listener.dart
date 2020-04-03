import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sbig_app/src/models/common/failure_model.dart';

abstract class ApiResponseListenerDio {
  static const int HTTP_OK = 200;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int MAINTENANCE = 403;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int DDOS_ERROR = -103;
  static const int NO_INTERNET_CONNECTION = -101;
  static const int UNKNOWN = -102;

  dynamic onHttpSuccess(Response response, {int diff = -1});

  ApiErrorModel onHttpFailure(Response response) {
    try {
      if (response != null) {
        print("response.statusCode "+response.statusCode.toString());
        switch (response.statusCode) {
          case BAD_REQUEST:
          case UNAUTHORIZED:
            ApiErrorModel apiErrorModel = ApiErrorModel.fromJson(response.data);
            apiErrorModel.statusCode = response.statusCode;
            return apiErrorModel;
            break;
          case NO_INTERNET_CONNECTION:
            return ApiErrorModel(
                "Internert is not available. Please check your wifi/data",
                response.statusCode);
            break;
          case INTERNAL_SERVER_ERROR:
            return ApiErrorModel("Server internal error. Please try again",
                response.statusCode);
            break;

          case MAINTENANCE:
            return ApiErrorModel(
                "Server is under maintenance. Please try again",
                response.statusCode);
            break;
          case DDOS_ERROR:
            return ApiErrorModel("Too many requests. Please try after sometime",
                response.statusCode);
            break;
          default:
            return ApiErrorModel(
                "Oops..Something went wrong. Please try after sometime",
                response.statusCode);
            break;
        }
      }
    } catch (e) {
      print("RESPONSE ERROR EXCEPTION: $e");
    }

    return ApiErrorModel(
        "Oops..Something went wrong. Please try after sometime",
        ApiResponseListenerDio.UNKNOWN);
  }
}
