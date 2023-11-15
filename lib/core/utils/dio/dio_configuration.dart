// Dart imports:
import 'dart:async';

// Package imports:
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/types/extensions/duration_x.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/core/utils/dio/completer_queue.dart';
import 'package:waterbus/features/app/bloc/bloc.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/auth/presentation/bloc/auth_bloc.dart';

@singleton
class DioConfiguration {
  final BaseRemoteData _remoteData;
  final AuthLocalDataSource _localDataSource;

  DioConfiguration(this._remoteData, this._localDataSource);

  bool _isRefreshing = false;
  final CompleterQueue<(String, String)> _refreshTokenCompleters =
      CompleterQueue<(String, String)>();

  // MARK: public methods
  Future<Dio> configuration(Dio dioClient) async {
    final MemCacheStore cacheStore = MemCacheStore(
      maxSize: 10485760,
      maxEntrySize: 1048576,
    );

    // Global options
    final CacheOptions options = CacheOptions(
      // A default store is required for interceptor.
      store: cacheStore,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      hitCacheOnErrorExcept: [StatusCode.forbiden, StatusCode.badGateway],
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: 1.seconds,
      priority: CachePriority.high,
      // Default. Allows 3 cache sets and ease cleanup.
    );

    dioClient.interceptors.add(DioCacheInterceptor(options: options));

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

    // Add interceptor for prevent response when system is maintaining...
    dioClient.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          final bool isRefreshingToken =
              [ApiEndpoints.refreshToken, ApiEndpoints.signOut].contains(
            response.requestOptions.path,
          );

          if (response.statusCode == StatusCode.unauthorized) {
            if (isRefreshingToken) {
              handler.next(response);
              _logOut();
            } else if (_localDataSource.refreshToken != null &&
                _localDataSource.accessToken != null) {
              try {
                final String oldAccessToken =
                    response.requestOptions.headers['Authorization'];

                final (String accessToken, String _) =
                    await onRefreshToken(oldAccessToken: oldAccessToken);

                response.requestOptions.headers['Authorization'] =
                    'Bearer $accessToken';

                final Response cloneReq = await dioClient.fetch(
                  response.requestOptions,
                );

                handler.resolve(cloneReq);
                // ignore: empty_catches
              } catch (_) {
                handler.next(response);
                _logOut();
              }
            } else {
              handler.next(response);
            }
          } else {
            handler.next(response);
          }
        },
        onError: (error, handler) async {},
      ),
    );

    return dioClient;
  }

  Future<(String, String)> onRefreshToken({
    String oldAccessToken = '',
    Function(
      String accessToken,
      String refreshToken,
    )? callback,
  }) async {
    if (oldAccessToken != 'Bearer ${_localDataSource.accessToken}') {
      return (_localDataSource.accessToken!, _localDataSource.refreshToken!);
    }

    final completer = Completer<(String, String)>();
    _refreshTokenCompleters.add(completer);

    if (!_isRefreshing) {
      _isRefreshing = true;

      final (String, String) result = await _performRefreshToken(
        callback: callback,
      );

      _isRefreshing = false;
      _refreshTokenCompleters.completeAllQueue(result);
    }

    return completer.future;
  }

  // MARK: Private methods
  Future<(String, String)> _performRefreshToken({
    Function(
      String accessToken,
      String refreshToken,
    )? callback,
  }) async {
    if (_localDataSource.refreshToken == null) {
      if (_localDataSource.accessToken != null) {
        _logOut();
      }
      return ("", "");
    }

    final Response response = await _remoteData.dio.post(
      ApiEndpoints.refreshToken,
      options: _remoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final String accessToken = response.data['token'];
      final String refreshToken = response.data['refreshToken'];

      _localDataSource.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      callback?.call(accessToken, refreshToken);

      return (accessToken, refreshToken);
    }

    return ("", "");
  }

  void _logOut() {
    AppBloc.authBloc.add(LogOutEvent());
  }
}
