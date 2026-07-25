// lib/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteService extends GetxService {
  static FavoriteService get to => Get.find();
  
  final RxList<FavoriteItem> favoriteItems = <FavoriteItem>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadFavoritesFromStorage();
  }
  
  // ========== Add to Favorites ==========
  Future<void> addFavorite(FavoriteItem item, {bool navigateToLikedScreen = true}) async {
    // Check if already exists
    if (favoriteItems.any((fav) => fav.id == item.id)) {
      Get.snackbar(
        'Already in Favorites',
        '${item.title} is already in your favorites! ❤️',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    // Add to list
    favoriteItems.add(item);
    await _saveFavoritesToStorage();
    
    // Show success message
    Get.snackbar(
      'Added to Favorites',
      '${item.title} added to your favorites! ❤️',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(milliseconds: 600),
      icon: const Icon(Icons.favorite, color: Colors.white),
    );
    
    print('✅ Added to favorites: ${item.title}');
    print('📊 Total favorites: ${favoriteItems.length}');
    
    // 🔥 Navigation - শুধু মাত্র যদি navigateToLikedScreen true হয়
    if (navigateToLikedScreen) {
      // 🔥 Check if already on favorites screen
      if (Get.currentRoute != '/favorites') {
        Future.delayed(const Duration(milliseconds: 700), () {
          Get.toNamed('/favorites');
        });
      } else {
        print('Already on Favorites screen');
      }
    }
  }
  
  // ========== Remove from Favorites ==========
  Future<void> removeFavorite(String itemId, {bool showSnackbar = true}) async {
    final item = favoriteItems.firstWhereOrNull((fav) => fav.id == itemId);
    if (item == null) return;
    
    favoriteItems.removeWhere((fav) => fav.id == itemId);
    await _saveFavoritesToStorage();
    
    if (showSnackbar) {
      Get.snackbar(
        'Removed from Favorites',
        '${item.title} removed from favorites 💔',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.favorite_border, color: Colors.white),
      );
    }
    
    print('❌ Removed from favorites: ${item.title}');
  }
  
  // ========== Toggle Favorite ==========
  Future<bool> toggleFavorite(FavoriteItem item, {bool navigateToLikedScreen = true}) async {
    final exists = favoriteItems.any((fav) => fav.id == item.id);
    
    if (exists) {
      await removeFavorite(item.id);
      return false;
    } else {
      await addFavorite(item, navigateToLikedScreen: navigateToLikedScreen);
      return true;
    }
  }
  
  // ========== Check if item is favorite ==========
  bool isFavorite(String itemId) {
    return favoriteItems.any((fav) => fav.id == itemId);
  }
  
  // ========== Get all favorites ==========
  List<FavoriteItem> getFavorites() {
    return favoriteItems.toList();
  }
  
  // ========== Get favorites count ==========
  int getFavoritesCount() {
    return favoriteItems.length;
  }
  
  // ========== Clear all favorites ==========
  Future<void> clearAllFavorites() async {
    favoriteItems.clear();
    await _saveFavoritesToStorage();
    
    Get.snackbar(
      'Cleared',
      'All favorites removed',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
  
  // ========== Storage Methods ==========
  Future<void> _saveFavoritesToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = favoriteItems.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString('favorites', jsonString);
      print('💾 Favorites saved: ${favoriteItems.length} items');
    } catch (e) {
      print('❌ Error saving favorites: $e');
    }
  }
  
  Future<void> _loadFavoritesFromStorage() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('favorites');
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonList = jsonDecode(jsonString) as List;
        favoriteItems.assignAll(
          jsonList.map((json) => FavoriteItem.fromJson(json)).toList()
        );
        print('📂 Favorites loaded: ${favoriteItems.length} items');
      }
    } catch (e) {
      print('❌ Error loading favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

// ========== Favorite Item Model ==========
class FavoriteItem {
  final String id;
  final String title;
  final String image;
  final double rating;
  final double? originalPrice;
  final double price;
  final bool isFavorite;
  final String? category;
  
  FavoriteItem({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    this.originalPrice,
    required this.price,
    this.isFavorite = true,
    this.category,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'rating': rating,
      'originalPrice': originalPrice,
      'price': price,
      'isFavorite': isFavorite,
      'category': category,
    };
  }
  
  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      originalPrice: json['originalPrice']?.toDouble(),
      price: json['price']?.toDouble() ?? 0.0,
      isFavorite: json['isFavorite'] ?? true,
      category: json['category'],
    );
  }
}