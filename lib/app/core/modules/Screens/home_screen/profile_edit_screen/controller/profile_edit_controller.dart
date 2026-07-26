// lib/app/core/modules/Screens/Your_Profile_screen/controller/your_profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';

class YourProfileController extends GetxController {
  static YourProfileController get to => Get.find();

  // ========== Text Editing Controllers ==========
  final nameController = TextEditingController();
  final dobController = TextEditingController();

  // ========== Observable Variables ==========
  var selectedGender = 'Male'.obs;
  var profileImageUrl = ''.obs;
  var isLoading = false.obs;
  var isFormValid = false.obs;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  // ========== ProfileController Reference ==========
  late ProfileController profileController;

  // ========== Lifecycle ==========
  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }
    // Get ProfileController
    profileController = Get.find<ProfileController>();

    // Load existing data
    _loadUserData();

    // Validate form
    _validateForm();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(4);
        print('👤 YourProfileScreen Loaded - Index: 4');
      } catch (e) {
        print('❌ Error: $e');
      }
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    super.onClose();
  }

  // ========== Load User Data ==========
  void _loadUserData() {
    // Load name from ProfileController
    nameController.text = profileController.userName.value;

    // Load DOB if exists
    if (profileController.userDob.value.isNotEmpty) {
      dobController.text = profileController.userDob.value;
    }

    // Load gender if exists
    if (profileController.userGender.value.isNotEmpty) {
      selectedGender.value = profileController.userGender.value;
    }

    // Load profile image
    if (profileController.profileImagePath.value.isNotEmpty) {
      profileImageUrl.value = profileController.profileImagePath.value;
    }

    print('📂 Loaded user data: ${profileController.userName.value}');
  }

  // ========== Form Validation ==========
  void _validateForm() {
    bool valid = nameController.text.isNotEmpty;
    isFormValid.value = valid;
  }

  // ========== Methods ==========
  void updateGender(String? gender) {
    if (gender != null) {
      selectedGender.value = gender;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1997, 11, 7),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      _validateForm();
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Change Profile Photo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImagePickerOption(
                    icon: Icons.photo_library,
                    label: "Gallery",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement gallery picker
                    },
                  ),
                  _buildImagePickerOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      // Implement camera picker
                    },
                  ),
                  _buildImagePickerOption(
                    icon: Icons.delete_outline,
                    label: "Remove",
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      profileImageUrl.value = '';
                      profileController.profileImagePath.value = '';
                      Get.snackbar(
                        'Success',
                        'Profile photo removed',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.grey,
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== Text Field Change Listener ==========
  void onTextChanged() {
    _validateForm();
  }

  // ========== Save Profile - Update ProfileController ==========
  Future<void> saveProfile() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (nameController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your name',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // 🔥 Update ProfileController
      profileController.userName.value = nameController.text;
      profileController.userDob.value = dobController.text;
      profileController.userGender.value = selectedGender.value;

      // Update profile image if changed
      if (profileImageUrl.value.isNotEmpty) {
        profileController.profileImagePath.value = profileImageUrl.value;
      }

      await profileController.saveUserData();
      profileController.update();
      profileController.refresh();

      print('✅ Profile updated: ${profileController.userName.value}');
      print('📸 Image updated: ${profileController.profileImagePath.value}');

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back to ProfileScreen
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.back();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }
}
