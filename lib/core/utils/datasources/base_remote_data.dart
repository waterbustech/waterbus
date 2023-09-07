// Dart imports:
import 'dart:async';
import 'dart:convert' as convert;

// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/constants/constants.dart';
import 'package:waterbus/core/injection/injection_container.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/dio/dio_configuration.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';

@singleton
class BaseRemoteData {
  final AuthLocalDataSource _authLocalDataSource;

  BaseRemoteData(this._authLocalDataSource);

  Dio dio = Dio(
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> postRoute(
    String gateway, {
    Map<String, dynamic>? body,
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
        data: body == null ? null : convert.jsonEncode(body),
        options: getOptions(),
        queryParameters: query == null ? null : paramsObject,
      );

      return response;
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Future<Response<dynamic>> getRoute(
    String gateway, {
    String params = '',
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
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
    } on DioException catch (exception) {
      return catchDioException(exception: exception, gateway: gateway);
    }
  }

  Response catchDioException({
    required DioException exception,
    required String gateway,
  }) {
    return Response(
      requestOptions: RequestOptions(path: gateway),
      statusCode: StatusCode.badGateway,
      statusMessage: "CATCH EXCEPTION DIO",
    );
  }

  Options get getOptionsRefreshToken {
    return Options(
      validateStatus: (status) {
        if (status == StatusCode.notAcceptable &&
            _authLocalDataSource.accessToken != null) {
          AppBloc.authBloc.add(LogOutEvent());
        }

        return true;
      },
      headers: {
        'Authorization': 'Bearer ${_authLocalDataSource.refreshToken}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
      },
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
      'Authorization': 'Bearer ${_authLocalDataSource.accessToken ?? ''}',
      'Content-Type': 'application/json; charset=UTF-8',
      'Connection': 'keep-alive',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  initialize() async {
    await Future.wait([
      getIt<DioConfiguration>()
          .configuration(dio)
          .then((client) => dio = client),
      getIt<DioConfiguration>().configRefreshToken(dio).then(
            (client) => dio = client,
          ),
    ]);
  }
}
