// lib/app/core/modules/Screens/login_screen/view/login_screen_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/controller/login_screen_controller.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login1Screen extends GetView<Login1Controller> {
  const Login1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground, // ✅ Use AppColors
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0.w,
              vertical: 16.0.h, // ✅ 24.h → 16.h
            ),
            child: Column(
              children: [
                // ==================================================
                // TOP SPACER (Responsive)
                // ==================================================
                SizedBox(height: 20.h),

                // ==================================================
                // LOGO / HEADER (Optional)
                // ==================================================
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.restaurant,
                    size: 40.sp,
                    color: AppColors.tomato,
                  ),
                ),

                SizedBox(height: 24.h),

                // ==================================================
                // TITLE: Login
                // ==================================================
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 28.sp, // ✅ 32.sp → 28.sp
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Sign in to continue",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 32.h),

                // ==================================================
                // PHONE FIELD
                // ==================================================
                IntlPhoneField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 14.sp, // ✅ 16.sp → 14.sp
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: AppColors.tomato,
                        width: 1.5.w,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h, // ✅ 16.h → 14.h
                    ),
                  ),
                  initialCountryCode: 'BD', // ✅ GB → BD
                  onChanged: (phone) {
                    controller.completePhoneNumber.value =
                        phone.completeNumber;
                  },
                  dropdownIconPosition: IconPosition.trailing,
                  dropdownIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black87,
                    size: 20.sp,
                  ),
                  flagsButtonPadding: EdgeInsets.only(left: 8.w),
                  style: TextStyle(
                    fontSize: 14.sp, // ✅ 16.sp → 14.sp
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 20.h), // ✅ 24.h → 20.h

                // ==================================================
                // REMEMBER ME
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Remember Me
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.toggleRememberMe(),
                          child: Obx(
                            () => Container(
                              width: 20.w, // ✅ 22.w → 20.w
                              height: 20.h, // ✅ 22.h → 20.h
                              decoration: BoxDecoration(
                                color: controller.isRememberMeChecked.value
                                    ? AppColors.tomato
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: controller.isRememberMeChecked.value
                                      ? AppColors.tomato
                                      : Colors.black26,
                                  width: 1.5.w,
                                ),
                              ),
                              child: controller.isRememberMeChecked.value
                                  ? Icon(
                                      Icons.check,
                                      size: 14.sp, // ✅ 16.sp → 14.sp
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w), // ✅ 12.w → 10.w
                        Text(
                          "Remember me",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14.sp, // ✅ 16.sp → 14.sp
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.FORGOT_PASSWORD);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h), // ✅ Spacer → SizedBox

                // ==================================================
                // SIGN IN BUTTON
                // ==================================================
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52.h, // ✅ 56.h → 52.h
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.signIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isRememberMeChecked.value
                            ? AppColors.tomato
                            : AppColors.tomato.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.tomato.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 22.h,
                              width: 22.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5.r,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16.sp, // ✅ 18.sp → 16.sp
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h), // ✅ 24.h → 20.h

                // ==================================================
                // OR DIVIDER
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black12,
                        thickness: 1.r,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        "Or sign in with",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 13.sp, // ✅ 14.sp → 13.sp
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black12,
                        thickness: 1.r,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h), // ✅ 24.h → 20.h

                // ==================================================
                // SOCIAL MEDIA BUTTONS
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      fallbackIcon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      label: 'Google',
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Google Sign-in coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.tomato,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    SizedBox(width: 16.w),
                    _buildSocialButton(
                      fallbackIcon: Icons.facebook,
                      iconColor: Colors.blue.shade700,
                      label: 'Facebook',
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Facebook Sign-in coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.tomato,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    SizedBox(width: 16.w),
                    _buildSocialButton(
                      fallbackIcon: Icons.apple,
                      iconColor: Colors.black,
                      label: 'Apple',
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Apple Sign-in coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.tomato,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                ),

                SizedBox(height: 24.h), // ✅ 28.h → 24.h

                // ==================================================
                // FOOTER
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.sp, // ✅ 15.sp → 14.sp
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 14.sp, // ✅ 15.sp → 14.sp
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SOCIAL BUTTON
  // ============================================================

  Widget _buildSocialButton({
    required IconData fallbackIcon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w, // ✅ 52.w → 48.w
            height: 48.h, // ✅ 52.h → 48.h
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                fallbackIcon,
                size: 24.sp, // ✅ 28.sp → 24.sp
                color: iconColor,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}