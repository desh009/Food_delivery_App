// lib/app/core/modules/Screens/Liked_screen/view/liked_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/controller/favourite_screen_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:get/get.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Initialize FavoriteService
    if (!Get.isRegistered<FavoriteService>()) {
      Get.put<FavoriteService>(FavoriteService(), permanent: true);
    }

    final LikedController controller = Get.isRegistered<LikedController>()
        ? Get.find<LikedController>()
        : Get.put(LikedController());

    final favoriteService = Get.find<FavoriteService>();

    // Set bottom nav index
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(2);
      } catch (e) {
        print('Error : $e');
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
                SizedBox(height: 8.h),
                _buildItemsCount(controller, theme, isDark),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                          strokeWidth: 3.r,
                        ),
                      );
                    }

                    if (controller.filteredItems.isEmpty) {
                      return _buildEmptyState(theme, isDark);
                    }

                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      itemCount: controller.filteredItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getGridColumns(context),
                        crossAxisSpacing: 14.w,
                        mainAxisSpacing: 14.h,
                        childAspectRatio: _getAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        final isFavorite = favoriteService.isFavorite(item.id);
                        return _buildFoodCard(
                          controller,
                          item,
                          isFavorite,
                          theme,
                          isDark,
                        );
                      },
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
  // RESPONSIVE HELPERS
  // ============================================================

  int _getGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 1;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 4;
  }

  double _getAspectRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) return 0.85;
    if (width < 600) return 0.74;
    if (width < 900) return 0.80;
    return 0.85;
  }

  // ============================================================
  // HEADER - 🔥 Dark Mode Support
  // ============================================================

  Widget _buildHeader(
    LikedController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => BottomNavController.to.goBack(),
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF333333) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16.sp,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Favorites',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Obx(
            () => controller.likedItems.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.clearAllLiked(),
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
    LikedController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF333333) : const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: isDark ? Colors.white54 : Colors.grey.shade400,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchQuery.value,
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search favorites...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade400,
                      fontSize: 13.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.searchQuery.value.isNotEmpty
                  ? GestureDetector(
                      onTap: () => controller.clearSearch(),
                      child: Icon(
                        Icons.clear_rounded,
                        color: isDark ? Colors.white54 : Colors.grey.shade400,
                        size: 18.sp,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.tune_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ITEMS COUNT - 🔥 Dark Mode Support
  // ============================================================

  Widget _buildItemsCount(
    LikedController controller,
    ThemeData theme,
    bool isDark,
  ) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.isSearching.value
                  ? '${controller.filteredItems.length} results'
                  : controller.getLikedCountText(),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            if (controller.likedItems.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 16.sp,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
            Icons.favorite_outline_rounded,
            size: 70.sp,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          SizedBox(height: 14.h),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Start adding your favorite items!',
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 18.h),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Browse Food',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOD CARD - 🔥 Dark Mode Support
  // ============================================================

  Widget _buildFoodCard(
    LikedController controller,
    FavoriteItem item,
    bool isFavorite,
    ThemeData theme,
    bool isDark,
  ) {
    final favoriteService = Get.find<FavoriteService>();

    return GestureDetector(
      onTap: () {
        final product = ProductModel(
          id: item.id,
          name: item.title,
          category: 'Food',
          imageUrl: item.image,
          rating: item.rating,
          price: item.price,
          oldPrice: item.originalPrice,
          description: 'Delicious ${item.title} made with fresh ingredients.',
        );

        Get.to(
          () => ProductDetailsScreen(product: product),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                  ),
                  child: Image.network(
                    item.image,
                    height: 100.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100.h,
                        width: double.infinity,
                        color: isDark ? Colors.grey[800] : Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 30.sp,
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: AnimatedFavoriteButton(
                    isFavorite: isFavorite,
                    size: 16.sp,
                    navigateOnAdd: false,
                    onTap: (newValue) async {
                      if (newValue) {
                        await favoriteService.addFavorite(
                          item,
                          navigateToLikedScreen: false,
                        );
                      } else {
                        await favoriteService.removeFavorite(item.id);
                      }
                    },
                  ),
                ),
              ],
            ),
            // DETAILS - 🔥 Dark Mode Support
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFB800),
                        size: 14.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        '${item.rating}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (item.originalPrice != null) ...[
                        Text(
                          '£ ${item.originalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        '£ ${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.tomato,
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