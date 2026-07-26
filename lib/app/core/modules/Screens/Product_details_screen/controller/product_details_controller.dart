// lib/app/core/modules/Screens/Product_details_screen/controller/product_details_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double price;
  final double? oldPrice;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.oldPrice,
    this.description = '',
  });

  // 🔥 From JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '1',
      name: json['name']?.toString() ?? 'Product',
      category: json['category']?.toString() ?? 'Food',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      rating: _parseDouble(json['rating'], 4.8),
      price: _parseDouble(json['price'], 0.0),
      oldPrice: _parseDoubleNullable(json['oldPrice']),
      description: json['description']?.toString() ?? '',
    );
  }

  static double _parseDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    if (value is num) return value.toDouble();
    return defaultValue;
  }

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    if (value is num) return value.toDouble();
    return null;
  }
}

class ProductDetailsController extends GetxController {
  static ProductDetailsController get to => Get.find();

  // ========== Product Data ==========
  late ProductModel product;

  // ========== Observable Variables ==========
  var quantity = 1.obs;
  var isFavorite = false.obs;
  var addCheese = false.obs;
  var addBacon = false.obs;
  var addMeat = false.obs;
  var isLoading = false.obs;

  // ========== Favorite Service ==========
  final FavoriteService favoriteService = Get.find<FavoriteService>();

  @override
  void onInit() {
    super.onInit();
    _loadProductData();
    
    // 🔥 Check if product is already in favorites
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isFavorite.value = favoriteService.isFavorite(product.id);
      print('⭐ Favorite status for ${product.name}: ${isFavorite.value}');
    });
  }

  // ========== Load Product Data ==========
  void _loadProductData() {
    print('🔍 ====== PRODUCT DETAILS CONTROLLER ======');
    print('📦 Get.arguments: ${Get.arguments}');
    
    final args = Get.arguments;

    if (args is ProductModel) {
      product = args;
      print('✅ Product Loaded: ${product.name}');
    } else if (args is Map<String, dynamic>) {
      product = ProductModel.fromJson(args);
      print('✅ Product from Map: ${product.name}');
    } else {
      // Default product
      product = ProductModel(
        id: '1',
        name: "Chicken Burger",
        category: "Food",
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
        rating: 4.8,
        price: 6.00,
        oldPrice: 10.00,
        description: 'A delicious chicken burger served on a toasted bun with fresh lettuce, tomato slices, and mayonnaise.',
      );
      print('⚠️ Using Default Product Data');
    }
    
    print('📦 Product Name: ${product.name}');
    print('💰 Price: ${product.price}');
  }

  // ========== 🔥 Toggle Favorite - Fixed ==========
  Future<void> toggleFavorite() async {
    print('⭐ Toggle Favorite called for: ${product.name}');
    
    final item = FavoriteItem(
      id: product.id,
      title: product.name,
      image: product.imageUrl,
      rating: product.rating,
      price: product.price,
    );

    // Toggle favorite with navigation
    final result = await favoriteService.toggleFavorite(
      item, 
      navigateToLikedScreen: true,  // 🔥 Liked Screen এ যাবে
    );
    
    isFavorite.value = result;
    print('⭐ Favorite toggled to: ${isFavorite.value}');
  }

  // ========== Quantity Methods ==========
  void increment() => quantity.value++;
  
  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // ========== Add to Cart ==========
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

  // ========== Get Add-ons Total ==========
  double getAddOnsTotal() {
    double total = 0.0;
    if (addCheese.value) total += 1.50;
    if (addBacon.value) total += 2.00;
    if (addMeat.value) total += 3.00;
    return total;
  }

  // ========== Get Total Price ==========
  double get totalPrice {
    return (product.price + getAddOnsTotal()) * quantity.value;
  }

  // ========== Get Selected Add-ons ==========
  List<Map<String, dynamic>> getSelectedAddOns() {
    final List<Map<String, dynamic>> selected = [];
    if (addCheese.value) {
      selected.add({'name': 'Add Cheese', 'price': 1.50});
    }
    if (addBacon.value) {
      selected.add({'name': 'Add Bacon', 'price': 2.00});
    }
    if (addMeat.value) {
      selected.add({'name': 'Add Meat (Extra Patty)', 'price': 3.00});
    }
    return selected;
  }
}