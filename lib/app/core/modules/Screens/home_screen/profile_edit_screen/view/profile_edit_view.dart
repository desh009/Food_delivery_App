// lib/app/core/modules/Screens/Your_Profile_screen/view/your_profile_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/profile_edit_screen/controller/profile_edit_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:get/get.dart';

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!Get.isRegistered<YourProfileController>()) {
      Get.put<YourProfileController>(YourProfileController());
    }

    final controller = Get.find<YourProfileController>();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ==================================================
            // MAIN CONTENT
            // ==================================================
            Column(
              children: [
                _buildHeader(controller, theme, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        _buildProfileAvatar(controller, isDark),
                        SizedBox(height: 20.h),
                        _buildNameField(controller, theme, isDark),
                        SizedBox(height: 12.h),
                        _buildDobField(controller, theme, isDark),
                        SizedBox(height: 12.h),
                        _buildGenderDropdown(controller, theme, isDark),
                        SizedBox(height: 20.h),
                        _buildSaveButton(controller, theme, isDark),
                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ==================================================
            // BOTTOM NAVIGATION
            // ==================================================
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHeader(
    YourProfileController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // Title
          Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          
          // Save Button in Header
          Obx(
            () => controller.isFormValid.value
                ? GestureDetector(
                    onTap: controller.saveProfile,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tomato,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 50.w,
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE AVATAR - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildProfileAvatar(YourProfileController controller, bool isDark) {
    return Center(
      child: Stack(
        children: [
          Obx(
            () => Container(
              width: 110.w,
              height: 110.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: controller.profileImageUrl.value.isNotEmpty
                      ? FileImage(File(controller.profileImageUrl.value))
                      : const NetworkImage('https://i.pravatar.cc/300')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.showImagePickerOptions(Get.context!),
              child: Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NAME FIELD - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildNameField(
    YourProfileController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildCustomCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller.nameController,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter your full name',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
              ),
            ),
            onChanged: (_) => controller.onTextChanged(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOB FIELD - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildDobField(
    YourProfileController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildCustomCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.dobController,
                  readOnly: true,
                  onTap: () => controller.selectDate(Get.context!),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.selectDate(Get.context!),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 18.sp,
                    color: AppColors.tomato,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GENDER DROPDOWN - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildGenderDropdown(
    YourProfileController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildCustomCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedGender.value,
                isExpanded: true,
                isDense: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? Colors.white : Colors.black87,
                  size: 20.sp,
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                dropdownColor: isDark ? const Color(0xFF333333) : Colors.white,
                onChanged: controller.updateGender,
                items: controller.genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildSaveButton(
    YourProfileController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: controller.isLoading.value || !controller.isFormValid.value
              ? null
              : controller.saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tomato,
            foregroundColor: Colors.white,
            elevation: 0,
            disabledBackgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 22.w,
                  height: 22.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5.r,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // ============================================================
  // CUSTOM CARD - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildCustomCard({
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : (AppColors.ashLight ?? Colors.grey.shade50),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.transparent,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}