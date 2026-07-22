// profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class ProfileController extends GetxController {
  final userName = 'Food App User'.obs;
  final userEmail = 'user@foodapp.com'.obs;
  final userPhone = '+880 1234 567890'.obs;
  final profileImagePath = ''.obs;

  // Settings
  final pushNotification = true.obs;
  final darkMode = false.obs;
  final sound = true.obs;
  final automaticallyUpdated = true.obs;
  final selectedLanguage = 'English'.obs;

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
    
    Get.snackbar(
      'Success',
      'Logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}