// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/meeting.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('meeting entity', () {
    test(
      'should be a subclass of Meeting entity',
      () {},
    );
    test('operator ==', () {
      final Meeting meeting1 = Meeting(title: 'Meeting with Kai 1');
      final Meeting meeting2 = Meeting(title: 'Meeting with Kai 2');

      // arrange
      final Map<String, dynamic> meetingSampleJson = jsonDecode(
        fixture(meetingSample),
      );

      // act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);

      expect(meeting.title == meeting1.title, true);
      expect(meeting == meeting2, false);
    });
  });

  group('copyWith', () {
    test('should return new value', () {
      // arrange
      final Map<String, dynamic> meetingSampleJson = jsonDecode(
        fixture(meetingSample),
      );

      // act
      final Meeting meeting = Meeting.fromMap(meetingSampleJson);

      final Meeting meetingClone = meeting.copyWith(title: 'Meeting with Kai');
      // assert
      expect(meetingClone.title, 'Meeting with Kai');
    });
  });

  group('fromMap', () {
    test(
      'fromMap - should return a valid model when the JSON',
      () {
        // arrange
        final Map<String, dynamic> meetingSampleJson = jsonDecode(
          fixture(meetingSample),
        );

        // act
        final Meeting meeting = Meeting.fromMap(meetingSampleJson);

        // assert
        expect(meeting, isNotNull);
      },
    );
  });

  group('fromJson', () {
    test(
      'fromJson - should return a valid model when the JSON',
      () {
        // arrange
        final String meetingSampleJson = fixture(meetingSample);

        // act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // assert
        expect(meeting, isNotNull);
      },
    );

    test(
      'toJson - should return a valid model when the JSON',
      () {
        // arrange
        final String meetingSampleJson = fixture(meetingSample);

        // act
        final Meeting meeting = Meeting.fromJson(meetingSampleJson);

        // assert
        expect(meeting.toJson(), isNotNull);
      },
    );
  });
}
