// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import '../../../../constants/sample_file_path.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('Participant', () {
    final String participantJson = fixture(participantSample);
    const User userModel = User(
      id: 1,
      userName: 'lambiengcode',
      fullName: 'Kai',
    );
    const User hostModel = User(
      id: 2,
      userName: 'lambiencode1',
      fullName: 'KaiDao',
    );

    test('Should create a Participant instance', () {
      const participant = Participant(
        id: 1,
        user: userModel,
      );

      expect(participant, isA<Participant>());
      expect(participant.id, 1);
      expect(participant.user, userModel);
    });

    test('Should create a new Participant instance with updated values', () {
      const User userModel = User(
        id: 1,
        userName: 'lambiengcode',
        fullName: 'Kai',
      );

      const User updatedUserModel = User(
        id: 2,
        userName: 'updatedUserName',
        fullName: 'UpdatedName',
      );

      const participant = Participant(
        id: 1,
        user: userModel,
      );

      final updatedParticipant1 = participant.copyWith(
        id: 2,
        user: updatedUserModel,
      );
      final updatedParticipant2 = participant.copyWith();

      expect(participant == updatedParticipant2, true);
      expect(updatedParticipant1, isA<Participant>());
      expect(updatedParticipant1.id, 2);
      expect(updatedParticipant1.user, updatedUserModel);
    });

    test('Should convert Participant to Map', () {
      const participant = Participant(
        id: 1,
        user: userModel,
      );

      final participantMap = participant.toMap();
      expect(participantMap, isA<Map<String, dynamic>>());
      expect(participantMap['id'], 1);
      expect(participantMap['user'], isA<Map<String, dynamic>>());
    });

    test('Should create Participant from Map', () {
      final participantMap = json.decode(participantJson);
      final participant = Participant.fromMap(participantMap);

      expect(participant, isA<Participant>());
      expect(participant.id, 1);
      expect(participant.user, userModel);
    });

    test('Should convert Participant to JSON', () {
      const participant = Participant(
        id: 1,
        user: userModel,
      );

      final participantJsonString = participant.toJson();
      expect(participantJsonString, isA<String>());
      expect(participantJsonString, jsonEncode(jsonDecode(participantJson)));
    });

    test('Should create Participant from JSON', () {
      final participant = Participant.fromJson(participantJson);

      expect(participant, isA<Participant>());
      expect(participant.id, 1);
      expect(participant.user, userModel);
    });

    test('Should check equality of Participant instances', () {
      const participant1 = Participant(
        id: 1,
        user: userModel,
      );

      const participant2 = Participant(
        id: 1,
        user: userModel,
      );

      const participant3 = Participant(
        id: 2,
        user: hostModel,
      );

      expect(participant1, equals(participant2));
      expect(participant1.hashCode, equals(participant2.hashCode));

      expect(participant1, isNot(equals(participant3)));
      expect(participant1.hashCode, isNot(equals(participant3.hashCode)));
    });

    test('toString - should return a string representation of the Participant',
        () {
      const participant = Participant(
        id: 1,
        user: userModel,
      );

      final participantString = participant.toString();

      expect(participantString, contains('Participant'));
      expect(participantString, contains(participant.id.toString()));
    });

    test('should have correct props', () {
      // Arrange
      const participant1 = Participant(
        id: 1,
        user: userModel,
      );

      const participant2 = Participant(
        id: 2,
        user: userModel,
      );

      // Act & Assert
      expect(participant1.props, [
        participant1.id,
        participant1.user,
        participant1.isMe,
      ]);

      expect(participant1.props, isNot(equals(participant2.props)));
    });
  });
}
