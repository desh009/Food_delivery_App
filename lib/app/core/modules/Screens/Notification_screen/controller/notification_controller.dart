// lib/app/core/modules/Screens/Notification_screen/controller/notification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  
  // ========== Observable Variables ==========
  var searchText = ''.obs;
  var isLoading = false.obs;
  var isSearching = false.obs;
  
  // ========== Notification Data ==========
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxList<NotificationItem> filteredNotifications = <NotificationItem>[].obs;
  
  // ========== Lifecycle ==========
  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
    
    // Set bottom nav index to 3 (Notifications)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(3);
        print('🔔 NotificationScreen Loaded - Index: 3');
      } catch (e) {
        print('❌ Error: $e');
      }
    });
  }
  
  // ========== Load Notifications ==========
  void _loadNotifications() {
    isLoading.value = true;
    
    // Simulate API call
    Future.delayed(const Duration(milliseconds: 300), () {
      notifications.assignAll([
        NotificationItem(
          id: '1',
          icon: Icons.confirmation_number_rounded,
          iconColor: const Color(0xFFFFB300),
          iconBgColor: const Color(0xFFFFF8E1),
          title: 'Get 20% Discount Code',
          subtitle: 'Get discount codes from sharing with friends.',
          time: '12:20  10/05/2024',
          isUnread: true,
          category: 'Today',
        ),
        NotificationItem(
          id: '2',
          icon: Icons.confirmation_number_rounded,
          iconColor: const Color(0xFFFFB300),
          iconBgColor: const Color(0xFFFFF8E1),
          title: 'Get 10% Discount Code',
          subtitle: 'Holiday discount code.',
          time: '11:10  10/05/2024',
          isUnread: true,
          category: 'Today',
        ),
        NotificationItem(
          id: '3',
          icon: Icons.check_circle_rounded,
          iconColor: const Color(0xFF00BFA5),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Order Received',
          subtitle: 'Order #SP_0023900 has been delivered successfully.',
          time: '10:15  10/05/2024',
          isUnread: false,
          category: 'Today',
        ),
        NotificationItem(
          id: '4',
          icon: Icons.two_wheeler_rounded,
          iconColor: const Color(0xFF00BCD4),
          iconBgColor: const Color(0xFFE0F7FA),
          title: 'Order on the Way',
          subtitle: 'Your delivery driver is on the way with your order.',
          time: '10:10  10/05/2024',
          isUnread: false,
          category: 'Today',
        ),
        NotificationItem(
          id: '5',
          icon: Icons.storefront_rounded,
          iconColor: const Color(0xFF00BFA5),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Your Order is Confirmed',
          subtitle: 'Your order #SP_0023900 has been confirmed.',
          time: '09:59  10/05/2024',
          isUnread: false,
          category: 'Today',
        ),
        NotificationItem(
          id: '6',
          icon: Icons.local_mall_rounded,
          iconColor: const Color(0xFF2EC4B6),
          iconBgColor: const Color(0xFFE8F8F5),
          title: 'Order Successful',
          subtitle: 'Order #SP_0023900 has been placed successfully.',
          time: '09:56  10/05/2024',
          isUnread: false,
          category: 'Today',
        ),
        NotificationItem(
          id: '7',
          icon: Icons.cancel_rounded,
          iconColor: const Color(0xFFFF5252),
          iconBgColor: const Color(0xFFFFEBEE),
          title: 'Order Cancelled',
          subtitle: 'Order #SP_0023450 has been cancelled.',
          time: '22:40  09/05/2024',
          isUnread: false,
          category: 'Yesterday',
        ),
        NotificationItem(
          id: '8',
          icon: Icons.person_rounded,
          iconColor: const Color(0xFF00BFA5),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'Account Setup Successful',
          subtitle: 'Congratulations! Your account setup was successful.',
          time: '20:15  09/05/2024',
          isUnread: false,
          category: 'Yesterday',
        ),
        NotificationItem(
          id: '9',
          icon: Icons.credit_card_rounded,
          iconColor: const Color(0xFF00BCD4),
          iconBgColor: const Color(0xFFE0F7FA),
          title: 'Credit Card Connected',
          subtitle: 'Congratulations! Your credit card has been successfully added.',
          time: '20:20  09/05/2024',
          isUnread: false,
          category: 'Yesterday',
        ),
        NotificationItem(
          id: '10',
          icon: Icons.confirmation_number_rounded,
          iconColor: const Color(0xFFFFB300),
          iconBgColor: const Color(0xFFFFF8E1),
          title: 'Get 5% Discount Code',
          subtitle: 'Discount code for new users.',
          time: '11:10  10/05/2024',
          isUnread: false,
          category: 'Yesterday',
        ),
      ]);
      
      filteredNotifications.assignAll(notifications);
      isLoading.value = false;
      
      print('📬 Notifications loaded: ${notifications.length}');
    });
  }
  
  // ========== Search Methods ==========
  void updateSearch(String query) {
    searchText.value = query;
    isSearching.value = query.isNotEmpty;
    _filterNotifications(query);
  }
  
  void clearSearch() {
    searchText.value = '';
    isSearching.value = false;
    filteredNotifications.assignAll(notifications);
  }
  
  void _filterNotifications(String query) {
    if (query.isEmpty) {
      filteredNotifications.assignAll(notifications);
      return;
    }
    
    final results = notifications.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
             item.subtitle.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    filteredNotifications.assignAll(results);
  }
  
  // ========== Get Categories ==========
  List<String> getCategories() {
    final categories = <String>{};
    for (var item in filteredNotifications) {
      categories.add(item.category);
    }
    return categories.toList();
  }
  
  // ========== Get Notifications by Category ==========
  List<NotificationItem> getNotificationsByCategory(String category) {
    return filteredNotifications.where((item) => item.category == category).toList();
  }
  
  // ========== Mark as Read ==========
  void markAsRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index != -1) {
      notifications[index].isUnread = false;
      notifications.refresh();
      
      // Also update filtered list
      final filterIndex = filteredNotifications.indexWhere((item) => item.id == id);
      if (filterIndex != -1) {
        filteredNotifications[filterIndex].isUnread = false;
        filteredNotifications.refresh();
      }
    }
  }
  
  // ========== Mark All as Read ==========
  void markAllAsRead() {
    for (var item in notifications) {
      item.isUnread = false;
    }
    notifications.refresh();
    filteredNotifications.refresh();
    
    Get.snackbar(
      'Success',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  // ========== Delete Notification ==========
  void deleteNotification(String id) {
    notifications.removeWhere((item) => item.id == id);
    filteredNotifications.removeWhere((item) => item.id == id);
    
    Get.snackbar(
      'Deleted',
      'Notification removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
  
  // ========== Clear All ==========
  void clearAll() {
    if (notifications.isEmpty) return;
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear All?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to clear all notifications?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifications.clear();
              filteredNotifications.clear();
              Get.back();
              Get.snackbar(
                'Cleared',
                'All notifications cleared',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  // ========== Utility Methods ==========
  int getUnreadCount() {
    return notifications.where((item) => item.isUnread).length;
  }
  
  int getTotalCount() {
    return notifications.length;
  }
  
  bool get isEmpty => notifications.isEmpty;
}

// ========== Notification Item Model ==========
class NotificationItem {
  final String id;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String time;
  bool isUnread;
  final String category;
  
  NotificationItem({
    required this.id,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
    required this.category,
  });
}