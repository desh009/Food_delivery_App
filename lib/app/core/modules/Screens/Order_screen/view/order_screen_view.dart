import 'package:flutter/material.dart';
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
    OrderDetailsBinding(orderId: orderId);
    
    final controller = Get.find<OrderDetailsController>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth > 600;
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
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildOrderSummaryHeader(controller),
                          const SizedBox(height: 16),
                          ...controller.orderItems.map((item) => 
                            _buildOrderItemCard(controller, item)
                          ),
                          const SizedBox(height: 20),
                          _buildInfoCard(
                            icon: Icons.location_on,
                            iconColor: const Color(0xFFFF6B4A),
                            title: "Deliver to -> ${controller.deliveryType.value}",
                            subtitle: controller.deliveryAddress.value,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                            icon: Icons.account_balance_wallet,
                            iconColor: const Color(0xFFFF6B4A),
                            title: "Payment method",
                            subtitle: controller.paymentMethod.value,
                          ),
                          const SizedBox(height: 12),
                          _buildPromotionsCard(controller),
                          const SizedBox(height: 24),
                          _buildPriceSummary(controller),
                          const SizedBox(height: 24),
                          _buildOverallRatingSection(controller),
                          const SizedBox(height: 100),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            
            // Global Bottom Navigation Bar
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Top App Bar ==========
  Widget _buildTopAppBar(OrderDetailsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back,
            onTap: () => Get.back(),
          ),
          Obx(() => Text(
            controller.orderNumber.value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          )),
          _buildIconButton(
            icon: Icons.more_horiz,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  // ========== Order Summary Header ==========
  Widget _buildOrderSummaryHeader(OrderDetailsController controller) {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            controller.orderStatus.value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
      ],
    ));
  }

  // ========== Order Item Card ==========
  Widget _buildOrderItemCard(OrderDetailsController controller, OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imagePath,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 65,
                      height: 65,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        if (item.originalPrice != null)
                          Text(
                            '£ ${item.originalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          '£ ${item.discountPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isReorderInProgress.value 
                    ? null 
                    : () => controller.reorderItem(item.id),
                icon: controller.isReorderInProgress.value
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.shopping_bag_outlined, size: 12, color: Colors.white),
                label: const Text(
                  "Reorder",
                  style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomato,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )),
            ],
          ),
          if (item.addOns.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...item.addOns.map(
              (addOn) => Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        addOn.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                    Text(
                      '£ ${addOn.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.tomato,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star_rounded,
                size: 20,
                color: index < item.rating ? Colors.amber : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showReviewDialog(controller, item),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18, right: 45),
                    child: Text(
                      item.isReviewed ? item.reviewText : "Type your review ...",
                      style: TextStyle(
                        fontSize: 12,
                        color: item.isReviewed ? Colors.black87 : Colors.grey.shade400,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 16, color: Colors.grey.shade400),
                        const SizedBox(width: 6),
                        Icon(Icons.image_outlined, size: 16, color: Colors.grey.shade400),
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

  // ========== Info Card ==========
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
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

  // ========== Promotions Card ==========
  Widget _buildPromotionsCard(OrderDetailsController controller) {
    return Obx(() => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              Icon(Icons.confirmation_number_outlined, size: 18, color: AppColors.tomato),
              const SizedBox(width: 10),
              const Text(
                "Promotions",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: controller.promotions.map((promo) => 
              _buildBadge(promo, const Color(0xFFFFC107))
            ).toList(),
          ),
        ],
      ),
    ));
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // ========== Price Summary ==========
  Widget _buildPriceSummary(OrderDetailsController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          _buildPriceRow("Subtotal", controller.formatPrice(controller.subtotal.value)),
          const SizedBox(height: 6),
          _buildPriceRow("Delivery Fee", controller.getDeliveryFeeText()),
          const SizedBox(height: 6),
          _buildPriceRow("Discount", controller.getDiscountText()),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Color(0xFFEEEEEE), thickness: 1),
          ),
          _buildPriceRow("Total", controller.formatPrice(controller.total.value), isTotal: true),
        ],
      ),
    ));
  }

  Widget _buildPriceRow(String title, String price, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.black54,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 15 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ========== Overall Rating Section ==========
  Widget _buildOverallRatingSection(OrderDetailsController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                size: 38,
                color: index < controller.overallRating.value.floor() 
                    ? Colors.amber 
                    : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => _showOverallReviewDialog(controller),
            child: Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Text(
                    controller.overallReview.value.isEmpty 
                        ? "Type your review ..." 
                        : controller.overallReview.value,
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.overallReview.value.isEmpty 
                          ? Colors.grey.shade400 
                          : Colors.black87,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 18, color: Colors.grey.shade400),
                        const SizedBox(width: 8),
                        Icon(Icons.image_outlined, size: 18, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // ========== Dialog Methods ==========
  
  void _showReviewDialog(OrderDetailsController controller, OrderItem item) {
    final TextEditingController reviewController = TextEditingController();
    reviewController.text = item.reviewText;
    int selectedRating = item.rating;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Write a Review",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Rate ${item.title}",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
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
                          size: 40,
                          color: index < selectedRating ? Colors.amber : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
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
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOverallReviewDialog(OrderDetailsController controller) {
    final TextEditingController reviewController = TextEditingController();
    reviewController.text = controller.overallReview.value;
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Overall Review",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Write your overall review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.submitOverallReview(reviewController.text);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                    ),
                    child: const Text("Submit"),
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