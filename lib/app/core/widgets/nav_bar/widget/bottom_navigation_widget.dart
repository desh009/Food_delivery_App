// lib/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    // 🔥 ProfileController Initialize
    if (!Get.isRegistered<ProfileController>()) {
      Get.put<ProfileController>(ProfileController(), permanent: true);
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 60.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            final ProfileController profileController =
                Get.find<ProfileController>();

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
                // 🔥 3. Cart (was Notifications)
                _buildNavItem(
                  index: 3,
                  icon: Icons.shopping_cart_outlined,  // ✅ Cart Icon
                  label: 'Cart',                      // ✅ Cart Label
                  isActive: controller.currentIndex.value == 3,
                  onTap: () {
                    controller.changeIndex(3);
                    controller.navigateToScreen(3, context);
                  },
                ),
                // 🔥 4. Profile - Dynamic Image
                _buildProfileItem(
                  context: context,
                  index: 4,
                  isActive: controller.currentIndex.value == 4,
                  controller: controller,
                  profileController: profileController,
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
        width: 55.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive) ...[
              Positioned(
                top: -22.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.tomato,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tomato.withOpacity(0.35),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 26.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      label,
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Center(
                child: Icon(icon, color: Colors.grey.shade400, size: 24.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== 🔥 Profile Nav Item with Dynamic Image ==========
  Widget _buildProfileItem({
    required BuildContext context,
    required int index,
    required bool isActive,
    required BottomNavController controller,
    required ProfileController profileController,
  }) {
    return GestureDetector(
      onTap: () {
        controller.changeIndex(index);
        controller.navigateToScreen(index, context);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 55.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            if (isActive) ...[
              Positioned(
                top: -22.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        color: AppColors.tomato,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tomato.withOpacity(0.35),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Obx(() {
                          final String imagePath =
                              profileController.profileImagePath.value;

                          if (imagePath.isNotEmpty &&
                              File(imagePath).existsSync()) {
                            return Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar();
                              },
                            );
                          } else {
                            return _buildDefaultAvatar();
                          }
                        }),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Center(
                child: Obx(() {
                  final String imagePath =
                      profileController.profileImagePath.value;

                  if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
                    return Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(File(imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    return Icon(
                      Icons.person_outline_rounded,
                      color: Colors.grey.shade400,
                      size: 25.sp,
                    );
                  }
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ========== Default Avatar ==========
  Widget _buildDefaultAvatar() {
    return Image.network(
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: Icon(Icons.person, color: Colors.grey.shade400, size: 30.sp),
        );
      },
    );
  }
}