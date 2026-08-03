// lib/app/core/modules/Screens/login_screen/controller/login_screen_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class Login1Controller extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ============================================================
  // ============================================================
  final RxBool isLoading = false.obs;
  final RxBool isRememberMeChecked = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxString completePhoneNumber = ''.obs;

  // ============================================================
  // 🔥 TOGGLE PASSWORD VISIBILITY
  // ============================================================
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ============================================================
  // ============================================================
  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  // ============================================================
  // ============================================================
  void signIn() async {
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    // Validation - Email
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validation - Phone
    if (phone.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validation - Password
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Implement actual login API
      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed(Routes.HOME);
      
      Get.snackbar(
        'Success',
        'Welcome back!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // ============================================================
  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}