// app/core/modules/Screens/home_screen/controller/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ========== Observables ==========
  final RxInt currentNavIndex = 0.obs;
  final RxInt currentBannerIndex = 0.obs;
  
  // Search & Filter
  final RxString searchText = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSortBy = 'Popular'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100.0.obs;
  final RxBool isFilterApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Any initialization logic
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
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
    // This will be implemented in the view
    // But controller handles the state
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
  }

  // ========== Navigation Methods ==========
  void navigateToProfile() {
    currentNavIndex.value = 4;
    // Navigation logic
  }

  void navigateToProductList(Map<String, String> category) {
    // Navigation logic
  }

  void navigateToSpecialOffer() {
    // Navigation logic
  }
}