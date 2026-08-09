import 'package:exam_jyoti/core/services/ad_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;

  bool _isLoading = false;

  void load() {
    if (_isLoading || _interstitialAd != null) {
      return;
    }

    _isLoading = true;

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;

              // Preload the next ad.
              load();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint(
                'Interstitial failed to show: ${error.message}',
              );

              ad.dispose();
              _interstitialAd = null;

              // Preload the next ad.
              load();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          _interstitialAd = null;

          debugPrint(
            'Interstitial failed to load: ${error.message}',
          );
        },
      ),
    );
  }

  Future<void> show({
    required VoidCallback onFinished,
  }) async {
    final ad = _interstitialAd;

    if (ad == null) {
      // No ad available, continue normally.
      onFinished();

      // Try loading one for the next time.
      load();

      return;
    }

    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();

        load();

        onFinished();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint(
          'Interstitial failed to show: ${error.message}',
        );

        ad.dispose();

        load();

        onFinished();
      },
    );

    await ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}