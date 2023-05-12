// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/auth/data/models/user_model.dart';
import 'package:waterbus/features/auth/domain/entities/user.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('user model', () {
    test(
      'should be a subclass of User Model',
      () {},
    );
    test('operator ==', () => null);
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );

      // act
      final User user = User.fromMap(userJson);

      final User userClone = user.copyWith(
        userName: "lambiengcode1",
        fullName: "Kai",
      );
      // assert
      expect(userClone.userName, "lambiengcode1");
      expect(userClone.fullName, "Kai");
      expect(userClone.userName != user.userName, true);
      expect(userClone.fullName != user.fullName, true);
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userSample),
        );

        // act
        final User user = User.fromMap(userJson);

        final User userClone = user.copyWith(
          userName: "lambiengcode1",
          fullName: "Kai",
        );

        // assert
        expect(userClone, isNotNull);
      },
    );

    test(
      'fromUserModel - should return a valid model when the JSON',
      () {
        // arrange
        final UserModel userModel = UserModel(
          id: 'lam',
          userName: 'lam',
          fullName: 'Kai',
          accessToken: 'a',
          refreshToken: '',
          avatar: null,
        );

        // act

        final User userActual = User.fromUserModel(userModel);

        // assert
        expect(userActual.id, userModel.id);
        expect(userActual.userName, userModel.userName);
        expect(userActual.fullName, userModel.fullName);
      },
    );
  });
}
