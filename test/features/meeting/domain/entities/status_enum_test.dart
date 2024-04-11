// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';

void main() {
  group('StatusEnum tests', () {
    test('StatusEnum.fromValue returns correct enum value', () {
      const inviting = 0;
      const invisibleValue = 1;
      const joinedValue = 2;

      expect(StatusX.fromValue(inviting), equals(StatusEnum.inviting));
      expect(StatusX.fromValue(invisibleValue), equals(StatusEnum.invisible));
      expect(StatusX.fromValue(joinedValue), equals(StatusEnum.joined));
    });

    test('StatusEnum.fromValue throws exception for unknown value', () {
      const unknownValue = 3;

      expect(() => StatusX.fromValue(unknownValue), throwsException);
    });
  });
}
