import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/admob_service.dart';
import '../../core/controllers/app_controller.dart';
import '../../routes/app_routes.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  final List<String>? features;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
    this.features,
  });
}

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find();
  final AdMobService _adMobService = Get.find();
  final AppController _appController = Get.find();

  // Page controller
  final PageController pageController = PageController();

  // State variables
  final _currentPage = 0.obs;

  // Getters
  int get currentPage => _currentPage.value;
  bool get isLastPage => _currentPage.value == onboardingPages.length - 1;

  // Onboarding pages data
  final List<OnboardingPage> onboardingPages = [
    OnboardingPage(
      title: 'Welcome to MVP Boilerplate',
      description: 'Your ultimate Flutter boilerplate for rapid MVP development with modern architecture and best practices.',
      icon: Icons.rocket_launch,
      backgroundColor: const Color(0xFF6366F1),
      features: [
        'Modern GetX architecture',
        'Firebase backend integration',
        'Social authentication ready',
        'AdMob monetization built-in',
      ],
    ),
    OnboardingPage(
      title: 'Powerful Authentication',
      description: 'Secure user authentication with email/password and social login options including Google, Apple, and Facebook.',
      icon: Icons.security,
      backgroundColor: const Color(0xFF10B981),
      features: [
        'Email/Password authentication',
        'Google Sign-In',
        'Apple Sign-In (iOS)',
        'Facebook Login',
        'Email verification',
        'Password recovery',
      ],
    ),
    OnboardingPage(
      title: 'Complete Profile Management',
      description: 'Full-featured profile system with image upload, verification, and comprehensive user data management.',
      icon: Icons.person,
      backgroundColor: const Color(0xFF8B5CF6),
      features: [
        'Profile picture upload',
        'Personal information management',
        'Email & phone verification',
        'Privacy controls',
        'Account settings',
      ],
    ),
    OnboardingPage(
      title: 'Firebase Integration',
      description: 'Seamless Firebase integration with real-time database, cloud storage, analytics, and push notifications.',
      icon: Icons.cloud,
      backgroundColor: const Color(0xFFF59E0B),
      features: [
        'Real-time Firestore database',
        'Cloud Storage for files',
        'Push notifications (FCM)',
        'Analytics & Crashlytics',
        'Offline support',
      ],
    ),
    OnboardingPage(
      title: 'Monetization Ready',
      description: 'Built-in AdMob integration with strategic ad placement and premium features for revenue generation.',
      icon: Icons.monetization_on,
      backgroundColor: const Color(0xFFEF4444),
      features: [
        'Banner ads',
        'Interstitial ads',
        'Rewarded video ads',
        'Premium/Pro features',
        'Ad-free experience option',
      ],
    ),
    OnboardingPage(
      title: 'Ready to Build!',
      description: 'Everything is set up and ready to go. Start building your amazing app with this comprehensive boilerplate.',
      icon: Icons.build,
      backgroundColor: const Color(0xFF06B6D4),
      features: [
        'Clean architecture',
        'Responsive design',
        'Dark/Light theme',
        'Comprehensive documentation',
        'Production ready',
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Load initial ads
    _adMobService.loadInterstitialAd();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Page change handler
  void onPageChanged(int index) {
    _currentPage.value = index;
  }

  // Navigation methods
  void nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Skip onboarding
  void skipOnboarding() {
    _showSkipDialog();
  }

  void _showSkipDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Skip Onboarding?'),
        content: const Text(
          'Are you sure you want to skip the introduction? You can always find this information in the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Stay'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              finishOnboarding();
            },
            child: const Text('Skip'),
          ),
        ],
      ),
    );
  }

  // Finish onboarding
  void finishOnboarding() {
    // Show interstitial ad before finishing
    _adMobService.showInterstitialAd();

    // Mark first time as false
    _appController.setFirstTime(false);

    // Navigate to login
    Get.offAllNamed(Routes.LOGIN);

    // Show welcome message
    _appController.showSnackbar(
      'Welcome!',
      'Thanks for checking out the MVP Boilerplate. Let\'s get you started!',
    );
  }

  // Go to specific page
  void goToPage(int index) {
    if (index >= 0 && index < onboardingPages.length) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Get page progress
  double get progress => (currentPage + 1) / onboardingPages.length;

  // Get current page data
  OnboardingPage get currentPageData => onboardingPages[currentPage];
}