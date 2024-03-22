class BeautyFilters {
  double smoothValue;
  double whiteValue;
  double thinFaceValue;
  double bigEyeValue;
  double lipstickValue;
  double blusherValue;
  BeautyFilters({
    this.smoothValue = 0,
    this.whiteValue = 0,
    this.thinFaceValue = 0,
    this.bigEyeValue = 0,
    this.lipstickValue = 0,
    this.blusherValue = 0,
  });

  BeautyFilters copyWith({
    double? smoothValue,
    double? whiteValue,
    double? thinFaceValue,
    double? bigEyeValue,
    double? lipstickValue,
    double? blusherValue,
  }) {
    return BeautyFilters(
      smoothValue: smoothValue ?? this.smoothValue,
      whiteValue: whiteValue ?? this.whiteValue,
      thinFaceValue: thinFaceValue ?? this.thinFaceValue,
      bigEyeValue: bigEyeValue ?? this.bigEyeValue,
      lipstickValue: lipstickValue ?? this.lipstickValue,
      blusherValue: blusherValue ?? this.blusherValue,
    );
  }
}
