// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:waterbus/features/auth/domain/entities/user.dart';
import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';

class Participant {
  final MeetingRole role;
  final User user;
  Participant({
    required this.role,
    required this.user,
  });

  Participant copyWith({
    MeetingRole? role,
    User? user,
  }) {
    return Participant(
      role: role ?? this.role,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role.value,
      'user': user.toMap(),
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      role: MeetingRoleX.fromValue(map['role'] ?? 1),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Participant(role: $role, user: $user)';

  @override
  bool operator ==(covariant Participant other) {
    if (identical(this, other)) return true;

    return other.role == role && other.user == user;
  }

  @override
  int get hashCode => role.hashCode ^ user.hashCode;
}
