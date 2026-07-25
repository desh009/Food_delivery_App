import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      icon: Icons.notifications_none_rounded,
      label: 'Notification',
      route: '/notifications',
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
  }

  void changeIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      print('✅ Index changed to: ${currentIndex.value}');
    }
  }

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
     print('⭐ Navigating to Favorites');
        if (Get.currentRoute != '/liked-screen') {
          Get.toNamed('/liked-screen');  // ← এখানে `/favorites` ব্যবহার করুন
        }
        break;
      case 3: // Notification
        Get.snackbar(
          'Notification',
          'Coming soon!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        break;
      case 4: // Profile
        print('👤 Navigating to Profile - Index: 4');
        if (Get.currentRoute != '/my-account') {
          Get.toNamed('/my-account');
        }
        break;
      default:
        break;
    }
  }

  void _updateIndexFromRoute(String route) {
    print('📍 Current Route: $route');
    switch (route) {
      case '/home':
        currentIndex.value = 0;
        break;
      case '/order-details':
        currentIndex.value = 1;
        break;
      case '//liked-screen':
        currentIndex.value = 2;
        break;
      case '/notifications':
        currentIndex.value = 3;
        break;
      case '/my-account':
        currentIndex.value = 4; // 🔥 এখানে 4 আছে নিশ্চিত করুন
        break;
      default:
        currentIndex.value = 0;
        break;
    }
    print('📌 Updated Index: ${currentIndex.value}');
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