// register_controller.dart
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Controllers
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  
  // Observable variables
  final isRememberMeChecked = false.obs;
  final isLoading = false.obs;
  final isRegisterMode = false.obs;
  final completePhoneNumber = ''.obs;
  final isValidPhone = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // Toggle Remember Me
  void toggleRememberMe() {
    isRememberMeChecked.toggle();
    print('Remember Me: ${isRememberMeChecked.value}');
  }

  // Validate Phone
  void validatePhone(String phoneNumber) {
    if (phoneNumber.length >= 10) {
      isValidPhone.value = true;
    } else {
      isValidPhone.value = false;
    }
  }

  // ✅ Check if button is active
  bool get isButtonActive {
    return isRememberMeChecked.value &&
        phoneController.text.isNotEmpty &&
        phoneController.text.length >= 10 &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty;
  }

  // ✅ Register Method (সঠিকভাবে সাজানো)
  void register() {
    print('Register button pressed!');
    print('Phone: ${phoneController.text}');
    print('Email: ${emailController.text}');
    print('Name: ${nameController.text}');
    print('Remember Me: ${isRememberMeChecked.value}');

    // ✅ প্রথমে isButtonActive চেক করুন
    if (!isButtonActive) {
      print('Button is not active!');
      Get.snackbar(
        'Error',
        'Please fill all fields and check Remember Me',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Phone validation
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Error',
        'Phone number must be at least 10 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Email validation
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // Name validation
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // ✅ Show loading
    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      // ✅ Navigate to OTP Screen with data
      Get.toNamed(
        Routes.OTP,
        arguments: {
          'phone': phoneController.text,
          'email': emailController.text,
          'name': nameController.text,
          'completePhoneNumber': completePhoneNumber.value,
        },
      );

      // Success message
      Get.snackbar(
        'Success',
        'Registration Successful!\nPhone: $completePhoneNumber\nEmail: ${emailController.text}\nName: ${nameController.text}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    });
  }

  // ✅ Sign In Method
  void signIn() {
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (phoneController.text.length < 10) {
      Get.snackbar(
        'Error',
        'Phone number must be at least 10 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Login Successful!\nPhone: $completePhoneNumber',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    });
  }
}