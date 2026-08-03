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
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderStatusCard(theme, isDark),
              SizedBox(height: 24.h),
              _buildOrderDetails(theme, isDark),
              SizedBox(height: 24.h),
              _buildDeliveryInfo(theme, isDark),
              SizedBox(height: 24.h),
              _buildOrderItems(theme, isDark),
              SizedBox(height: 30.h),
              _buildActionButtons(context, theme, isDark),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================
  PreferredSizeWidget _buildAppBar(ThemeData theme, bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? Colors.white : Colors.black87,
        ),
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
    );
  }

  // ============================================================
  // ORDER STATUS CARD
  // ============================================================
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
              color: (isCancelled ? Colors.grey : AppColors.tomato).withOpacity(
                0.3,
              ),
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
                Expanded(
                  child: Text(
                    "Order #${controller.orderNumber.value}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "Expected Delivery",
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
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

  // ============================================================
  // PROGRESS TIMELINE
  // ============================================================
  Widget _buildProgressTimeline(bool isDark) {
    return Obx(() {
      return Column(
        children: controller.timelineSteps.map((step) {
          final index = controller.timelineSteps.indexOf(step);
          final isCompleted = step['completed'] as bool;
          final isLast = index == controller.timelineSteps.length - 1;

          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['label'] as String,
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.white70,
                        fontSize: 16.sp,
                        fontWeight: isCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      step['time'] as String,
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  // ============================================================
  // ORDER DETAILS
  // ============================================================
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
            _buildDetailRow(
              "Payment Method",
              controller.paymentMethod.value,
              isDark,
            ),
            _buildDivider(isDark),
            _buildDetailRow(
              "Payment Status",
              controller.paymentStatus.value,
              isDark,
            ),
            _buildDivider(isDark),
            _buildDetailRow(
              "Delivery Type",
              controller.deliveryType.value,
              isDark,
            ),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

  // ============================================================
  // DELIVERY INFORMATION
  // ============================================================
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address['address'] ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        address['city'] ?? '',
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Phone: ${address['phone'] ?? ''}",
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

  // ============================================================
  // ORDER ITEMS
  // ============================================================
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
            ...controller.orderItems.map(
              (item) => _buildOrderItem(item, isDark),
            ),
            Divider(
              height: 20.h,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            _buildTotalRow(
              "Subtotal",
              "\$${controller.subtotal.value.toStringAsFixed(2)}",
              isDark,
            ),
            SizedBox(height: 4.h),
            _buildTotalRow(
              "Delivery",
              "\$${controller.deliveryCharge.value.toStringAsFixed(2)}",
              isDark,
            ),
            SizedBox(height: 4.h),
            _buildTotalRow(
              "Tax",
              "\$${controller.tax.value.toStringAsFixed(2)}",
              isDark,
            ),
            Divider(
              height: 16.h,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['quantity'],
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.black54,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Flexible(
            child: Text(
              item['price'],
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value,
    bool isDark, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal
                ? (isDark ? Colors.white : Colors.black87)
                : (isDark ? Colors.grey.shade400 : Colors.black54),
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: isTotal
                  ? AppColors.tomato
                  : (isDark ? Colors.white : Colors.black87),
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================
  Widget _buildActionButtons(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
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
              onPressed: () => _showCancelBottomSheet(context, theme, isDark),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      );
    });
  }

  // ============================================================
  // CANCEL ORDER BOTTOM SHEET
  // ============================================================
  void _showCancelBottomSheet(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    final List<String> cancelReasons = [
      'Changed my mind',
      'Order taking too long',
      'Wrong items selected',
      'Delivery address is wrong',
      'Better deal elsewhere',
      'Payment issue',
      'Other',
    ];

    String? selectedReason;
    String? additionalNote;
    bool isConfirmChecked = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade700 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  // Title
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                              size: 28.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Cancel Order',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Please tell us why you want to cancel this order. This helps us improve our service.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ========== REASON SELECTION ==========
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Why are you cancelling?',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        ...cancelReasons.map((reason) {
                          final isSelected = selectedReason == reason;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReason = reason;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 6.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                          ? AppColors.tomato.withOpacity(0.2)
                                          : AppColors.tomato.withOpacity(0.1))
                                    : (isDark
                                          ? const Color(0xFF2A2A2A)
                                          : const Color(0xFFF5F5F5)),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.tomato
                                      : (isDark
                                            ? Colors.grey.shade800
                                            : Colors.grey.shade200),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.tomato
                                            : (isDark
                                                  ? Colors.grey.shade600
                                                  : Colors.grey.shade400),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Container(
                                            margin: EdgeInsets.all(3.r),
                                            decoration: BoxDecoration(
                                              color: AppColors.tomato,
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ========== ADDITIONAL NOTE ==========
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Note (Optional)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isDark
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              additionalNote = value;
                            },
                            maxLines: 3,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Tell us more (optional)...',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                                fontSize: 13.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ========== CONFIRM CHECKBOX ==========
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isConfirmChecked,
                          onChanged: (value) {
                            setState(() {
                              isConfirmChecked = value ?? false;
                            });
                          },
                          activeColor: AppColors.tomato,
                          checkColor: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            'I understand that this action cannot be undone and may affect my order history.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // ========== CANCEL BUTTON ==========
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              side: BorderSide(
                                color: isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Go Back',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                (selectedReason == null || !isConfirmChecked)
                                ? null
                                : () {
                                    Get.back();
                                    controller.cancelOrderWithReason(
                                      reason: selectedReason!,
                                      note: additionalNote ?? '',
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              disabledBackgroundColor: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                            child: Text(
                              'Confirm Cancel',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
