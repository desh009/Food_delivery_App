// lib/app/core/modules/Screens/Product_details_screen/controller/product_details_controller.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
// ✅ Correct import path

class ProductDetailsController extends GetxController {
  static ProductDetailsController get to => Get.find();

  late ProductModel product;

  var quantity = 1.obs;
  var isFavorite = false.obs;
  var addCheese = false.obs;
  var addBacon = false.obs;
  var addMeat = false.obs;
  var isLoading = false.obs;

  final FavoriteService favoriteService = Get.find<FavoriteService>();

  @override
  void onInit() {
    super.onInit();
    _loadProductData();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isFavorite.value = favoriteService.isFavorite(product.id);
      print('⭐ Favorite status for ${product.name}: ${isFavorite.value}');
    });
  }

  void _loadProductData() {
    print('🔍 ====== PRODUCT DETAILS CONTROLLER ======');
    print('📦 Get.arguments: ${Get.arguments}');
    
    final args = Get.arguments;

    if (args is ProductModel) {
      product = args;
      print('✅ Product Loaded: ${product.name}');
    } else if (args is FavoriteItem) {
      product = ProductModel.fromFavoriteItem(args);
      print('✅ Product from FavoriteItem: ${product.name}');
    } else if (args is Map<String, dynamic>) {
      // ✅ Now fromJson exists
      product = ProductModel.fromJson(args);
      print('✅ Product from Map: ${product.name}');
    } else if (args is ProductModel) {
      product = args;
      print('✅ Product from ProductModel: ${product.name}');
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
    print('🖼️ Image: ${product.imageUrl}');
  }

  // ============ FAVORITE METHODS ============

  Future<void> toggleFavorite() async {
    print('⭐ Toggle Favorite called for: ${product.name}');
    
    final item = FavoriteItem(
      id: product.id,
      title: product.name,
      image: product.imageUrl,
      rating: product.rating,
      price: product.price,
      originalPrice: product.oldPrice,
    );

    final result = await favoriteService.toggleFavorite(
      item, 
      navigateToLikedScreen: false,
    );
    
    isFavorite.value = result;
    print('⭐ Favorite toggled to: ${isFavorite.value}');
  }

  // ============ QUANTITY METHODS ============

  void increment() {
    if (quantity.value < 10) {
      quantity.value++;
    }
  }
  
  void decrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // ============ ADD-ONS METHODS ============

  double getAddOnsTotal() {
    double total = 0.0;
    if (addCheese.value) total += 0.50;
    if (addBacon.value) total += 1.00;
    if (addMeat.value) total += 2.00;
    return total;
  }

  List<Map<String, dynamic>> getSelectedAddOns() {
    final List<Map<String, dynamic>> selected = [];
    if (addCheese.value) {
      selected.add({'name': 'Add Cheese', 'price': 0.50});
    }
    if (addBacon.value) {
      selected.add({'name': 'Add Bacon', 'price': 1.00});
    }
    if (addMeat.value) {
      selected.add({'name': 'Add Meat (Extra Patty)', 'price': 2.00});
    }
    return selected;
  }

  // ============ TOTAL PRICE ============

  double get totalPrice {
    return (product.price + getAddOnsTotal()) * quantity.value;
  }

  // ============ ADD TO CART ============

  void addToCart() {
    final addOns = getSelectedAddOns();
    
    Get.snackbar(
      'Added to Cart',
      '${product.name} added to cart!${addOns.isNotEmpty ? ' with ${addOns.length} add-ons' : ''}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  // ============ NAVIGATION ============

  void goBack() {
    Get.back();
  }

  void goToCart() {
    Get.toNamed('/cart');
  }

  @override
  void onClose() {
    print('🗑️ ProductDetailsController disposed');
    super.onClose();
  }
}