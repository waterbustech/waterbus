// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:waterbus_sdk/types/index.dart';

import 'package:waterbus/features/meeting/domain/entities/meeting_role.dart';

class Member extends Equatable {
  final int id;
  final MeetingRole role;
  final MemberStatusEnum status;
  final User user;
  final bool isMe;
  const Member({
    required this.id,
    required this.role,
    required this.user,
    this.isMe = false,
    this.status = MemberStatusEnum.joined,
  });

  Member copyWith({
    int? id,
    MeetingRole? role,
    User? user,
    bool? isMe,
    MemberStatusEnum? status,
  }) {
    return Member(
      id: id ?? this.id,
      role: role ?? this.role,
      user: user ?? this.user,
      isMe: isMe ?? this.isMe,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'role': role.value,
      'user': user.toMap(),
      'isMe': isMe,
      'status': status.value,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] as int,
      role: MeetingRoleX.fromValue(map['role'] ?? MeetingRole.attendee.value),
      user: User.fromMap(map['user'] as Map<String, dynamic>),
      isMe: map['isMe'] ?? false,
      status: MemberStatusEnum.fromValue(
        map['status'] ?? MemberStatusEnum.inviting.value,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Participant(id: $id, role: $role, user: $user)';

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.role == role &&
        other.user == user &&
        other.isMe == isMe &&
        other.status == status;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      role.hashCode ^
      user.hashCode ^
      isMe.hashCode ^
      status.hashCode;

  @override
  List<Object> get props {
    return [
      id,
      role,
      status,
      user,
      isMe,
    ];
  }
}
