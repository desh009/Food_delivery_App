// lib/app/core/modules/Screens/track_order_screen/view/track_order_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Track_order/controller/track_order_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';

class TrackOrderScreen extends GetView<TrackOrderController> {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Card
                _buildOrderStatusCard(),
                
                const SizedBox(height: 24),
                
                // Order Details
                _buildOrderDetails(),
                
                const SizedBox(height: 24),
                
                // Delivery Information
                _buildDeliveryInfo(),
                
                const SizedBox(height: 24),
                
                // Order Items
                _buildOrderItems(),
                
                const SizedBox(height: 30),
                
                // Action Buttons
                _buildActionButtons(),
                
                const SizedBox(height: 20),
              ],
            ),
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
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: controller.goBack,
      ),
      title: const Text(
        "Track Order",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.support_agent, color: Colors.black87),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCancelled 
                ? [Colors.grey, Colors.grey.shade700]
                : [AppColors.tomato, AppColors.tomato.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (isCancelled ? Colors.grey : AppColors.tomato).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
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
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCancelled ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.orderStatus.value,
                    style: TextStyle(
                      color: isCancelled ? Colors.white : AppColors.tomato,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Expected Delivery",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              controller.expectedDelivery.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.access_time,
                      color: isCompleted ? AppColors.tomato : Colors.white70,
                      size: 16,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted 
                          ? Colors.white 
                          : Colors.white.withOpacity(0.3),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Timeline content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['label'] as String,
                      style: TextStyle(
                        color: isCompleted ? Colors.white : Colors.white70,
                        fontSize: 16,
                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Text(
                      step['time'] as String,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    if (!isLast) const SizedBox(height: 8),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Details",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
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
      height: 1,
    );
  }

  // ========== Delivery Information ==========
  Widget _buildDeliveryInfo() {
    return Obx(() {
      final address = controller.deliveryAddress.value;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: AppColors.tomato,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address['address'] ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        address['city'] ?? '',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Phone: ${address['phone'] ?? ''}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Items",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...controller.orderItems.map((item) => _buildOrderItem(item)),
            const Divider(height: 20),
            _buildTotalRow("Subtotal", "\$${controller.subtotal.value.toStringAsFixed(2)}"),
            const SizedBox(height: 4),
            _buildTotalRow("Delivery", "\$${controller.deliveryCharge.value.toStringAsFixed(2)}"),
            const SizedBox(height: 4),
            _buildTotalRow("Tax", "\$${controller.tax.value.toStringAsFixed(2)}"),
            const Divider(height: 16),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(item['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  item['quantity'],
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item['price'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
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
        return const SizedBox.shrink();
      }
      
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.cancelOrder,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Cancel Order",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Need Help?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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