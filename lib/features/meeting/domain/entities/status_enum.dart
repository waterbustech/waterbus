enum StatusEnum {
  inviting(0),
  invisible(1),
  joined(2);

  const StatusEnum(this.value);
  final int value;
}

extension StatusX on StatusEnum {
  static StatusEnum fromValue(int value) {
    switch (value) {
      case 0:
        return StatusEnum.inviting;
      case 1:
        return StatusEnum.invisible;
      case 2:
        return StatusEnum.joined;
      default:
        throw Exception('Unknown MeetingRole value: $value');
    }
  }
}
