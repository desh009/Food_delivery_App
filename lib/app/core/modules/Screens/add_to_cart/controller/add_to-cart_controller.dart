// lib/app/core/modules/Screens/add_to_cart/controller/add_to-cart_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ========== Cart Item Model ==========
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
    int quantity = 1,
    List<Map<String, dynamic>>? addOns,
  })  : quantity = quantity.obs,
        addOns = addOns ?? [];

  CartItem copyWith({int? quantity, List<Map<String, dynamic>>? addOns}) {
    return CartItem(
      name: name,
      imageUrl: imageUrl,
      price: price,
      oldPrice: oldPrice,
      quantity: quantity ?? this.quantity.value,
      addOns: addOns ?? this.addOns,
    );
  }
}

// ========== Cart Controller ==========
class CartController extends GetxController {
  static CartController get instance {
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
    return Get.find<CartController>();
  }

  var cartItems = <CartItem>[].obs;
  var selectedPaymentMethod = ''.obs;
  var appliedVoucher = ''.obs;
  var appliedVoucherDiscount = 0.0.obs;
  var appliedVoucherTitle = ''.obs;
  
  final double deliveryFee = 2.99;

  void applyVoucher({
    required String code,
    required double discountAmount,
    required String voucherTitle,
  }) {
    appliedVoucher.value = code;
    appliedVoucherDiscount.value = discountAmount;
    appliedVoucherTitle.value = voucherTitle;
    
    print('✅ Voucher Applied: $code');
    print('💰 Discount: £$discountAmount');
    print('📝 Title: $voucherTitle');
  }

  void clearVoucher() {
    appliedVoucher.value = '';
    appliedVoucherDiscount.value = 0.0;
    appliedVoucherTitle.value = '';
    print('🗑️ Voucher Cleared');
  }

  void addToCart({
    required String name,
    required String imageUrl,
    required double price,
    double? oldPrice,
    int quantity = 1,
    List<Map<String, dynamic>> addOns = const [],
  }) {
    print('🛒 Adding to Cart: $name');
    print('📦 Quantity: $quantity');
    print('💰 Price: £$price');
    print('📋 Add-ons: $addOns');

    final existingIndex = cartItems.indexWhere((item) {
      if (item.name != name) return false;
      return _compareAddOns(item.addOns, addOns);
    });

    if (existingIndex != -1) {
      final existingItem = cartItems[existingIndex];
      existingItem.quantity.value += quantity;
      cartItems.refresh();
      print('✅ Updated existing item: ${existingItem.name} x${existingItem.quantity.value}');
    } else {
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
      print('✅ Added new item: $name');
    }

    print('🛒 Total Items in Cart: ${cartItems.length}');
    print('💰 Subtotal: £${subtotal.toStringAsFixed(2)}');
    
    cartItems.refresh();

    Get.snackbar(
      'Added to Cart 🛒',
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

  void removeItem(CartItem item) {
    cartItems.remove(item);
    cartItems.refresh();
    Get.snackbar(
      'Removed',
      '${item.name} removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void incrementQuantity(int index) {
    if (index < cartItems.length) {
      cartItems[index].quantity.value++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(int index) {
    if (index < cartItems.length) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
        cartItems.refresh();
      } else {
        removeItem(cartItems[index]);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedPaymentMethod.value = '';
    cartItems.refresh();
    Get.snackbar(
      'Cart Cleared',
      'All items removed from cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  double get subtotal {
    double total = 0.0;
    for (var item in cartItems) {
      double addOnsPrice = item.addOns.fold(
        0.0,
        (sum, addOn) => sum + (addOn['price'] as double),
      );
      total += (item.price + addOnsPrice) * item.quantity.value;
    }
    return total;
  }

  double get total {
    double totalAmount = subtotal + (cartItems.isNotEmpty ? deliveryFee : 0);
    totalAmount -= appliedVoucherDiscount.value;
    if (totalAmount < 0) totalAmount = 0;
    return totalAmount;
  }

  int get totalItems {
    int count = 0;
    for (var item in cartItems) {
      count += item.quantity.value;
    }
    return count;
  }

  bool get isEmpty => cartItems.isEmpty;
  int get itemCount => cartItems.length;

  void checkout() {
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

    Get.snackbar(
      'Order Placed! 🎉',
      'Your order has been placed successfully!\nPayment: ${selectedPaymentMethod.value}\nTotal: £${total.toStringAsFixed(2)}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    clearCart();
  }

  String get paymentMethodDisplay {
    if (selectedPaymentMethod.value.isEmpty) {
      return 'Select Payment Method';
    }
    return selectedPaymentMethod.value;
  }

  @override
  void onClose() {
    cartItems.close();
    super.onClose();
  }
}