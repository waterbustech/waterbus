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
  group('user entity', () {
    test(
      'should be a subclass of User entity',
      () {},
    );
    test('operator ==', () {
      const User userModel1 = User(
        id: "lambiengcode",
        userName: "lambiengcode",
        fullName: "Kai Dao",
      );
      const User userModel2 = User(
        id: "lambiengcode1",
        userName: "lambiengcode",
        fullName: "Kai Dao",
      );

      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userSample),
      );

      // act
      final User user = User.fromMap(userJson);

      expect(user == userModel1, true);
      expect(user == userModel2, false);
      expect(user.toString(), userModel1.toString());
      expect(user.hashCode, user.copyWith().hashCode);
    });
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

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String userJson = fixture(userSample);

        // act
        final User user = User.fromJson(userJson);

        // assert
        expect(user, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userSample),
        );

        // act
        final User user = User.fromMap(userJson);

        // assert
        expect(user.toJson(), isNotNull);
      },
    );
  });
}
