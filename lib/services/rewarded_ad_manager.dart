import 'dart:async';
import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

final RewardedAdManager rewardedAdManager = RewardedAdManager();

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  Future<void> loadRewardedAd() async {
    if (_isLoading) {
      log('RewardedAd is already loading...');
      return;
    }

    _isLoading = true;

    try {
      final completer = Completer<void>();

      RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Ad Unit ID
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (RewardedAd ad) {
                ad.dispose();
                _rewardedAd = null;
                // Don't auto-reload here, let the caller decide
              },
              onAdFailedToShowFullScreenContent: (
                RewardedAd ad,
                AdError error,
              ) {
                log('RewardedAd failed to show: $error');
                ad.dispose();
                _rewardedAd = null;
              },
            );
            _isLoading = false;
            log('✅ RewardedAd loaded successfully');
            completer.complete();
          },
          onAdFailedToLoad: (LoadAdError error) {
            log('❌ RewardedAd failed to load: $error');
            _isLoading = false;
            completer.completeError(error);
          },
        ),
      );

      await completer.future;
    } catch (e) {
      _isLoading = false;
      log('❌ Error loading RewardedAd: $e');
      rethrow;
    }
  }

  Future<void> showRewardedAd(Function onAdViewed) async {
    if (_rewardedAd == null) {
      log('RewardedAd is not ready. Loading ad first...');
      await loadRewardedAd();
    }

    if (_rewardedAd != null) {
      try {
        final completer = Completer<void>();

        _rewardedAd?.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            log('✅ User earned reward: ${reward.amount} ${reward.type}');
            onAdViewed(); // Execute the function when the ad is viewed
            completer.complete();
          },
        );

        // Update the full screen callback to complete the future when dismissed
        _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            log('RewardedAd dismissed');
            ad.dispose();
            _rewardedAd = null;
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            log('❌ RewardedAd failed to show: $error');
            ad.dispose();
            _rewardedAd = null;
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
          },
        );

        await completer.future;
        log('✅ RewardedAd interaction completed');

        // Preload the next ad
        await loadRewardedAd();
      } catch (e) {
        log('❌ Error showing RewardedAd: $e');
        rethrow;
      }
    } else {
      throw Exception('RewardedAd failed to load and is not available');
    }
  }

  bool get isAdReady => _rewardedAd != null;
  bool get isLoading => _isLoading;

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
  }
}
