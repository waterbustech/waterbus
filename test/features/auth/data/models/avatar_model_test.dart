// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:waterbus/features/auth/data/models/avatar_model.dart';

// Project imports:
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('avatar model', () {
    test(
      'should be a subclass of Avatar Model',
      () {
        // arrange
        final AvatarModel avatar = AvatarModel(
          name: '',
          src: '',
          location: '',
          version: 1,
        );

        expect(avatar, isA<AvatarModel>());
      },
    );
    test('operator ==', () {
      // arrange
      final AvatarModel avatar1 = AvatarModel(
        name: '',
        src: '',
        location: '',
        version: 1,
      );
      final AvatarModel avatar2 = AvatarModel(
        name: '1',
        src: '',
        location: '',
        version: 1,
      );

      expect(avatar1 != avatar2, true);
      expect(avatar1.toString() != avatar2.toString(), true);
    });
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> avatarJson = jsonDecode(
        fixture(avatarModelSample),
      );
      final AvatarModel avatar = AvatarModel.fromMap(avatarJson);

      // act
      final AvatarModel avatarClone = avatar.copyWith(
        id: "2",
        name: "3",
        src: "4",
        location: "5",
      );

      // assert
      expect(avatarClone.id, "2");
      expect(avatarClone.name, "3");
      expect(avatarClone.src, "4");
      expect(avatarClone.location, "5");
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> avatarJson = jsonDecode(
          fixture(avatarModelSample),
        );

        // act
        final AvatarModel avatar = AvatarModel.fromMap(avatarJson);

        // assert
        expect(avatar, isNotNull);
      },
    );
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> avatarJson = jsonDecode(
          fixture(avatarModelSample),
        );

        // act
        final AvatarModel avatar = AvatarModel.fromMap(avatarJson);

        // assert
        expect(avatar, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String avatarJson = fixture(avatarModelSample);

        // act
        final AvatarModel avatar = AvatarModel.fromJson(avatarJson);

        // assert
        expect(avatar, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> avatarJsom = jsonDecode(
          fixture(avatarModelSample),
        );

        // act
        final AvatarModel avatar = AvatarModel.fromMap(avatarJsom);

        // assert
        expect(avatar.toJson(), isNotNull);
      },
    );
  });
}
