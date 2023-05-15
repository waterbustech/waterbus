// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/data/datasources/user_remote_datasource.dart';
import 'package:waterbus/features/profile/data/repositories/user_repository_impl.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRemoteDataSource>()])
void main() {
  late UserRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(mockRemoteDataSource);
  });

  group('test get user profile', () {
    // arrange
    final Map<String, dynamic> userJson = {
      "responseSuccess": {
        "data": {
          "accessToken":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDVjYTAzOTE1MDAxYTQ5ZjczYjg5YTkiLCJpYXQiOjE2ODM4NjU0NzgsImV4cCI6MTY4Mzg2NjA3OH0.LwJ5iFGBUA9kdwOiDt5gNsvfR0ccN7FdoXcKSY2--b0",
          "refreshToken":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDVjYTAzOTE1MDAxYTQ5ZjczYjg5YTkiLCJpYXQiOjE2ODM4NjU0NzgsImV4cCI6MTY4Mzk1MTg3OH0.cGePZPTDYjEO5_OH7_Ek7wcL2vYNx4BhuMXq0dmqCRQ",
          "user": {
            "_id": "645ca03915001a49f73b89a9",
            "googleId": "222223332",
            "fullName": "lambiengcode",
            "userName": "lam-bieng-code.714552",
            "status": 0,
            "activeStatus": 0,
            "createdAt":
                "Thu May 11 2023 07:58:20 GMT+0000 (Coordinated Universal Time)",
            "modifiedAt":
                "Thu May 11 2023 07:58:20 GMT+0000 (Coordinated Universal Time)",
            "avatar": {
              "_id": "1",
              "name": "a",
              "src": "b",
              "location": "location",
              "v": 1
            }
          }
        },
        "message": "done"
      }
    };

    final UserModel userModel = UserModel.fromMapRemote(
      userJson['responseSuccess']['data'],
    );

    test(
      'get user profile successfully',
      () async {
        when(mockRemoteDataSource.getUserProfile()).thenAnswer(
          (realInvocation) => Future.value(userModel),
        );

        final Either<Failure, User> result = await repository.getUserProfile();

        expect(
          result.isRight(),
          Right<Failure, User>(User.fromUserModel(userModel)).isRight(),
        );
        verify(mockRemoteDataSource.getUserProfile());
        verifyNever(mockRemoteDataSource.updateUserProfile(userModel));
      },
    );

    test(
      'get user profile fail',
      () async {
        when(mockRemoteDataSource.getUserProfile()).thenAnswer(
          (realInvocation) => Future.value(),
        );

        final Either<Failure, User> result = await repository.getUserProfile();

        expect(result.isLeft(), Left<Failure, User>(NullValue()).isLeft());
        verify(mockRemoteDataSource.getUserProfile());
        verifyNever(mockRemoteDataSource.updateUserProfile(userModel));
      },
    );
  });
  group('test update user profile', () {
    // arrange
    final Map<String, dynamic> userJson = {
      "responseSuccess": {
        "data": {
          "accessToken":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDVjYTAzOTE1MDAxYTQ5ZjczYjg5YTkiLCJpYXQiOjE2ODM4NjU0NzgsImV4cCI6MTY4Mzg2NjA3OH0.LwJ5iFGBUA9kdwOiDt5gNsvfR0ccN7FdoXcKSY2--b0",
          "refreshToken":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NDVjYTAzOTE1MDAxYTQ5ZjczYjg5YTkiLCJpYXQiOjE2ODM4NjU0NzgsImV4cCI6MTY4Mzk1MTg3OH0.cGePZPTDYjEO5_OH7_Ek7wcL2vYNx4BhuMXq0dmqCRQ",
          "user": {
            "_id": "645ca03915001a49f73b89a9",
            "googleId": "222223332",
            "fullName": "lambiengcode",
            "userName": "lam-bieng-code.714552",
            "status": 0,
            "activeStatus": 0,
            "createdAt":
                "Thu May 11 2023 07:58:20 GMT+0000 (Coordinated Universal Time)",
            "modifiedAt":
                "Thu May 11 2023 07:58:20 GMT+0000 (Coordinated Universal Time)",
            "avatar": {
              "_id": "1",
              "name": "a",
              "src": "b",
              "location": "location",
              "v": 1
            }
          }
        },
        "message": "done"
      }
    };

    final UserModel userModel = UserModel.fromMapRemote(
      userJson['responseSuccess']['data'],
    );

    final UserModel newUserModel = userModel.copyWith(
      fullName: "Kai",
    );

    final User userEntity = User.fromUserModel(newUserModel);

    test('update profile successfully', () async {
      when(
        mockRemoteDataSource
            .updateUserProfile(UserModel.fromUserEntity(userEntity)),
      ).thenAnswer(
        (realInvocation) => Future.value(newUserModel),
      );

      final Either<Failure, User> result = await repository.updateUserProfile(
        userEntity,
      );

      expect(
        result.isRight(),
        Right<Failure, User>(userEntity).isRight(),
      );

      verify(
        mockRemoteDataSource
            .updateUserProfile(UserModel.fromUserEntity(userEntity)),
      );
      verifyNever(mockRemoteDataSource.updateUserProfile(userModel));
      verifyNever(mockRemoteDataSource.getUserProfile());
    });

    test('update profile failure', () async {
      when(
        mockRemoteDataSource.updateUserProfile(
          UserModel.fromUserEntity(userEntity),
        ),
      ).thenAnswer(
        (realInvocation) => Future.value(),
      );

      final Either<Failure, User> result = await repository.updateUserProfile(
        userEntity,
      );

      expect(
        result.isLeft(),
        Left<Failure, User>(NullValue()).isLeft(),
      );

      verify(
        mockRemoteDataSource.updateUserProfile(
          UserModel.fromUserEntity(userEntity),
        ),
      );
      verifyNever(mockRemoteDataSource.updateUserProfile(userModel));
      verifyNever(mockRemoteDataSource.getUserProfile());
    });
  });
}
