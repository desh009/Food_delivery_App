// lib/app/core/modules/Screens/special_offers_screen/controller/special_offers_controller.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
// ✅ Import ProductModel

class SpecialOffersController extends GetxController {
  var specialProducts = <Map<String, dynamic>>[].obs;
  var filteredProducts = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;
  var selectedFilter = 'All'.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 500));

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
          "description":
              "Delicious chicken burger with fresh lettuce and special sauce.",
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
          "description":
              "Juicy beef burger with cheese and caramelized onions.",
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

      filteredProducts.value = specialProducts.value;
    } catch (e) {
      errorMessage.value = 'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(int index, bool newValue) {
    if (index >= specialProducts.length) return;

    final productId = specialProducts[index]['id'];
    specialProducts[index]['isFavorite'] = newValue;

    final filteredIndex = filteredProducts.indexWhere(
      (p) => p['id'] == productId,
    );
    if (filteredIndex != -1) {
      filteredProducts[filteredIndex]['isFavorite'] = newValue;
    }

    specialProducts.refresh();
    filteredProducts.refresh();
  }

  void updateSearch(String value) {
    searchText.value = value;
    _applySearchAndFilter();
  }

  void _applySearchAndFilter() {
    print('Applying search and filter...');
    print('Search text: ${searchText.value}');
    print('Selected filter: ${selectedFilter.value}');

    List<Map<String, dynamic>> baseList;
    if (searchText.value.isEmpty) {
      baseList = List.from(specialProducts.value);
    } else {
      final lowerQuery = searchText.value.toLowerCase();
      baseList = specialProducts
          .where(
            (product) =>
                product['name'].toString().toLowerCase().contains(lowerQuery),
          )
          .toList();
    }

    print('Base list length: ${baseList.length}');
    _applyFilterToBaseList(baseList);
  }

  void _applyFilterToBaseList(List<Map<String, dynamic>> baseList) {
    print('Applying filter: ${selectedFilter.value}');

    switch (selectedFilter.value) {
      case 'Low to High':
        baseList.sort((a, b) {
          final priceA = (a['newPrice'] as num).toDouble();
          final priceB = (b['newPrice'] as num).toDouble();
          return priceA.compareTo(priceB);
        });
        break;

      case 'High to Low':
        baseList.sort((a, b) {
          final priceA = (a['newPrice'] as num).toDouble();
          final priceB = (b['newPrice'] as num).toDouble();
          return priceB.compareTo(priceA);
        });
        break;

      case 'Top Rated':
        baseList.sort((a, b) {
          final ratingA = double.parse(a['rating'].toString());
          final ratingB = double.parse(b['rating'].toString());
          return ratingB.compareTo(ratingA);
        });
        break;

      default:
        break;
    }

    filteredProducts.assignAll(baseList);
    print('Filtered products count: ${filteredProducts.length}');
  }

  void onFilterTap() {
    print('Filter button tapped!');
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('All'),
            _buildFilterOption('Low to High'),
            _buildFilterOption('High to Low'),
            _buildFilterOption('Top Rated'),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Clear filter tapped!');
                  selectedFilter.value = 'All';
                  _applySearchAndFilter();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tomato,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Clear Filter',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildFilterOption(String option) {
    return ListTile(
      title: Text(
        option,
        style: TextStyle(
          fontWeight: selectedFilter.value == option
              ? FontWeight.bold
              : FontWeight.normal,
          color: selectedFilter.value == option
              ? AppColors.tomato
              : Colors.black87,
        ),
      ),
      leading: Radio<String>(
        value: option,
        groupValue: selectedFilter.value,
        onChanged: (value) {
          print('Option selected: $value');
          selectedFilter.value = value!;
          print('Selected filter updated: ${selectedFilter.value}');
          _applySearchAndFilter();
          Get.back();
        },
        activeColor: AppColors.tomato,
      ),
    );
  }

  // ============ ✅ FIXED: GO TO PRODUCT DETAILS ============
  void goToProductDetails(Map<String, dynamic> productData) {
    try {
      if (productData.isEmpty) {
        Get.snackbar('Error', 'Product data is empty');
        return;
      }

      // ✅ Convert Map to ProductModel
      final product = ProductModel(
        id: productData['id']?.toString() ?? '',
        name: productData['name']?.toString() ?? '',
        category: 'Special Offer',
        imageUrl: productData['image']?.toString() ?? '',
        rating: double.tryParse(productData['rating']?.toString() ?? '0') ?? 0.0,
        price: (productData['newPrice'] as num?)?.toDouble() ?? 0.0,
        oldPrice: (productData['oldPrice'] as num?)?.toDouble(),
        description: productData['description']?.toString() ?? '', isFavorite: null, image: '', title: '',
      );

      // ✅ Navigate with ProductModel
      Get.to(
        () => ProductDetailsScreen(product: product),
        binding: ProductDetailsBinding(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      print('Error navigating: $e');
      Get.snackbar(
        'Error',
        'Failed to navigate to product details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}