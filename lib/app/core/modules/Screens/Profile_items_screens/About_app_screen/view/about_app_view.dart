// lib/app/core/modules/Screens/Profile_items_screens/about_app_screen/view/about_app_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';
import '../controller/about_app_controller.dart';

class AboutAppScreen extends GetView<AboutAppController> {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Initialize Controller
    if (!Get.isRegistered<AboutAppController>()) {
      Get.put(AboutAppController());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => Stack(
            children: [
              // ==================================================
              // MAIN CONTENT
              // ==================================================
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildAppLogo(),
                          SizedBox(height: 14.h),
                          _buildAppName(),
                          SizedBox(height: 6.h),
                          _buildAppVersion(),
                          SizedBox(height: 24.h),
                          _buildAppOverview(),
                          SizedBox(height: 30.h),
                          // ✅ Menu Options সরানো হয়েছে
                          _buildSocialMedia(),
                          SizedBox(height: 16.h),
                          _buildCopyright(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // ==================================================
              // LOADING OVERLAY
              // ==================================================
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.tomato,
                      strokeWidth: 3.r,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.ashLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.sp,
                color: AppColors.darkBackground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'About App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBackground,
              ),
            ),
          ),
          // ✅ Share button সরানো হয়েছে
          SizedBox(width: 38.w), // Balance alignment
        ],
      ),
    );
  }

  // ============================================================
  // APP LOGO
  // ============================================================
  Widget _buildAppLogo() {
    return Container(
      width: 90.w,
      height: 90.h,
      decoration: BoxDecoration(
        color: AppColors.tomato.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.tomato.withOpacity(0.3),
          width: 2.w,
        ),
      ),
      child: Icon(
        Icons.restaurant_rounded,
        size: 44.sp,
        color: AppColors.tomato,
      ),
    );
  }

  // ============================================================
  // APP NAME
  // ============================================================
  Widget _buildAppName() {
    return Obx(
      () => Text(
        controller.appName.value,
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.darkBackground,
        ),
      ),
    );
  }

  // ============================================================
  // APP VERSION
  // ============================================================
  Widget _buildAppVersion() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.ashLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          'Version ${controller.appVersion.value}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.darkBackground.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP OVERVIEW
  // ============================================================
  Widget _buildAppOverview() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.ashLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.ashLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Overview',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBackground,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Perto Eats is your ultimate food ordering and delivery solution. Designed to bring delicious meals from your favorite local restaurants straight to your doorstep with speed and convenience.\n\nOur mission is to seamlessly connect food lovers with exceptional culinary experiences through a modern, intuitive, and secure mobile application platform.',
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.6,
              color: AppColors.darkBackground.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SOCIAL MEDIA
  // ============================================================
  Widget _buildSocialMedia() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: controller.socialLinks.map((social) {
        return _buildSocialIcon(
          icon: social['icon'],
          onTap: () => controller.openSocialMedia(social['url']),
        );
      }).toList(),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          color: AppColors.ashLight.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.darkBackground, size: 20.sp),
      ),
    );
  }

  // ============================================================
  // COPYRIGHT
  // ============================================================
  Widget _buildCopyright() {
    return Text(
      '© 2026 Perto Eats. All rights reserved.',
      style: TextStyle(fontSize: 11.sp, color: AppColors.ashLight),
    );
  }
}
