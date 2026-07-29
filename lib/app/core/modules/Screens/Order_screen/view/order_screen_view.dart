// lib/app/core/modules/Screens/Order_screen/view/order_screen_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/binder/order_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/controller/order-screen_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String? orderId;

  const OrderDetailsScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    // ✅ Controller Initialize
    if (!Get.isRegistered<OrderDetailsController>()) {
      Get.put(OrderDetailsController());
    }

    final controller = Get.find<OrderDetailsController>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth > 600;

    // ✅ Set Bottom Nav Index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(1);
      } catch (e) {
        // Ignore
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                _buildTopAppBar(controller),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                          strokeWidth: 3.r,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24.w : 16.w,
                        vertical: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderSummaryHeader(controller),
                          SizedBox(height: 16.h),
                          ...controller.orderItems.map(
                            (item) => _buildOrderItemCard(controller, item),
                          ),
                          SizedBox(height: 20.h),
                          _buildInfoCard(
                            icon: Icons.location_on,
                            iconColor: const Color(0xFFFF6B4A),
                            title: "Deliver to",
                            subtitle: controller.deliveryAddress.value,
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoCard(
                            icon: Icons.account_balance_wallet,
                            iconColor: const Color(0xFFFF6B4A),
                            title: "Payment method",
                            subtitle: controller.paymentMethod.value,
                          ),
                          SizedBox(height: 12.h),
                          _buildPromotionsCard(controller),
                          SizedBox(height: 24.h),
                          _buildPriceSummary(controller),
                          SizedBox(height: 24.h),
                          _buildOverallRatingSection(controller),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),

            // Global Bottom Navigation Bar
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP APP BAR - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildTopAppBar(OrderDetailsController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              BottomNavController.to.goBack();
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back, size: 18.sp, color: Colors.black87),
            ),
          ),
          SizedBox(width: 8.w),
          // ✅ শুধু Obx যেখানে Observable ব্যবহার হচ্ছে
          Expanded(
            child: Obx(
              () => Text(
                controller.orderNumber.value,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          _buildIconButton(icon: Icons.more_horiz, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18.sp, color: Colors.black87),
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY HEADER - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildOrderSummaryHeader(OrderDetailsController controller) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getStatusColor(controller.orderStatus.value).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              controller.orderStatus.value,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(controller.orderStatus.value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // ============================================================
  // ORDER ITEM CARD - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildOrderItemCard(
    OrderDetailsController controller,
    OrderItem item,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  item.imagePath,
                  width: 65.w,
                  height: 65.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 65.w,
                      height: 65.h,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 30.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6.w,
                      children: [
                        if (item.originalPrice != null)
                          Text(
                            '£ ${item.originalPrice!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '£ ${item.discountPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                    if (item.quantity > 1)
                      Text(
                        'Qty: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // ✅ Obx সঠিকভাবে ব্যবহার করা হয়েছে
              Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isReorderInProgress.value
                      ? null
                      : () => controller.reorderItem(item.id),
                  icon: controller.isReorderInProgress.value
                      ? SizedBox(
                          width: 12.w,
                          height: 12.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.shopping_bag_outlined,
                          size: 12.sp,
                          color: Colors.white,
                        ),
                  label: Text(
                    "Reorder",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tomato,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 0.h,
                    ),
                    minimumSize: Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (item.addOns.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ...item.addOns.map(
              (addOn) => Padding(
                padding: EdgeInsets.only(top: 2.0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        addOn.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Text(
                      '£ ${addOn.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tomato,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                size: 20.sp,
                color: index < item.rating
                    ? Colors.amber
                    : Colors.grey.shade300,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () => _showReviewDialog(controller, item),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18.h, right: 45.w),
                    child: Text(
                      item.isReviewed
                          ? item.reviewText
                          : "Type your review ...",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: item.isReviewed
                            ? Colors.black87
                            : Colors.grey.shade400,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.h,
                    right: 0.w,
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 16.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.image_outlined,
                          size: 16.sp,
                          color: Colors.grey.shade400,
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
    );
  }

  // ============================================================
  // INFO CARD - ✅ Obx সরানো হয়েছে (কারণ Observable নেই)
  // ============================================================
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROMOTIONS CARD - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildPromotionsCard(OrderDetailsController controller) {
    return Obx(
      () => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  size: 18.sp,
                  color: AppColors.tomato,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Promotions",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 4,
              children: controller.promotions
                  .map((promo) => _buildBadge(promo, const Color(0xFFFFC107)))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // ============================================================
  // PRICE SUMMARY - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildPriceSummary(OrderDetailsController controller) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildPriceRow(
              "Subtotal",
              controller.formatPrice(controller.subtotal.value),
            ),
            SizedBox(height: 6.h),
            _buildPriceRow("Delivery Fee", controller.getDeliveryFeeText()),
            SizedBox(height: 6.h),
            _buildPriceRow("Discount", controller.getDiscountText()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Divider(color: const Color(0xFFEEEEEE), thickness: 1.r),
            ),
            _buildPriceRow(
              "Total",
              controller.formatPrice(controller.total.value),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.black54,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 15.sp : 12.sp,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.tomato : Colors.black87,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OVERALL RATING SECTION - ✅ Obx ঠিক করা হয়েছে
  // ============================================================
  Widget _buildOverallRatingSection(OrderDetailsController controller) {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star_rounded,
                  size: 38.sp,
                  color: index < controller.overallRating.value.floor()
                      ? Colors.amber
                      : Colors.grey.shade300,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            GestureDetector(
              onTap: () => _showOverallReviewDialog(controller),
              child: Container(
                width: double.infinity,
                height: 90.h,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    Text(
                      controller.overallReview.value.isEmpty
                          ? "Type your review ..."
                          : controller.overallReview.value,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: controller.overallReview.value.isEmpty
                            ? Colors.grey.shade400
                            : Colors.black87,
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      right: 0.w,
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 18.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.image_outlined,
                            size: 18.sp,
                            color: Colors.grey.shade400,
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

  // ============================================================
  // REVIEW DIALOG
  // ============================================================
  void _showReviewDialog(OrderDetailsController controller, OrderItem item) {
    final TextEditingController reviewController = TextEditingController();
    reviewController.text = item.reviewText;
    int selectedRating = item.rating;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Write a Review",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Text("Rate ${item.title}", style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star_rounded,
                          size: 40.sp,
                          color: index < selectedRating
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.all(12.r),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRating > 0) {
                        controller.submitReview(
                          item.id,
                          selectedRating,
                          reviewController.text,
                        );
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OVERALL REVIEW DIALOG
  // ============================================================
  void _showOverallReviewDialog(OrderDetailsController controller) {
    final TextEditingController reviewController = TextEditingController();
    reviewController.text = controller.overallReview.value;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          constraints: BoxConstraints(maxWidth: 400.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overall Review",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your overall review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.all(12.r),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      controller.submitOverallReview(reviewController.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}