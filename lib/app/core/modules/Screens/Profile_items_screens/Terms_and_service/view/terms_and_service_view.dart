// lib/app/core/modules/Screens/Profile_items_screens/Terms_and_Services_Screen/view/terms_and_services_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Terms_and_service/controller/terms_and_service_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class TermsAndServicesScreen extends GetView<TermsAndServicesController> {
  const TermsAndServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Controller Initialize
    if (!Get.isRegistered<TermsAndServicesController>()) {
      Get.put(TermsAndServicesController());
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              // ============================================================
              // MAIN CONTENT
              // ============================================================
              Column(
                children: [
                  // Custom Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: _buildHeader(theme, isDark),
                  ),

                  // Scrollable Content
                  if (controller.errorMessage.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: controller.loadTermsData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.tomato,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Last Updated Tag
                            _buildLastUpdatedTag(isDark),
                            SizedBox(height: 16.h),

                            // Terms Sections
                            ...controller.termsSections.map(
                              (section) =>
                                  _buildSection(section, theme, isDark),
                            ),

                            SizedBox(height: 16.h),

                            // Contact Section Card

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              // ============================================================
              // LOADING OVERLAY
              // ============================================================
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.tomato,
                      strokeWidth: 3.r,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.goBack,
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF333333) : Colors.white,
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
              color: isDark ? Colors.white : Colors.black87,
              size: 20.sp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Terms of Service",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 36.w),
      ],
    );
  }

  // ============================================================
  // LAST UPDATED TAG - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildLastUpdatedTag(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.tomato.withOpacity(0.2)
            : AppColors.tomato.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 14.sp, color: AppColors.tomato),
          SizedBox(width: 6.w),
          Obx(
            () => Text(
              "Last Updated: ${controller.lastUpdated.value}",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.tomato,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildSection(
    Map<String, dynamic> section,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          section['title'] ?? '',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          section['content'] ?? '',
          style: TextStyle(
            fontSize: 12.sp,
            height: 1.5,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
          ),
        ),
        if (section['bulletPoints'] != null &&
            (section['bulletPoints'] as List).isNotEmpty) ...[
          SizedBox(height: 10.h),
          ...(section['bulletPoints'] as List).map(
            (bullet) => _buildBulletItem(bullet, theme, isDark),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // BULLET ITEM - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildBulletItem(
    Map<String, dynamic> bullet,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Container(
              width: 5.w,
              height: 5.h,
              decoration: const BoxDecoration(
                color: AppColors.tomato,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 11.sp,
                  height: 1.4,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
                children: [
                  TextSpan(
                    text: bullet['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: bullet['desc'] ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT CARD - 🔥 Dark Mode Support
  // ============================================================
}
