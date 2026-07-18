// otp_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class VerificationController extends GetxController {
  // OTP Text Controllers
  final txt1 = TextEditingController();
  final txt2 = TextEditingController();
  final txt3 = TextEditingController();
  final txt4 = TextEditingController();

  // Focus Nodes
  final f1 = FocusNode();
  final f2 = FocusNode();
  final f3 = FocusNode();
  final f4 = FocusNode();

  // Observable variables
  final isOtpComplete = false.obs;
  final isLoading = false.obs;

  // Timer variables
  final canResend = false.obs;
  final timeRemaining = 60.obs;
  final formattedTime = '01:00'.obs;
  Timer? _timer;

  final phoneNumber = ''.obs;
  final email = ''.obs;
  final name = ''.obs;
  final countryCode = ''.obs;

  @override
  void onInit() {
    super.onInit();

 final args = Get.arguments as Map<String, dynamic>?;
  if (args != null) {
    phoneNumber.value = args['phone'] ?? '';
    email.value = args['email'] ?? '';
    name.value = args['name'] ?? '';
    countryCode.value = args['countryCode'] ?? '';
  }
  startTimer();
}
  

 
  @override
  void onClose() {
    txt1.dispose();
    txt2.dispose();
    txt3.dispose();
    txt4.dispose();
    f1.dispose();
    f2.dispose();
    f3.dispose();
    f4.dispose();
    if (_timer != null) _timer!.cancel();
    super.onClose();
  }

  // ✅ Check if OTP is complete
  void checkOtpComplete() {
    if (txt1.text.isNotEmpty &&
        txt2.text.isNotEmpty &&
        txt3.text.isNotEmpty &&
        txt4.text.isNotEmpty) {
      isOtpComplete.value = true;
    } else {
      isOtpComplete.value = false;
    }
  }

  // ✅ Get OTP String
  String get otpCode {
    return txt1.text + txt2.text + txt3.text + txt4.text;
  }

  // ✅ Verify OTP
  void verifyOTP() {
    if (!isOtpComplete.value) {
      Get.snackbar(
        'Error',
        'Please enter complete OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'OTP Verified Successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );

      // Navigate to Home or Login
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed(Routes.LOGIN);
      });
    });
  }

  // ✅ Timer Methods
  void startTimer() {
    canResend.value = false;
    timeRemaining.value = 60;
    updateFormattedTime();

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
        updateFormattedTime();
      } else {
        t.cancel();
        canResend.value = true;
      }
    });
  }

  void updateFormattedTime() {
    int minutes = timeRemaining.value ~/ 60;
    int seconds = timeRemaining.value % 60;
    formattedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
