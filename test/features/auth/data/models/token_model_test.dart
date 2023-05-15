// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:waterbus/features/auth/data/models/token_model.dart';

// Project imports:
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('token model', () {
    test(
      'should be a subclass of Token Model',
      () {
        // arrange
        final TokenModel tokenModel = TokenModel(
          accessToken: 'a',
          refreshToken: 'b',
        );

        expect(tokenModel, isA<TokenModel>());
      },
    );
    test('operator ==', () {
      // arrange
      final TokenModel token1 = TokenModel(accessToken: '1', refreshToken: '2');
      final TokenModel token2 = TokenModel(accessToken: '3', refreshToken: '4');

      expect(token1 == token1.copyWith(), true);
      expect(token1 != token2, true);
      expect(token1.hashCode, token1.copyWith().hashCode);
      expect(token1.toString() != token2.toString(), true);
    });
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> userModelJson = jsonDecode(
        fixture(userModelSample),
      );
      final TokenModel tokenModel = TokenModel.fromMap(userModelJson);

      // act
      final TokenModel tokenModelClone = tokenModel.copyWith(
        accessToken: "99",
        refreshToken: "69",
      );

      // assert
      expect(tokenModelClone.accessToken, "99");
      expect(tokenModelClone.refreshToken, "69");
      expect(tokenModel.accessToken != tokenModelClone.accessToken, true);
      expect(tokenModel.refreshToken != tokenModelClone.refreshToken, true);
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userModelJson = jsonDecode(
          fixture(userModelSample),
        );

        // act
        final TokenModel tokenModel = TokenModel.fromMap(userModelJson);

        // assert
        expect(tokenModel, isNotNull);
      },
    );
    test(
      'toMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> userModelJson = jsonDecode(
          fixture(userModelSample),
        );

        // act
        final TokenModel tokenModel = TokenModel.fromMap(userModelJson);

        // assert
        expect(tokenModel.toMap(), isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String tokenModelJson = fixture(userModelSample);

        // act
        final TokenModel tokenModel = TokenModel.fromJson(tokenModelJson);

        // assert
        expect(tokenModel, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final String tokenModelJson = fixture(userModelSample);

        // act
        final TokenModel tokenModel = TokenModel.fromJson(tokenModelJson);

        // assert
        expect(tokenModel.toJson(), isNotNull);
      },
    );
  });
}
