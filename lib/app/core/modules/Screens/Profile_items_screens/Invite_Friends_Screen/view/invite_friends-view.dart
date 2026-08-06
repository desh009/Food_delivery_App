// lib/app/core/modules/Screens/Profile_items_screens/Invite_Friends_Screen/view/invite_friends_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Invite_Friends_Screen/controller/invite_friends_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class InviteFriendScreen extends GetView<InviteFriendController> {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme, isDark),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildRewardBanner(isDark),
                    SizedBox(height: 24.h),
                    _buildAppLinkBox(theme, isDark),
                    SizedBox(height: 28.h),
                    _buildStatsRow(isDark),
                    SizedBox(height: 20.h),
                    _buildHowItWorks(theme, isDark),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            _buildBottomCTA(theme, isDark),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightAsh.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.r,
                color: isDark ? AppColors.darkText : AppColors.darkBackground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Invite Friends',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.darkBackground,
              ),
            ),
          ),
          Obx(
            () => controller.totalInvites.value > 0
                ? GestureDetector(
                    onTap: controller.resetInviteData,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : SizedBox(width: 40.w),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REWARD BANNER
  // ============================================================
  Widget _buildRewardBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tomato,
            AppColors.tomato.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.tomato.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70.r,
            height: 70.r,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: Colors.white,
              size: 36.r,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Share With Friends',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Share the app with your friends and earn rewards!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // APP LINK BOX - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildAppLinkBox(ThemeData theme, bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightAsh.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : AppColors.lightAsh.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHARE APP LINK',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: isDark ? Colors.grey.shade500 : AppColors.darkBackground.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Expanded(
                  child: Text(
                    controller.appLink.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.darkText : AppColors.darkBackground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Obx(
                () => GestureDetector(
                  onTap: controller.copyAppLink,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: controller.isCopied.value
                          ? Colors.green.withOpacity(0.1)
                          : AppColors.tomato.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: controller.isCopied.value
                          ? Border.all(color: Colors.green, width: 1)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          controller.isCopied.value
                              ? Icons.check_circle_rounded
                              : Icons.copy_rounded,
                          size: 16.r,
                          color: controller.isCopied.value
                              ? Colors.green
                              : AppColors.tomato,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          controller.isCopied.value ? 'Copied!' : 'Copy',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: controller.isCopied.value
                                ? Colors.green
                                : AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS ROW - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildStatsRow(bool isDark) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Shares',
              controller.totalInvites.value.toString(),
              Icons.share_rounded,
              Colors.blue,
              isDark,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Total Rewards',
              '\$${controller.totalRewards.value.toStringAsFixed(0)}',
              Icons.monetization_on_rounded,
              Colors.green,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark ? color.withOpacity(0.3) : color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.r),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOW IT WORKS - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHowItWorks(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'How It Works',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.darkBackground,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildStepItem(
          stepNumber: '1',
          title: 'Share the App',
          description: 'Share the app link with your friends via any platform.',
          icon: Icons.share_rounded,
          isDark: isDark,
        ),
        _buildStepItem(
          stepNumber: '2',
          title: 'Friend Downloads',
          description: 'Your friend downloads and installs the app.',
          icon: Icons.download_rounded,
          isDark: isDark,
        ),
        _buildStepItem(
          stepNumber: '3',
          title: 'Get Rewarded',
          description: 'You earn rewards when your friend starts using the app.',
          icon: Icons.monetization_on_rounded,
          isLast: true,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
    bool isLast = false,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightAsh.withOpacity(0.25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.tomato.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.tomato,
                size: 20.r,
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 36.h,
                color: isDark ? Colors.grey.shade700 : AppColors.lightAsh.withOpacity(0.5),
              ),
          ],
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, bottom: isLast ? 0 : 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$stepNumber. $title',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.darkBackground,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.grey.shade400 : AppColors.darkBackground.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM CTA BUTTON - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildBottomCTA(ThemeData theme, bool isDark) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton.icon(
            onPressed: controller.isLoading.value ? null : controller.shareAppLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            icon: controller.isLoading.value
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
            label: Text(
              controller.isLoading.value ? 'Sharing...' : 'Share App',
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