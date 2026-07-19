// login_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login1Controller extends GetxController {
  // Observable variables
  final isRememberMeChecked = false.obs;
  final isLoading = false.obs;
  final isRegisterMode = false.obs; 
  final phoneController = TextEditingController();
  final completePhoneNumber = ''.obs;
  final isValidPhone = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  // Toggle Remember Me
  void toggleRememberMe() {
    isRememberMeChecked.toggle();
  }

  // ✅ Toggle Register Mode


  void validatePhone(String phoneNumber) {
    if (phoneNumber.length >= 10) {
      isValidPhone.value = true;
    } else {
      isValidPhone.value = false;
    }
  }

  bool get isButtonActive {
    return isRememberMeChecked.value &&
        phoneController.text.isNotEmpty &&
        phoneController.text.length >= 10;
  }

  bool get isFormValid {
    return phoneController.text.isNotEmpty && phoneController.text.length >= 10;
  }

  void signIn() {
    if (isButtonActive) {
      return;
    }
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

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      Get.snackbar(
        'Success',
        isRegisterMode.value
            ? 'Registration Successful!\nPhone: $completePhoneNumber'
            : 'Login Successful!\nPhone: $completePhoneNumber',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    });
  }
}
