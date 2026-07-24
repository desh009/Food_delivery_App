import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:get/get.dart';

class OrderDetailsController extends GetxController {
  // ========== Observable Variables ==========
  
  // Order items data
  final RxList<OrderItem> orderItems = <OrderItem>[].obs;
  
  // Order metadata
  final RxString orderNumber = 'SP 0023502'.obs;
  final RxString orderStatus = 'Completed'.obs;
  final RxString deliveryAddress = '221B Baker Street, London, United Kingdom'.obs;
  final RxString paymentMethod = 'Cash'.obs;
  final RxString deliveryType = 'Home'.obs;
  
  // Pricing
  final RxDouble subtotal = 31.50.obs;
  final RxDouble deliveryFee = 0.0.obs;
  final RxDouble discount = 6.30.obs;
  final RxDouble total = 25.20.obs;
  
  // Promotions
  final RxList<String> promotions = <String>['FREE SHIPPING', '20%'].obs;
  
  // Rating
  final RxDouble overallRating = 4.0.obs;
  final RxString overallReview = ''.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isReorderInProgress = false.obs;
  
  final String? orderId;
  bool _isDataLoaded = false;
  
  OrderDetailsController({this.orderId});
  
  @override
  void onInit() {
    super.onInit();
    
    // Update bottom nav index when order screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BottomNavController.to.changeIndex(1);
    });
    
    // Load data after UI is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  // ========== Data Loading Methods ==========
  
  void _loadData() {
    if (_isDataLoaded) return;
    
    isLoading.value = true;
    
    Future.microtask(() async {
      try {
        if (orderId != null && orderId!.isNotEmpty) {
          await _fetchOrderData(orderId!);
        } else {
          await _loadSampleData();
        }
        
        calculateTotals();
        _isDataLoaded = true;
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to load order data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      } finally {
        isLoading.value = false;
      }
    });
  }
  
  Future<void> _fetchOrderData(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _loadSampleData();
  }
  
  Future<void> _loadSampleData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    orderItems.assignAll([
      OrderItem(
        id: 'item_1',
        title: 'Chicken Burger',
        imagePath: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=300',
        originalPrice: 10.00,
        discountPrice: 6.00,
        addOns: [
          AddOn(title: 'Add Cheese', price: 0.50),
          AddOn(title: 'Add Meat (Extra Patty)', price: 2.00),
        ],
        rating: 4,
        reviewText: 'Chicken burger is delicious!\nI will save it for next order.',
        isReviewed: true,
        quantity: 1,
      ),
      OrderItem(
        id: 'item_2',
        title: 'Ramen Noodles',
        imagePath: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=300',
        originalPrice: 22.00,
        discountPrice: 15.00,
        addOns: [],
        rating: 5,
        reviewText: '',
        isReviewed: false,
        quantity: 1,
      ),
      OrderItem(
        id: 'item_3',
        title: 'Cherry Tomato Salad',
        imagePath: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=300',
        originalPrice: null,
        discountPrice: 8.00,
        addOns: [],
        rating: 0,
        reviewText: '',
        isReviewed: false,
        quantity: 1,
      ),
    ]);
  }
  
  // ========== Calculation Methods ==========
  
  void calculateTotals() {
    double calculatedSubtotal = 0.0;
    for (var item in orderItems) {
      calculatedSubtotal += (item.discountPrice * item.quantity);
      for (var addOn in item.addOns) {
        calculatedSubtotal += addOn.price * item.quantity;
      }
    }
    
    subtotal.value = calculatedSubtotal;
    discount.value = subtotal.value * 0.20;
    total.value = subtotal.value - discount.value + deliveryFee.value;
    
    subtotal.refresh();
    discount.refresh();
    total.refresh();
  }
  
  // ========== Reorder Methods ==========
  
  Future<void> reorderItem(String itemId) async {
    isReorderInProgress.value = true;
    try {
      final item = orderItems.firstWhere((element) => element.id == itemId);
      await Future.delayed(const Duration(milliseconds: 500));
      
      Get.snackbar(
        'Success',
        '${item.title} added to cart!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reorder item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isReorderInProgress.value = false;
    }
  }
  
  Future<void> reorderAllItems() async {
    isReorderInProgress.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      Get.snackbar(
        'Success',
        'All items added to cart!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reorder items',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isReorderInProgress.value = false;
    }
  }
  
  // ========== Review Methods ==========
  
  Future<void> submitReview(String itemId, int rating, String reviewText) async {
    try {
      final index = orderItems.indexWhere((element) => element.id == itemId);
      if (index != -1) {
        orderItems[index].rating = rating;
        orderItems[index].reviewText = reviewText;
        orderItems[index].isReviewed = true;
        orderItems.refresh();
      }
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      Get.snackbar(
        'Success',
        'Review submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
  
  Future<void> submitOverallReview(String reviewText) async {
    try {
      overallReview.value = reviewText;
      await Future.delayed(const Duration(milliseconds: 300));
      
      Get.snackbar(
        'Success',
        'Overall review submitted!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit review',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }
  
  // ========== Utility Methods ==========
  
  String formatPrice(double price) {
    return '£ ${price.toStringAsFixed(2)}';
  }
  
  String getDeliveryFeeText() {
    return deliveryFee.value == 0 ? 'FREE' : formatPrice(deliveryFee.value);
  }
  
  String getDiscountText() {
    return '- ${formatPrice(discount.value)}';
  }
}

// ========== Data Models ==========

class AddOn {
  final String title;
  final double price;
  
  AddOn({
    required this.title,
    required this.price,
  });
  
  Map<String, String> toMap() {
    return {
      'title': title,
      'price': '£ ${price.toStringAsFixed(2)}',
    };
  }
}

class OrderItem {
  final String id;
  final String title;
  final String imagePath;
  final double? originalPrice;
  final double discountPrice;
  final List<AddOn> addOns;
  int rating;
  String reviewText;
  bool isReviewed;
  int quantity;
  
  OrderItem({
    required this.id,
    required this.title,
    required this.imagePath,
    this.originalPrice,
    required this.discountPrice,
    this.addOns = const [],
    this.rating = 0,
    this.reviewText = '',
    this.isReviewed = false,
    this.quantity = 1,
  });
  
  OrderItem copyWith({
    String? id,
    String? title,
    String? imagePath,
    double? originalPrice,
    double? discountPrice,
    List<AddOn>? addOns,
    int? rating,
    String? reviewText,
    bool? isReviewed,
    int? quantity,
  }) {
    return OrderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      addOns: addOns ?? this.addOns,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      isReviewed: isReviewed ?? this.isReviewed,
      quantity: quantity ?? this.quantity,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'originalPrice': originalPrice,
      'discountPrice': discountPrice,
      'addOns': addOns.map((e) => e.toMap()).toList(),
      'rating': rating,
      'reviewText': reviewText,
      'isReviewed': isReviewed,
      'quantity': quantity,
    };
  }
}