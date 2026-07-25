// lib/app/core/modules/Screens/favourite_screen/controller/favourite_screen_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';

class LikedController extends GetxController {
  static LikedController get to => Get.find();

  final FavoriteService favoriteService = Get.find<FavoriteService>();

  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;

  List<FavoriteItem> get filteredItems {
    if (searchQuery.value.isEmpty) {
      return favoriteService.favoriteItems;
    }
    return favoriteService.favoriteItems.where((item) {
      return item.title.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  bool get isLoading => favoriteService.isLoading.value;
  List<FavoriteItem> get likedItems => favoriteService.favoriteItems;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BottomNavController.to.changeIndex(2);
        print('⭐ LikedScreen Loaded - Index: 2');
        print('📊 Total favorites: ${favoriteService.favoriteItems.length}');
      } catch (e) {
        print('❌ Error: $e');
      }
    });
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
  }

  Future<void> toggleLike(String itemId) async {
    final item = favoriteService.favoriteItems.firstWhereOrNull(
      (fav) => fav.id == itemId,
    );
    if (item != null) {
      await favoriteService.toggleFavorite(item, navigateToLikedScreen: false);
    }
  }

  Future<void> removeItem(String itemId) async {
    await favoriteService.removeFavorite(itemId);
  }

  Future<void> clearAllLiked() async {
    if (favoriteService.favoriteItems.isEmpty) return;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Clear All?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to remove all items from favorites?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await favoriteService.clearAllFavorites();
              Get.back();
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

  void navigateToFoodDetail(FavoriteItem item) {
    Get.toNamed(
      '/product-details',
      arguments: {
        'id': item.id,
        'title': item.title,
        'image': item.image,
        'price': item.price,
      },
    );
  }

  int get totalLikedItems => favoriteService.favoriteItems.length;
  bool get isEmpty => favoriteService.favoriteItems.isEmpty;

  String getLikedCountText() {
    if (favoriteService.favoriteItems.isEmpty) return 'No favorites';
    if (favoriteService.favoriteItems.length == 1) return '1 item';
    return '${favoriteService.favoriteItems.length} items';
  }
}
