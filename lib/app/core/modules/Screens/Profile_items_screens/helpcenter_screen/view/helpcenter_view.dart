// lib/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/view/helpcenter_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/controller/helpcenter-controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class HelpCenterScreen extends GetView<HelpCenterController> {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
          onPressed: controller.goBack,
        ),
        title: Text(
          'Help Center',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : const Color(0xFFF3F3F4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                onChanged: controller.searchFAQ,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Search FAQs...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.black38,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.grey.shade500 : Colors.black38,
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        // ===== Loading State =====
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.tomato,
            ),
          );
        }

        // ===== Error State - 🔥 Dark Mode Support =====
        if (controller.errorMessage.isNotEmpty) {
          return Center(
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.red.shade300 : Colors.red,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: controller.loadFAQData,
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
          );
        }

        // ===== Empty State - 🔥 Dark Mode Support =====
        if (controller.faqList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 60.sp,
                  color: isDark ? Colors.grey.shade600 : Colors.black26,
                ),
                SizedBox(height: 12.h),
                Text(
                  'No FAQs found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: isDark ? Colors.grey.shade400 : Colors.black38,
                  ),
                ),
              ],
            ),
          );
        }

        // ===== FAQ List =====
        return ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            // FAQ Items
            ...controller.faqList.map(
              (faq) => _buildFAQItem(
                faq['question'] ?? '',
                faq['answer'] ?? '',
                isDark,
              ),
            ),
            SizedBox(height: 20.h),

            // ===== Contact Support Section - 🔥 Dark Mode Support =====
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242424) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.headset_mic_outlined,
                    color: AppColors.tomato,
                    size: 40.sp,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Our support team is here for you ${controller.supportHours.value}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.grey.shade400 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.emailSupport,
                          icon: Icon(
                            Icons.email_outlined,
                            size: 18.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.callSupport,
                          icon: Icon(Icons.phone_outlined, size: 18.sp),
                          label: Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tomato,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: controller.contactSupport,
                      icon: Icon(
                        Icons.support_agent_outlined,
                        color: AppColors.tomato,
                      ),
                      label: Text(
                        'View All Contact Options',
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        );
      }),
    );
  }

  // ========== FAQ Item Widget - 🔥 Dark Mode Support ==========
  Widget _buildFAQItem(String question, String answer, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242424) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.tomato,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.question_mark,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey.shade400 : Colors.black54,
                height: 1.6.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}