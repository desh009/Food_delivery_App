// lib/app/core/modules/Screens/Notification_screen/view/notification_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/binder/notification_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/controller/notification_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
        Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        print('NotificationScreen Loaded - Setting index to 3');
        BottomNavController.to.changeIndex(3);
      } catch (e) {
        print('Error: $e');
      }
    });

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(controller),
                  _buildSearchBar(controller),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.tomato,
                          ),
                        );
                      }

                      if (controller.filteredNotifications.isEmpty) {
                        return _buildEmptyState();
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Unread count
                            if (controller.getUnreadCount() > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${controller.getUnreadCount()} unread',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.markAllAsRead,
                                      child: Text(
                                        'Mark all as read',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.tomato,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Notifications by category
                            ...controller.getCategories().map((category) {
                              final items = controller
                                  .getNotificationsByCategory(category);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionHeader(category),
                                  const SizedBox(height: 12),
                                  ...items.map(
                                    (item) => _buildNotificationTile(
                                      controller: controller,
                                      item: item,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: const BottomNavigationWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== 🔥 Header - Obx সরানো হয়েছে (শুধু Text) ==========
  Widget _buildHeader(NotificationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed('/home');
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
            ),
          ),
          // 🔥 Obx সরানো হয়েছে - Text static
          const Text(
            'Notification',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // 🔥 Obx সরানো হয়েছে - Delete button static
          Obx(
            () => controller.notifications.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearAll,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: Colors.red.shade400,
                      ),
                    ),
                  )
                : const SizedBox(width: 40),
          ),
        ],
      ),
    );
  }

  // ========== 🔥 Search Bar - Obx ঠিক করা ==========
  Widget _buildSearchBar(NotificationController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.ashLight, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchText.value,
                  ),
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search notifications...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            // 🔥 Obx ঠিক করা - শুধু clear button এ Obx
            Obx(
              () => controller.searchText.value.isNotEmpty
                  ? GestureDetector(
                      onTap: controller.clearSearch,
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey.shade400,
                        size: 18,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.tune, color: Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }

  // ========== Build Empty State ==========
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ========== Section Header ==========
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // ========== Notification Tile ==========
  Widget _buildNotificationTile({
    required NotificationController controller,
    required NotificationItem item,
  }) {
    return GestureDetector(
      onTap: () {
        if (item.isUnread) {
          controller.markAsRead(item.id);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (item.isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: const BoxDecoration(
                            color: AppColors.tomato,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      // Delete button
                      GestureDetector(
                        onTap: () => controller.deleteNotification(item.id),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}