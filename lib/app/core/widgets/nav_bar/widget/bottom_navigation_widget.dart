import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';
import 'dart:io';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();
    final ProfileController? profileController = 
        Get.isRegistered<ProfileController>() ? Get.find<ProfileController>() : null;

    return Container(
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 🔥 3টি Nav Item (Home, Orders, Favorites)
            ...List.generate(3, (index) {
              return _buildNavItem(
                index: index,
                icon: controller.navItems[index].icon,
                label: controller.navItems[index].label,
                isActive: controller.currentIndex.value == index,
                onTap: () {
                  controller.changeIndex(index);
                  controller.navigateToScreen(index, context);
                },
              );
            }),
            
            // 🔥 Profile Item (Index 3)
            _buildProfileItem(
              controller: controller,
              profileController: profileController,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
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

  // 🔥 Profile Item
  Widget _buildProfileItem({
    required BottomNavController controller,
    required ProfileController? profileController,
  }) {
    final bool isActive = controller.currentIndex.value == 3;  // Profile index 3
    
    return GestureDetector(
      onTap: () {
        print('Profile Avatar Tapped');
        controller.changeIndex(3);  // Profile index 3
        controller.navigateToScreen(3, Get.context!);
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? AppColors.tomato : Colors.transparent,
            width: 2,
          ),
          image: profileController != null &&
                  profileController.profileImagePath.value.isNotEmpty
              ? DecorationImage(
                  image: FileImage(
                    File(profileController.profileImagePath.value),
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
    );
  }
}