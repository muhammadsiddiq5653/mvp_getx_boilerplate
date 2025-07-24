import 'package:get/get.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/admob_service.dart';
import '../../core/controllers/app_controller.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final AdMobService _adMobService = Get.find();
  final AppController _appController = Get.find();

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _isLoading.value = true;

      // Add any data loading logic here
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _appController.showSnackbar('Error', e.toString(), isError: true);
    } finally {
      _isLoading.value = false;
    }
  }

  void showFeatureComingSoon() {
    // Increment interstitial ad counter for strategic placement
    _adMobService.incrementInterstitialCounter();

    _appController.showSnackbar(
      'Coming Soon',
      'This feature is coming soon!',
    );
  }

  void showRewardedAdExample() {
    _adMobService.showRewardedAd(
      onUserEarnedReward: (ad, reward) {
        _appController.showSnackbar(
          'Reward Earned',
          'You earned a reward: ${reward.amount} ${reward.type}',
        );
      },
    );
  }

  void refresh() {
    _loadData();
  }
}
