// lib/app/core/modules/Screens/Profile_screen/view/profile_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/binder/help_center_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/view/helpcenter_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        print('ProfileScreen Loaded - Setting index to 4');
        BottomNavController.to.changeIndex(4);
      } catch (e) {
        print('Error: $e');
      }
    });

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // ========== Main Content (Scrollable) ==========
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                child: Column(
                  children: [
                    // ========== Top Header Bar ==========
                    _buildTopHeader(),
                    const SizedBox(height: 20),

                    // ========== User Profile Header ==========
                    _buildUserProfileHeader(controller),
                    const SizedBox(height: 20),

                    // ========== Logout Button ==========
                    _buildLogoutButton(controller),
                    const SizedBox(height: 24),

                    // ========== Primary Navigation Items ==========
                    _buildListTile(
                      Icons.location_on_outlined,
                      "My Locations",
                      onTap: () {
                        Get.snackbar(
                          'My Locations',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.confirmation_number_outlined,
                      "My Promotions",
                      onTap: () {
                        Get.snackbar(
                          'My Promotions',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.account_balance_wallet_outlined,
                      "Vouchers",
                      onTap: () {
                        Get.snackbar(
                          'Payment Methods',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.chat_bubble_outline_rounded,
                      "Messages",
                      onTap: () {
                        Get.snackbar(
                          'Messages',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.people_outline_rounded,
                      "Invite Friends",
                      onTap: () {
                        Get.snackbar(
                          'Invite Friends',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.shield_outlined,
                      "Security",
                      onTap: () {
                        Get.snackbar(
                          'Security',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      Icons.help_outline_rounded,
                      "Help Center",
                      onTap: () {
                        Get.to(
                          () => const HelpCenterScreen(),
                          binding: HelpCenterBinding(),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                    const SizedBox(height: 8),

                    // ========== Preferences / Settings ==========
                    _buildLanguageDropdown(controller),
                    _buildSwitchTile(
                      "Push Notification",
                      controller.pushNotification,
                    ),
                    _buildSwitchTile("Dark Mode", controller.darkMode),
                    _buildSwitchTile("Sound", controller.sound),
                    _buildSwitchTile(
                      "Automatically Updated",
                      controller.automaticallyUpdated,
                    ),

                    const SizedBox(height: 8),
                    const Divider(color: Color(0xFFEEEEEE), thickness: 1),
                    const SizedBox(height: 8),

                    // ========== Secondary Items ==========
                    _buildListTile(
                      null,
                      "Term of Service",
                      onTap: () {
                        Get.snackbar(
                          'Term of Service',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      null,
                      "Privacy Policy",
                      onTap: () {
                        Get.snackbar(
                          'Privacy Policy',
                          'Coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildListTile(
                      null,
                      "About App",
                      onTap: () {
                        Get.snackbar(
                          'About App',
                          'Version 1.0.0',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // ========== Global Bottom Navigation Bar ==========
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: const BottomNavigationWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== Top App Bar ==========
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 18,
              color: Colors.black87,
            ),
          ),
        ),
        const Text(
          "Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.more_horiz, size: 18, color: Colors.black87),
        ),
      ],
    );
  }

  // ========== 🔥 Profile Info Header (No Image Picker) ==========
  Widget _buildUserProfileHeader(ProfileController controller) {
    return Row(
      children: [
        // 🔥 Only Avatar - No Edit Option
        Obx(
          () => CircleAvatar(
            radius: 32,
            backgroundImage: controller.profileImagePath.value.isNotEmpty
                ? FileImage(File(controller.profileImagePath.value))
                : const NetworkImage('https://i.pravatar.cc/300')
                      as ImageProvider,
          ),
        ),
        const SizedBox(width: 14),

        // Text Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tomato,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 13,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.userPhone.value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Obx(
                () => Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.userEmail.value,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔥 Edit Button - Navigate to YourProfileScreen
        GestureDetector(
          onTap: () {
            Get.toNamed('/profile-edit');
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.tomato,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.tomato.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.edit, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ========== Logout Button ==========
  Widget _buildLogoutButton(ProfileController controller) {
    return InkWell(
      onTap: () {
        _showLogoutDialog(Get.context!);
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0EF),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.tomato, size: 20),
            const SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(
                color: AppColors.tomato,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Logout Dialog ==========
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  Get.offAllNamed('/login');

                  Get.snackbar(
                    'Success',
                    'Logged out successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to logout',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ========== Standard List Tile Item ==========
  Widget _buildListTile(IconData? icon, String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: icon != null
            ? Icon(icon, size: 20, color: Colors.black87)
            : null,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.black45,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  // ========== Language Dropdown ==========
  Widget _buildLanguageDropdown(ProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Language",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedLanguage.value,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  items: <String>['English', 'Bangla', 'Spanish'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.selectedLanguage.value = newValue;
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Switch Settings Tile ==========
  Widget _buildSwitchTile(String title, RxBool rxBool) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Obx(
            () => Switch(
              value: rxBool.value,
              activeColor: AppColors.tomato,
              inactiveTrackColor: Colors.grey.shade200,
              inactiveThumbColor: Colors.grey.shade400,
              onChanged: (val) {
                rxBool.value = val;
              },
            ),
          ),
        ],
      ),
    );
  }
}
