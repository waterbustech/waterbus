extension DurationX on int {
  Duration get milliseconds {
    return Duration(milliseconds: this);
  }

  Duration get seconds {
    return Duration(seconds: this);
  }

  Duration get hours {
    return Duration(hours: this);
  }
}
