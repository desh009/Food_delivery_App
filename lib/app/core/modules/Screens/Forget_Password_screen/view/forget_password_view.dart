import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/controller/forget_password_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final cardBg = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: _buildHeader(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),

                    // Top Lock Icon Header Card
                    Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: AppColors.tomato.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 60.sp,
                        color: AppColors.tomato,
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Title
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Description
                    Text(
                      "Don't worry! Enter your email or phone number and we'll send you a code to reset your password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.5,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // Input Field Container
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email or Phone Number",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextField(
                            controller: controller.inputController,
                            style: TextStyle(fontSize: 13.sp, color: textColor),
                            decoration: InputDecoration(
                              hintText: "e.g. user@email.com or 017xxxxxxxx",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                              prefixIcon: Icon(
                                Icons.alternate_email_rounded,
                                size: 18.sp,
                                color: AppColors.tomato,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: AppColors.tomato,
                                  width: 1.5.w,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Send Button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.sendResetCode(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tomato,
                            disabledBackgroundColor: AppColors.tomato.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Send Reset Code",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Back to Login Link
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            size: 16.sp,
                            color: AppColors.tomato,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Back to Login",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.tomato,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Helper
  Widget _buildHeader(BuildContext context) {
    final iconBg = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: textColor,
              size: 20.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        SizedBox(width: 36.w),
      ],
    );
  }
}