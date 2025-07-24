import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/firebase_service.dart';
import '../../core/controllers/app_controller.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find();
  final FirebaseService _firebaseService = Get.find();
  final AppController _appController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Add any initialization logic here
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is logged in
      if (_firebaseService.isLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else if (_appController.isFirstTime) {
        Get.offAllNamed(Routes.ONBOARDING);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      // Handle initialization errors
      Get.snackbar('Error', 'Failed to initialize app: ${e.toString()}');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}