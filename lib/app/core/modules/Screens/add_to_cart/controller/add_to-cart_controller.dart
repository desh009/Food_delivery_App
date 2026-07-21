import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  final double? oldPrice;
  RxInt quantity;
  final List<Map<String, dynamic>> addOns;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    required int quantity,
    required this.addOns,
  }) : quantity = quantity.obs;
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var selectedPaymentMethod = ''.obs;
  
  // ========== Delivery Fee ==========
  final double deliveryFee = 2.99;

  // ========== Singleton Pattern ==========
  static CartController get instance {
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }
    return Get.find<CartController>();
  }

  // ========== Add to Cart ==========
  void addToCart({
    required String name,
    required String imageUrl,
    required double price,
    double? oldPrice,
    required int quantity,
    required List<Map<String, dynamic>> addOns,
  }) {
    // Check if item already exists with same add-ons
    final existingIndex = cartItems.indexWhere(
      (item) => item.name == name && _compareAddOns(item.addOns, addOns),
    );

    if (existingIndex != -1) {
      // Update quantity
      cartItems[existingIndex].quantity.value += quantity;
    } else {
      // Add new item
      cartItems.add(
        CartItem(
          name: name,
          imageUrl: imageUrl,
          price: price,
          oldPrice: oldPrice,
          quantity: quantity,
          addOns: addOns,
        ),
      );
    }
    
    // Show success message
    Get.snackbar(
      'Added to Cart',
      '$name added successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  bool _compareAddOns(
    List<Map<String, dynamic>> addOns1,
    List<Map<String, dynamic>> addOns2,
  ) {
    if (addOns1.length != addOns2.length) return false;
    for (var i = 0; i < addOns1.length; i++) {
      if (addOns1[i]['name'] != addOns2[i]['name']) return false;
    }
    return true;
  }

  // ========== Remove Item ==========
  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  // ========== Update Quantity ==========
  void incrementQuantity(int index) {
    cartItems[index].quantity.value++;
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity.value > 1) {
      cartItems[index].quantity.value--;
    }
  }

  // ========== Clear Cart ==========
  void clearCart() {
    cartItems.clear();
    selectedPaymentMethod.value = '';
  }

  // ========== Calculate Subtotal ==========
  double get subtotal {
    return cartItems.fold(0.0, (sum, item) {
      double addOnsPrice = item.addOns.fold(
        0.0,
        (s, addOn) => s + (addOn['price'] as double),
      );
      return sum + ((item.price + addOnsPrice) * item.quantity.value);
    });
  }

  // ========== Calculate Total (with delivery fee) ==========
  double get total {
    return subtotal + (cartItems.isNotEmpty ? deliveryFee : 0);
  }

  // ========== Get Total Items Count ==========
  int get totalItems {
    int count = 0;
    for (var item in cartItems) {
      count += item.quantity.value;
    }
    return count;
  }

  // ========== Check if Cart is Empty ==========
  bool get isEmpty => cartItems.isEmpty;

  // ========== Checkout ==========
  void checkout() {
    // 1. Check if cart is empty
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Your cart is empty!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Check if payment method is selected
    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        'Payment Required',
        'Please select a payment method',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 3. Place Order
    Get.snackbar(
      'Order Placed!',
      'Your order has been placed successfully!\nPayment: ${selectedPaymentMethod.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
    
    // Clear cart after successful order
    clearCart();
  }

  // ========== Get Payment Method Display Name ==========
  String get paymentMethodDisplay {
    if (selectedPaymentMethod.value.isEmpty) {
      return 'Select Payment Method';
    }
    return selectedPaymentMethod.value;
  }
}