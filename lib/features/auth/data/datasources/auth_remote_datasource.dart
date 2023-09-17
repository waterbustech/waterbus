// Package imports:
import 'package:auth/models/auth_payload_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/error/auth_failure.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(String, String)> refreshToken();
  Future<UserModel?> signInWithSocial(AuthPayloadModel authPayload);
  Future<bool> logOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final BaseRemoteData _baseRemoteData;

  AuthRemoteDataSourceImpl(this._baseRemoteData);

  @override
  Future<UserModel?> signInWithSocial(AuthPayloadModel authPayload) async {
    final Map<String, dynamic> body = authPayload.toMap();
    final Response response = await _baseRemoteData.postRoute(
      ApiEndpoints.signIn,
      body: body,
    );

    if (response.statusCode == StatusCode.created) {
      return UserModel.fromMapRemote(response.data);
    }

    return null;
  }

  @override
  Future<(String, String)> refreshToken() async {
    final Response response = await _baseRemoteData.dio.post(
      ApiEndpoints.refreshToken,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      final rawData = response.data;
      return (rawData['token'] as String, rawData['refreshToken'] as String);
    }

    throw RefreshTokenExpired();
  }

  @override
  Future<bool> logOut() async {
    final Response response = await _baseRemoteData.postRoute(
      ApiEndpoints.signOut,
    );

    if (response.statusCode == StatusCode.noContent) {
      return true;
    }

    return false;
  }
}
