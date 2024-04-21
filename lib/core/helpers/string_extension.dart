extension StringExtension on String {
  String get formatRoomCode {
    String code = this;

    for (int i = length; i < 9; i++) {
      code = "0$code";
    }

    return "${code.substring(0, 3)}-${code.substring(3, 6)}-${code.substring(6, 9)}";
  }
}
