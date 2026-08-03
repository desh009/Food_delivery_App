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
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0.w,
            vertical: 16.0.h,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ==================================================
                // TOP SPACER
                // ==================================================
                SizedBox(height: 20.h),

                // ==================================================
                // LOGO
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
                // TITLE
                // ==================================================
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Sign in to continue",
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.black54,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 32.h),

                // ==================================================
                // 🔥 EMAIL FIELD
                // ==================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Address",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade800 : Colors.transparent,
                        ),
                      ),
                      child: ClipRRect(

                        borderRadius: BorderRadius.circular(12.r),
                        child: TextField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey.shade600 : Colors.black38,
                              fontSize: 14.sp,
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: isDark ? Colors.grey.shade500 : Colors.black38,
                              size: 20.sp,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // ==================================================
                // 🔥 PHONE NUMBER FIELD
                // ==================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    IntlPhoneField(
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                        hintText: 'Enter phone number',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey.shade600 : Colors.black26,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
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
                          vertical: 14.h,
                        ),
                      ),
                      initialCountryCode: 'BD',
                      onChanged: (phone) {
                        controller.completePhoneNumber.value =
                            phone.completeNumber;
                      },
                      dropdownIconPosition: IconPosition.trailing,
                      dropdownIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: isDark ? Colors.white : Colors.black87,
                        size: 20.sp,
                      ),
                      flagsButtonPadding: EdgeInsets.only(left: 8.w),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // ==================================================
                // 🔥 PASSWORD FIELD
                // ==================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark ? Colors.grey.shade800 : Colors.transparent,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                              hintStyle: TextStyle(
                                color: isDark ? Colors.grey.shade600 : Colors.black38,
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: isDark ? Colors.grey.shade500 : Colors.black38,
                                size: 20.sp,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: isDark ? Colors.grey.shade500 : Colors.black38,
                                  size: 20.sp,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ==================================================
                // REMEMBER ME & FORGOT PASSWORD
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
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: controller.isRememberMeChecked.value
                                    ? AppColors.tomato
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: controller.isRememberMeChecked.value
                                      ? AppColors.tomato
                                      : (isDark ? Colors.grey.shade600 : Colors.black26),
                                  width: 1.5.w,
                                ),
                              ),
                              child: controller.isRememberMeChecked.value
                                  ? Icon(
                                      Icons.check,
                                      size: 14.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Remember me",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.FORGET_PASSWORD);
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

                SizedBox(height: 32.h),

                // ==================================================
                // SIGN IN BUTTON
                // ==================================================
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.signIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tomato,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.tomato.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                        disabledBackgroundColor: isDark
                            ? Colors.grey.shade700
                            : AppColors.tomato.withOpacity(0.5),
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
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ==================================================
                // OR DIVIDER
                // ==================================================
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey.shade800 : Colors.black12,
                        thickness: 1.r,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        "Or sign in with",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade500 : Colors.black38,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey.shade800 : Colors.black12,
                        thickness: 1.r,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

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
                      isDark: isDark,
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
                      isDark: isDark,
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
                      iconColor: isDark ? Colors.white : Colors.black,
                      label: 'Apple',
                      isDark: isDark,
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

                SizedBox(height: 24.h),

                // ==================================================
                // FOOTER
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.black87,
                        fontSize: 14.sp,
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
                          fontSize: 14.sp,
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
  // SOCIAL BUTTON - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildSocialButton({
    required IconData fallbackIcon,
    required Color iconColor,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF333333) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.black12,
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
                size: 24.sp,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: isDark ? Colors.grey.shade400 : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}