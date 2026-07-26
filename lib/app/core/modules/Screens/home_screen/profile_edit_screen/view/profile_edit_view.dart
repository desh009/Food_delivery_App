// lib/app/core/modules/Screens/Your_Profile_screen/view/your_profile_view.dart

import 'dart:io';

import 'package:flutter/material.dart';
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
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildProfileAvatar(controller),
                        const SizedBox(height: 24),
                        _buildNameField(controller),
                        const SizedBox(height: 14),
                        _buildDobField(controller),
                        const SizedBox(height: 14),
                        _buildGenderDropdown(controller),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: _buildBottomButton(controller),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Header ==========
  Widget _buildHeader(YourProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tomato,
                      ),
                    ),
                  )
                : const SizedBox(width: 40),
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
              width: 120,
              height: 120,
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
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => controller.showImagePickerOptions(Get.context!),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 16,
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
          const Text(
            'Full Name',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller.nameController,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: const InputDecoration(
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
          const Text(
            'Date of Birth',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.dobController,
                  readOnly: true,
                  onTap: () => controller.selectDate(Get.context!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: const InputDecoration(
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
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
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
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedGender.value,
                isExpanded: true,
                isDense: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black87,
                  size: 22,
                ),
                style: const TextStyle(
                  fontSize: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.ashLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  // ========== Bottom Button ==========
  Widget _buildBottomButton(YourProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
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
