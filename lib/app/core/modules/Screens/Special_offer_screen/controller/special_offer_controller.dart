import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:get/get.dart';

class SpecialOffersController extends GetxController {
  var specialProducts = <Map<String, dynamic>>[].obs;
  
  var filteredProducts = <Map<String, dynamic>>[].obs;

  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    specialProducts.value = [
      {
        "id": "1",
        "name": "Chicken Burger",
        "image":
            "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 10.00,
        "newPrice": 6.00,
        "isFavorite": true,
        "description": "Delicious chicken burger with fresh lettuce and special sauce.",
      },
      {
        "id": "2",
        "name": "Beef Burger",
        "image":
            "https://images.unsplash.com/photo-1542574271-7f3b92e6c821?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 12.00,
        "newPrice": 10.00,
        "isFavorite": false,
        "description": "Juicy beef burger with cheese and caramelized onions.",
      },
      {
        "id": "3",
        "name": "Ramen Noodles",
        "image":
            "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 22.00,
        "newPrice": 15.00,
        "isFavorite": true,
        "description": "Japanese ramen with pork broth and soft-boiled egg.",
      },
      {
        "id": "4",
        "name": "Pho Noodles",
        "image":
            "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 24.00,
        "newPrice": 20.00,
        "isFavorite": false,
        "description": "Vietnamese pho with beef and fresh herbs.",
      },
      {
        "id": "5",
        "name": "Fresh Fruit Donuts",
        "image":
            "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 6.00,
        "newPrice": 5.00,
        "isFavorite": true,
        "description": "Fresh donuts topped with colorful fruits.",
      },
      {
        "id": "6",
        "name": "Rotini",
        "image":
            "https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=500",
        "rating": "4.9",
        "oldPrice": 20.00,
        "newPrice": 18.00,
        "isFavorite": false,
        "description": "Pasta rotini with creamy sauce and herbs.",
      },
    ];
    
    filteredProducts.value = specialProducts;
  }

  void toggleFavorite(int index, bool newValue) {
    // specialProducts এ আপডেট
    if (index < specialProducts.length) {
      specialProducts[index]['isFavorite'] = newValue;
      
      // filteredProducts এ আপডেট (id দিয়ে খুঁজুন)
      final productId = specialProducts[index]['id'];
      final filteredIndex = filteredProducts.indexWhere(
        (p) => p['id'] == productId,
      );
      if (filteredIndex != -1) {
        filteredProducts[filteredIndex]['isFavorite'] = newValue;
      }
      
      // UI রিফ্রেশ
      specialProducts.refresh();
      filteredProducts.refresh();
    }
  }

  // সার্চ আপডেট
  void updateSearch(String value) {
    searchText.value = value;
    _filterProducts(value);
  }

  // প্রোডাক্ট ফিল্টার করা
  void _filterProducts(String query) {
    if (query.isEmpty) {
      filteredProducts.value = specialProducts;
    } else {
      filteredProducts.value = specialProducts
          .where(
            (product) => product['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  // ফিল্টার বাটন অ্যাকশন
  void onFilterTap() {
    Get.snackbar(
      "Filter",
      "Filter feature coming soon!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: Colors.white,
    );
  }

  // =====  Product Details Navigation ======
  void goToProductDetails(Map<String, dynamic> product) {
    // Debugging
    print('🛒 Product Clicked: ${product['name']}');
    print('📦 Product Data: $product');
    
    Get.to(
      () =>  ProductDetailsScreen(),  // ← const যোগ করুন
      binding: ProductDetailsBinding(),
      arguments: product,
    );
  }
}