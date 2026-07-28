// lib/app/core/modules/Screens/Notification_screen/view/notification_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/binder/notification_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/controller/notification_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ==================================================
            // MAIN CONTENT
            // ==================================================
            Column(
              children: [
                _buildHeader(controller),
                _buildSearchBar(controller),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                          strokeWidth: 3.r,
                        ),
                      );
                    }

                    if (controller.filteredNotifications.isEmpty) {
                      return _buildEmptyState();
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w, // ✅ 20.w → 16.w
                        vertical: 8.h, // ✅ 10.h → 8.h
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread count
                          if (controller.getUnreadCount() > 0)
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h), // ✅ 12.h → 10.h
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${controller.getUnreadCount()} unread',
                                    style: TextStyle(
                                      fontSize: 12.sp, // ✅ 13.sp → 12.sp
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.markAllAsRead,
                                    child: Text(
                                      'Mark all as read',
                                      style: TextStyle(
                                        fontSize: 12.sp, // ✅ 13.sp → 12.sp
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
                                SizedBox(height: 10.h), // ✅ 12.h → 10.h
                                ...items.map(
                                  (item) => _buildNotificationTile(
                                    controller: controller,
                                    item: item,
                                  ),
                                ),
                                SizedBox(height: 14.h), // ✅ 16.h → 14.h
                              ],
                            );
                          }).toList(),

                          SizedBox(height: 16.h), // ✅ 20.h → 16.h
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
            // ==================================================
            // BOTTOM NAVIGATION
            // ==================================================
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: const BottomNavigationWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER - Responsive
  // ============================================================
  Widget _buildHeader(NotificationController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w, // ✅ 20.w → 16.w
        vertical: 10.h, // ✅ 12.h → 10.h
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed('/home');
            },
            child: Container(
              width: 38.w, // ✅ 40.w → 38.w
              height: 38.h, // ✅ 40.h → 38.h
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.sp, // ✅ 20.sp → 18.sp
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            'Notification',
            style: TextStyle(
              fontSize: 18.sp, // ✅ 20.sp → 18.sp
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Obx(
            () => controller.notifications.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearAll,
                    child: Container(
                      width: 38.w, // ✅ 40.w → 38.w
                      height: 38.h, // ✅ 40.h → 38.h
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18.sp, // ✅ 20.sp → 18.sp
                        color: Colors.red.shade400,
                      ),
                    ),
                  )
                : SizedBox(width: 38.w),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH BAR - Responsive
  // ============================================================
  Widget _buildSearchBar(NotificationController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w, // ✅ 20.w → 16.w
        vertical: 6.h, // ✅ 8.h → 6.h
      ),
      child: Container(
        height: 42.h, // ✅ 46.h → 42.h
        padding: EdgeInsets.symmetric(horizontal: 12.w), // ✅ 14.w → 12.w
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey.shade400,
              size: 18.sp, // ✅ 20.sp → 18.sp
            ),
            SizedBox(width: 8.w), // ✅ 10.w → 8.w
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchText.value,
                  ),
                  style: TextStyle(
                    fontSize: 13.sp, // ✅ 14.sp → 13.sp
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search notifications...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.sp, // ✅ 14.sp → 13.sp
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.searchText.value.isNotEmpty
                  ? GestureDetector(
                      onTap: controller.clearSearch,
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey.shade400,
                        size: 16.sp, // ✅ 18.sp → 16.sp
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 6.w), // ✅ 8.w → 6.w
            Icon(
              Icons.tune,
              color: Colors.black87,
              size: 18.sp, // ✅ 20.sp → 18.sp
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE - Responsive
  // ============================================================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 70.sp, // ✅ 80.sp → 70.sp
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 14.h), // ✅ 16.h → 14.h
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18.sp, // ✅ 20.sp → 18.sp
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 6.h), // ✅ 8.h → 6.h
          Text(
            'You are all caught up!',
            style: TextStyle(
              fontSize: 13.sp, // ✅ 14.sp → 13.sp
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER - Responsive
  // ============================================================
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp, // ✅ 16.sp → 15.sp
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // ============================================================
  // NOTIFICATION TILE - Responsive
  // ============================================================
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
        padding: EdgeInsets.only(bottom: 14.h), // ✅ 16.h → 14.h
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.w, // ✅ 42.w → 38.w
              height: 38.h, // ✅ 42.h → 38.h
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: item.iconColor,
                size: 18.sp, // ✅ 20.sp → 18.sp
              ),
            ),
            SizedBox(width: 10.w), // ✅ 12.w → 10.w
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13.sp, // ✅ 14.sp → 13.sp
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (item.isUnread)
                        Container(
                          width: 6.w, // ✅ 8.w → 6.w
                          height: 6.h, // ✅ 8.h → 6.h
                          margin: EdgeInsets.only(left: 4.w), // ✅ 6.w → 4.w
                          decoration: BoxDecoration(
                            color: AppColors.tomato,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h), // ✅ 3.h → 2.h
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 11.sp, // ✅ 12.sp → 11.sp
                      color: Colors.grey.shade600,
                      height: 1.2.h, // ✅ 1.3.h → 1.2.h
                    ),
                  ),
                  SizedBox(height: 3.h), // ✅ 4.h → 3.h
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 9.sp, // ✅ 10.sp → 9.sp
                          color: Colors.grey.shade500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.deleteNotification(item.id),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14.sp, // ✅ 16.sp → 14.sp
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