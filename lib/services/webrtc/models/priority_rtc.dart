enum Priority {
  veryLow,
  low,
  medium,
  high,
}

extension PriorityExtension on Priority {
  static const Map<String, Priority> types = {
    'very-low': Priority.veryLow,
    'low': Priority.low,
    'medium': Priority.medium,
    'high': Priority.high,
  };

  static const Map<Priority, String> values = {
    Priority.veryLow: 'very-low',
    Priority.low: 'low',
    Priority.medium: 'medium',
    Priority.high: 'high',
  };

  static Priority fromString(String i) => types[i]!;
  String get value => values[this]!;
}
