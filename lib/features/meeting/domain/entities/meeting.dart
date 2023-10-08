// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';

class Meeting {
  final int id;
  final String title;
  final List<Participant> participants;
  final int code;
  final DateTime? createdAt;
  Meeting({
    this.id = -1,
    required this.title,
    this.participants = const [],
    this.code = -1,
    this.createdAt,
  });

  Meeting copyWith({
    int? id,
    String? title,
    List<Participant>? participants,
    int? code,
    DateTime? createdAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      participants: participants ?? this.participants,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'users': participants.map((x) => x.toMap()).toList(),
      'code': code,
      'createdAt': createdAt.toString(),
    };
  }

  Map<String, dynamic> toMapCreate(String password) {
    return {
      'title': title,
      'password': password,
      'code': code,
    };
  }

  factory Meeting.fromMap(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] as int,
      title: map['title'] as String,
      participants: List<Participant>.from(
        (map['users'] as List).map<Participant>(
          (x) => Participant.fromMap(x as Map<String, dynamic>),
        ),
      ),
      code: map['code'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Meeting(id: $id, title: $title, users: $participants, code: $code)';
  }

  @override
  bool operator ==(covariant Meeting other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.participants, participants) &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ participants.hashCode ^ code.hashCode;
  }
}

extension MeetingX on Meeting {
  List<Participant> get users => participants
      .where((participant) => participant.status == StatusEnum.active)
      .toList();

  List<Participant> get getUniqueUsers {
    final Set<int> uniqueStatuses =
        participants.map((participant) => participant.user.id).toSet();

    return participants
        .where((participant) => uniqueStatuses.contains(participant.user.id))
        .toList();
  }

  bool get isNoOneElse {
    if (getUniqueUsers.isEmpty) return true;

    if (getUniqueUsers.length == 1 && getUniqueUsers.first.isMe) {
      return true;
    }

    return false;
  }
}
