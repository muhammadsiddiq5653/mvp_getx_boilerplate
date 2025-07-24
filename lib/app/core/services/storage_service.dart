import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final _box = GetStorage();

  // Keys
  static const String _keyFirstTime = 'first_time';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyUserToken = 'user_token';
  static const String _keyUserData = 'user_data';
  static const String _keyLanguage = 'language';

  // Generic methods
  T? read<T>(String key) => _box.read<T>(key);

  Future<void> write(String key, dynamic value) => _box.write(key, value);

  Future<void> remove(String key) => _box.remove(key);

  Future<void> clear() => _box.erase();

  bool hasData(String key) => _box.hasData(key);

  // App-specific methods
  bool get isFirstTime => read<bool>(_keyFirstTime) ?? true;

  Future<void> setFirstTime(bool value) => write(_keyFirstTime, value);

  ThemeMode? getThemeMode() {
    final theme = read<String>(_keyThemeMode);
    if (theme == null) return null;

    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) {
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    return write(_keyThemeMode, themeString);
  }

  String? get userToken => read<String>(_keyUserToken);

  Future<void> setUserToken(String token) => write(_keyUserToken, token);

  Future<void> clearUserToken() => remove(_keyUserToken);

  Map<String, dynamic>? get userData {
    final data = read<Map<String, dynamic>>(_keyUserData);
    return data;
  }

  Future<void> setUserData(Map<String, dynamic> data) => write(_keyUserData, data);

  Future<void> clearUserData() => remove(_keyUserData);

  String? get language => read<String>(_keyLanguage);

  Future<void> setLanguage(String language) => write(_keyLanguage, language);

  Future<void> clearUserSession() async {
    await clearUserToken();
    await clearUserData();
  }
}