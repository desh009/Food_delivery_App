// lib/app/core/modules/Screens/track_order_screen/controller/track_order_controller.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class TrackOrderController extends GetxController {
  final orderStatus = 'In Progress'.obs;
  final expectedDelivery = 'Today, 7:30 PM'.obs;
  final orderNumber = 'ORD-2024-001'.obs;

  final orderDate = 'Dec 25, 2024'.obs;
  final paymentMethod = 'Credit Card'.obs;
  final paymentStatus = 'Paid'.obs;
  final deliveryType = 'Home Delivery'.obs;
  final cancellationReason = ''.obs;
  final cancellationNote = ''.obs;

  // Delivery address
  final deliveryAddress = {
    'name': 'John Doe',
    'address': '123 Main Street, Apartment 4B',
    'city': 'New York, NY 10001',
    'phone': '+1 234 567 8900',
  }.obs;

  // Order items
  final RxList<Map<String, dynamic>> orderItems = <Map<String, dynamic>>[
    {
      'name': 'Cheese Burger',
      'quantity': '2x',
      'price': '\$25.98',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
    },
    {
      'name': 'Pepperoni Pizza',
      'quantity': '1x',
      'price': '\$15.99',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
    },
    {
      'name': 'Coca Cola',
      'quantity': '3x',
      'price': '\$6.00',
      'image':
          'https://images.unsplash.com/photo-1543854932-4d2e5d5fe46b?q=80&w=500',
    },
  ].obs;

  // ============ TIMELINE STEPS ============
  final RxList<Map<String, dynamic>> timelineSteps = <Map<String, dynamic>>[
    {'label': 'Order Placed', 'time': '5:30 PM', 'completed': true},
    {'label': 'Preparing', 'time': '6:00 PM', 'completed': true},
    {'label': 'On The Way', 'time': '7:00 PM', 'completed': false},
    {'label': 'Delivered', 'time': '7:30 PM', 'completed': false},
  ].obs;

  // ============ PRICE CALCULATION ============
  final subtotal = 47.97.obs;
  final deliveryCharge = 2.00.obs;
  final tax = 3.50.obs;
  final total = 53.47.obs;

  @override
  void onInit() {
    super.onInit();
    // Load order data from arguments if passed
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      _loadOrderData(args);
    }
  }

  // ============ LOAD ORDER DATA ============
  void _loadOrderData(Map<String, dynamic> args) {
    if (args['orderNumber'] != null) {
      orderNumber.value = args['orderNumber'];
    }
    if (args['orderStatus'] != null) {
      orderStatus.value = args['orderStatus'];
    }
    if (args['expectedDelivery'] != null) {
      expectedDelivery.value = args['expectedDelivery'];
    }
    // Load more data as needed
  }

  // ============ UPDATE ORDER STATUS ============
  void updateOrderStatus(String status) {
    orderStatus.value = status;
    // Update timeline based on status
    _updateTimeline(status);
  }

  void _updateTimeline(String status) {
    switch (status) {
      case 'Order Placed':
        timelineSteps[0]['completed'] = true;
        timelineSteps[1]['completed'] = false;
        timelineSteps[2]['completed'] = false;
        timelineSteps[3]['completed'] = false;
        break;
      case 'Preparing':
        timelineSteps[0]['completed'] = true;
        timelineSteps[1]['completed'] = true;
        timelineSteps[2]['completed'] = false;
        timelineSteps[3]['completed'] = false;
        break;
      case 'On The Way':
        timelineSteps[0]['completed'] = true;
        timelineSteps[1]['completed'] = true;
        timelineSteps[2]['completed'] = true;
        timelineSteps[3]['completed'] = false;
        break;
      case 'Delivered':
        timelineSteps[0]['completed'] = true;
        timelineSteps[1]['completed'] = true;
        timelineSteps[2]['completed'] = true;
        timelineSteps[3]['completed'] = true;
        break;
      default:
        break;
    }
    timelineSteps.refresh();
  }

  // ============ CALCULATE TOTALS ============
  void calculateTotals() {
    double sum = 0.0;
    for (var item in orderItems) {
      final priceString = item['price'].toString().replaceAll('\$', '');
      final price = double.tryParse(priceString) ?? 0.0;
      sum += price;
    }
    subtotal.value = sum;
    total.value = sum + deliveryCharge.value + tax.value;
  }

  // ============ GO BACK ============
  void goBack() {
    Get.back();
  }

  // ============ CANCEL ORDER ============
  void cancelOrderWithReason({required String reason, required String note}) {
    try {
      // Update order status
      orderStatus.value = 'Cancelled';

      // Save cancellation reason
      cancellationReason.value = reason;
      cancellationNote.value = note;

      // Update timeline
      final cancelStep = {
        'label': 'Order Cancelled',
        'time': DateTime.now().toString(),
        'completed': true,
      };
      timelineSteps.add(cancelStep);

      // Show success message
      // Get.snackbar(
      //   'Order Cancelled',
      //   'Your order has been cancelled successfully.\nReason: $reason',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      // );

      // Save to history
      _saveCancelledOrder(reason, note);
    } catch (e) {
      // Get.snackbar(
      //   'Error',
      //   'Failed to cancel order. Please try again.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  }

  void _saveCancelledOrder(String reason, String note) {
    // Save cancelled order details to local storage or database
    // You can implement SharedPreferences or GetStorage here
  }
}
