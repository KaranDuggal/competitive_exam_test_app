import 'dart:io';

class AdHelper {
  // Android Test IDs
  static const String _androidBanner = 'ca-app-pub-9043975919879102/2883302251';
  static const String _androidInterstitial = 'ca-app-pub-9043975919879102/5266651967';
  static const String _androidRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // iOS Test IDs
  static const String _iosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String _iosRewarded = 'ca-app-pub-3940256099942544/1712485313';

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return _androidBanner;
    return _iosBanner;
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) return _androidInterstitial;
    return _iosInterstitial;
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) return _androidRewarded;
    return _iosRewarded;
  }
}
