// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Project imports:
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/profile/domain/repositories/user_repository.dart';
import 'package:waterbus/features/profile/domain/usecases/get_user_profile.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'get_user_profile_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  late GetUserProfile usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserProfile(mockUserRepository);
  });

  test('should get profile success', () async {
    // arrange
    final Map<String, dynamic> userJson = jsonDecode(
      fixture(userSample),
    );

    // act
    final User user = User.fromMap(userJson);

    when(
      mockUserRepository.getUserProfile(),
    ).thenAnswer(
      (realInvocation) => Future.value(Right(user)),
    );

    // act
    final Either<Failure, User> result = await usecase.call(null);

    // assert
    expect(
      result.isRight(),
      Right<Failure, User>(user).isRight(),
    );

    verify(mockUserRepository.getUserProfile());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should get profile failure', () async {
    when(
      mockUserRepository.getUserProfile(),
    ).thenAnswer(
      (realInvocation) => Future.value(Left(NullValue())),
    );

    // act
    final Either<Failure, User> result = await usecase.call(null);

    // assert
    expect(
      result.isLeft(),
      Left<Failure, User>(NullValue()).isLeft(),
    );

    verify(mockUserRepository.getUserProfile());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
