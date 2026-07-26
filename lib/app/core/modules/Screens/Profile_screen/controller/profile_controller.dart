// lib/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  
  // ========== User Info ==========
  var userName = 'Thomas K. Wilson'.obs;
  var userPhone = '20 1234 5629'.obs;
  var userEmail = 'thomas.abc.inc@gmail.com'.obs;
  var userDob = '07/11/1997'.obs;
  var userGender = 'Male'.obs;
  
  // ========== 🔥 Profile Image ==========
  var profileImagePath = ''.obs;
  
  // ========== Settings ==========
  var pushNotification = true.obs;
  var darkMode = false.obs;
  var sound = true.obs;
  var automaticallyUpdated = true.obs;
  var selectedLanguage = 'English'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }
  
  // ========== Load User Data ==========
  void _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      userName.value = prefs.getString('userName') ?? 'Thomas K. Wilson';
      userPhone.value = prefs.getString('userPhone') ?? '20 1234 5629';
      userEmail.value = prefs.getString('userEmail') ?? 'thomas.abc.inc@gmail.com';
      userDob.value = prefs.getString('userDob') ?? '07/11/1997';
      userGender.value = prefs.getString('userGender') ?? 'Male';
      profileImagePath.value = prefs.getString('profileImage') ?? '';
      
      print('📂 Profile loaded: ${userName.value}');
      print('📸 Profile image: ${profileImagePath.value.isEmpty ? 'No image' : 'Has image'}');
      
      // 🔥 Force update UI
      update();
      
    } catch (e) {
      print('❌ Error loading profile: $e');
    }
  }
  
  // ========== 🔥 Save User Data and Force Update ==========
  Future<void> saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('userName', userName.value);
      await prefs.setString('userPhone', userPhone.value);
      await prefs.setString('userEmail', userEmail.value);
      await prefs.setString('userDob', userDob.value);
      await prefs.setString('userGender', userGender.value);
      await prefs.setString('profileImage', profileImagePath.value);
      
      print('💾 Profile saved: ${userName.value}');
      print('📸 Image saved: ${profileImagePath.value}');
      
      // 🔥 IMPORTANT: Force update all Obx widgets
      update();
      refresh();
      
    } catch (e) {
      print('❌ Error saving profile: $e');
    }
  }
  
  // ========== 🔥 Update Profile Image ==========
  void updateProfileImage(String imagePath) {
    print('🔄 Updating profile image to: $imagePath');
    profileImagePath.value = imagePath;
    saveUserData();
    update();
    refresh();
  }
  
  // ========== 🔥 Remove Profile Image ==========
  void removeProfileImage() {
    print('🗑️ Removing profile image');
    profileImagePath.value = '';
    saveUserData();
    update();
    refresh();
  }
  
  // ========== Update Methods ==========
  void updateUserName(String name) {
    userName.value = name;
    saveUserData();
  }
  
  void updateUserPhone(String phone) {
    userPhone.value = phone;
    saveUserData();
  }
  
  void updateUserEmail(String email) {
    userEmail.value = email;
    saveUserData();
  }
  
  void updateUserDob(String dob) {
    userDob.value = dob;
    saveUserData();
  }
  
  void updateUserGender(String gender) {
    userGender.value = gender;
    saveUserData();
  }
}