// app/core/modules/Screens/home_screen/controller/home_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ========== Navigation ==========
  final RxInt currentNavIndex = 0.obs;

  // ========== Banner Slider ==========
  final RxInt currentBannerIndex = 0.obs;
  late PageController pageController;
  final int bannerCount = 4;

  // Auto-slide timer
  Timer? _bannerTimer;
  final RxBool isAutoSlideActive = true.obs;
  bool _isInitialized = false;

  // ========== Search & Filter ==========
  final RxString searchText = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSortBy = 'Popular'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100.0.obs;
  final RxBool isFilterApplied = false.obs;

  // ========== Featured Categories ==========
  final RxList<Map<String, dynamic>> featuredCategories =
      <Map<String, dynamic>>[
        {
          'name': 'Burger',
          'icon': '🍔',
          'color': Color(0xFFFF6B6B),
          'items': 24,
          'isPopular': true,
        },
        {
          'name': 'Pizza',
          'icon': '🍕',
          'color': Color(0xFF4ECDC4),
          'items': 18,
          'isPopular': true,
        },
        {
          'name': 'Sushi',
          'icon': '🍣',
          'color': Color(0xFFFF9F43),
          'items': 12,
          'isPopular': false,
        },
        {
          'name': 'Pasta',
          'icon': '🍝',
          'color': Color(0xFFA29BFE),
          'items': 15,
          'isPopular': false,
        },
        {
          'name': 'Salad',
          'icon': '🥗',
          'color': Color(0xFF55EFC4),
          'items': 10,
          'isPopular': true,
        },
        {
          'name': 'Drink',
          'icon': '🥤',
          'color': Color(0xFF74B9FF),
          'items': 20,
          'isPopular': false,
        },
        {
          'name': 'Dessert',
          'icon': '🍰',
          'color': Color(0xFFFD79A8),
          'items': 14,
          'isPopular': false,
        },
        {
          'name': 'Noodles',
          'icon': '🍜',
          'color': Color(0xFFFDCB6E),
          'items': 16,
          'isPopular': true,
        },
        {
          'name': 'Taco',
          'icon': '🌮',
          'color': Color(0xFFE17055),
          'items': 8,
          'isPopular': false,
        },
        {
          'name': 'Sandwich',
          'icon': '🥪',
          'color': Color(0xFF00CEC9),
          'items': 11,
          'isPopular': false,
        },
        {
          'name': 'Ice Cream',
          'icon': '🍦',
          'color': Color(0xFFF8A5C2),
          'items': 9,
          'isPopular': true,
        },
        {
          'name': 'More',
          'icon': '👀',
          'color': Color(0xFFB8B8B8),
          'items': 0,
          'isPopular': false,
        },
      ].obs;

  // ========== Special Offers ==========
  final RxList<Map<String, dynamic>> specialOffers = <Map<String, dynamic>>[
    {
      'id': '1',
      'title': 'Cheese Burger',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      'rating': 4.8,
      'price': 12.99,
      'discount': 20,
      'isFavorite': false,
      'restaurant': 'Burger House',
      'deliveryTime': '15-20 min',
    },
    {
      'id': '2',
      'title': 'Pepperoni Pizza',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'rating': 4.9,
      'price': 15.99,
      'discount': 15,
      'isFavorite': false,
      'restaurant': 'Pizza Palace',
      'deliveryTime': '20-25 min',
    },
    {
      'id': '3',
      'title': 'Sushi Platter',
      'image':
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=500',
      'rating': 4.7,
      'price': 24.99,
      'discount': 25,
      'isFavorite': false,
      'restaurant': 'Sushi Master',
      'deliveryTime': '25-30 min',
    },
    {
      'id': '4',
      'title': 'Pasta Carbonara',
      'image':
          'https://images.unsplash.com/photo-1588013273468-315fd88ea34c?q=80&w=500',
      'rating': 4.6,
      'price': 14.99,
      'discount': 10,
      'isFavorite': false,
      'restaurant': 'Pasta House',
      'deliveryTime': '18-22 min',
    },
  ].obs;

  // ========== Popular Restaurants ==========
  final RxList<Map<String, dynamic>>
  popularRestaurants = <Map<String, dynamic>>[
    {
      'name': 'McDonald\'s',
      'image':
          'https://images.unsplash.com/photo-1571091710454-4d6c7a4c3a7c?q=80&w=500',
      'rating': 4.5,
      'deliveryTime': '15-20 min',
      'distance': 0.8,
      'isOpen': true,
    },
    {
      'name': 'KFC',
      'image':
          'https://images.unsplash.com/photo-1562967914-608f82629710?q=80&w=500',
      'rating': 4.3,
      'deliveryTime': '20-25 min',
      'distance': 1.2,
      'isOpen': true,
    },
    {
      'name': 'Subway',
      'image':
          'https://images.unsplash.com/photo-1592417817098-8fd3b9e7f4b8?q=80&w=500',
      'rating': 4.4,
      'deliveryTime': '10-15 min',
      'distance': 0.5,
      'isOpen': true,
    },
    {
      'name': 'Domino\'s',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'rating': 4.6,
      'deliveryTime': '25-30 min',
      'distance': 1.5,
      'isOpen': false,
    },
  ].obs;

  // ========== Trending Food Items ==========
  final RxList<Map<String, dynamic>> trendingItems = <Map<String, dynamic>>[
    {
      'name': 'Double Cheese Burger',
      'image':
          'https://images.unsplash.com/photo-1553979459-d2229ba743d0?q=80&w=500',
      'price': 13.99,
      'rating': 4.9,
      'orders': 1250,
    },
    {
      'name': 'Margherita Pizza',
      'image':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500',
      'price': 11.99,
      'rating': 4.8,
      'orders': 980,
    },
    {
      'name': 'Chicken Wings',
      'image':
          'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?q=80&w=500',
      'price': 9.99,
      'rating': 4.7,
      'orders': 850,
    },
  ].obs;

  // ========== User Location ==========
  final RxString deliveryAddress = '221B Baker Street'.obs;
  final RxString selectedArea = 'Home'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController here
    pageController = PageController(viewportFraction: 0.85);
    
    // Start auto-slide after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAutoSlideActive.value) {
        startAutoSlide();
      }
    });
  }

  @override
  void onClose() {
    _stopAutoSlide();
    pageController.dispose();
    super.onClose();
  }

  // ========== Auto Slide Methods ==========
  void startAutoSlide() {
    _stopAutoSlide(); // Cancel any existing timer first
    if (!isAutoSlideActive.value) return;
    
    // Check if pageController has clients before starting
    if (!pageController.hasClients) {
      // If no clients yet, wait for them
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients && isAutoSlideActive.value) {
          _startTimer();
        }
      });
      return;
    }
    
    _startTimer();
  }

  void _startTimer() {
    if (_bannerTimer != null) return; // Timer already running
    
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients && isAutoSlideActive.value) {
        final nextPage = (currentBannerIndex.value + 1) % bannerCount;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        currentBannerIndex.value = nextPage;
      }
    });
  }

  void _stopAutoSlide() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
  }

  void toggleAutoSlide(bool isActive) {
    isAutoSlideActive.value = isActive;
    if (isActive) {
      startAutoSlide();
    } else {
      _stopAutoSlide();
    }
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
    // Reset timer when user manually swipes
    if (_bannerTimer != null) {
      _stopAutoSlide();
      startAutoSlide(); // Restart with fresh timer
    }
  }

  // Call this when the page view is ready (after the first frame)
  void onPageViewReady() {
    if (isAutoSlideActive.value) {
      startAutoSlide();
    }
  }

  // ========== Search Methods ==========
  void updateSearch(String value) {
    searchText.value = value;
    checkFilterStatus();
  }

  void clearSearch() {
    searchText.value = '';
    checkFilterStatus();
  }

  // ========== Filter Methods ==========
  void showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Category Filter
            _buildFilterSection(
              title: 'Category',
              children: [
                Wrap(
                  spacing: 8,
                  children:
                      ['All', 'Burger', 'Pizza', 'Sushi', 'Pasta', 'Salad']
                          .map(
                            (category) => FilterChip(
                              label: Text(category),
                              selected: selectedCategory.value == category,
                              onSelected: (selected) {
                                selectedCategory.value = category;
                                checkFilterStatus();
                                Get.back();
                              },
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price Range
            _buildFilterSection(
              title: 'Price Range',
              children: [
                RangeSlider(
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
                  },
                  onChangeEnd: (values) {
                    checkFilterStatus();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: resetFilter,
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      checkFilterStatus();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  void checkFilterStatus() {
    bool hasFilter = false;

    if (selectedCategory.value != 'All') hasFilter = true;
    if (selectedSortBy.value != 'Popular') hasFilter = true;
    if (minPrice.value > 0 || maxPrice.value < 100) hasFilter = true;
    if (searchText.value.isNotEmpty) hasFilter = true;

    isFilterApplied.value = hasFilter;
  }

  void resetFilter() {
    selectedCategory.value = 'All';
    selectedSortBy.value = 'Popular';
    minPrice.value = 0;
    maxPrice.value = 100;
    searchText.value = '';
    isFilterApplied.value = false;
    Get.back();
  }

  // ========== Toggle Favorite ==========
  void toggleFavorite(String id) {
    final index = specialOffers.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      specialOffers[index]['isFavorite'] = !specialOffers[index]['isFavorite'];
      specialOffers.refresh();
    }
  }

  // ========== Navigation Methods ==========
  void navigateToProfile() {
    currentNavIndex.value = 4;
    Get.toNamed('/profile');
  }

  void navigateToCategory(Map<String, dynamic> category) {
    Get.toNamed(
      '/product-list',
      arguments: {'name': category['name'], 'icon': category['icon']},
    );
  }

  void navigateToSpecialOffer() {
    Get.toNamed('/special-offer');
  }

  void navigateToRestaurant(Map<String, dynamic> restaurant) {
    Get.toNamed('/restaurant-detail', arguments: restaurant);
  }

  void navigateToProductDetail(Map<String, dynamic> product) {
    Get.toNamed('/product-detail', arguments: product);
  }
}