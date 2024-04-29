// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

class TabOption {
  final String key;
  final Widget tab;
  TabOption({
    required this.key,
    required this.tab,
  });

  TabOption copyWith({
    String? key,
    Widget? tab,
  }) {
    return TabOption(
      key: key ?? this.key,
      tab: tab ?? this.tab,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
    };
  }

  factory TabOption.fromMap(Map<String, dynamic> map) {
    return TabOption(
      key: map['key'] as String,
      tab: const SizedBox(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TabOption.fromJson(String source) =>
      TabOption.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TabOption(key: $key, tab: $tab)';

  @override
  bool operator ==(covariant TabOption other) {
    if (identical(this, other)) return true;

    return other.key == key && other.tab == tab;
  }

  @override
  int get hashCode => key.hashCode ^ tab.hashCode;
}
