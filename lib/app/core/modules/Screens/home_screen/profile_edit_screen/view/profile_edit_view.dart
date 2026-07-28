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
    if (!Get.isRegistered<YourProfileController>()) {
      Get.put<YourProfileController>(YourProfileController());
    }

    final controller = Get.find<YourProfileController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ==================================================
            // MAIN CONTENT
            // ==================================================
            Column(
              children: [
                _buildHeader(controller),
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
                        _buildProfileAvatar(controller),
                        SizedBox(height: 20.h),
                        _buildNameField(controller),
                        SizedBox(height: 12.h),
                        _buildDobField(controller),
                        SizedBox(height: 12.h),
                        _buildGenderDropdown(controller),
                        SizedBox(height: 20.h),
                        // ✅ Save Button (Inside Scroll)
                        _buildSaveButton(controller),
                        SizedBox(height: 100.h), // ✅ Space for NavBar
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
              child: BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader(YourProfileController controller) {
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
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.sp,
                color: Colors.black87,
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
                fontSize: 18.sp, // ✅ 20.sp → 18.sp
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Save Button in Header (Optional)
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
  // PROFILE AVATAR
  // ============================================================
  Widget _buildProfileAvatar(YourProfileController controller) {
    return Center(
      child: Stack(
        children: [
          Obx(
            () => Container(
              width: 110.w, // ✅ 120.w → 110.w
              height: 110.h, // ✅ 120.h → 110.h
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
            bottom: 0, // ✅ top → bottom
            right: 0,
            child: GestureDetector(
              onTap: () => controller.showImagePickerOptions(Get.context!),
              child: Container(
                width: 30.w, // ✅ 32.w → 30.w
                height: 30.h, // ✅ 32.h → 30.h
                decoration: BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.w,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded, // ✅ edit → camera
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
  // NAME FIELD
  // ============================================================
  Widget _buildNameField(YourProfileController controller) {
    return _buildCustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Full Name',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller.nameController,
            style: TextStyle(
              fontSize: 15.sp, // ✅ 16.sp → 15.sp
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter your full name',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade400,
              ),
            ),
            onChanged: (_) => controller.onTextChanged(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DOB FIELD
  // ============================================================
  Widget _buildDobField(YourProfileController controller) {
    return _buildCustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
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
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade400,
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
                    size: 18.sp, // ✅ 20.sp → 18.sp
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
  // GENDER DROPDOWN
  // ============================================================
  Widget _buildGenderDropdown(YourProfileController controller) {
    return _buildCustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
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
                  color: Colors.black87,
                  size: 20.sp,
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                onChanged: controller.updateGender,
                items: controller.genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 14.sp),
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
  // SAVE BUTTON (Inside Scroll)
  // ============================================================
  Widget _buildSaveButton(YourProfileController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50.h, // ✅ 52.h → 50.h
        child: ElevatedButton(
          onPressed: controller.isLoading.value || !controller.isFormValid.value
              ? null
              : controller.saveProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.tomato,
            foregroundColor: Colors.white,
            elevation: 0,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.r), // ✅ 26.r → 25.r
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
  // CUSTOM CARD
  // ============================================================
  Widget _buildCustomCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14.w, // ✅ 16.w → 14.w
        vertical: 12.h, // ✅ 14.h → 12.h
      ),
      decoration: BoxDecoration(
        color: AppColors.ashLight ?? Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r), // ✅ 14.r → 12.r
      ),
      child: child,
    );
  }

  // ============================================================
  // BOTTOM BUTTON (Old - সরিয়ে ফেলেছি)
  // ============================================================
  // ❌ এই widget আর প্রয়োজন নেই
}