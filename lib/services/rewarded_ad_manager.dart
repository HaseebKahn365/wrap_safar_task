import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

final RewardedAdManager rewardedAdManager = RewardedAdManager();

class RewardedAdManager {
  RewardedAd? _rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test Ad Unit ID
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
              loadRewardedAd(); // Reload the ad after it's dismissed
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('RewardedAd failed to load: $error');
        },
      ),
    );
    log('Ad is now ready');
  }

  void showRewardedAd(Function onAdViewed) {
    if (_rewardedAd != null) {
      _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          onAdViewed(); // Execute the function when the ad is viewed
        },
      );
      loadRewardedAd(); // Automatically reload the ad when it's not available
    } else {
      log('RewardedAd is not ready yet.');
      loadRewardedAd();
    }
  }
}
