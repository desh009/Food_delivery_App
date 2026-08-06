// lib/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  BottomNavItem({required this.icon, required this.label, required this.route});
}

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();

  final RxInt currentIndex = 0.obs;

  final List<BottomNavItem> navItems = [
    BottomNavItem(icon: Icons.home_filled, label: 'Home', route: '/home'),
    BottomNavItem(
      icon: Icons.assignment_outlined,
      label: 'Orders',
      route: '/order-details',
    ),
    BottomNavItem(
      icon: Icons.favorite_border,
      label: 'Favorites',
      route: '/liked-screen',
    ),
    BottomNavItem(
      icon: Icons.shopping_cart_outlined,
      label: 'Add To Cart',
      route: '/cart-item',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      label: 'Profile',
      route: '/my-account',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _updateIndexFromRoute(Get.currentRoute);
    print('📍 Initial Index: ${currentIndex.value}');
  }

  // ========== Change Index ==========
  void changeIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      print('✅ Index changed to: ${currentIndex.value}');
    }
  }

  // ========== ✅ Back Button - Home Screen এ যাবে ==========
  void goBack() {
    print('🔙 Back Button Pressed - Going to Home');
    
    // ✅ Home Index (0) এ যাবে
    currentIndex.value = 0;
    
    // ✅ Home Screen এ Navigate
    Get.offAllNamed('/home');
    
    print('📍 Navigated to Home - Index: ${currentIndex.value}');
  }

  // ========== Navigate to Screen ==========
  void navigateToScreen(int index, BuildContext context) {
    print('🔄 Navigating to index: $index');
    
    switch (index) {
      case 0: // Home
        if (Get.currentRoute != '/home') {
          Get.offAllNamed('/home');
        }
        break;
      case 1: // Orders
        if (Get.currentRoute != '/order-details') {
          Get.toNamed('/order-details');
        }
        break;
      case 2: // Favorites
        if (Get.currentRoute != '/liked-screen') {
          Get.toNamed('/liked-screen');
        }
        break;
      case 3: // Add To Cart
        if (Get.currentRoute != '/cart-item') {
          Get.toNamed('/cart-item');
        }
        break;
      case 4: // Profile
        if (Get.currentRoute != '/my-account') {
          Get.toNamed('/my-account');
        }
        break;
      default:
        break;
    }
  }

  // ========== Update Index from Route ==========
  void _updateIndexFromRoute(String route) {
    print('📍 Current Route: $route');
    switch (route) {
      case '/home':
        currentIndex.value = 0;
        break;
      case '/order-details':
        currentIndex.value = 1;
        break;
      case '/liked-screen':
        currentIndex.value = 2;
        break;
      case '/cart-item':
        currentIndex.value = 3;
        break;
      case '/my-account':
        currentIndex.value = 4;
        break;
      default:
        // currentIndex.value = 0;
        break;
    }
    print('📌 Updated Index: ${currentIndex.value}');
  }

  // ========== Route Changed Listener ==========
  void onRouteChanged(String route) {
    _updateIndexFromRoute(route);
  }

  // ========== Reset Navigation ==========
  void resetNavigation() {
    currentIndex.value = 0;
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    super.onClose();
  }
}