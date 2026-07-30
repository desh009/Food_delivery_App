// lib/app/core/theme/theme_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  ThemeMode get currentThemeMode => themeMode.value;
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool('is_dark_mode') ?? false;
      themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
      Get.changeThemeMode(themeMode.value);
    } catch (_) {
      themeMode.value = ThemeMode.light;
      Get.changeThemeMode(themeMode.value);
    }
  }

  Future<void> toggleTheme() async {
    themeMode.value = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', themeMode.value == ThemeMode.dark);
    } catch (_) {}

    Get.changeThemeMode(themeMode.value);
    update(); // 🔥 UI update করার জন্য
  }

  // 🔥 আলাদা ভাবে Theme Set করার জন্য
  Future<void> setTheme(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', isDark);
    } catch (_) {}
    Get.changeThemeMode(themeMode.value);
    update();
  }
}