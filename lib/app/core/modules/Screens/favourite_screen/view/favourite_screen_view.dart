// lib/app/core/modules/Screens/Liked_screen/view/liked_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/controller/favourite_screen_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/binder/favourite_screen_binder.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize FavoriteService
    if (!Get.isRegistered<FavoriteService>()) {
      Get.put<FavoriteService>(FavoriteService(), permanent: true);
    }

    // Initialize Controller
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

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(controller),
              _buildSearchBar(controller),
              const SizedBox(height: 10),
              _buildItemsCount(controller),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.tomato),
                    );
                  }
      
                  if (controller.filteredItems.isEmpty) {
                    return _buildEmptyState();
                  }
      
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: controller.filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.74,
                    ),
                    itemBuilder: (context, index) {
                      final item = controller.filteredItems[index];
                      final isFavorite = favoriteService.isFavorite(item.id);
                      return _buildFoodCard(controller, item, isFavorite);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigationWidget(),
      ),
    );
  }

  Widget _buildHeader(LikedController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Favorites',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Obx(
            () => controller.likedItems.isNotEmpty
                ? GestureDetector(
                    onTap: () => controller.clearAllLiked(),
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


  Widget _buildSearchBar(LikedController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F5F7),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: Colors.grey.shade400, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(
                () => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  controller: TextEditingController(
                    text: controller.searchQuery.value,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search favorites...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
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
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Icon(Icons.tune_rounded, color: Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCount(LikedController controller) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.isSearching.value
                  ? '${controller.filteredItems.length} results'
                  : controller.getLikedCountText(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            if (controller.likedItems.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.sort_rounded,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline_rounded,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding your favorite items!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.offAllNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Browse Food',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(
    LikedController controller,
    FavoriteItem item,
    bool isFavorite,
  ) {
    final favoriteService = Get.find<FavoriteService>();

    return GestureDetector(
      onTap: () => controller.navigateToFoodDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    item.image,
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 115,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedFavoriteButton(
                    isFavorite: isFavorite,
                    size: 18,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB800),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (item.originalPrice != null) ...[
                        Text(
                          '£ ${item.originalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        '£ ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
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
