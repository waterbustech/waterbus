// Package imports:
import 'package:injectable/injectable.dart';
import 'package:waterbus/core/constants/api_endpoints.dart';

// Project imports:
import 'package:waterbus/core/utils/datasources/base_remote_data.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel?> getUserProfile();
  Future<UserModel?> updateUserProfile(UserModel userModel);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final BaseRemoteData _baseRemoteData;

  UserRemoteDataSourceImpl(this._baseRemoteData);

  @override
  Future<UserModel?> getUserProfile() async {
    _baseRemoteData.getRoute(ApiEndpoints.userInfo);
    return null;
  }

  @override
  Future<UserModel?> updateUserProfile(UserModel userModel) async {
    return null;
  }
}
