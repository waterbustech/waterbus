import 'package:flutter/services.dart';

class RoomCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filtered =
        newValue.text.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
    if (filtered.length > 11) {
      filtered = filtered.substring(0, 11);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < filtered.length; i++) {
      buffer.write(filtered[i]);
      if (i == 2 || i == 6) {
        buffer.write('-');
      }
    }

    String formatted = buffer.toString();
    if (formatted.endsWith('-')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
