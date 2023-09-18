// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';

void main() {
  group('MeetingRole', () {
    test('Should return correct integer value for host', () {
      const role = MeetingRole.host;
      expect(role.value, 0);
    });

    test('Should return correct integer value for attendee', () {
      const role = MeetingRole.attendee;
      expect(role.value, 1);
    });

    test('Should return correct MeetingRole for integer value 0', () {
      final role = MeetingRoleX.fromValue(0);
      expect(role, MeetingRole.host);
    });

    test('Should return correct MeetingRole for integer value 1', () {
      final role = MeetingRoleX.fromValue(1);
      expect(role, MeetingRole.attendee);
    });

    test('Should throw an exception for unknown integer value', () {
      expect(() => MeetingRoleX.fromValue(2), throwsA(isA<Exception>()));
    });
  });
}
