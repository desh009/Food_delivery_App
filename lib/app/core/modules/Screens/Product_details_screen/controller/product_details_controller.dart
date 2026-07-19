import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  late ProductModel product;

  var quantity = 1.obs;
  var isFavorite = false.obs;

  var addCheese = false.obs;
  var addBacon = false.obs;
  var addMeat = false.obs;

  @override
  void onInit() {
    super.onInit();

    print('🔍 ====== PRODUCT DETAILS CONTROLLER ======');
    print('📦 Get.arguments: ${Get.arguments}');
    print('📦 Argument Type: ${Get.arguments.runtimeType}');
    final args = Get.arguments;

    if (args is ProductModel) {
      product = args;
      print('✅ Product Loaded: ${product.name}');
      print('📦 Category: ${product.category}');
      print('💰 Price: ${product.price}');
    } else if (args is Map<String, dynamic>) {
      product = ProductModel(
        id: args['id']?.toString() ?? '1',
        name: args['name']?.toString() ?? 'Product',
        category: args['category']?.toString() ?? 'Food',
        imageUrl:
            args['imageUrl']?.toString() ?? args['image']?.toString() ?? '',
        rating: _safeDouble(args, 'rating', 4.8), // ← Safe Double parsing
        price: _safeDouble(args, 'price', 0.0), // ← Safe Double parsing
        oldPrice: _safeDouble(args, 'oldPrice', null),
      );
      print('⚠️ Using default product data');
      print('Product Name : ${product.name}');
    } else {
      product = ProductModel(
        id: '1',
        name: "Default",
        category: "Food",
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
        rating: 4.8,
        price: 6.00,
        oldPrice: 10.00,
      );
    }
    print('Using Default Product Data !');
  }
 double _safeDouble(Map<String, dynamic> map, String key, double? defaultValue) {
    final value = map[key];
    if (value == null) {
      return defaultValue ?? 0.0;
    }
    
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('⚠️ Failed to parse "$key": "$value" as double');
        return defaultValue ?? 0.0;
      }
    }
    
    if (value is num) {
      return value.toDouble();
    }
    
    return defaultValue ?? 0.0;
  }
  void increment() => quantity.value++;

  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void addToCart() {
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  double get totalPrice {
    double basePrice = product.price;
    double extraCost = 0;

    if (addCheese.value) extraCost += 1.50;
    if (addBacon.value) extraCost += 2.00;
    if (addMeat.value) extraCost += 3.00;

    return (basePrice + extraCost) * quantity.value;
  }
}
