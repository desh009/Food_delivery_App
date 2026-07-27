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
            Column(
              children: [
                _buildHeader(controller),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        _buildProfileAvatar(controller),
                        SizedBox(height: 24.h),
                        _buildNameField(controller),
                        SizedBox(height: 14.h),
                        _buildDobField(controller),
                        SizedBox(height: 14.h),
                        _buildGenderDropdown(controller),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 80.h,
              left: 0.w,
              right: 0.w,
              child: _buildBottomButton(controller),
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Header ==========
  Widget _buildHeader(YourProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
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
          Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
            () => controller.isFormValid.value
                ? GestureDetector(
                    onTap: controller.saveProfile,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tomato,
                      ),
                    ),
                  )
                : SizedBox(width: 40.w),
          ),
        ],
      ),
    );
  }

  // ========== Profile Avatar ==========
  Widget _buildProfileAvatar(YourProfileController controller) {
    return Center(
      child: Stack(
        children: [
          Obx(
            () => Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: controller.profileImageUrl.value.isNotEmpty
                      ? FileImage(File(controller.profileImageUrl.value))
                      : NetworkImage('https://i.pravatar.cc/300')
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: GestureDetector(
              onTap: () => controller.showImagePickerOptions(Get.context!),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                child: Icon(
                  Icons.edit_rounded,
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

  // ========== Name Field ==========
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
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controller.nameController,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter your full name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (_) => controller.onTextChanged(),
          ),
        ],
      ),
    );
  }

  // ========== DOB Field ==========
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
              color: Colors.grey,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'DD/MM/YYYY',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.selectDate(Get.context!),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 20.sp,
                  color: AppColors.tomato,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========== Gender Dropdown ==========
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
              color: Colors.grey,
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
                  size: 22.sp,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                onChanged: controller.updateGender,
                items: controller.genderOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Custom Card ==========
  Widget _buildCustomCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.ashLight,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  // ========== Bottom Button ==========
  Widget _buildBottomButton(YourProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.r),
              ),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
      ),
    );
  }
}
