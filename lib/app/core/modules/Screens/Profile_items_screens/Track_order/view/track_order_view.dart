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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Card
                _buildOrderStatusCard(),
                
                SizedBox(height: 24.h),
                
                // Order Details
                _buildOrderDetails(),
                
                SizedBox(height: 24.h),
                
                // Delivery Information
                _buildDeliveryInfo(),
                
                SizedBox(height: 24.h),
                
                // Order Items
                _buildOrderItems(),
                
                SizedBox(height: 30.h),
                
                // Action Buttons
                _buildActionButtons(),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
  }

  // ========== APP BAR ==========
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: controller.goBack,
      ),
      title: Text(
        "Track Order",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.support_agent, color: Colors.black87),
          onPressed: controller.contactSupport,
        ),
      ],
    );
  }

  // ========== Order Status Card ==========
  Widget _buildOrderStatusCard() {
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
            if (!isCancelled) _buildProgressTimeline(),
          ],
        ),
      );
    });
  }

  // ========== Progress Timeline ==========
  Widget _buildProgressTimeline() {
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

  // ========== Order Details ==========
  Widget _buildOrderDetails() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            _buildDetailRow("Order Date", controller.orderDate.value),
            _buildDivider(),
            _buildDetailRow("Payment Method", controller.paymentMethod.value),
            _buildDivider(),
            _buildDetailRow("Payment Status", controller.paymentStatus.value),
            _buildDivider(),
            _buildDetailRow("Delivery Type", controller.deliveryType.value),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade200,
      height: 1.h,
    );
  }

  // ========== Delivery Information ==========
  Widget _buildDeliveryInfo() {
    return Obx(() {
      final address = controller.deliveryAddress.value;
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: Colors.black87,
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
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address['address'] ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        address['city'] ?? '',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "Phone: ${address['phone'] ?? ''}",
                        style: TextStyle(
                          color: Colors.black54,
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

  // ========== Order Items ==========
  Widget _buildOrderItems() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
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
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            ...controller.orderItems.map((item) => _buildOrderItem(item)),
            Divider(height: 20.h),
            _buildTotalRow("Subtotal", "\$${controller.subtotal.value.toStringAsFixed(2)}"),
            SizedBox(height: 4.h),
            _buildTotalRow("Delivery", "\$${controller.deliveryCharge.value.toStringAsFixed(2)}"),
            SizedBox(height: 4.h),
            _buildTotalRow("Tax", "\$${controller.tax.value.toStringAsFixed(2)}"),
            Divider(height: 16.h),
            _buildTotalRow(
              "Total",
              "\$${controller.total.value.toStringAsFixed(2)}",
              isTotal: true,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
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
                    color: Colors.black87,
                  ),
                ),
                Text(
                  item['quantity'],
                  style: TextStyle(
                    color: Colors.black54,
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
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black87 : Colors.black54,
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.tomato : Colors.black87,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // ========== Action Buttons ==========
  Widget _buildActionButtons() {
    return Obx(() {
      final isCancelled = controller.orderStatus.value == 'Cancelled';
      final isDelivered = controller.orderStatus.value == 'Delivered';
      
      if (isCancelled || isDelivered) {
        return SizedBox.shrink();
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