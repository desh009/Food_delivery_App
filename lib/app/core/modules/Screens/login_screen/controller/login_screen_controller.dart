// login_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class Login1Controller extends GetxController {
  final phoneController = TextEditingController();
  final isRememberMeChecked = false.obs;
  final isLoading = false.obs;
  final completePhoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔵 LoginController initialized');
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void toggleRememberMe() {
    isRememberMeChecked.toggle();
  }

  // ✅ Sign In - শুধু Phone Number দিয়ে
  void signIn() async {
    print('🟢 Sign In button pressed');
    print('📱 Phone: ${phoneController.text}');

    // Phone Validation
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number (min 10 digits)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      print('🔵 Processing login...');

      // Simulate network delay (2 seconds)
      await Future.delayed(const Duration(seconds: 2));

      // ✅ Navigate to Home Screen
      Get.offAllNamed(Routes.HOME);

      // Success message
      Get.snackbar(
        'Success',
        'Welcome back! 👋',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Login error: $e');
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Social Login Methods
  void signInWithGoogle() {
    Get.snackbar(
      'Info',
      'Google Sign-in coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void signInWithFacebook() {
    Get.snackbar(
      'Info',
      'Facebook Sign-in coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void signInWithApple() {
    Get.snackbar(
      'Info',
      'Apple Sign-in coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
