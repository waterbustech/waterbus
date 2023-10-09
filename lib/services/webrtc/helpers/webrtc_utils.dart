class WebRTCUtils {
  static String removeRTCPMux(String sdp) {
    sdp = sdp.replaceAll(RegExp(r'a=rtcp-mux.*\r\n'), '');

    return sdp;
  }

  static String enableAudioDTX({required String sdp}) {
    sdp = sdp.replaceAll(
      'a=fmtp:111 minptime=10;useinbandfec=1',
      'a=fmtp:111 minptime=10;useinbandfec=1;usedtx=1',
    );
    return sdp;
  }
}
