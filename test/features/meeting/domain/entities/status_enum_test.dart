// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';

void main() {
  group('StatusEnum tests', () {
    test('StatusEnum.fromValue returns correct enum value', () {
      const activeValue = 0;
      const inactiveValue = 1;

      expect(StatusX.fromValue(activeValue), equals(StatusEnum.active));
      expect(StatusX.fromValue(inactiveValue), equals(StatusEnum.inactive));
    });

    test('StatusEnum.fromValue throws exception for unknown value', () {
      const unknownValue = 2;

      expect(() => StatusX.fromValue(unknownValue), throwsException);
    });
  });
}
