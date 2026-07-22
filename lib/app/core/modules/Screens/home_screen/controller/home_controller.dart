import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class HomeController extends GetxController {
  // ========== Navigation Index ==========
  var currentNavIndex = 0.obs;

  // ========== Banner Index ==========
  var currentBannerIndex = 0.obs;

  // ========== Search Related ==========
  var searchText = ''.obs;
  var isSearchActive = false.obs;

  // ========== Filter Related ==========
  var selectedCategory = 'All'.obs;
  var selectedSortBy = 'Popular'.obs;
  var minPrice = 0.0.obs;
  var maxPrice = 100.0.obs;
  var isFilterApplied = false.obs;

  // ========== Categories List ==========
  final List<String> categories = [
    'All',
    'Burger',
    'Pizza',
    'Pasta',
    'Salad',
    'Drink',
    'Dessert',
    'Noodles',
    'Sandwich',
    'Taco',
    'Burrito',
  ];

  // ========== Sort Options ==========
  final List<String> sortOptions = [
    'Popular',
    'Rating',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
  ];

  // ========== Products (Demo Data) ==========
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'Cheese Burger',
      'price': 12.99,
      'rating': 4.8,
      'category': 'Burger',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      'isFavorite': false,
    },
    {
      'id': 2,
      'name': 'Pepperoni Pizza',
      'price': 15.99,
      'rating': 4.9,
      'category': 'Pizza',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'isFavorite': false,
    },
    {
      'id': 3,
      'name': 'Caesar Salad',
      'price': 9.99,
      'rating': 4.7,
      'category': 'Salad',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500',
      'isFavorite': false,
    },
    {
      'id': 4,
      'name': 'Spaghetti Pasta',
      'price': 13.99,
      'rating': 4.6,
      'category': 'Pasta',
      'image':
          'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?q=80&w=500',
      'isFavorite': false,
    },
  ];

  // ========== Get Filtered Products ==========
  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> result = List.from(products);

    // Filter by Category
    if (selectedCategory.value != 'All') {
      result = result
          .where((product) => product['category'] == selectedCategory.value)
          .toList();
    }

    // Filter by Price Range
    result = result
        .where(
          (product) =>
              product['price'] >= minPrice.value &&
              product['price'] <= maxPrice.value,
        )
        .toList();

    // Sort
    switch (selectedSortBy.value) {
      case 'Popular':
        break;
      case 'Rating':
        result.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double),
        );
        break;
      case 'Price: Low to High':
        result.sort(
          (a, b) => (a['price'] as double).compareTo(b['price'] as double),
        );
        break;
      case 'Price: High to Low':
        result.sort(
          (a, b) => (b['price'] as double).compareTo(a['price'] as double),
        );
        break;
      case 'Newest':
        result = result.reversed.toList();
        break;
    }

    // Search Filter
    if (searchText.value.isNotEmpty) {
      result = result
          .where(
            (product) => product['name'].toLowerCase().contains(
              searchText.value.toLowerCase(),
            ),
          )
          .toList();
    }

    return result;
  }

  // ========== Apply Filter ==========
  void applyFilter() {
    isFilterApplied.value = true;
    Get.back(); // BottomSheet বন্ধ করুন

    Get.snackbar(
      'Filter Applied',
      'Category: ${selectedCategory.value}\nSort: ${selectedSortBy.value}\nPrice: £${minPrice.value.toInt()} - £${maxPrice.value.toInt()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // ========== Reset Filter ==========
  void resetFilter() {
    selectedCategory.value = 'All';
    selectedSortBy.value = 'Popular';
    minPrice.value = 0.0;
    maxPrice.value = 100.0;
    isFilterApplied.value = false;
    searchText.value = '';

    Get.back();
    Get.snackbar(
      'Filter Reset',
      'All filters have been reset',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey,
      colorText: Colors.white,
    );
  }

  // ========== Check Filter Status ==========
  void checkFilterStatus() {
    if (selectedCategory.value == 'All' &&
        selectedSortBy.value == 'Popular' &&
        minPrice.value == 0 &&
        maxPrice.value == 100 &&
        searchText.value.isEmpty) {
      isFilterApplied.value = false;
    } else {
      isFilterApplied.value = true;
    }
  }

  // ========== Clear Search ==========
  void clearSearch() {
    searchText.value = '';
    isSearchActive.value = false;
    checkFilterStatus();
  }

  // ========== Update Search ==========
  void updateSearch(String value) {
    searchText.value = value;
    isSearchActive.value = value.isNotEmpty;
    checkFilterStatus();
  }

  // ========== Toggle Favorite ==========
  void toggleFavorite(int productId) {
    final index = products.indexWhere((product) => product['id'] == productId);
    if (index != -1) {
      products[index]['isFavorite'] = !products[index]['isFavorite'];
      update();
    }
  }

  // ========== Get Product By ID ==========
  Map<String, dynamic>? getProductById(int id) {
    try {
      return products.firstWhere((product) => product['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // ========== Get Favorite Products ==========
  List<Map<String, dynamic>> get favoriteProducts {
    return products.where((product) => product['isFavorite'] == true).toList();
  }

  // ========== Get Products By Category ==========
  List<Map<String, dynamic>> getProductsByCategory(String category) {
    if (category == 'All') {
      return products;
    }
    return products
        .where((product) => product['category'] == category)
        .toList();
  }

  // ========== 🟢 Show Filter BottomSheet ==========
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          resetFilter();
                          setState(() {});
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: AppColors.tomato,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Category Filter
                  const Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      children: categories.map((category) {
                        bool isSelected = selectedCategory.value == category;
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            selectedCategory.value = category;
                            setState(() {});
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: AppColors.tomato.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.tomato
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.tomato
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sort By
                  const Text(
                    "Sort By",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      children: sortOptions.map((sort) {
                        bool isSelected = selectedSortBy.value == sort;
                        return FilterChip(
                          label: Text(sort),
                          selected: isSelected,
                          onSelected: (selected) {
                            selectedSortBy.value = sort;
                            setState(() {});
                          },
                          backgroundColor: Colors.grey[100],
                          selectedColor: AppColors.tomato.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.tomato
                                : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.tomato
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price Range
                  const Text(
                    "Price Range",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            "£${minPrice.value.toInt()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.tomato,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Obx(
                          () => RangeSlider(
                            values: RangeValues(minPrice.value, maxPrice.value),
                            min: 0,
                            max: 100,
                            divisions: 20,
                            labels: RangeLabels(
                              '£${minPrice.value.toInt()}',
                              '£${maxPrice.value.toInt()}',
                            ),
                            onChanged: (values) {
                              minPrice.value = values.start;
                              maxPrice.value = values.end;
                              setState(() {});
                            },
                            activeColor: AppColors.tomato,
                            inactiveColor: Colors.grey[300],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            "£${maxPrice.value.toInt()}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.tomato,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Apply Filter Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        applyFilter();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tomato,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ========== Lifecycle Methods ==========
  @override
  void onInit() {
    super.onInit();
    currentBannerIndex.value = 0;
    print('HomeController Initialized');
  }

  @override
  void onReady() {
    super.onReady();
    print('HomeController Ready');
  }

  @override
  void onClose() {
    super.onClose();
    print('HomeController Closed');
  }
}
