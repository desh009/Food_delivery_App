import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ========== Variables ==========
  
  // Banner Slider Controller
  late PageController pageController;
  RxInt currentBannerIndex = 0.obs;
  
  // Search
  RxString searchText = ''.obs;
  
  // Filter
  RxString selectedCategory = 'All'.obs;
  RxString selectedSortBy = 'Popular'.obs;
  RxDouble minPrice = 0.0.obs;
  RxDouble maxPrice = 100.0.obs;
  RxBool isFilterApplied = false.obs;
  
  // Bottom Navigation
  RxInt currentNavIndex = 0.obs;
  
  // ========== Lifecycle ==========
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  // ========== Banner Methods ==========
  
  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
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
  
  void checkFilterStatus() {
    bool isApplied = false;
    
    if (selectedCategory.value != 'All') isApplied = true;
    if (selectedSortBy.value != 'Popular') isApplied = true;
    if (minPrice.value > 0 || maxPrice.value < 100) isApplied = true;
    if (searchText.value.isNotEmpty) isApplied = true;
    
    isFilterApplied.value = isApplied;
  }
  
  void resetFilter() {
    selectedCategory.value = 'All';
    selectedSortBy.value = 'Popular';
    minPrice.value = 0.0;
    maxPrice.value = 100.0;
    searchText.value = '';
    isFilterApplied.value = false;
  }
  
  void showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    resetFilter();
                    Get.back();
                  },
                  child: const Text(
                    "Reset All",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Category Filter
            const Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  'All',
                  'Burger',
                  'Pizza',
                  'Pasta',
                  'Salad',
                  'Drinks',
                  'Dessert',
                ].map((category) {
                  bool isSelected = selectedCategory.value == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      selectedCategory.value = category;
                      checkFilterStatus();
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Price Range
            const Text(
              "Price Range",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "£${minPrice.value.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "£${maxPrice.value.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(minPrice.value, maxPrice.value),
                    min: 0,
                    max: 100,
                    divisions: 100,
                    activeColor: Colors.green,
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (values) {
                      minPrice.value = values.start;
                      maxPrice.value = values.end;
                      checkFilterStatus();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sort By
            const Text(
              "Sort By",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  'Popular',
                  'Price: Low to High',
                  'Price: High to Low',
                  'Rating',
                ].map((sortOption) {
                  bool isSelected = selectedSortBy.value == sortOption;
                  return FilterChip(
                    label: Text(sortOption),
                    selected: isSelected,
                    onSelected: (selected) {
                      selectedSortBy.value = sortOption;
                      checkFilterStatus();
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
      isScrollControlled: true,
    );
  }
}