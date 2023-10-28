enum WebRTCCodec {
  vp8('vp8'),
  h264('h264'),
  av1('av1');

  const WebRTCCodec(this.codec);
  final String codec;
}
