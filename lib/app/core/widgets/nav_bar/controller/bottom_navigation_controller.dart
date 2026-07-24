import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();

  final RxInt currentIndex = 0.obs;

  // ✅ Alerts সরিয়ে ফেলুন
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
      route: '/favorites',
    ),
    // Alerts সরানো হয়েছে
  ];

  @override
  void onInit() {
    super.onInit();
    _updateIndexFromRoute(Get.currentRoute);
  }

  void changeIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  // 🔥 Navigation Logic - Alerts সরান
  void navigateToScreen(int index, BuildContext context) {
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
        Get.snackbar(
          'Favorites',
          'Coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        break;
      case 3: // Profile
        print('Navigating to Profile');
        if (Get.currentRoute != '/my-account') {
          Get.toNamed('/my-account');
        }
        break;
      default:
        break;
    }
  }

  void _updateIndexFromRoute(String route) {
    print('Current Route: $route');
    switch (route) {
      case '/home':
        currentIndex.value = 0;
        break;
      case '/order-details':
        currentIndex.value = 1;
        break;
      case '/favorites':
        currentIndex.value = 2;
        break;
      case '/my-account':
        currentIndex.value = 3;  // Profile index 3
        break;
      default:
        currentIndex.value = 0;
        break;
    }
    print('Updated Index: ${currentIndex.value}');
  }

  void onRouteChanged(String route) {
    _updateIndexFromRoute(route);
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;
  final String route;

  BottomNavItem({required this.icon, required this.label, required this.route});
}