// lib/app/core/modules/Screens/voucher_screen/view/voucher_view.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Voucher_screen/controller/voucher-screen_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class VoucherScreen extends GetView<VoucherController> {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (!Get.isRegistered<VoucherController>()) {
      Get.put(VoucherController());
    }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Status Summary
                    _buildStatusSummary(theme, isDark),
                    SizedBox(height: 16.h),

                    // List Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Vouchers',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.darkBackground,
                          ),
                        ),
                        Obx(
                          () => Text(
                            '${controller.getAvailableVouchersCount()} available',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Available Vouchers List
                    Obx(() {
                      final availableVouchers = controller.getAvailableVouchers();
                      if (availableVouchers.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.h),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 60.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'All vouchers used!',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'New offers coming soon!',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: availableVouchers.length,
                        itemBuilder: (context, index) {
                          final voucher = availableVouchers[index];
                          final code = voucher['code']!;
                          final isSelected = controller.selectedVoucher.value == code;
                          return _buildVoucherCard(voucher, index, isSelected, theme, isDark);
                        },
                      );
                    }),

                    // Used Vouchers Section
                    Obx(() {
                      final usedVouchers = controller.getUsedVouchers();
                      if (usedVouchers.isEmpty) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Used Vouchers',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.resetUsedVouchers,
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          ...usedVouchers.map(
                            (voucher) => _buildUsedVoucherCard(voucher['code']!, isDark),
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: 20.h),

                    // Apply Button
                    Obx(
                      () => controller.selectedVoucher.value.isNotEmpty
                          ? SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.applyVoucher();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.tomato,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'Apply Voucher',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Header - 🔥 Dark Mode Support ==========
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
              'Vouchers & Offers',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.darkBackground,
              ),
            ),
          ),
          Obx(
            () => controller.selectedVoucher.value.isNotEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '1 Selected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : SizedBox(width: 40.w),
          ),
        ],
      ),
    );
  }

  // ========== Status Summary - 🔥 Dark Mode Support ==========
  Widget _buildStatusSummary(ThemeData theme, bool isDark) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightAsh.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatusItem(
              'Used',
              controller.getUsedVouchersCount().toString(),
              Colors.grey,
              isDark,
            ),
            _buildStatusItem(
              'Available',
              controller.getAvailableVouchersCount().toString(),
              Colors.green,
              isDark,
            ),
            _buildStatusItem(
              'Total',
              controller.availableVouchers.length.toString(),
              AppColors.tomato,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String count, Color color, bool isDark) {
    return Column(
      children: [
        Text(
          count,
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
            color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ========== Used Voucher Card - 🔥 Dark Mode Support ==========
  Widget _buildUsedVoucherCard(String code, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withOpacity(0.7) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.grey, size: 16.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              code,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'Used',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Voucher Card - 🔥 Dark Mode Support ==========
  Widget _buildVoucherCard(
    Map<String, dynamic> voucher,
    int index,
    bool isSelected,
    ThemeData theme,
    bool isDark,
  ) {
    final code = voucher['code']!;
    final isUsed = controller.isVoucherUsed(code);

    return GestureDetector(
      onTap: isUsed ? null : () => controller.selectVoucher(index, code),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark 
                  ? Colors.green.shade900.withOpacity(0.25) 
                  : Colors.green.shade50)
              : (isDark ? AppColors.darkCard : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? Colors.black.withOpacity(0.3) 
                  : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected
                ? Colors.green
                : (isDark ? Colors.grey.shade800 : AppColors.lightAsh.withOpacity(0.4)),
            width: isSelected ? 2.w : 1.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Left Badge
                Container(
                  width: 90.w,
                  color: isSelected ? Colors.green : AppColors.tomato,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.local_offer_rounded,
                        color: Colors.white,
                        size: 24.r,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        voucher['discount']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      if (isSelected) ...[
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'SELECTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Container(
                  width: 1,
                  color: isDark ? Colors.grey.shade800 : AppColors.lightAsh.withOpacity(0.5),
                ),

                // Right Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                voucher['title']!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppColors.darkText : AppColors.darkBackground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.copyVoucherCode(code),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey.shade800
                                      : AppColors.lightAsh.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.tomato,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Min spend: £${(voucher['minSpend'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey.shade400 : AppColors.darkBackground.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              voucher['validity']!,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '✓ Selected',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}