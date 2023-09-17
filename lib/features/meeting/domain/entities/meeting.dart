// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/participant.dart';

class Meeting {
  final int id;
  final String title;
  final List<Participant> users;
  final String code;
  Meeting({
    this.id = -1,
    required this.title,
    this.users = const [],
    this.code = '',
  });

  Meeting copyWith({
    int? id,
    String? title,
    List<Participant>? users,
    String? code,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      users: users ?? this.users,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'users': users.map((x) => x.toMap()).toList(),
      'code': code,
    };
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] as int,
      title: map['title'] as String,
      users: List<Participant>.from(
        (map['users'] as List<int>).map<Participant>(
          (x) => Participant.fromMap(x as Map<String, dynamic>),
        ),
      ),
      code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Meeting(id: $id, title: $title, users: $users, code: $code)';
  }

  @override
  bool operator ==(covariant Meeting other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.users, users) &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ users.hashCode ^ code.hashCode;
  }
}
