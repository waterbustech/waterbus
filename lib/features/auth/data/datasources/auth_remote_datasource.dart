// Package imports:
// ignore_for_file: dead_code

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
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final BaseRemoteData _baseRemoteData;

  AuthRemoteDataSourceImpl(this._baseRemoteData);

  @override
  Future<UserModel?> signInWithSocial(AuthPayloadModel authPayload) async {
    return UserModel.fromMapRemote({
      "_id": "lambiengcode",
      "userName": "lambiengcode",
      "fullName": "Kai Dao",
      "accessToken": "token_1",
      "refreshToken": "token_2",
      "avatar": {
        "_id": "1",
        "name": "a",
        "src": "b",
        "location": "https://avatars.githubusercontent.com/u/60530946?v=4",
        "v": 1
      }
    });
    final Map<String, dynamic> body = authPayload.toMap();
    final Response response = await _baseRemoteData.postRoute(
      ApiEndpoints.signIn,
      body,
    );

    if (response.statusCode == StatusCode.created) {
      return UserModel.fromMapRemote({
        "_id": "lambiengcode",
        "userName": "lambiengcode",
        "fullName": "Kai Dao",
        "accessToken": "token_1",
        "refreshToken": "token_2",
        "avatar": {
          "_id": "1",
          "name": "a",
          "src": "b",
          "location": "location",
          "v": 1
        }
      });
    }

    return null;
  }

  @override
  Future<(String, String)> refreshToken() async {
    return ('access_token', 'user_token');
    final Response response = await _baseRemoteData.dio.get(
      ApiEndpoints.refreshToken,
      options: _baseRemoteData.getOptionsRefreshToken,
    );

    if (response.statusCode == StatusCode.ok) {
      return ('access_token', 'user_token');
    }

    throw RefreshTokenExpired();
  }
}
