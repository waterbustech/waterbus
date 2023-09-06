enum MeetingRole {
  host(0),
  attendee(1);

  const MeetingRole(this.value);
  final int value;
}

extension MeetingRoleX on MeetingRole {
  int get value {
    switch (this) {
      case MeetingRole.host:
        return 0;
      case MeetingRole.attendee:
        return 1;
      default:
        throw Exception('Unknown MeetingRole');
    }
  }

  static MeetingRole fromValue(int value) {
    switch (value) {
      case 0:
        return MeetingRole.host;
      case 1:
        return MeetingRole.attendee;
      default:
        throw Exception('Unknown MeetingRole value: $value');
    }
  }
}
