// Package imports:
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/core/utils/path_helper.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';

@singleton
class DioConfiguration {
  final BaseRemoteData _remoteData;
  final AuthLocalDataSource _localDataSource;

  DioConfiguration(this._remoteData, this._localDataSource);

  Future<void> onRefreshToken({
    Function(String accessToken, String refreshToken)? callback,
  }) async {
    if (_localDataSource.accessToken != null ||
        _localDataSource.refreshToken != null) return;

    final Response response = await _remoteData.dio.get(
      ApiEndpoints.refreshToken,
      options: _remoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final String accessToken = response.data['data']['accessToken'];
      final String refreshToken = response.data['data']['refreshToken'];

      _localDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      callback?.call(accessToken, refreshToken);
    }
  }

  Future<Dio> configuration(Dio dioClient) async {
    // Integration cookie
    final String tempDir = await PathHelper.tempDirWaterbus;
    final PersistCookieJar cookieJar = PersistCookieJar(
      storage: FileStorage(tempDir),
    );
    dioClient.interceptors.add(CookieManager(cookieJar));

    // Integration retry
    dioClient.interceptors.add(
      RetryInterceptor(
        dio: dioClient,
        // logPrint: print, // specify log function (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          // Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );

    dioClient.httpClientAdapter = NativeAdapter();

    return dioClient;
  }

  Future<Dio> configRefreshToken(Dio dioClient) async {
    dioClient.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == StatusCode.unauthorized) {
            try {
              await onRefreshToken(
                callback: (accessToken, refreshToken) async {
                  // Set bearer token in header for resolve later
                  error.requestOptions.headers["Authorization"] =
                      "Bearer $accessToken";

                  // Create request with new access token
                  final opts = Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  );

                  final cloneReq = await dioClient.request(
                    error.requestOptions.path,
                    options: opts,
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                  );

                  return handler.resolve(cloneReq);
                },
              );
              // ignore: empty_catches
            } catch (_) {
              handler.reject(error);
            }
          }

          return handler.next(error);
        },
      ),
    );

    return dioClient;
  }
}
