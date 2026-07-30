// lib/app/core/modules/Screens/Profile_screen/view/profile_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/l10n/Local_Controller/local_controller.dart';
import 'package:food_hjoiopk/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    final localizations = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(4);
      } catch (e) {
        print('Error: $e');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ========== Main Content ==========
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 100.h),
              child: Column(
                children: [
                  _buildTopHeader(localizations),
                  SizedBox(height: 20.h),
                  _buildUserProfileHeader(controller, localizations),
                  SizedBox(height: 20.h),
                  _buildLogoutButton(controller, localizations),
                  SizedBox(height: 24.h),

                  // ========== Primary Navigation Items ==========
                  _buildListTile(
                    Icons.location_on_outlined,
                    localizations.trackOrder,
                    onTap: () {
                      Get.toNamed('/track-order');
                    },
                  ),
      
                  _buildListTile(
                    Icons.account_balance_wallet_outlined,
                    localizations.vouchers,
                    onTap: () {
                      Get.toNamed('/voucher');
                    },
                  ),
                  _buildListTile(
                    Icons.chat_bubble_outline_rounded,
                    localizations.messages,
                    onTap: () {
                      Get.toNamed('/message');
                    },
                  ),
                  _buildListTile(
                    Icons.people_outline_rounded,
                    localizations.inviteFriends,
                    onTap: () {
                      Get.toNamed('/invite_friends');
                    },
                  ),
                  _buildListTile(
                    Icons.shield_outlined,
                    localizations.security,
                    onTap: () {
                      Get.toNamed('/security');
                    },
                  ),
                  _buildListTile(
                    Icons.help_outline_rounded,
                    localizations.helpCenter,
                    onTap: () {
                      Get.toNamed('/help-center');
                    },
                  ),

                  SizedBox(height: 8.h),
                  Divider(color: const Color(0xFFEEEEEE), thickness: 1.r),
                  SizedBox(height: 8.h),

                  // ========== Settings ==========
                  _buildLanguageDropdown(localizations),
                  _buildSwitchTile(
                    localizations.pushNotification,
                    controller.pushNotification,
                  ),
                  _buildSwitchTile(
                    localizations.darkMode,
                    controller.darkMode,
                  ),
                  _buildSwitchTile(
                    localizations.sound,
                    controller.sound,
                  ),
                  _buildSwitchTile(
                    localizations.automaticallyUpdated,
                    controller.automaticallyUpdated,
                  ),

                  SizedBox(height: 8.h),
                  Divider(color: const Color(0xFFEEEEEE), thickness: 1.r),
                  SizedBox(height: 8.h),

                  // ========== Secondary Items ==========
                  _buildListTile(
                    null,
                    localizations.termOfService,
                    onTap: () {
                      Get.snackbar(
                        localizations.termOfService,
                        'Coming soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildListTile(
                    null,
                    localizations.privacyPolicy,
                    onTap: () {
                      Get.snackbar(
                        localizations.privacyPolicy,
                        'Coming soon!',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  _buildListTile(
                    null,
                    localizations.aboutApp,
                    onTap: () {
                      Get.toNamed('/about-app');
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // ========== Bottom Navigation Bar ==========
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Top App Bar ==========
  Widget _buildTopHeader(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            BottomNavController.to.goBack();
          },
          child: Container(
            padding: EdgeInsets.all(10.r),
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
            child: Icon(Icons.arrow_back, size: 18.sp, color: Colors.black87),
          ),
        ),
        Text(
          localizations.profile,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.r),
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
          child: Icon(Icons.more_horiz, size: 18.sp, color: Colors.black87),
        ),
      ],
    );
  }

  // ========== User Profile Header ==========
  Widget _buildUserProfileHeader(
    ProfileController controller,
    AppLocalizations localizations,
  ) {
    return Row(
      children: [
        Obx(
          () => CircleAvatar(
            radius: 32.r,
            backgroundImage: controller.profileImagePath.value.isNotEmpty
                ? FileImage(File(controller.profileImagePath.value))
                : const NetworkImage('https://i.pravatar.cc/300')
                    as ImageProvider,
          ),
        ),
        SizedBox(width: 14.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tomato,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Row(
                  children: [
                    Icon(
                      Icons.phone_outlined,
                      size: 13.sp,
                      color: Colors.black45,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.userPhone.value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Obx(
                () => Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 13.sp,
                      color: Colors.black45,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.userEmail.value,
                      style: TextStyle(fontSize: 11.sp, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            Get.toNamed('/profile-edit');
          },
          child: Container(
            padding: EdgeInsets.all(12.r),
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
            child: Icon(Icons.edit, size: 18.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ========== Logout Button ==========
  Widget _buildLogoutButton(
    ProfileController controller,
    AppLocalizations localizations,
  ) {
    return InkWell(
      onTap: () {
        _showLogoutDialog(Get.context!, localizations);
      },
      borderRadius: BorderRadius.circular(22.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0EF),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.tomato, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              localizations.logout,
              style: TextStyle(
                color: AppColors.tomato,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Logout Dialog ==========
  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            localizations.logout,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            localizations.logoutConfirm,
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.cancel,
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
                    localizations.success,
                    localizations.logoutSuccess,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Get.snackbar(
                    localizations.error,
                    localizations.logoutFailed,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                localizations.logout,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ========== List Tile ==========
  Widget _buildListTile(
    IconData? icon,
    String title, {
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: icon != null
            ? Icon(icon, size: 20.sp, color: Colors.black87)
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: Colors.black45,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  // ========== Language Dropdown ==========
  Widget _buildLanguageDropdown(AppLocalizations localizations) {
    final localeController = LocaleController.to;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.language,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: localeController.currentLocale.value.languageCode,
                  isDense: true,
                  icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
                  items: LocaleController.supportedLanguages.map((language) {
                    final code = language['code'] ?? 'en';
                    final flag = code == 'en' ? '🇺🇸' : '🇧🇩';
                    final name = language['name'] ?? code;

                    return DropdownMenuItem<String>(
                      value: code,
                      child: Row(
                        children: [
                          Text(flag, style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 6.w),
                          Text(name, style: TextStyle(fontSize: 13.sp)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      localeController.changeLanguage(newValue);

                      String languageName =
                          newValue == 'bn' ? 'বাংলা' : 'English';
                      Get.snackbar(
                        localizations.language,
                        'Language changed to $languageName',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );
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

  // ========== Switch Tile ==========
  Widget _buildSwitchTile(String title, RxBool rxBool) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
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