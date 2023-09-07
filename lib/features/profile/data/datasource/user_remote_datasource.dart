// Package imports:
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:waterbus/core/constants/api_endpoints.dart';
import 'package:waterbus/core/types/http_status_code.dart';
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';

abstract class UserRemoteDataSource {
  Future<User?> getUserProfile();
  Future<bool> updateUserProfile(User user);
  Future<String?> getPresignedUrl();
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final BaseRemoteData _remoteData;
  UserRemoteDataSourceImpl(this._remoteData);

  @override
  Future<String?> getPresignedUrl() async {
    final Response response = await _remoteData.postRoute(
      ApiEndpoints.presignedUrlS3,
    );

    if (response.statusCode == StatusCode.created) {
      final Map<String, dynamic> rawData = response.data;
      return rawData['presignedUrl'];
    }

    return null;
  }

  @override
  Future<User?> getUserProfile() async {
    final Response response = await _remoteData.getRoute(ApiEndpoints.users);

    if (response.statusCode == StatusCode.ok) {
      final Map<String, dynamic> rawData = response.data;
      return User.fromMap(rawData);
    }

    return null;
  }

  @override
  Future<bool> updateUserProfile(User user) async {
    final Response response = await _remoteData.putRoute(
      ApiEndpoints.users,
      user.toMap(),
    );

    if (response.statusCode == StatusCode.ok) {
      return true;
    }

    return false;
  }
}
