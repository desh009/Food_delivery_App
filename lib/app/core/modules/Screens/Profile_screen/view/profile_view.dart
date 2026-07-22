import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final HomeController homeController = Get.find<HomeController>();

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
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
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
                    _buildListTile(Icons.location_on_outlined, "My Locations"),
                    _buildListTile(
                      Icons.confirmation_number_outlined,
                      "My Promotions",
                    ),
                    _buildListTile(
                      Icons.account_balance_wallet_outlined,
                      "Payment Methods",
                    ),
                    _buildListTile(Icons.chat_bubble_outline_rounded, "Messages"),
                    _buildListTile(
                      Icons.people_outline_rounded,
                      "Invite Friends",
                    ),
                    _buildListTile(Icons.shield_outlined, "Security"),
                    _buildListTile(Icons.help_outline_rounded, "Help Center"),
      
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
                    _buildListTile(null, "Term of Service"),
                    _buildListTile(null, "Privacy Policy"),
                    _buildListTile(null, "About App"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      
              // ========== Custom Floating Bottom Navigation Bar ==========
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    // প্রোফাইল কন্ট্রোলার চেক করুন
                    final ProfileController? profileController =
                        Get.isRegistered<ProfileController>()
                        ? Get.find<ProfileController>()
                        : null;
      
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          0,
                          Icons.home_filled,
                          "Home",
                          homeController,
                          onTap: () {
                            homeController.currentNavIndex.value = 0;
                            Get.back(); // Profile Screen থেকে Home এ ফিরে যান
                          },
                        ),
                        _buildNavItem(
                          1,
                          Icons.assignment_outlined,
                          "Orders",
                          homeController,
                          onTap: () {
                            homeController.currentNavIndex.value = 1;
                            Get.snackbar(
                              'Orders',
                              'Coming soon!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        _buildNavItem(
                          2,
                          Icons.favorite_border,
                          "Favorites",
                          homeController,
                          onTap: () {
                            homeController.currentNavIndex.value = 2;
                            Get.snackbar(
                              'Favorites',
                              'Coming soon!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        _buildNavItem(
                          3,
                          Icons.notifications_none_rounded,
                          "Alerts",
                          homeController,
                          onTap: () {
                            homeController.currentNavIndex.value = 3;
                            Get.snackbar(
                              'Alerts',
                              'Coming soon!',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                        ),
                        // Profile Avatar with Dynamic Image
                        GestureDetector(
                          onTap: () {
                            homeController.currentNavIndex.value = 4;
                            // ইতিমধ্যে Profile Screen এ আছেন
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: homeController.currentNavIndex.value == 4
                                    ? AppColors.tomato
                                    : Colors.transparent,
                                width: 2,
                              ),
                              image:
                                  profileController != null &&
                                      profileController
                                          .profileImagePath
                                          .value
                                          .isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(
                                        File(
                                          profileController
                                              .profileImagePath
                                              .value,
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
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

  // ========== Profile Info Header Row ==========
  Widget _buildUserProfileHeader(ProfileController controller) {
    return Row(
      children: [
        // Avatar Image with Edit Option
        GestureDetector(
          onTap: () {
            _showImagePickerOptions(Get.context!, controller);
          },
          child: Stack(
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 32,
                  backgroundImage: controller.profileImagePath.value.isNotEmpty
                      ? FileImage(File(controller.profileImagePath.value))
                      : const NetworkImage('https://i.pravatar.cc/300')
                            as ImageProvider,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.tomato,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Text Info (Name, Phone, Email)
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

        // Round Edit Pencil Button
        GestureDetector(
          onTap: () {
            Get.snackbar(
              'Edit Profile',
              'Feature coming soon!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue,
              colorText: Colors.white,
            );
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

  // ========== Image Picker Options ==========
  void _showImagePickerOptions(
    BuildContext context,
    ProfileController controller,
  ) {
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
                      // controller.pickImageFromGallery();
                    },
                  ),
                  _buildImagePickerOption(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      // controller.pickImageFromCamera();
                    },
                  ),
                  _buildImagePickerOption(
                    icon: Icons.delete_outline,
                    label: "Remove",
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      controller.profileImagePath.value = '';
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

  // ========== Image Picker Option Button ==========
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
  // Profile Screen এর _showLogoutDialog মেথড আপডেট করুন

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
              
              // ✅ Clear SharedPreferences
              try {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // সব ডাটা Clear
                
                // ✅ Navigate to Login
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
  Widget _buildListTile(IconData? icon, String title) {
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
        onTap: () {},
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

  // ========== Bottom Navigation Item Builder ==========
  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    HomeController controller, {
    required VoidCallback onTap,
  }) {
    bool isActive = controller.currentNavIndex.value == index;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isActive ? 10 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.tomato : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.black38,
              size: 26,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.tomato,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
