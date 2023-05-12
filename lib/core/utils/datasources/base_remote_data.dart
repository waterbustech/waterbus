// Dart imports:
import 'dart:async';
import 'dart:convert' as convert;

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/types/http_status_code.dart';

@singleton
class BaseRemoteData {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeOut),
      receiveTimeout: const Duration(milliseconds: receiveTimeOut),
      sendTimeout: const Duration(milliseconds: receiveTimeOut),
    ),
  ); // with default Options

  Future<Response<dynamic>> downloadFile(
    String url,
    String path,
    Function onReceive,
  ) async {
    final Response response = await dio.download(
      url,
      path,
      options: getOptions(),
      onReceiveProgress: (received, total) {
        onReceive(received, total);
      },
    );
    return response;
  }

  Future<Response<dynamic>> postFormData(
    String gateway,
    FormData formData,
  ) async {
    try {
      final Response response = await dio.post(
        gateway,
        data: formData,
        options: getOptions(),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> putFormData(
    String gateway,
    FormData formData,
  ) async {
    try {
      final Response response = await dio.put(
        gateway,
        data: formData,
        options: getOptions(),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );
      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> postRoute(
    String gateway,
    Map<String, dynamic> body, {
    String? query,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }
      final Response response = await dio.post(
        gateway,
        data: convert.jsonEncode(body),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> putRoute(
    String gateway,
    Map<String, dynamic> body,
  ) async {
    try {
      final Response response = await dio.put(
        gateway,
        data: convert.jsonEncode(body),
        options: getOptions(),
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> patchRoute(
    String gateway, {
    String? query,
    Map<String, dynamic>? body,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      final Response response = await dio.patch(
        gateway,
        data: body == null ? null : convert.jsonEncode(body),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> getRoute(
    String gateway, {
    String? params,
    String? query,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      final Response response = await dio.get(
        gateway,
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> deleteRoute(
    String gateway, {
    String? params,
    String? query,
    Map<String, dynamic>? body,
    FormData? formData,
  }) async {
    try {
      final Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      final Response response = await dio.delete(
        gateway,
        data: formData ?? (body == null ? null : convert.jsonEncode(body)),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioError catch (exception) {
      return catchDioError(exception: exception, gateway: gateway);
    }
  }

  Response catchDioError({
    required DioError exception,
    required String gateway,
  }) {
    return Response(
      requestOptions: RequestOptions(path: gateway),
      statusCode: StatusCode.badGateway,
      statusMessage: "CATCH EXCEPTION DIO",
    );
  }

  Options getOptions() {
    return Options(
      validateStatus: (status) {
        return true;
      },
      headers: getHeaders(),
    );
  }

  getHeaders() {
    return {
      'Authorization': 'Bearer ',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }
}
