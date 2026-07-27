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
        backgroundColor: Color(0xFF1E1E1E),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0.w,
              vertical: 24.0.h,
            ),
            child: Column(
              children: [
                Spacer(flex: 2),
      
                // Title: Login
                Text(
                  "Login",
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
      
                SizedBox(height: 32.h),
                // intl_phone_field
                IntlPhoneField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
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
                      vertical: 16.h,
                    ),
                  ),
                  initialCountryCode: 'GB',
                  onChanged: (phone) {
                    controller.completePhoneNumber.value =
                        phone.completeNumber;
                  },
                  dropdownIconPosition: IconPosition.trailing,
                  dropdownIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black87,
                  ),
                  flagsButtonPadding: EdgeInsets.only(left: 8.w),
                  style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                ),
      
                SizedBox(height: 24.h),
      
                // Remember Me Checkbox Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleRememberMe(),
                      child: Obx(
                        () => Container(
                          width: 22.w,
                          height: 22.h,
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
                                  size: 16.sp,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Remember me",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
      
                Spacer(flex: 5),
      
                // Sign In Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.signIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isRememberMeChecked.value
                            ? AppColors.tomato
                            : Colors.white,
                        foregroundColor: controller.isRememberMeChecked.value
                            ? Colors.white
                            : Colors.black,
                        elevation: controller.isRememberMeChecked.value ? 4 : 0,
                        shadowColor: controller.isRememberMeChecked.value
                            ? AppColors.tomato.withOpacity(0.4)
                            : Colors.transparent,
                        side: BorderSide(
                          color: controller.isRememberMeChecked.value
                              ? AppColors.tomato
                              : Colors.black26,
                          width: 1.5.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5.r,
                                color: controller.isRememberMeChecked.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          : Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: controller.isRememberMeChecked.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
      
                SizedBox(height: 24.h),
      
                // "Or sign in with" Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black12, thickness: 1.r),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Text(
                        "Or sign in with",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.black12, thickness: 1.r),
                    ),
                  ],
                ),
      
                SizedBox(height: 24.h),
      
                // Social Media Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      fallbackIcon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      onTap: () {
                        Get.snackbar('Info', 'Google Sign-in coming soon!');
                      },
                    ),
                    SizedBox(width: 16.w),
                    _buildSocialButton(
                      fallbackIcon: Icons.facebook,
                      iconColor: Colors.blue,
                      onTap: () {
                        Get.snackbar('Info', 'Facebook Sign-in coming soon!');
                      },
                    ),
                    SizedBox(width: 16.w),
                    _buildSocialButton(
                      fallbackIcon: Icons.apple,
                      iconColor: Colors.black,
                      onTap: () {
                        Get.snackbar('Info', 'Apple Sign-in coming soon!');
                      },
                    ),
                  ],
                ),
      
                SizedBox(height: 28.h),
      
                // Footer Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15.sp,
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildSocialButton({
    required IconData fallbackIcon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 1.w),
        ),
        child: Center(child: Icon(fallbackIcon, size: 28.sp, color: iconColor)),
      ),
    );
  }
}