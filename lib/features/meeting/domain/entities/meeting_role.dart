enum MeetingRole {
  host(0),
  attendee(1);

  const MeetingRole(this.value);
  final int value;
}

extension MeetingRoleX on MeetingRole {
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
