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

    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        print('NotificationScreen Loaded - Setting index to 3');
        BottomNavController.to.changeIndex(3);
      } catch (e) {
        print('Error: $e');
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ==================================================
            // MAIN CONTENT
            // ==================================================
            Column(
              children: [
                _buildHeader(controller, theme, isDark),
                _buildSearchBar(controller, theme, isDark),
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
                      return _buildEmptyState(theme, isDark);
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread count
                          if (controller.getUnreadCount() > 0)
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${controller.getUnreadCount()} unread',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.markAllAsRead,
                                    child: Text(
                                      'Mark all as read',
                                      style: TextStyle(
                                        fontSize: 12.sp,
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
                            final items = controller.getNotificationsByCategory(
                              category,
                            );
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(category, theme, isDark),
                                SizedBox(height: 10.h),
                                ...items.map(
                                  (item) => _buildNotificationTile(
                                    controller: controller,
                                    item: item,
                                    theme: theme,
                                    isDark: isDark,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                              ],
                            );
                          }).toList(),

                          SizedBox(height: 16.h),
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
  // HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHeader(
    NotificationController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 10.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Get.offAllNamed('/home');
            },
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Text(
            'Notification',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Obx(
            () => controller.notifications.isNotEmpty
                ? GestureDetector(
                    onTap: controller.clearAll,
                    child: Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.red.shade900.withOpacity(0.3)
                            : Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18.sp,
                        color: isDark ? Colors.red.shade400 : Colors.red.shade400,
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
  // SEARCH BAR - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildSearchBar(
    NotificationController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 6.h,
      ),
      child: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? Colors.white54 : Colors.grey.shade400,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchText.value,
                  ),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search notifications...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey,
                      fontSize: 13.sp,
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
                        color: isDark ? Colors.white54 : Colors.grey.shade400,
                        size: 16.sp,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.tune,
              color: isDark ? Colors.white : Colors.black87,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildEmptyState(ThemeData theme, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_rounded,
            size: 70.sp,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          SizedBox(height: 14.h),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'You are all caught up!',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildSectionHeader(
    String title,
    ThemeData theme,
    bool isDark,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  // ============================================================
  // NOTIFICATION TILE - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildNotificationTile({
    required NotificationController controller,
    required NotificationItem item,
    required ThemeData theme,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () {
        if (item.isUnread) {
          controller.markAsRead(item.id);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : item.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: isDark ? Colors.white70 : item.iconColor,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 10.w),
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      if (item.isUnread)
                        Container(
                          width: 6.w,
                          height: 6.h,
                          margin: EdgeInsets.only(left: 4.w),
                          decoration: BoxDecoration(
                            color: AppColors.tomato,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => controller.deleteNotification(item.id),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14.sp,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
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