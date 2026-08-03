import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/Code_verify/binder/code_verify_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/Code_verify/view/code_verify_view.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController inputController = TextEditingController();
  final RxBool isLoading = false.obs;

// Controller-এর ভেতর:
void sendResetCode() async {
  if (inputController.text.trim().isEmpty) return;

  isLoading.value = true;
  await Future.delayed(const Duration(seconds: 2)); // API Call
  isLoading.value = false;

  // এখানে পরবর্তী স্ক্রিন কল করবেন
  Get.to(
    () => const ResetPasswordScreen(),
    binding: ResetPasswordBinding(),
  );

  // অথবা Named Route ব্যবহার করলে:
  // Get.toNamed('/otp-verification');
}

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  
}