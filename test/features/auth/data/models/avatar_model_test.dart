// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/auth/data/models/avatar_model.dart';
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
        id: '3',
        name: '2',
        src: '1',
        location: '0',
        version: 1,
      );
      final AvatarModel avatar2 = AvatarModel(
        id: '0',
        name: '1',
        src: '2',
        location: '3',
        version: 1,
      );

      expect(avatar1 == avatar1.copyWith(), true);
      expect(avatar1 != avatar2, true);
      expect(avatar1.hashCode, avatar1.copyWith().hashCode);
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
        version: 2,
      );

      // assert
      expect(avatarClone.id, "2");
      expect(avatarClone.name, "3");
      expect(avatarClone.src, "4");
      expect(avatarClone.location, "5");
      expect(avatarClone.version, 2);
      expect(avatar.id != avatarClone.id, true);
      expect(avatar.name != avatarClone.name, true);
      expect(avatar.src != avatarClone.src, true);
      expect(avatar.location != avatarClone.location, true);
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
