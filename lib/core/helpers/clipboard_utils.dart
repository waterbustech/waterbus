import 'package:flutter/services.dart';

import 'package:waterbus/core/helpers/device_utils.dart';

/// A Flutter Clipboard Plugin.
class ClipboardUtils {
  /// copy receives a string text and saves to Clipboard
  /// returns void
  static Future<void> copy(String text) async {
    if (text.isNotEmpty) {
      DeviceUtils().lightImpact();
      await Clipboard.setData(ClipboardData(text: text));
      return;
    } else {
      throw 'Please enter a string';
    }
  }

  static Future<void> clearClipboard() async {
    await Clipboard.setData(const ClipboardData(text: ''));
  }

  /// Paste retrieves the data from clipboard.
  static Future<String> paste() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    return data?.text?.toString() ?? "";
  }

  /// controlC receives a string text and saves to Clipboard
  /// returns boolean value
  static Future<bool> controlC(String text) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      return true;
    } else {
      return false;
    }
  }

  /// controlV retrieves the data from clipboard.
  /// same as paste
  /// But returns dynamic data
  static Future<dynamic> controlV() async {
    final ClipboardData? data = await Clipboard.getData('text/plain');
    return data;
  }
}
