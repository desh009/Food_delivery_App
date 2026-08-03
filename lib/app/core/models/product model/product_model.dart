// lib/app/core/models/product_model.dart

import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double price;
  final double? oldPrice;
  final String description;
  final bool? isFavorite; // 🔥 যোগ করুন

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.oldPrice,
    this.description = '',
    required String image,
    required String title,
    this.isFavorite,
  });

  // ========== ✅ FROM JSON - Factory Constructor ==========
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: json['oldPrice'] != null
          ? (json['oldPrice'] as num).toDouble()
          : null,
      description: json['description']?.toString() ?? '',
      image: '',
      title: '',
    );
  }

  // ========== ✅ FROM FAVORITE ITEM ==========
  factory ProductModel.fromFavoriteItem(FavoriteItem item) {
    return ProductModel(
      id: item.id,
      name: item.title,
      category: 'Food',
      imageUrl: item.image,
      rating: item.rating,
      price: item.price,
      oldPrice: item.originalPrice,
      description: 'Delicious ${item.title} made with fresh ingredients.',
      image: '',
      title: '',
    );
  }

  // ========== ✅ TO JSON ==========
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
      'price': price,
      'oldPrice': oldPrice,
      'description': description,
    };
  }
}
