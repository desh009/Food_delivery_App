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
                          ),
                        );
                      }

                      if (controller.filteredNotifications.isEmpty) {
                        return _buildEmptyState();
                      }

                      return SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Unread count
                            if (controller.getUnreadCount() > 0)
                              Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${controller.getUnreadCount()} unread',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: controller.markAllAsRead,
                                      child: Text(
                                        'Mark all as read',
                                        style: TextStyle(
                                          fontSize: 13.sp,
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
                                  SizedBox(height: 12.h),
                                  ...items.map(
                                    (item) => _buildNotificationTile(
                                      controller: controller,
                                      item: item,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              );
                            }).toList(),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: BottomNavigationWidget(),
              ),
            ],
          ),
        ),
      );
  }

  // ========== 🔥 Header - Obx সরানো হয়েছে (শুধু Text) ==========
  Widget _buildHeader(NotificationController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed('/home');
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.sp,
                color: Colors.black87,
              ),
            ),
          ),
          // 🔥 Obx সরানো হয়েছে - Text static
          Text(
            'Notification',
            style: TextStyle(
              fontSize: 20.sp,
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
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.sp,
                        color: Colors.red.shade400,
                      ),
                    ),
                  )
                : SizedBox(width: 40.w),
          ),
        ],
      ),
    );
  }

  // ========== 🔥 Search Bar - Obx ঠিক করা ==========
  Widget _buildSearchBar(NotificationController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.ashLight, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchText.value,
                  ),
                  style: TextStyle(fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search notifications...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
                        size: 18.sp,
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.tune, color: Colors.black87, size: 20.sp),
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
            size: 80.sp,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You are all caught up!',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ========== Section Header ==========
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
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
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (item.isUnread)
                        Container(
                          width: 8.w,
                          height: 8.h,
                          margin: EdgeInsets.only(left: 6.w),
                          decoration: BoxDecoration(
                            color: AppColors.tomato,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                      height: 1.3.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      // Delete button
                      GestureDetector(
                        onTap: () => controller.deleteNotification(item.id),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16.sp,
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