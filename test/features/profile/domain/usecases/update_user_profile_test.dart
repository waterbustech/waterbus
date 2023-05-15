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
import 'package:waterbus/features/profile/domain/usecases/update_user_profile.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'get_user_profile_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  late UpdateUserProfile usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdateUserProfile(mockUserRepository);
  });

  test('should update profile success', () async {
    // arrange
    final Map<String, dynamic> userJson = jsonDecode(
      fixture(userSample),
    );

    // act
    final User user = User.fromMap(userJson);

    final User newUser = user.copyWith(
      fullName: "lambiengcode1",
      userName: "lambiengcode.dev",
    );

    when(
      mockUserRepository.updateUserProfile(newUser),
    ).thenAnswer(
      (realInvocation) => Future.value(Right(newUser)),
    );

    // act
    final Either<Failure, User> result = await usecase.call(newUser);

    // assert
    expect(
      result.isRight(),
      Right<Failure, User>(user).isRight(),
    );

    verify(mockUserRepository.updateUserProfile(newUser));
    verifyNever(mockUserRepository.updateUserProfile(user));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
