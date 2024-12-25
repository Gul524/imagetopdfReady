import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static String? bannerAdUnitId;
  static String? secondBannerAdUnitId;
  static String? rewardInterstitialAdUnitId;
  static String? appOpenAdUnitId;

  static AppOpenAd? appOpenAd;
  static RewardedInterstitialAd? rewardedInterstitialAd;
  static BannerAd? bannerAd;
  static BannerAd? secondBannerAd;

  static bool isAppOpenAdLoaded = false;
  static bool isRewardedInterstitialAdLoaded = false;

  // Initialize Ad IDs
  static void initAdIds() {
    if (Platform.isAndroid) {
      bannerAdUnitId = 'ca-app-pub-3726996144492501/4172252754'; 
      secondBannerAdUnitId = 'ca-app-pub-3726996144492501/9984660676'; 
      rewardInterstitialAdUnitId = 'ca-app-pub-3726996144492501/7367603176';
      appOpenAdUnitId = 'ca-app-pub-3726996144492501/4611134829'; 
    } else if (Platform.isIOS) {
      bannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test Banner
      rewardInterstitialAdUnitId = 'ca-app-pub-3940256099942544/6978759866'; // Test Rewarded Interstitial
      appOpenAdUnitId = 'ca-app-pub-3940256099942544/5662855259'; // Test App Open
    }
  }

  /// Initialize the Google Mobile Ads SDK
  static Future<void> initializeAds() async {
    await MobileAds.instance.initialize();
    initAdIds();
  }

  /// Load App Open Ad
  static Future<void> loadAppOpenAd() async {
    if (appOpenAdUnitId == null) return;

    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          isAppOpenAdLoaded = true;
          print("App Open Ad loaded successfully");
        },
        onAdFailedToLoad: (error) {
          isAppOpenAdLoaded = false;
          print("App Open Ad failed to load: $error");
        },
      ),
    );
  }

  /// Show App Open Ad
  static void showAppOpenAd() {
    if (isAppOpenAdLoaded && appOpenAd != null) {
      appOpenAd!.show();
      appOpenAd = null; // Dispose the reference after showing
      isAppOpenAdLoaded = false;
      loadAppOpenAd(); // Preload the next ad
    } else {
      print("App Open Ad not loaded yet");
    }
  }

  /// Load Rewarded Interstitial Ad
  static Future<void> loadRewardedInterstitialAd() async {
    if (rewardInterstitialAdUnitId == null) return;

    await RewardedInterstitialAd.load(
      adUnitId: rewardInterstitialAdUnitId!,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedInterstitialAd = ad;
          isRewardedInterstitialAdLoaded = true;
          print("Rewarded Interstitial Ad loaded successfully");
        },
        onAdFailedToLoad: (error) {
          isRewardedInterstitialAdLoaded = false;
          print("Rewarded Interstitial Ad failed to load: $error");
        },
      ),
    );
  }

  /// Show Rewarded Interstitial Ad
  static void showRewardedInterstitialAd(Function onRewardEarned) {
    if (isRewardedInterstitialAdLoaded && rewardedInterstitialAd != null) {
      rewardedInterstitialAd!.show(onUserEarnedReward: (ad, reward) {
        print("User earned reward: ${reward.amount} ${reward.type}");
        onRewardEarned();
      });
      rewardedInterstitialAd = null; // Dispose after showing
      isRewardedInterstitialAdLoaded = false;
      loadRewardedInterstitialAd(); // Preload the next ad
    } else {
      print("Rewarded Interstitial Ad not loaded yet");
    }
  }

  /// Create and Load Banner Ad
  static BannerAd? createBannerAd() {
    if (bannerAdUnitId == null) return null;

    bannerAd = BannerAd(
      adUnitId: bannerAdUnitId!,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print("Banner Ad loaded successfully"),
        onAdFailedToLoad: (ad, error) {
          print("Banner Ad failed to load: $error");
          ad.dispose();
        },
      ),
    );
    bannerAd!.load();
    return bannerAd;
  }

  static BannerAd? createSecondBannerAd() {
    if (bannerAdUnitId == null) return null;

    bannerAd = BannerAd(
      adUnitId: secondBannerAdUnitId!,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print("Banner Ad loaded successfully"),
        onAdFailedToLoad: (ad, error) {
          print("Banner Ad failed to load: $error");
          ad.dispose();
        },
      ),
    );
    bannerAd!.load();
    return bannerAd;
  }

  /// Dispose All Ads
  static void disposeAds() {
    appOpenAd?.dispose();
    bannerAd?.dispose();
    rewardedInterstitialAd?.dispose();
  }
}
