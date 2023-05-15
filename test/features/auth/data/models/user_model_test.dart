// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/auth/data/models/avatar_model.dart';
import 'package:waterbus/features/auth/data/models/token_model.dart';
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
      // arrange
      final Map<String, dynamic> avatarJson = jsonDecode(
        fixture(avatarModelSample),
      );

      final AvatarModel avatarModel = AvatarModel.fromMap(avatarJson);

      final UserModel userModel1 = UserModel(
        id: "lambiengcode",
        userName: "lambiengcode",
        fullName: "Kai Dao",
        token: TokenModel(
          accessToken: "token_1",
          refreshToken: "token_2",
        ),
        avatar: avatarModel,
      );
      final UserModel userModel2 = UserModel(
        id: "lambiengcode1",
        userName: "lambiengcode",
        fullName: "Kai Dao",
        token: TokenModel(
          accessToken: "token_1",
          refreshToken: "token_2",
        ),
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
      expect(user.toString(), userModel1.toString());
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
        token: TokenModel(
          accessToken: "1",
          refreshToken: "2",
        ),
        id: 'a',
      );
      // assert
      expect(userClone.userName, "lambiengcode1");
      expect(userClone.fullName, "Kai");
      expect(userClone.userName != user.userName, true);
      expect(userClone.fullName != user.fullName, true);
      expect(userClone.token?.accessToken != user.token?.accessToken, true);
      expect(userClone.token?.refreshToken != user.token?.refreshToken, true);
      expect(userClone.id != user.id, true);
      expect(user.hashCode, user.copyWith().hashCode);
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

    test(
      'fromMapRemote - should return a valid model when the JSON',
      () {
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

        // act
        final UserModel user = UserModel.fromMapRemote(
          userJson['responseSuccess']['data'],
        );

        // assert
        expect(user.fullName, "lambiengcode");
        expect(user.avatar, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String userJson = fixture(userModelSample);

        // act
        final UserModel user = UserModel.fromJson(userJson);

        // assert
        expect(user, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userModelJson = jsonDecode(
          fixture(userModelSample),
        );

        // act
        final UserModel user = UserModel.fromMap(userModelJson);

        // assert
        expect(user.toJson(), isNotNull);
      },
    );
  });
}
