// lib/app/modules/auth/controllers/auth_controller.dart
import 'package:flutter/widgets.dart';
import 'package:food_hjoiopk/app/core/models/user/user.dart';
import 'package:food_hjoiopk/app/core/remote/constant/constant.dart';
import 'package:food_hjoiopk/app/core/remote/helper/share_helper.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // ========== Text Controllers ==========
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ========== Observable Variables ==========
  final isLoading = false.obs;
  final isRegisterMode = false.obs;
  final isRememberMe = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // ========== Validation ==========
  bool get isFormValid {
    if (isRegisterMode.value) {
      return nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          emailController.text.contains('@') &&
          phoneController.text.isNotEmpty &&
          phoneController.text.length >= 10 &&
          passwordController.text.isNotEmpty &&
          passwordController.text.length >= 6 &&
          confirmPasswordController.text == passwordController.text;
    } else {
      return (emailController.text.isNotEmpty || phoneController.text.isNotEmpty) &&
          passwordController.text.isNotEmpty;
    }
  }

  // ========== Toggle Password Visibility ==========
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // ========== Toggle Remember Me ==========
  void toggleRememberMe() {
    isRememberMe.value = !isRememberMe.value;
  }

  // ========== Toggle Mode ==========
  void toggleMode() {
    isRegisterMode.value = !isRegisterMode.value;
    clearFields();
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // ========== 📝 Register ==========
  Future<void> register() async {
    if (!isFormValid) {
      // Get.snackbar(
      //   'Error',
      //   'Please fill all fields correctly',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      // Get.snackbar(
      //   'Error',
      //   'Passwords do not match',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return;
    }

    isLoading.value = true;

    try {
      // ✅ নতুন ইউজার তৈরি করুন
      final String userId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final User newUser = User(
        id: userId,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        profileImage: 'https://i.pravatar.cc/300?img=${userId.hashCode % 70}',
      );

      // ✅ ইউজার লিস্টে যোগ করুন (SharedPreferences)
      await _saveUserToList(newUser);

      // ✅ অটো লগইন করুন
      await ShareHelper.setUserData(
        token: 'token_$userId',
        user: newUser,
      );

      isLoading.value = false;

      // ✅ Home Screen এ যান
      Get.offAllNamed(Routes.HOME);

      // Get.snackbar(
      //   'Success',
      //   'Registration Successful!\nWelcome ${newUser.name}! 🎉',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      // );

    } catch (e) {
      isLoading.value = false;
      // Get.snackbar(
      //   'Error',
      //   'Registration failed: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  // ========== 🔑 Login ==========
  Future<void> login() async {
    if (!isFormValid) {
      // Get.snackbar(
      //   'Error',
      //   'Please enter email/phone and password',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      return;
    }

    isLoading.value = true;

    try {
      // ✅ ইউজার লিস্ট থেকে ইউজার খুঁজুন
      final User? foundUser = await _findUser(
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );

      if (foundUser == null) {
        isLoading.value = false;
        // Get.snackbar(
        //   'Error',
        //   'Invalid email/phone or password',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
        return;
      }

      // ✅ লগইন করুন
      await ShareHelper.setUserData(
        token: 'token_${foundUser.id}',
        user: foundUser,
      );

      isLoading.value = false;

      // ✅ Home Screen এ যান
      Get.offAllNamed(Routes.HOME);

      // Get.snackbar(
      //   'Success',
      //   'Welcome back, ${foundUser.name}! 👋',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      // );

    } catch (e) {
      isLoading.value = false;
      // Get.snackbar(
      //   'Error',
      //   'Login failed: $e',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  // ========== 💾 Save User to List ==========
  Future<void> _saveUserToList(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Existing users list load করুন
      List<User> users = await _getAllUsers();
      
      // Check if user already exists (by email or phone)
      final bool exists = users.any((u) => 
        u.email == user.email || u.phone == user.phone
      );
      
      if (exists) {
        throw Exception('User with this email or phone already exists');
      }
      
      // নতুন ইউজার যোগ করুন
      users.add(user);
      
      // লিস্ট সেভ করুন
      final String usersJson = json.encode(users.map((u) => u.toJson()).toList());
      await prefs.setString(AppConstant.usersList, usersJson);
      
      print('✅ User saved: ${user.name}');
    } catch (e) {
      print('❌ Error saving user: $e');
      rethrow;
    }
  }

  // ========== 📋 Get All Users ==========
  Future<List<User>> _getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? usersString = prefs.getString(AppConstant.usersList);
      
      if (usersString == null || usersString.isEmpty) {
        return [];
      }
      
      final List<dynamic> usersJson = json.decode(usersString);
      return usersJson.map((json) => User.fromJson(json)).toList();
      
    } catch (e) {
      print('❌ Error loading users: $e');
      return [];
    }
  }

  // ========== 🔍 Find User ==========
  Future<User?> _findUser({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      final List<User> users = await _getAllUsers();
      
      return users.firstWhere((user) {
        final bool emailMatch = email != null && email.isNotEmpty 
            ? user.email == email 
            : false;
        final bool phoneMatch = phone != null && phone.isNotEmpty 
            ? user.phone == phone 
            : false;
        final bool passwordMatch = user.password == password;
        
        return (emailMatch || phoneMatch) && passwordMatch;
      });
      
    } catch (e) {
      return null;
    }
  }

  // ========== 🚪 Logout ==========
  void logout() {
    ShareHelper.logout();
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}