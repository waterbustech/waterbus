// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/auth/data/models/user_model.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('user model', () {
    test(
      'should be a subclass of User entity',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userModelSample),
        );

        // act
        final UserModel user = UserModel.fromMap(userJson);

        expect(user, isA<UserModel>());
      },
    );
    test('operator ==', () {
      final UserModel userModel1 = UserModel(
        id: "lambiengcode",
        userName: "lambiengcode",
        fullName: "Kai Dao",
        accessToken: "token_1",
        refreshToken: "token_2",
        avatar: null,
      );
      final UserModel userModel2 = UserModel(
        id: "lambiengcode1",
        userName: "lambiengcode",
        fullName: "Kai Dao",
        accessToken: "token_1",
        refreshToken: "token_2",
        avatar: null,
      );

      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userModelSample),
      );

      // act
      final UserModel user = UserModel.fromMap(userJson);

      expect(user == userModel1, true);
      expect(user == userModel2, false);
    });
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> userJson = jsonDecode(
        fixture(userModelSample),
      );

      // act
      final UserModel user = UserModel.fromMap(userJson);

      final UserModel userClone = user.copyWith(
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
          fixture(userModelSample),
        );

        // act
        final UserModel user = UserModel.fromMap(userJson);

        final UserModel userClone = user.copyWith(
          userName: "lambiengcode1",
          fullName: "Kai",
        );

        // assert
        expect(userClone, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userJson = jsonDecode(
          fixture(userSample),
        );

        // act
        final UserModel user = UserModel.fromMap(userJson);

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
        final UserModel user = UserModel.fromMap(userJson);

        // assert
        expect(user.toJson(), isNotNull);
      },
    );
  });
}
