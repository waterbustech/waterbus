import 'dart:convert';

class NotificationSettings {
  final bool newMessage;
  final bool newInvitation;
  final bool participantJoined;
  final bool participantLeft;
  final bool participantRaiseHand;
  NotificationSettings({
    this.newMessage = true,
    this.newInvitation = true,
    this.participantJoined = true,
    this.participantLeft = true,
    this.participantRaiseHand = true,
  });

  NotificationSettings copyWith({
    bool? newMessage,
    bool? newInvitation,
    bool? participantJoined,
    bool? participantLeft,
    bool? participantRaiseHand,
  }) {
    return NotificationSettings(
      newMessage: newMessage ?? this.newMessage,
      newInvitation: newInvitation ?? this.newInvitation,
      participantJoined: participantJoined ?? this.participantJoined,
      participantLeft: participantLeft ?? this.participantLeft,
      participantRaiseHand: participantRaiseHand ?? this.participantRaiseHand,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'newMessage': newMessage,
      'newInvitation': newInvitation,
      'participantJoined': participantJoined,
      'participantLeft': participantLeft,
      'participantRaiseHand': participantRaiseHand,
    };
  }

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      newMessage: map['newMessage'] ?? true,
      newInvitation: map['newInvitation'] ?? true,
      participantJoined: map['participantJoined'] ?? true,
      participantLeft: map['participantLeft'] ?? true,
      participantRaiseHand: map['participantRaiseHand'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationSettings.fromJson(String source) =>
      NotificationSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationSetting(newMessage: $newMessage, newInvitation: $newInvitation, participantJoined: $participantJoined, participantLeft: $participantLeft, participantRaiseHand: $participantRaiseHand)';
  }

  @override
  bool operator ==(covariant NotificationSettings other) {
    if (identical(this, other)) return true;

    return other.newMessage == newMessage &&
        other.newInvitation == newInvitation &&
        other.participantJoined == participantJoined &&
        other.participantLeft == participantLeft &&
        other.participantRaiseHand == participantRaiseHand;
  }

  @override
  int get hashCode {
    return newMessage.hashCode ^
        newInvitation.hashCode ^
        participantJoined.hashCode ^
        participantLeft.hashCode ^
        participantRaiseHand.hashCode;
  }
}
