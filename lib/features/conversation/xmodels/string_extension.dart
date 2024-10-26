import 'package:waterbus/core/constants/constants.dart';

extension StringExtension on String {
  String formatVietnamese() {
    var result = this;
    for (int i = 0; i < vietnameseRegex.length; i++) {
      result = result.replaceAll(
        vietnameseRegex[i],
        i > vietnamese.length - 1 ? '' : vietnamese[i],
      );
    }
    return result;
  }
}
