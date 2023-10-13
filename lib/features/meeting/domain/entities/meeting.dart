// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:waterbus/features/meeting/domain/entities/participant.dart';
import 'package:waterbus/features/meeting/domain/entities/status_enum.dart';

class Meeting extends Equatable {
  final int id;
  final String title;
  final List<Participant> participants;
  final int code;
  final DateTime? createdAt;
  final DateTime? latestJoinedAt;
  const Meeting({
    this.id = -1,
    required this.title,
    this.participants = const [],
    this.code = -1,
    this.createdAt,
    this.latestJoinedAt,
  });

  Meeting copyWith({
    int? id,
    String? title,
    List<Participant>? participants,
    int? code,
    DateTime? createdAt,
    DateTime? latestJoinedAt,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      participants: participants ?? this.participants,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      latestJoinedAt: latestJoinedAt ?? this.latestJoinedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'users': participants.map((x) => x.toMap()).toList(),
      'code': code,
      'createdAt': createdAt.toString(),
      'latestJoinedAt': latestJoinedAt.toString(),
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
      latestJoinedAt: DateTime.parse(
        map['latestJoinedAt'] ?? map['createdAt'],
      ).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Meeting other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.createdAt == createdAt &&
        other.latestJoinedAt == latestJoinedAt &&
        listEquals(other.participants, participants) &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        participants.hashCode ^
        code.hashCode ^
        createdAt.hashCode ^
        latestJoinedAt.hashCode;
  }

  @override
  List<Object?> get props => [
        id,
        participants,
        code,
        createdAt,
        title,
        latestJoinedAt,
      ];

  @override
  bool get stringify => true;
}

extension MeetingX on Meeting {
  List<Participant> get users => participants
      .where((participant) => participant.status == StatusEnum.active)
      .toList();

  List<Participant> get getUniqueUsers {
    final Set<int> uniqueUserIds = <int>{};
    final List<Participant> uniqueParticipants = [];

    for (final Participant participant in participants) {
      if (!uniqueUserIds.contains(participant.user.id)) {
        uniqueUserIds.add(participant.user.id);
        uniqueParticipants.add(participant);
      }
    }

    return uniqueParticipants;
  }

  bool get isNoOneElse {
    if (getUniqueUsers.isEmpty) return true;

    if (getUniqueUsers.length == 1 && getUniqueUsers.first.isMe) {
      return true;
    }

    return false;
  }

  String get inviteLink => 'https:/waterbus.tech/meeting/$code';

  String? get participantsOnlineTile {
    if (users.isEmpty) return null;

    final n = users.length;

    if (n == 1) {
      return '${participants[0].user.fullName} is in the room';
    } else if (n == 2) {
      return '${participants[0].user.fullName} and ${participants[1].user.fullName} are in the room';
    } else {
      final int otherParticipants = n - 2;
      final String participantList = participants
          .sublist(0, 2)
          .map<String>((participant) => participant.user.fullName)
          .join(', ');
      return '$participantList and $otherParticipants others are in the room';
    }
  }

  DateTime get latestJoinedTime {
    return latestJoinedAt ?? createdAt ?? DateTime.now();
  }
}
