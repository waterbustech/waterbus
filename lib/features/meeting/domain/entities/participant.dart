// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';

class Participant {
  final int id;
  final MeetingRole role;
  final User user;
  bool isMe;
  Participant({
    required this.id,
    required this.role,
    required this.user,
    this.isMe = false,
  });

  Participant copyWith({
    int? id,
    MeetingRole? role,
    User? user,
    bool? isMe,
  }) {
    return Participant(
      id: id ?? this.id,
      role: role ?? this.role,
      user: user ?? this.user,
      isMe: isMe ?? this.isMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role.value,
      'user': user.toMap(),
      'isMe': isMe,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      id: map['id'] as int,
      role: MeetingRoleX.fromValue(map['role'] ?? 1),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      isMe: map['isMe'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Participant(id: $id, role: $role, user: $user)';

  @override
  bool operator ==(covariant Participant other) {
    if (identical(this, other)) return true;

    return other.id == id && other.role == role && other.user == user;
  }

  @override
  int get hashCode => id.hashCode ^ role.hashCode ^ user.hashCode;
}
