enum StatusEnum {
  active(0),
  inactive(1);

  const StatusEnum(this.value);
  final int value;
}

extension StatusX on StatusEnum {
  static StatusEnum fromValue(int value) {
    switch (value) {
      case 0:
        return StatusEnum.active;
      case 1:
        return StatusEnum.inactive;
      default:
        throw Exception('Unknown MeetingRole value: $value');
    }
  }
}
