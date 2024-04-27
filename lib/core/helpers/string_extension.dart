extension StringExtension on String {
  String get formatRoomCode {
    final String paddedCode = padLeft(9, '0');
    return "${paddedCode.substring(0, 3)}-${paddedCode.substring(3, 6)}-${paddedCode.substring(6)}";
  }
}
