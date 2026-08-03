// lib/app/core/modules/Screens/Register_screen/controller/Register_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class RegisterController extends GetxController {
  // ============================================================
  // 🔥 TEXT CONTROLLERS - lateinit ব্যবহার করুন
  // ============================================================
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;

  // ============================================================
  // 🔥 OBSERVABLE VARIABLES
  // ============================================================
  final RxBool isLoading = false.obs;
  final RxBool isRememberMeChecked = false.obs;
  final RxBool isPasswordHidden = true.obs;
  final RxString completePhoneNumber = ''.obs;

  // ============================================================
  // 🔥 INIT - Controllers তৈরি করুন
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    // এখানে Controllers Initialize করুন
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  // ============================================================
  // 🔥 TOGGLE PASSWORD VISIBILITY
  // ============================================================
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // ============================================================
  // 🔥 TOGGLE REMEMBER ME
  // ============================================================
  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  // ============================================================
  // 🔥 REGISTER
  // ============================================================
  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    // Validation - Name
    if (name.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (name.length < 3) {
      Get.snackbar(
        'Error',
        'Name must be at least 3 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validation - Email
    if (email.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
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
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (phone.length < 10) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Validation - Password
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please create a password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
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
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Check Terms
    if (!isRememberMeChecked.value) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms & Conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO: Implement actual registration API
      await Future.delayed(const Duration(seconds: 2));

      // ============================================================
      // 🔥 REGISTRATION SUCCESS - TextField Clear করুন
      // ============================================================
      // Controllers এখনও active আছে, clear করুন
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      isRememberMeChecked.value = false;

      // Navigate to OTP
      Get.offAllNamed(Routes.OTP, arguments: {'email': email, 'phone': phone});

      Get.snackbar(
        'Success',
        'Account created successfully! Please verify your OTP.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 🔥 NAVIGATE TO LOGIN
  // ============================================================
  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  // ============================================================
  // 🔥 GO BACK
  // ============================================================
  void goBack() {
    Get.back();
  }

  // ============================================================
  // 🔥 DISPOSE - Controllers Dispose করুন
  // ============================================================
  @override
  void onClose() {
    // Controllers Dispose করার আগে check করুন
    if (nameController != null) {
      nameController.dispose();
    }
    if (emailController != null) {
      emailController.dispose();
    }
    if (phoneController != null) {
      phoneController.dispose();
    }
    if (passwordController != null) {
      passwordController.dispose();
    }
    super.onClose();
  }
}
