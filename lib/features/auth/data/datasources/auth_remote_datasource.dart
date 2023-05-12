// Package imports:
import 'package:auth/models/auth_payload_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
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
      return UserModel.fromMapRemote(response.data['data']);
    }

    return null;
  }
}
