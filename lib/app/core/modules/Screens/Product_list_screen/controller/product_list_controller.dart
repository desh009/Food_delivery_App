// lib/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart

import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final double price;
  final double? oldPrice;
  final String description; // 🔥 New field for search

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    this.oldPrice,
    this.description = '', // Default empty string
  });
}

class ProductListController extends GetxController {
  late String categoryName;
  late String categoryIcon;
  var searchQuery = ''.obs;
  
  // 🔥 Observable map to track favorite status for each product
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;
  
  // 🔥 Favorite Service
  final FavoriteService favoriteService = Get.find<FavoriteService>();

  // ============ 🔥 NEW FILTER PROPERTIES ============
  final selectedPriceRange = 'all'.obs;
  final selectedRating = 0.0.obs;
  final selectedSort = 'popular'.obs;
  final activeFilters = <String, String>{}.obs;
  final filteredProducts = <ProductModel>[].obs; // 🔥 Observable list for filtered products

  @override
  void onInit() {
    super.onInit();
    
    // 🔥 FIX: Properly get arguments
    final args = Get.arguments;
    print('🔍 ProductListController onInit called with args: $args');
    
    if (args is Map<String, dynamic>) {
      categoryName = args['name'] ?? 'Burger';
      categoryIcon = args['icon'] ?? '🍔';
    } else {
      categoryName = 'Burger';
      categoryIcon = '🍔';
    }
    
    print('✅ Category Name: $categoryName');
    print('✅ Category Icon: $categoryIcon');
    print('📦 Total Products: ${allProducts.length}');
    
    // 🔥 Initialize favorite status for all products
    _initFavoriteStatus();
    
    // 🔥 NEW: Listen to search changes and apply filters
    ever(searchQuery, (_) => applyFilters());
    
    // 🔥 NEW: Apply initial filters
    applyFilters();
  }

  // 🔥 Initialize favorite status for all products
  void _initFavoriteStatus() {
    for (var product in allProducts) {
      favoriteStatus[product.id] = favoriteService.isFavorite(product.id);
    }
  }

  // ============ 🔥 NEW FILTER METHODS ============

  // 🔥 Set price range filter
  void setPriceRange(String range) {
    selectedPriceRange.value = range;
    if (range == 'all') {
      activeFilters.remove('priceRange');
    } else {
      activeFilters['priceRange'] = _getPriceRangeLabel(range);
    }
    applyFilters();
  }

  // 🔥 Set rating filter
  void setRating(double rating) {
    selectedRating.value = rating;
    if (rating == 0) {
      activeFilters.remove('rating');
    } else {
      activeFilters['rating'] = '$rating+ ⭐';
    }
    applyFilters();
  }

  // 🔥 Set sort option
  void setSort(String sort) {
    selectedSort.value = sort;
    if (sort == 'popular') {
      activeFilters.remove('sort');
    } else {
      activeFilters['sort'] = _getSortLabel(sort);
    }
    applyFilters();
  }

  // 🔥 Clear a specific filter
  void clearFilter(String key) {
    switch (key) {
      case 'priceRange':
        selectedPriceRange.value = 'all';
        break;
      case 'rating':
        selectedRating.value = 0;
        break;
      case 'sort':
        selectedSort.value = 'popular';
        break;
    }
    activeFilters.remove(key);
    applyFilters();
  }

  // 🔥 Clear all filters
  void clearAllFilters() {
    selectedPriceRange.value = 'all';
    selectedRating.value = 0;
    selectedSort.value = 'popular';
    activeFilters.clear();
    applyFilters();
  }

  // 🔥 Get active filter count for badge
  int getActiveFilterCount() {
    return activeFilters.length;
  }

  // 🔥 Helper method for price range labels
  String _getPriceRangeLabel(String range) {
    switch (range) {
      case 'under10': return 'Under £10';
      case '10to25': return '£10-£25';
      case '25to50': return '£25-£50';
      case 'over50': return 'Over £50';
      default: return '';
    }
  }

  // 🔥 Helper method for sort labels
  String _getSortLabel(String sort) {
    switch (sort) {
      case 'priceAsc': return 'Price: Low-High';
      case 'priceDesc': return 'Price: High-Low';
      case 'rating': return 'Rating';
      default: return 'Popular';
    }
  }

  // 🔥 Main filter application method
  void applyFilters() {
    // Get all products that match the category
    final categoryProducts = allProducts.where((product) {
      return product.category.toLowerCase() == categoryName.toLowerCase();
    }).toList();
    
    // Apply all filters
    filteredProducts.value = _filterProducts(categoryProducts);
    print('📊 Filtered Products: ${filteredProducts.length} for category: $categoryName');
  }

  // 🔥 Core filtering logic
  List<ProductModel> _filterProducts(List<ProductModel> products) {
    List<ProductModel> result = List.from(products);

    // 🔥 Apply price filter
    switch (selectedPriceRange.value) {
      case 'under10':
        result = result.where((p) => p.price < 10).toList();
        break;
      case '10to25':
        result = result.where((p) => p.price >= 10 && p.price <= 25).toList();
        break;
      case '25to50':
        result = result.where((p) => p.price >= 25 && p.price <= 50).toList();
        break;
      case 'over50':
        result = result.where((p) => p.price > 50).toList();
        break;
    }

    // 🔥 Apply rating filter
    if (selectedRating.value > 0) {
      result = result.where((p) => p.rating >= selectedRating.value).toList();
    }

    // 🔥 Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((p) => 
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)
      ).toList();
    }

    // 🔥 Apply sorting
    switch (selectedSort.value) {
      case 'priceAsc':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'priceDesc':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default: // 'popular'
        // Keep original order
        break;
    }

    return result;
  }

  // 🔥 Toggle Favorite Method
  Future<void> toggleFavorite(ProductModel product) async {
    print('⭐ Toggle Favorite for: ${product.name}');
    
    final item = FavoriteItem(
      id: product.id,
      title: product.name,
      image: product.imageUrl,
      rating: product.rating,
      price: product.price,
    );

    final result = await favoriteService.toggleFavorite(
      item, 
      navigateToLikedScreen: false,
    );
    
    // 🔥 Update the favorite status in the map
    favoriteStatus[product.id] = result;
  }

  // 🔥 Check if product is favorite
  bool isFavorite(ProductModel product) {
    return favoriteStatus[product.id] ?? false;
  }

  void goToProductDetails(ProductModel product) {
    print('🛒 Product Clicked: ${product.name}');
    print('📦 Product ID: ${product.id}');
    print('💰 Price: ${product.price}');
    
    Get.to(
      () => ProductDetailsScreen(),
      binding: ProductDetailsBinding(),
      arguments: product,
    );
  }

  // ============ ALL PRODUCTS LIST ============
  final List<ProductModel> allProducts = [
    // Burgers
    ProductModel(
      id: 'b1', name: 'Chicken Burger', category: 'Burger', rating: 4.9, price: 6.00, oldPrice: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      description: 'Juicy grilled chicken burger with fresh lettuce and special sauce',
    ),
    ProductModel(
      id: 'b2', name: 'Beef Burger', category: 'Burger', rating: 4.9, price: 10.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      description: 'Premium beef patty with melted cheese and caramelized onions',
    ),
    ProductModel(
      id: 'b3', name: 'Fish Burger', category: 'Burger', rating: 4.7, price: 8.00,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?q=80&w=500',
      description: 'Crispy fish fillet with tartar sauce and lettuce',
    ),
    ProductModel(
      id: 'b4', name: 'Turkey Burger', category: 'Burger', rating: 4.8, price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?q=80&w=500',
      description: 'Lean turkey patty with avocado and roasted peppers',
    ),

    // Taco
    ProductModel(
      id: 't1', name: 'Chicken Soft Taco', category: 'Taco', rating: 4.8, price: 5.50, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?q=80&w=500',
      description: 'Soft flour tortilla with grilled chicken and fresh salsa',
    ),
    ProductModel(
      id: 't2', name: 'Beef Crunchy Taco', category: 'Taco', rating: 4.9, price: 6.50,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      description: 'Crispy shell with seasoned beef and cheese',
    ),

    // Burrito
    ProductModel(
      id: 'br1', name: 'Loaded Beef Burrito', category: 'Burrito', rating: 4.6, price: 8.50, oldPrice: 11.00,
      imageUrl: 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?q=80&w=500',
      description: 'Large burrito filled with beef, rice, beans and guacamole',
    ),

    // Drink
    ProductModel(
      id: 'd1', name: 'Iced Latte Coffee', category: 'Drink', rating: 4.9, price: 4.00,
      imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=500',
      description: 'Smooth iced latte with a hint of vanilla',
    ),

    // Pizza
    ProductModel(
      id: 'p1', name: 'Margherita Pizza', category: 'Pizza', rating: 4.9, price: 12.00, oldPrice: 16.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=500',
      description: 'Classic pizza with fresh mozzarella and basil',
    ),

    // Donut
    ProductModel(
      id: 'dn1', name: 'Choco Glazed Donut', category: 'Donut', rating: 4.8, price: 2.50,
      imageUrl: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500',
      description: 'Delicious chocolate glazed donut with sprinkles',
    ),

    // Salad
    ProductModel(
      id: 's1', name: 'Mediterranean Salad', category: 'Salad', rating: 4.9, price: 7.00, oldPrice: 9.50,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500',
      description: 'Fresh salad with feta cheese, olives and vinaigrette',
    ),

    // Noodles
    ProductModel(
      id: 'n1', name: 'Spicy Ramen Noodles', category: 'Noodles', rating: 4.9, price: 9.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500',
      description: 'Authentic ramen with spicy broth and toppings',
    ),

    // Sandwich
    ProductModel(
      id: 'sw1', name: 'Club Grilled Sandwich', category: 'Sandwich', rating: 4.7, price: 5.00, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?q=80&w=500',
      description: 'Grilled club sandwich with turkey, bacon and cheese',
    ),

    // Pasta
    ProductModel(
      id: 'ps1', name: 'Creamy Alfredo Pasta', category: 'Pasta', rating: 4.9, price: 11.00, oldPrice: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=500',
      description: 'Rich and creamy Alfredo pasta with parmesan',
    ),

    // Ice Cream
    ProductModel(
      id: 'ic1', name: 'Double Chocolate Fudge', category: 'Ice Cream', rating: 4.9, price: 4.50, oldPrice: 6.00,
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=500',
      description: 'Rich chocolate ice cream with fudge chunks',
    ),

    // More
    ProductModel(
      id: 'm1', name: 'Crispy French Fries', category: 'More', rating: 4.8, price: 3.00, oldPrice: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?q=80&w=500',
      description: 'Golden crispy fries with sea salt',
    ),
  ];
}