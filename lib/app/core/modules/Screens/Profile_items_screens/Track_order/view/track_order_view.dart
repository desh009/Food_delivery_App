// lib/app/core/modules/Screens/track_order_screen/view/track_order_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Track_order/controller/track_order_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class TrackOrderScreen extends GetView<TrackOrderController> {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: _buildAppBar(theme, isDark),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status Card
              _buildOrderStatusCard(theme, isDark),
              
              SizedBox(height: 24.h),
              
              // Order Details
              _buildOrderDetails(theme, isDark),
              
              SizedBox(height: 24.h),
              
              // Delivery Information
              _buildDeliveryInfo(theme, isDark),
              
              SizedBox(height: 24.h),
              
              // Order Items
              _buildOrderItems(theme, isDark),
              
              SizedBox(height: 30.h),
              
              // Action Buttons
              _buildActionButtons(theme, isDark),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ========== APP BAR - 🔥 Dark Mode Support ==========
  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black87),
        onPressed: controller.goBack,
      ),
      title: Text(
        "Track Order",
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.support_agent, color: isDark ? Colors.white : Colors.black87),
          onPressed: controller.contactSupport,
        ),
      ],
    );
  }

  // ========== Order Status Card - 🔥 Dark Mode Support ==========
  Widget _buildOrderStatusCard(ThemeData theme, bool isDark) {
    return Obx(() {
      final status = controller.orderStatus.value;
      final isCancelled = status == 'Cancelled';
      
      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCancelled 
                ? [Colors.grey, Colors.grey.shade700]
                : [AppColors.tomato, AppColors.tomato.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (isCancelled ? Colors.grey : AppColors.tomato).withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${controller.orderNumber.value}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    controller.orderStatus.value,
                    style: TextStyle(
                      color: isCancelled ? Colors.white : AppColors.tomato,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "Expected Delivery",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              controller.expectedDelivery.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            if (!isCancelled) _buildProgressTimeline(isDark),
          ],
        ),
      );
    });
  }

  // ========== Progress Timeline - 🔥 Dark Mode Support ==========
  Widget _buildProgressTimeline(bool isDark) {
    return Obx(() {
      return Column(
        children: controller.timelineSteps.map((step) {
          final index = controller.timelineSteps.indexOf(step);
          final isCompleted = step['completed'] as bool;
          final isLast = index == controller.timelineSteps.length - 1;

          return Row(
            children: [
              // Timeline icon
              Column(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
                        width: 2.w,
                      ),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.access_time,
                      color: isCompleted ? AppColors.tomato : Colors.white70,
                      size: 16.sp,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2.w,
                      height: 40.h,
                      color: isCompleted 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.3),
                    ),
                ],
              ),
              SizedBox(width: 16.w),
              // Timeline content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['label'] as String,
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.white70,
                        fontSize: 16.sp,
                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      step['time'] as String,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                    if (!isLast) SizedBox(height: 8.h),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      );
    });
  }

  // ========== Order Details - 🔥 Dark Mode Support ==========
  Widget _buildOrderDetails(ThemeData theme, bool isDark) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Details",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("Order Date", controller.orderDate.value, isDark),
            _buildDivider(isDark),
            _buildDetailRow("Payment Method", controller.paymentMethod.value, isDark),
            _buildDivider(isDark),
            _buildDetailRow("Payment Status", controller.paymentStatus.value, isDark),
            _buildDivider(isDark),
            _buildDetailRow("Delivery Type", controller.deliveryType.value, isDark),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.black54,
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      height: 1.h,
    );
  }

  // ========== Delivery Information - 🔥 Dark Mode Support ==========
  Widget _buildDeliveryInfo(ThemeData theme, bool isDark) {
    return Obx(() {
      final address = controller.deliveryAddress.value;
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.tomato,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['name'] ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address['address'] ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        address['city'] ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "Phone: ${address['phone'] ?? ''}",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ========== Order Items - 🔥 Dark Mode Support ==========
  Widget _buildOrderItems(ThemeData theme, bool isDark) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Items",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            ...controller.orderItems.map((item) => _buildOrderItem(item, isDark)),
            Divider(height: 20.h, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            _buildTotalRow("Subtotal", "\$${controller.subtotal.value.toStringAsFixed(2)}", isDark),
            SizedBox(height: 4.h),
            _buildTotalRow("Delivery", "\$${controller.deliveryCharge.value.toStringAsFixed(2)}", isDark),
            SizedBox(height: 4.h),
            _buildTotalRow("Tax", "\$${controller.tax.value.toStringAsFixed(2)}", isDark),
            Divider(height: 16.h, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            _buildTotalRow(
              "Total",
              "\$${controller.total.value.toStringAsFixed(2)}",
              isDark,
              isTotal: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderItem(Map<String, dynamic> item, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: NetworkImage(item['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  item['quantity'],
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.black54,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item['price'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, bool isDark, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? (isDark ? Colors.white : Colors.black87) : (isDark ? Colors.grey.shade400 : Colors.black54),
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.tomato : (isDark ? Colors.white : Colors.black87),
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // ========== Action Buttons - 🔥 Dark Mode Support ==========
  Widget _buildActionButtons(ThemeData theme, bool isDark) {
    return Obx(() {
      final isCancelled = controller.orderStatus.value == 'Cancelled';
      final isDelivered = controller.orderStatus.value == 'Delivered';
      
      if (isCancelled || isDelivered) {
        return const SizedBox.shrink();
      }
      
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.cancelOrder,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Cancel Order",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Support',
                  'Connecting to support...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.tomato,
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tomato,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Need Help?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}