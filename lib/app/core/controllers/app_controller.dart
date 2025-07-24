import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class AppController extends GetxController {
  final StorageService _storageService = Get.find();

  // Theme Management
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // App State
  final _isFirstTime = true.obs;
  bool get isFirstTime => _isFirstTime.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadAppSettings();
  }

  void _loadAppSettings() {
    // Load theme mode
    final savedTheme = _storageService.getThemeMode();
    if (savedTheme != null) {
      _themeMode.value = savedTheme;
    }

    // Load first time status
    _isFirstTime.value = _storageService.isFirstTime;
  }

  void changeThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storageService.setThemeMode(mode);
    Get.changeThemeMode(mode);
  }

  void setFirstTime(bool value) {
    _isFirstTime.value = value;
    _storageService.setFirstTime(value);
  }

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  void showSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void showBottomSheet(Widget child) {
    Get.bottomSheet(
      child,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  void showDialog(String title, String content, {VoidCallback? onConfirm}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          if (onConfirm != null)
            TextButton(
              onPressed: () {
                Get.back();
                onConfirm();
              },
              child: const Text('Confirm'),
            ),
        ],
      ),
    );
  }
}