// Package imports:
// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
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
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required File image,
  });
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
  Future<String?> uploadImageToS3({
    required String uploadUrl,
    required File image,
  }) async {
    try {
      final Uri uri = Uri.parse(uploadUrl);

      final http.Response response = await http.put(
        uri,
        body: image.readAsBytesSync(),
        headers: const {"Content-Type": 'image/png'},
      );

      if (response.statusCode == StatusCode.ok) {
        return uploadUrl.split('?').first;
      }

      return null;
    } catch (error) {
      return null;
    }
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
