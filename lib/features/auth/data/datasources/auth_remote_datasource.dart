// Package imports:
import 'package:auth/models/auth_payload_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/error/auth_failure.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/features/auth/data/models/token_model.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> refreshToken();
  Future<UserModel?> signInWithSocial(AuthPayloadModel authPayload);
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
      body,
    );

    if (response.statusCode == StatusCode.created) {
      return UserModel.fromMapRemote(response.data['responseSuccess']['data']);
    }

    return null;
  }

  @override
  Future<TokenModel> refreshToken() async {
    final Response response = await _baseRemoteData.dio.get(
      ApiEndpoints.refreshToken,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      return TokenModel(
        accessToken:
            response.data['responseSuccess']['data']['accessToken'].toString(),
        refreshToken:
            response.data['responseSuccess']['data']['refreshToken'].toString(),
      );
    }

    throw RefreshTokenExpired();
  }
}
