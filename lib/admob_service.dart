import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9375718730337475/2367553909";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9375718730337475/6769208622";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}