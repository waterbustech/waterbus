// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:auth/models/auth_payload_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/auth_failure.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:waterbus/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:waterbus/features/auth/data/models/user_model.dart';
import 'package:waterbus/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/usecases/login_with_social.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'auth_repository_imp_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthLocalDataSource>()])
@GenerateNiceMocks([MockSpec<AuthRemoteDataSource>()])
void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(
      mockAuthLocalDataSource,
      mockAuthRemoteDataSource,
    );
  });

  group('onAuthCheck', () {
    test('auth check success', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final UserModel user = UserModel.fromMap(userJson);

      when(mockAuthLocalDataSource.getUserModel()).thenAnswer(
        (realInvocation) => user,
      );

      when(mockAuthRemoteDataSource.refreshToken()).thenAnswer(
        (realInvocation) => Future.value(('token_1', 'token_2')),
      );

      // act
      final Either<Failure, User> result = await repository.onAuthCheck();

      // assert
      expect(
        result.isRight(),
        Right<Failure, User>(User.fromUserModel(user)).isRight(),
      );

      verify(repository.onAuthCheck());
      verifyNever(
        repository.loginWithSocial(
          AuthParams(
            payloadModel: AuthPayloadModel(fullName: ''),
          ),
        ),
      );
    });

    test('auth check failure - if nothing in local storage', () async {
      when(mockAuthLocalDataSource.getUserModel()).thenAnswer(
        (realInvocation) => null,
      );

      // act
      final Either<Failure, User> result = await repository.onAuthCheck();

      // assert
      expect(
        result.isLeft(),
        Left<Failure, User>(NullValue()).isLeft(),
      );

      verify(repository.onAuthCheck());
      verifyNever(mockAuthRemoteDataSource.refreshToken());
      verifyNever(
        repository.loginWithSocial(
          AuthParams(
            payloadModel: AuthPayloadModel(fullName: ''),
          ),
        ),
      );
    });

    test('auth check failure - refresh token fail (expired)', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final UserModel user = UserModel.fromMap(userJson);

      when(mockAuthLocalDataSource.getUserModel()).thenAnswer(
        (realInvocation) => user,
      );

      when(mockAuthRemoteDataSource.refreshToken()).thenAnswer(
        (realInvocation) => throw RefreshTokenExpired(),
      );

      // act
      final Either<Failure, User> result = await repository.onAuthCheck();

      // assert
      expect(
        result.isLeft(),
        Left<Failure, User>(NullValue()).isLeft(),
      );

      verify(repository.onAuthCheck());
      verifyNever(
        mockAuthLocalDataSource.saveTokens(accessToken: '', refreshToken: ''),
      );
      verifyNever(
        repository.loginWithSocial(
          AuthParams(
            payloadModel: AuthPayloadModel(fullName: ''),
          ),
        ),
      );
    });
  });

  group('logInWithSocial', () {
    final AuthParams authParams = AuthParams(
      payloadModel: AuthPayloadModel(fullName: ''),
    );

    test('login success', () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );
      final UserModel user = UserModel.fromMap(userJson);

      when(mockAuthRemoteDataSource.signInWithSocial(authParams.payloadModel))
          .thenAnswer(
        (realInvocation) => Future.value(user),
      );

      // act
      final Either<Failure, User> result = await repository.loginWithSocial(
        authParams,
      );

      // assert
      expect(
        result.isRight(),
        Right<Failure, User>(User.fromUserModel(user)).isRight(),
      );

      verify(repository.loginWithSocial(authParams));
      verify(mockAuthLocalDataSource.saveUserModel(user));
      verifyNever(
        mockAuthLocalDataSource.saveTokens(accessToken: '', refreshToken: ''),
      );
      verifyNever(
        repository.onAuthCheck(),
      );
    });
  });
}
