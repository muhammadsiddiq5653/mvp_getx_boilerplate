import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'storage_service.dart';

class AdMobService extends GetxService {
  final StorageService _storageService = Get.find();

  // Ad Units - Replace with your actual Ad Unit IDs
  static const String _androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String _iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String _androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID
  static const String _androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String _iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Ad state
  final _isBannerAdLoaded = false.obs;
  final _isInterstitialAdLoaded = false.obs;
  final _isRewardedAdLoaded = false.obs;
  final _isAdsEnabled = true.obs;

  // Getters
  bool get isBannerAdLoaded => _isBannerAdLoaded.value;
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded.value;
  bool get isRewardedAdLoaded => _isRewardedAdLoaded.value;
  bool get isAdsEnabled => _isAdsEnabled.value;
  BannerAd? get bannerAd => _bannerAd;

  // Ad Unit IDs
  String get bannerAdUnitId => Platform.isAndroid ? _androidBannerAdUnitId : _iosBannerAdUnitId;
  String get interstitialAdUnitId => Platform.isAndroid ? _androidInterstitialAdUnitId : _iosInterstitialAdUnitId;
  String get rewardedAdUnitId => Platform.isAndroid ? _androidRewardedAdUnitId : _iosRewardedAdUnitId;

  @override
  void onInit() {
    super.onInit();
    _initializeAds();
  }

  Future<void> _initializeAds() async {
    // Load ads preference
    _isAdsEnabled.value = _storageService.read('ads_enabled') ?? true;

    if (!_isAdsEnabled.value) return;

    // Initialize the Mobile Ads SDK
    await MobileAds.instance.initialize();

    // Set request configuration for testing
    final RequestConfiguration requestConfiguration = RequestConfiguration(
      testDeviceIds: ['YOUR_TEST_DEVICE_ID'], // Add your test device ID
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    // Load initial ads
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // Banner Ad Methods
  void loadBannerAd() {
    if (!_isAdsEnabled.value) return;

    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded.value = true;
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded.value = false;
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
        onAdOpened: (ad) => print('Banner ad opened'),
        onAdClosed: (ad) => print('Banner ad closed'),
      ),
    );

    _bannerAd?.load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded.value = false;
  }

  // Interstitial Ad Methods
  void loadInterstitialAd() {
    if (!_isAdsEnabled.value) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded.value = true;
          print('Interstitial ad loaded');

          // Set fullscreen content callback
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) => print('Interstitial ad showed'),
            onAdDismissedFullScreenContent: (ad) {
              print('Interstitial ad dismissed');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded.value = false;
              loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded.value = false;
              loadInterstitialAd(); // Load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoaded.value = false;
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null && _isInterstitialAdLoaded.value) {
      _interstitialAd?.show();
    } else {
      print('Interstitial ad not ready');
      loadInterstitialAd(); // Try to load if not ready
    }
  }

  // Rewarded Ad Methods
  void loadRewardedAd() {
    if (!_isAdsEnabled.value) return;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded.value = true;
          print('Rewarded ad loaded');

          // Set fullscreen content callback
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) => print('Rewarded ad showed'),
            onAdDismissedFullScreenContent: (ad) {
              print('Rewarded ad dismissed');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded.value = false;
              loadRewardedAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded.value = false;
              loadRewardedAd(); // Load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoaded.value = false;
          print('Rewarded ad failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd({required Function(AdWithoutView, RewardItem) onUserEarnedReward}) {
    if (_rewardedAd != null && _isRewardedAdLoaded.value) {
      _rewardedAd?.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      print('Rewarded ad not ready');
      loadRewardedAd(); // Try to load if not ready
    }
  }

  // Ad Settings
  void enableAds() {
    _isAdsEnabled.value = true;
    _storageService.write('ads_enabled', true);
    _initializeAds();
  }

  void disableAds() {
    _isAdsEnabled.value = false;
    _storageService.write('ads_enabled', false);
    disposeAllAds();
  }

  void disposeAllAds() {
    disposeBannerAd();
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isInterstitialAdLoaded.value = false;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdLoaded.value = false;
  }

  @override
  void onClose() {
    disposeAllAds();
    super.onClose();
  }

  // Helper methods for strategic ad placement
  int _interstitialAdCounter = 0;
  static const int _interstitialAdFrequency = 3; // Show every 3 actions

  void incrementInterstitialCounter() {
    _interstitialAdCounter++;
    if (_interstitialAdCounter >= _interstitialAdFrequency) {
      showInterstitialAd();
      _interstitialAdCounter = 0;
    }
  }

  // Check if user has premium (no ads)
  bool get isPremiumUser => _storageService.read('is_premium') ?? false;

  void setPremiumUser(bool isPremium) {
    _storageService.write('is_premium', isPremium);
    if (isPremium) {
      disableAds();
    } else {
      enableAds();
    }
  }
}