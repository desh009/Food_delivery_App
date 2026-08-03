// lib/app/core/modules/Screens/otp_screen/view/otp_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/otp_screen/controller/otp_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class VerificationScreen extends GetView<VerificationController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final controller = Get.put(VerificationController());

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.0.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ==================================================
                // BACK BUTTON - 🔥 Dark Mode Support
                // ==================================================
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ==================================================
                // TITLE - 🔥 Dark Mode Support
                // ==================================================
                Text(
                  "Verification",
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 34.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 16.h),

                // ==================================================
                // SUBTITLE - 🔥 Dark Mode Support
                // ==================================================
                Obx(
                  () => Column(
                    children: [
                      Text(
                        "Code has been sent to",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black87,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${controller.countryCode.value} ${controller.phoneNumber.value}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 36.h),

                // ==================================================
                // OTP INPUT FIELDS - 🔥 Dark Mode Support
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpBox(
                      context,
                      controller.txt1,
                      controller.f1,
                      controller.f2,
                      controller,
                      isDark,
                    ),
                    _buildOtpBox(
                      context,
                      controller.txt2,
                      controller.f2,
                      controller.f3,
                      controller,
                      isDark,
                    ),
                    _buildOtpBox(
                      context,
                      controller.txt3,
                      controller.f3,
                      controller.f4,
                      controller,
                      isDark,
                    ),
                    _buildOtpBox(
                      context,
                      controller.txt4,
                      controller.f4,
                      null,
                      controller,
                      isDark,
                    ),
                  ],
                ),

                SizedBox(height: 40.h),

                // ==================================================
                // RESEND SECTION - 🔥 Dark Mode Support
                // ==================================================
                Text(
                  "Didn't receive code?",
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.black87,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: isDark ? Colors.grey.shade400 : Colors.black87,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Obx(
                      () => Text(
                        controller.formattedTime.value,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black87,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Obx(
                  () => GestureDetector(
                    onTap: controller.canResend.value
                        ? () => controller.startTimer()
                        : null,
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                        color: controller.canResend.value
                            ? AppColors.tomato
                            : (isDark ? Colors.grey.shade600 : Colors.black38),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // ==================================================
                // VERIFY BUTTON - 🔥 Dark Mode Support
                // ==================================================
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: controller.isOtpComplete.value && !controller.isLoading.value
                          ? () => controller.verifyOTP()
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isOtpComplete.value
                            ? AppColors.tomato
                            : (isDark ? Colors.grey.shade800 : Colors.white),
                        foregroundColor: controller.isOtpComplete.value
                            ? Colors.white
                            : (isDark ? Colors.grey.shade400 : Colors.black),
                        elevation: controller.isOtpComplete.value ? 4 : 0,
                        shadowColor: controller.isOtpComplete.value
                            ? AppColors.tomato.withOpacity(0.4)
                            : Colors.transparent,
                        side: BorderSide(
                          color: controller.isOtpComplete.value
                              ? AppColors.tomato
                              : (isDark ? Colors.grey.shade700 : Colors.black26),
                          width: 1.5.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0.r),
                        ),
                        disabledBackgroundColor: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade200,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 22.h,
                              width: 22.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5.r,
                                color: controller.isOtpComplete.value
                                    ? Colors.white
                                    : (isDark ? Colors.grey.shade400 : Colors.black),
                              ),
                            )
                          : Text(
                              "Verify",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: controller.isOtpComplete.value
                                    ? Colors.white
                                    : (isDark ? Colors.grey.shade400 : Colors.black),
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ==================================================
                // FOOTER - 🔥 Dark Mode Support
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Back to ",
                      style: TextStyle(
                        color: isDark ? Colors.grey.shade400 : Colors.black87,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Sign In",
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
  // OTP BOX - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildOtpBox(
    BuildContext context,
    TextEditingController textController,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    VerificationController controller,
    bool isDark,
  ) {
    return Container(
      width: 64.w,
      height: 72.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.transparent,
          width: 1.w,
        ),
      ),
      child: Center(
        child: TextField(
          controller: textController,
          focusNode: currentFocus,
          onChanged: (value) {
            controller.checkOtpComplete();

            if (value.length == 1) {
              if (nextFocus != null) {
                FocusScope.of(context).requestFocus(nextFocus);
              } else {
                currentFocus.unfocus();
              }
            }
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          },
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }
}