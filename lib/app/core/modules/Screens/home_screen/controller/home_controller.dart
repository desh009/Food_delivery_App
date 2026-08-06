// lib/app/core/controllers/home_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // 🔥 pageController এখানে ডিফাইন করুন (শুধু একবার)
  final PageController pageController = PageController(initialPage: 0);
  final RxInt currentBannerIndex = 0.obs;

  // ============ SEARCH AND FILTER PROPERTIES ============
  final RxString searchText = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSortBy = 'Popular'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100.0.obs;
  final RxBool isFilterApplied = false.obs;

  // 🔥 Filtered offers list
  final RxList<Map<String, dynamic>> filteredOffers =
      <Map<String, dynamic>>[].obs;

  // 🔥 Original offers data
  List<Map<String, dynamic>> allSpecialOffers = [];

  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    _startBannerTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(0);
      } catch (e) {
        // Ignore
      }
    });

    // 🔥 Listen to search changes
    ever(searchText, (_) => applyFilters());
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  // ============ BANNER METHODS ============

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
    _resetBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        int nextPage = (currentBannerIndex.value + 1) % 4;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetBannerTimer() {
    _bannerTimer?.cancel();
    _startBannerTimer();
  }

  // ============ FILTER METHODS ============

  // 🔥 Set special offers data from view
  void setSpecialOffers(List<Map<String, dynamic>> offers) {
    allSpecialOffers = offers;
    applyFilters();
  }

  // 🔥 Apply all filters
  void applyFilters() {
    if (allSpecialOffers.isEmpty) return;

    List<Map<String, dynamic>> result = List.from(allSpecialOffers);

    // 🔥 Filter by category (if not 'All')
    if (selectedCategory.value != 'All') {
      result = result.where((offer) {
        // Check if title contains the category
        return offer['category'].toString().toLowerCase() ==
            selectedCategory.value.toLowerCase();
      }).toList();
    }

    // 🔥 Filter by search text
    if (searchText.value.isNotEmpty) {
      final query = searchText.value.toLowerCase();
      result = result.where((offer) {
        final title = offer['title'].toString().toLowerCase();
        final category = offer['category']?.toString().toLowerCase() ?? '';
        return title.contains(query) || category.contains(query);
      }).toList();
    }

    // 🔥 Filter by price range
    result = result.where((offer) {
      final priceString = offer['price'].toString().replaceAll('\$', '');
      final price = double.tryParse(priceString) ?? 0.0;
      return price >= minPrice.value && price <= maxPrice.value;
    }).toList();

    // 🔥 Apply sorting
    switch (selectedSortBy.value) {
      case 'Price: Low-High':
        result.sort((a, b) {
          final priceA =
              double.tryParse(a['price'].toString().replaceAll('\$', '')) ??
              0.0;
          final priceB =
              double.tryParse(b['price'].toString().replaceAll('\$', '')) ??
              0.0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High-Low':
        result.sort((a, b) {
          final priceA =
              double.tryParse(a['price'].toString().replaceAll('\$', '')) ??
              0.0;
          final priceB =
              double.tryParse(b['price'].toString().replaceAll('\$', '')) ??
              0.0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Rating':
        result.sort((a, b) {
          final ratingA = double.tryParse(a['rating'].toString()) ?? 0.0;
          final ratingB = double.tryParse(b['rating'].toString()) ?? 0.0;
          return ratingB.compareTo(ratingA);
        });
        break;
      default: // 'Popular'
        // Keep original order
        break;
    }

    filteredOffers.value = result;
    checkFilterStatus();
  }

  // 🔥 Update search
  void updateSearch(String value) {
    searchText.value = value;
    // applyFilters();
  }

  // 🔥 Clear search
  void clearSearch() {
    searchText.value = '';
    applyFilters();
  }

  // 🔥 Check if any filter is active
  void checkFilterStatus() {
    bool hasFilter = false;
    if (selectedCategory.value != 'All') hasFilter = true;
    if (selectedSortBy.value != 'Popular') hasFilter = true;
    if (minPrice.value > 0 || maxPrice.value < 100) hasFilter = true;
    if (searchText.value.isNotEmpty) hasFilter = true;
    isFilterApplied.value = hasFilter;
  }

  // 🔥 Reset all filters
  void resetFilter() {
    selectedCategory.value = 'All';
    selectedSortBy.value = 'Popular';
    minPrice.value = 0;
    maxPrice.value = 100;
    searchText.value = '';
    applyFilters();
  }

  // 🔥 Clear a specific filter
  void clearFilter(String filterType) {
    switch (filterType) {
      case 'category':
        selectedCategory.value = 'All';
        break;
      case 'sort':
        selectedSortBy.value = 'Popular';
        break;
      case 'price':
        minPrice.value = 0;
        maxPrice.value = 100;
        break;
      case 'search':
        searchText.value = '';
        break;
    }
    applyFilters();
  }

  // ============ FILTER BOTTOM SHEET ============

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Products",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          resetFilter();
                          Get.back();
                        },
                        child: const Text(
                          "Reset All",
                          style: TextStyle(
                            color: AppColors.tomato,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ========== Category Filter ==========
                        _buildFilterSection(
                          title: "Category",
                          child: Obx(() {
                            final categories = [
                              'All',
                              'Burger',
                              'Pizza',
                              'Salad',
                              'Tacos',
                              'Drinks',
                            ];
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: categories.map((category) {
                                return _buildFilterChip(
                                  label: category,
                                  isSelected:
                                      selectedCategory.value == category,
                                  onSelected: () {
                                    selectedCategory.value = category;
                                    applyFilters();
                                  },
                                );
                              }).toList(),
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // ========== Sort By Filter ==========
                        _buildFilterSection(
                          title: "Sort By",
                          child: Obx(() {
                            final sortOptions = [
                              'Popular',
                              'Price: Low-High',
                              'Price: High-Low',
                              'Rating',
                            ];
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sortOptions.map((option) {
                                return _buildFilterChip(
                                  label: option,
                                  isSelected: selectedSortBy.value == option,
                                  onSelected: () {
                                    selectedSortBy.value = option;
                                    applyFilters();
                                  },
                                );
                              }).toList(),
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // ========== Price Range Filter ==========
                        _buildFilterSection(
                          title: "Price Range",
                          child: Obx(() {
                            return Column(
                              children: [
                                // Price Range Slider
                                RangeSlider(
                                  values: RangeValues(
                                    minPrice.value,
                                    maxPrice.value,
                                  ),
                                  min: 0,
                                  max: 100,
                                  divisions: 20,
                                  activeColor: AppColors.tomato,
                                  inactiveColor: Colors.grey[300],
                                  onChanged: (values) {
                                    minPrice.value = values.start;
                                    maxPrice.value = values.end;
                                    applyFilters();
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '£${minPrice.value.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      '£${maxPrice.value.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // ========== Quick Price Filters ==========
                        _buildFilterSection(
                          title: "Quick Price Filters",
                          child: Obx(() {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildFilterChip(
                                  label: "All",
                                  isSelected:
                                      minPrice.value == 0 &&
                                      maxPrice.value == 100,
                                  onSelected: () {
                                    minPrice.value = 0;
                                    maxPrice.value = 100;
                                    applyFilters();
                                  },
                                ),
                                _buildFilterChip(
                                  label: "Under £10",
                                  isSelected:
                                      minPrice.value == 0 &&
                                      maxPrice.value == 10,
                                  onSelected: () {
                                    minPrice.value = 0;
                                    maxPrice.value = 10;
                                    applyFilters();
                                  },
                                ),
                                _buildFilterChip(
                                  label: "£10 - £25",
                                  isSelected:
                                      minPrice.value == 10 &&
                                      maxPrice.value == 25,
                                  onSelected: () {
                                    minPrice.value = 10;
                                    maxPrice.value = 25;
                                    applyFilters();
                                  },
                                ),
                                _buildFilterChip(
                                  label: "Over £25",
                                  isSelected:
                                      minPrice.value == 25 &&
                                      maxPrice.value == 100,
                                  onSelected: () {
                                    minPrice.value = 25;
                                    maxPrice.value = 100;
                                    applyFilters();
                                  },
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 30),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============ HELPER WIDGETS ============

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.tomato,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: isSelected ? AppColors.tomato : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }

  // ============ VOICE ASSISTANT METHODS ============

  // 🔥 Voice Assistant এর জন্য সার্চ
  void voiceSearch(String query) {
    if (query.isNotEmpty) {
      searchText.value = query;
      applyFilters();
      Get.snackbar(
        '🔍 Voice Search',
        'Searching for "$query"',
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );
    }
  }

  // 🔥 Voice Assistant এর জন্য ক্যাটাগরি
  void voiceNavigateToCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
    Get.snackbar(
      '📂 Category',
      'Showing $category items',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }

  // 🔥 Voice Assistant এর জন্য কার্ট যোগ
  void voiceAddToCart(String itemName, int quantity) {
    Get.snackbar(
      '🛒 Added to Cart',
      '$quantity x $itemName added!',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }

  // 🔥 Voice Assistant এর জন্য অর্ডার
  void voicePlaceOrder() {
    Get.snackbar(
      '✅ Order Placed',
      'Your order has been placed successfully!',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
    );
  }

  // 🔥 Voice Assistant এর জন্য নেভিগেট
  void voiceNavigateTo(String screen) {
    switch (screen) {
      case '/cart':
        Get.toNamed('/cart');
        break;
      case '/profile':
        Get.toNamed('/profile-edit');
        break;
      case '/home':
        Get.offAllNamed('/home');
        break;
      default:
        Get.offAllNamed('/home');
    }
  }
}
