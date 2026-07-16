import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login1Controller extends GetxController {
  // Remember me চেকবক্সের জন্য reactive স্টেট
  var isRememberMeChecked = false.obs;

  // ফোন নম্বরের টেক্সট কন্ট্রোলার
  final phoneController = TextEditingController();

  // চেকবক্স টগল করার মেথড
  void toggleRememberMe() {
    isRememberMeChecked.value = !isRememberMeChecked.value;
  }

  // সাইন ইন মেথড
  void signIn() {
    String phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      Get.snackbar(
        "Error", 
        "Please enter your phone number",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // আপনার সাইন ইন লজিক এখানে লিখবেন
    print("Phone Number: $phoneNumber");
    print("Remember Me: ${isRememberMeChecked.value}");
  }

  @override
  void onClose() {
    phoneController.dispose(); // মেমোরি লিক রোধ করতে কন্ট্রোলার ডিসপোজ করা হয়েছে
    super.onClose();
  }
}