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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildRewardBanner(),
                    SizedBox(height: 24.h),
                    _buildAppLinkBox(),
                    SizedBox(height: 28.h),
                    _buildStatsRow(),
                    SizedBox(height: 20.h),
                    _buildHowItWorks(),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
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
                color: AppColors.ashLight.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.r,
                color: AppColors.darkBackground,
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
                color: AppColors.darkBackground,
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
  // REWARD BANNER - এখানে Obx সরানো হয়েছে
  // ============================================================
  Widget _buildRewardBanner() {
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
          // Obx সরানো হয়েছে কারণ এখানে কোনো observable variable নেই
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
  // APP LINK BOX
  // ============================================================
  Widget _buildAppLinkBox() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.ashLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.ashLight.withOpacity(0.5),
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
              color: AppColors.darkBackground.withOpacity(0.6),
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
                      color: AppColors.darkBackground,
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
  // STATS ROW
  // ============================================================
  Widget _buildStatsRow() {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Shares',
              controller.totalInvites.value.toString(),
              Icons.share_rounded,
              Colors.blue,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Total Rewards',
              '\$${controller.totalRewards.value.toStringAsFixed(0)}',
              Icons.monetization_on_rounded,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: color.withOpacity(0.2),
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
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOW IT WORKS
  // ============================================================
  Widget _buildHowItWorks() {
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
              color: AppColors.darkBackground,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildStepItem(
          stepNumber: '1',
          title: 'Share the App',
          description: 'Share the app link with your friends via any platform.',
          icon: Icons.share_rounded,
        ),
        _buildStepItem(
          stepNumber: '2',
          title: 'Friend Downloads',
          description: 'Your friend downloads and installs the app.',
          icon: Icons.download_rounded,
        ),
        _buildStepItem(
          stepNumber: '3',
          title: 'Get Rewarded',
          description: 'You earn rewards when your friend starts using the app.',
          icon: Icons.monetization_on_rounded,
          isLast: true,
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
                color: AppColors.ashLight.withOpacity(0.25),
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
                color: AppColors.ashLight.withOpacity(0.5),
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
                    color: AppColors.darkBackground,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.darkBackground.withOpacity(0.7),
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
  // BOTTOM CTA BUTTON
  // ============================================================
  Widget _buildBottomCTA() {
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