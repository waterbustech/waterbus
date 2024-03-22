// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/beauty_filters.dart';

void main() {
  group('BeautyFilters', () {
    test('Should create a BeautyFilters instance with default values', () {
      final beautyFilters = BeautyFilters();

      expect(beautyFilters.smoothValue, equals(0));
      expect(beautyFilters.whiteValue, equals(0));
      expect(beautyFilters.thinFaceValue, equals(0));
      expect(beautyFilters.bigEyeValue, equals(0));
      expect(beautyFilters.lipstickValue, equals(0));
      expect(beautyFilters.blusherValue, equals(0));
    });

    test('Should create a BeautyFilters instance with custom values', () {
      final beautyFilters = BeautyFilters(
        smoothValue: 0.5,
        whiteValue: 0.3,
        thinFaceValue: 0.7,
        bigEyeValue: 0.8,
        lipstickValue: 0.4,
        blusherValue: 0.2,
      );

      expect(beautyFilters.smoothValue, equals(0.5));
      expect(beautyFilters.whiteValue, equals(0.3));
      expect(beautyFilters.thinFaceValue, equals(0.7));
      expect(beautyFilters.bigEyeValue, equals(0.8));
      expect(beautyFilters.lipstickValue, equals(0.4));
      expect(beautyFilters.blusherValue, equals(0.2));
    });

    test('Should correctly copy a BeautyFilters instance', () {
      final originalFilters = BeautyFilters(
        smoothValue: 0.2,
        whiteValue: 0.6,
        thinFaceValue: 0.4,
        bigEyeValue: 0.9,
        lipstickValue: 0.3,
        blusherValue: 0.1,
      );

      final copiedFilters0 = originalFilters.copyWith();

      final copiedFilters1 = originalFilters.copyWith(
        smoothValue: 0.8,
        whiteValue: 0.5,
        thinFaceValue: 0.3,
        bigEyeValue: 0.1,
        lipstickValue: 0.4,
        blusherValue: 0.3,
      );

      expect(copiedFilters0.smoothValue, equals(originalFilters.smoothValue));
      expect(copiedFilters0.smoothValue == copiedFilters1.smoothValue, false);

      expect(copiedFilters1.smoothValue, equals(0.8));
      expect(copiedFilters1.whiteValue, equals(0.5));
      expect(copiedFilters1.thinFaceValue, equals(0.3));
      expect(copiedFilters1.bigEyeValue, equals(0.1));
      expect(copiedFilters1.lipstickValue, equals(0.4));
      expect(copiedFilters1.blusherValue, equals(0.3));
    });

    // You can add more tests for other methods or functionality as needed
  });
}
