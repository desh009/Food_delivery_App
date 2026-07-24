import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 0. Home
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: controller.currentIndex.value == 0,
                  onTap: () {
                    controller.changeIndex(0);
                    controller.navigateToScreen(0, context);
                  },
                ),
                // 1. Orders
                _buildNavItem(
                  index: 1,
                  icon: Icons.assignment_outlined,
                  label: 'Orders',
                  isActive: controller.currentIndex.value == 1,
                  onTap: () {
                    controller.changeIndex(1);
                    controller.navigateToScreen(1, context);
                  },
                ),
                // 2. Favorites
                _buildNavItem(
                  index: 2,
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorites',
                  isActive: controller.currentIndex.value == 2,
                  onTap: () {
                    controller.changeIndex(2);
                    controller.navigateToScreen(2, context);
                  },
                ),
                // 3. Notifications
                _buildNavItem(
                  index: 3,
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  isActive: controller.currentIndex.value == 3,
                  onTap: () {
                    controller.changeIndex(3);
                    controller.navigateToScreen(3, context);
                  },
                ),
                // 4. Profile
                _buildProfileItem(
                  context: context,
                  index: 4,
                  isActive: controller.currentIndex.value == 4,
                  controller: controller,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  // ========== Standard Dynamic Nav Item ==========
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive) ...[
              // Floating Popped-Up Active Button
              Positioned(
                top: -22,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.tomato,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tomato.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
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
                ),
              ),
            ] else ...[
              // Normal Inactive Icon (No Text Label)
              Center(
                child: Icon(
                  icon,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== Profile Nav Item ==========
  Widget _buildProfileItem({
    required BuildContext context,
    required int index,
    required bool isActive,
    required BottomNavController controller,
  }) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        controller.navigateToScreen(index, context);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive) ...[
              // Floating Popped-Up Profile Avatar
              Positioned(
                top: -22,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.tomato,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tomato.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _getProfileImage(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Inactive Profile Icon
              Center(
                child: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.grey.shade400,
                  size: 25,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== Safe Profile Image Provider ==========
  Widget _getProfileImage() {
    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();
      if (profileController.profileImagePath.value.isNotEmpty) {
        return Image.file(
          File(profileController.profileImagePath.value),
          fit: BoxFit.cover,
        );
      }
    }
    return Image.network(
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
      fit: BoxFit.cover,
    );
  }
}