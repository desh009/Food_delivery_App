import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // 🔥 pageController এখানে ডিফাইন করুন (শুধু একবার)
  final PageController pageController = PageController(initialPage: 0);
  final RxInt currentBannerIndex = 0.obs;
  
  // Search and Filter
  final RxString searchText = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedSortBy = 'Popular'.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 100.0.obs;
  final RxBool isFilterApplied = false.obs;
  
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
  }
  
  @override
  void onClose() {
    _bannerTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
  
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
  
  void updateSearch(String value) {
    searchText.value = value;
    checkFilterStatus();
  }
  
  void clearSearch() {
    searchText.value = '';
    checkFilterStatus();
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
            const Text('Filter Options'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Apply Filter'),
            ),
          ],
        ),
      ),
    );
  }
}