import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:waterbus/core/error/failures.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/auth/domain/repositories/auth_repository.dart';
import 'package:waterbus/features/auth/domain/usecases/check_auth.dart';

import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'check_auth_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
void main() {
  late CheckAuth usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = CheckAuth(mockAuthRepository);
  });

  test(
    'should sign in successful',
    () async {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );

      // act
      final User user = User.fromMap(userJson);

      when(
        mockAuthRepository.onAuthCheck(),
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

      verify(mockAuthRepository.onAuthCheck());
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
