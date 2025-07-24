import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/admob_service.dart';
import '../../core/controllers/app_controller.dart';
import '../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final AdMobService _adMobService = Get.find();
  final AppController _appController = Get.find();

  // Getters
  bool get isAdsEnabled => _adMobService.isAdsEnabled;
  bool get isPremiumUser => _adMobService.isPremiumUser;

  String get currentThemeText {
    switch (_appController.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }

  void showThemeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: _appController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  _appController.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _appController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  _appController.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: _appController.themeMode,
              onChanged: (value) {
                if (value != null) {
                  _appController.changeThemeMode(value);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void toggleAds(bool value) {
    if (value) {
      _adMobService.enableAds();
      _appController.showSnackbar(
        'Ads Enabled',
        'Ads help support the development of this app',
      );
    } else {
      _adMobService.disableAds();
      _appController.showSnackbar(
        'Ads Disabled',
        'You can re-enable ads anytime from settings',
      );
    }
  }

  void showPremiumDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('🌟 Upgrade to Premium'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium features include:'),
            SizedBox(height: 8),
            Text('• Ad-free experience'),
            Text('• Exclusive features'),
            Text('• Priority support'),
            Text('• Early access to new features'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _purchasePremium();
            },
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  void _purchasePremium() {
    // In a real app, integrate with in-app purchases
    // For demo purposes, we'll just enable premium
    _adMobService.setPremiumUser(true);
    _appController.showSnackbar(
      'Premium Activated!',
      'Thank you for supporting us!',
    );
  }

  void showRewardedAd() {
    _adMobService.showRewardedAd(
     onUserEarnedReward: (ad, reward) {
        _appController.showSnackbar(
          'Reward Earned',
          'You earned a reward: ${reward.amount} ${reward.type}',
        );
      },
    );
  }

  void goToProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  void showSignOutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await _firebaseService.signOut();
      Get.offAllNamed(Routes.LOGIN);
      _appController.showSnackbar(
        'Signed Out',
        'You have been signed out successfully',
      );
    } catch (e) {
      _appController.showSnackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        isError: true,
      );
    }
  }

  void showAboutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('About MVP Boilerplate'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('A Flutter boilerplate for rapid MVP development with Firebase, GetX, and AdMob integration.'),
            SizedBox(height: 16),
            Text('Built with ❤️ for developers'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void openPrivacyPolicy() async {
    const url = 'https://your-app.com/privacy-policy';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _appController.showSnackbar(
        'Error',
        'Could not open privacy policy',
        isError: true,
      );
    }
  }

  void openTermsOfService() async {
    const url = 'https://your-app.com/terms-of-service';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      _appController.showSnackbar(
        'Error',
        'Could not open terms of service',
        isError: true,
      );
    }
  }
}