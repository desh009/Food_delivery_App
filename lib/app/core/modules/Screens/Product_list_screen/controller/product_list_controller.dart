import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double price;
  final double? oldPrice;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.oldPrice,
  });
}

class ProductListController extends GetxController {
  late String categoryName;
  late String categoryIcon;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    categoryName = Get.arguments['name'] ?? 'Burger';
    categoryIcon = Get.arguments['icon'] ?? '🍔';
    
    print('✅ Category: $categoryName');
    print('📦 Products: ${filteredProducts.length}');
  }

  final List<ProductModel> allProducts = [
    // Burgers
    ProductModel(
      id: 'b1', name: 'Chicken Burger', category: 'Burger', rating: 4.9, price: 6.00, oldPrice: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
    ),
    ProductModel(
      id: 'b2', name: 'Beef Burger', category: 'Burger', rating: 4.9, price: 10.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
    ),
    ProductModel(
      id: 'b3', name: 'Fish Burger', category: 'Burger', rating: 4.7, price: 8.00,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?q=80&w=500',
    ),
    ProductModel(
      id: 'b4', name: 'Turkey Burger', category: 'Burger', rating: 4.8, price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?q=80&w=500',
    ),

    // Taco
    ProductModel(
      id: 't1', name: 'Chicken Soft Taco', category: 'Taco', rating: 4.8, price: 5.50, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?q=80&w=500',
    ),
    ProductModel(
      id: 't2', name: 'Beef Crunchy Taco', category: 'Taco', rating: 4.9, price: 6.50,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
    ),

    // Burrito
    ProductModel(
      id: 'br1', name: 'Loaded Beef Burrito', category: 'Burrito', rating: 4.6, price: 8.50, oldPrice: 11.00,
      imageUrl: 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?q=80&w=500',
    ),

    // Drink
    ProductModel(
      id: 'd1', name: 'Iced Latte Coffee', category: 'Drink', rating: 4.9, price: 4.00,
      imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=500',
    ),

    // Pizza
    ProductModel(
      id: 'p1', name: 'Margherita Pizza', category: 'Pizza', rating: 4.9, price: 12.00, oldPrice: 16.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=500',
    ),

    // Donut
    ProductModel(
      id: 'dn1', name: 'Choco Glazed Donut', category: 'Donut', rating: 4.8, price: 2.50,
      imageUrl: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500',
    ),

    // Salad
    ProductModel(
      id: 's1', name: 'Mediterranean Salad', category: 'Salad', rating: 4.9, price: 7.00, oldPrice: 9.50,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500',
    ),

    // Noodles
    ProductModel(
      id: 'n1', name: 'Spicy Ramen Noodles', category: 'Noodles', rating: 4.9, price: 9.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500',
    ),

    // Sandwich
    ProductModel(
      id: 'sw1', name: 'Club Grilled Sandwich', category: 'Sandwich', rating: 4.7, price: 5.00, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?q=80&w=500',
    ),

    // Pasta
    ProductModel(
      id: 'ps1', name: 'Creamy Alfredo Pasta', category: 'Pasta', rating: 4.9, price: 11.00, oldPrice: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=500',
    ),

    // Ice Cream
    ProductModel(
      id: 'ic1', name: 'Double Chocolate Fudge', category: 'Ice Cream', rating: 4.9, price: 4.50, oldPrice: 6.00,
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=500',
    ),

    // More
    ProductModel(
      id: 'm1', name: 'Crispy French Fries', category: 'More', rating: 4.8, price: 3.00, oldPrice: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?q=80&w=500',
    ),
  ];

  List<ProductModel> get filteredProducts {
    return allProducts.where((product) {
      final matchesCategory = product.category.toLowerCase() == categoryName.toLowerCase();
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void goToProductDetails(ProductModel product) {
    print('🛒 Product Clicked: ${product.name}');
    print('📦 Product ID: ${product.id}');
    print('💰 Price: ${product.price}');
    
    Get.to(
      () =>  ProductDetailsScreen(),
      binding: ProductDetailsBinding(),
      arguments: product,  // ← ProductModel পাঠান
    );
  }
}