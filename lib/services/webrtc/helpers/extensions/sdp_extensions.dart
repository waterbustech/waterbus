extension SdpX on String {
  String removeRTCPMux() {
    return replaceAll(RegExp(r'a=rtcp-mux.*\r\n'), '');
  }

  String enableAudioDTX() {
    return replaceAll(
      'a=fmtp:111 minptime=10;useinbandfec=1',
      'a=fmtp:111 minptime=10;useinbandfec=1;usedtx=1',
    );
  }
}
