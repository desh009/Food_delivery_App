// lib/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart

import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';

class ProductListController extends GetxController {
  late String categoryName;
  late String categoryIcon;
  var searchQuery = ''.obs;
  
  final RxMap<String, bool> favoriteStatus = <String, bool>{}.obs;
  final FavoriteService favoriteService = Get.find<FavoriteService>();

  final selectedPriceRange = 'all'.obs;
  final selectedRating = 0.0.obs;
  final selectedSort = 'popular'.obs;
  final activeFilters = <String, String>{}.obs;
  final filteredProducts = <ProductModel>[].obs;
  
  // ✅ ভয়েস সার্চের জন্য ফ্ল্যাগ
  var isVoiceSearch = false.obs;

  @override
  void onInit() {
    super.onInit();
    
    final args = Get.arguments;
    print('🔍 ProductListController onInit called with args: $args');
    
    // 🔥🔥🔥 মূল ফিক্স: category নাম সঠিকভাবে সেট করা
    if (args is Map<String, dynamic>) {
      // 'category' বা 'name' থেকে ভ্যালু নিন
      String? rawCategory = args['category'] ?? args['name'];
      
      // ✅ ভয়েস সার্চ চেক করুন
      isVoiceSearch.value = args['isVoiceSearch'] ?? false;
      
      if (rawCategory != null && rawCategory.isNotEmpty) {
        // ক্যাটাগরি নাম normalize করুন
        categoryName = _normalizeCategoryName(rawCategory);
      } else {
        categoryName = 'Burger'; // ডিফল্ট
      }
      
      categoryIcon = args['icon'] ?? _getCategoryIcon(categoryName);
      
      print('✅ Normalized Category: $categoryName');
      print('✅ Category Icon: $categoryIcon');
      print('✅ Is Voice Search: ${isVoiceSearch.value}');
      
      // ✅ ভয়েস সার্চ কুয়েরি থাকলে সেট করুন
      if (isVoiceSearch.value && args['searchQuery'] != null) {
        String query = args['searchQuery'] as String;
        searchQuery.value = query;
        print('✅ Voice Search Query: $query');
      }
      
    } else {
      categoryName = 'Burger';
      categoryIcon = '🍔';
    }
    
    // 🔥 সব প্রোডাক্ট প্রিন্ট করুন (ডিবাগের জন্য)
    print('📦 All Products Count: ${allProducts.length}');
    for (var p in allProducts) {
      print('   📌 ${p.name} (${p.category})');
    }
    
    _initFavoriteStatus();
    ever(searchQuery, (_) => applyFilters());
    applyFilters();
  }

  // 🔥🔥🔥 ক্যাটাগরি নাম normalize করার ফাংশন
  String _normalizeCategoryName(String category) {
    // প্রথমে Capitalize করুন
    String formatted = category
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
    
    print('🔄 Normalizing: "$category" → "$formatted"');
    
    // 🔥 Special cases - এখানে সব ক্যাটাগরি ম্যাপিং যোগ করুন
    final Map<String, String> categoryMap = {
      'burger': 'Burger',
      'pizza': 'Pizza',
      'taco': 'Taco',
      'tacos': 'Taco',
      'salad': 'Salad',
      'drink': 'Drink',
      'drinks': 'Drink',
      'pasta': 'Pasta',
      'noodles': 'Noodles',
      'sandwich': 'Sandwich',
      'ice cream': 'Ice Cream',
      'icecream': 'Ice Cream',
      'donut': 'Donut',
      'donuts': 'Donut',
      'burrito': 'Burrito',
      'more': 'More',
    };
    
    // ম্যাপ থেকে খুঁজে দেখুন
    String lowerKey = formatted.toLowerCase();
    if (categoryMap.containsKey(lowerKey)) {
      String mapped = categoryMap[lowerKey]!;
      print('🔄 Mapped: "$formatted" → "$mapped"');
      return mapped;
    }
    
    // না পেলে formatted রিটার্ন করুন
    return formatted;
  }

  // 🔥 ক্যাটাগরি অনুযায়ী আইকন
  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'burger': return '🍔';
      case 'pizza': return '🍕';
      case 'taco': return '🌮';
      case 'salad': return '🥗';
      case 'drink': return '🥤';
      case 'pasta': return '🍝';
      case 'noodles': return '🍜';
      case 'sandwich': return '🥪';
      case 'ice cream': return '🍦';
      case 'donut': return '🍩';
      case 'burrito': return '🌯';
      case 'more': return '🍽️';
      default: return '🍽️';
    }
  }

  void _initFavoriteStatus() {
    for (var product in allProducts) {
      favoriteStatus[product.id] = favoriteService.isFavorite(product.id);
    }
  }

  // ============ FILTER METHODS ============

  void setPriceRange(String range) {
    selectedPriceRange.value = range;
    if (range == 'all') {
      activeFilters.remove('priceRange');
    } else {
      activeFilters['priceRange'] = _getPriceRangeLabel(range);
    }
    applyFilters();
  }

  void setRating(double rating) {
    selectedRating.value = rating;
    if (rating == 0) {
      activeFilters.remove('rating');
    } else {
      activeFilters['rating'] = '$rating+ ⭐';
    }
    applyFilters();
  }

  void setSort(String sort) {
    selectedSort.value = sort;
    if (sort == 'popular') {
      activeFilters.remove('sort');
    } else {
      activeFilters['sort'] = _getSortLabel(sort);
    }
    applyFilters();
  }

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

  void clearAllFilters() {
    selectedPriceRange.value = 'all';
    selectedRating.value = 0;
    selectedSort.value = 'popular';
    activeFilters.clear();
    applyFilters();
  }

  int getActiveFilterCount() {
    return activeFilters.length;
  }

  String _getPriceRangeLabel(String range) {
    switch (range) {
      case 'under10': return 'Under £10';
      case '10to25': return '£10-£25';
      case '25to50': return '£25-£50';
      case 'over50': return 'Over £50';
      default: return '';
    }
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'priceAsc': return 'Price: Low-High';
      case 'priceDesc': return 'Price: High-Low';
      case 'rating': return 'Rating';
      default: return 'Popular';
    }
  }

  // ✅✅✅ ভয়েস সার্চের জন্য নতুন মেথড
  void filterProductsBySearch(String query) {
    print('🔍🔍🔍 filterProductsBySearch called with: "$query"');
    
    if (query.isEmpty) {
      // যদি সার্চ খালি হয়, তাহলে ক্যাটাগরি অনুযায়ী ফিল্টার করুন
      applyFilters();
      return;
    }

    final searchLower = query.toLowerCase().trim();
    
    // 🔥 প্রথমে ক্যাটাগরি অনুযায়ী ফিল্টার করুন
    final categoryProducts = allProducts.where((product) {
      return product.category.toLowerCase() == categoryName.toLowerCase();
    }).toList();
    
    // 🔥 তারপর সার্চ কুয়েরি অনুযায়ী ফিল্টার করুন
    final searchedProducts = categoryProducts.where((product) {
      return product.name.toLowerCase().contains(searchLower) ||
          product.description.toLowerCase().contains(searchLower);
    }).toList();
    
    print('📊 Category Products: ${categoryProducts.length}, Searched Products: ${searchedProducts.length}');
    
    // 🔥 ফিল্টার অ্যাপ্লাই করুন
    filteredProducts.value = _filterProducts(searchedProducts);
    
    // 🔥 যদি কোনো প্রোডাক্ট না পাওয়া যায় এবং ভয়েস সার্চ হয়
    if (filteredProducts.isEmpty && isVoiceSearch.value) {
      print('⚠️ No products found for voice search: "$query"');
      // এখানে চাইলে ইউজারকে নোটিফাই করতে পারেন
    }
  }

  // 🔥🔥🔥 মেইন ফিল্টার ফাংশন
  void applyFilters() {
    print('🔍🔍🔍 Applying filters for category: "$categoryName"');
    
    // 🔥 ক্যাটাগরি অনুযায়ী ফিল্টার
    final categoryProducts = allProducts.where((product) {
      // case-insensitive comparison
      bool isMatch = product.category.toLowerCase() == categoryName.toLowerCase();
      
      if (isMatch) {
        print('✅ MATCH: ${product.name} (${product.category})');
      } else {
        print('❌ NO MATCH: ${product.name} (${product.category}) vs ${categoryName}');
      }
      
      return isMatch;
    }).toList();
    
    print('📊 Category Products found: ${categoryProducts.length}');
    
    // 🔥 সার্চ কুয়েরি থাকলে সেটাও অ্যাপ্লাই করুন
    List<ProductModel> productsToFilter = categoryProducts;
    
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      productsToFilter = categoryProducts.where((p) => 
        p.name.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query)
      ).toList();
      print('📊 After Search Filter: ${productsToFilter.length}');
    }
    
    // 🔥 অন্যান্য ফিল্টার প্রয়োগ করুন
    filteredProducts.value = _filterProducts(productsToFilter);
    
    print('📊 Final Filtered Products: ${filteredProducts.length}');
    
    // 🔥 যদি কোনো প্রোডাক্ট না পাওয়া যায়
    if (filteredProducts.isEmpty) {
      print('⚠️ No products found for category: $categoryName');
    }
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    List<ProductModel> result = List.from(products);

    // Price Range Filter
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

    // Rating Filter
    if (selectedRating.value > 0) {
      result = result.where((p) => p.rating >= selectedRating.value).toList();
    }

    // Sort
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
      default:
        break;
    }

    return result;
  }

  // ============ FAVORITE METHODS ============

  Future<void> toggleFavorite(ProductModel product) async {
    print('⭐ Toggle Favorite for: ${product.name}');
    
    final item = FavoriteItem(
      id: product.id,
      title: product.name,
      image: product.imageUrl,
      rating: product.rating,
      price: product.price,
      originalPrice: product.oldPrice,
    );

    final result = await favoriteService.toggleFavorite(
      item, 
      navigateToLikedScreen: false,
    );
    
    favoriteStatus[product.id] = result;
  }

  bool isFavorite(ProductModel product) {
    return favoriteStatus[product.id] ?? false;
  }

  // ============ GO TO PRODUCT DETAILS ============
  void goToProductDetails(ProductModel product) {
    print('🛒 Product Clicked: ${product.name}');
    
    Get.to(
      () => ProductDetailsScreen(product: product),
      binding: ProductDetailsBinding(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  // ============ ALL PRODUCTS LIST ============
  final List<ProductModel> allProducts = [
    // 🍔 BURGER
    ProductModel(
      id: 'b1', name: 'Chicken Burger', category: 'Burger', rating: 4.9, price: 6.00, oldPrice: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      description: 'Juicy grilled chicken burger with fresh lettuce and special sauce', image: '', title: '',
    ),
    ProductModel(
      id: 'b2', name: 'Beef Burger', category: 'Burger', rating: 4.9, price: 10.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      description: 'Premium beef patty with melted cheese and caramelized onions', isFavorite: null, image: '', title: '',
    ),
    ProductModel(
      id: 'b3', name: 'Fish Burger', category: 'Burger', rating: 4.7, price: 8.00,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?q=80&w=500',
      description: 'Crispy fish fillet with tartar sauce and lettuce', isFavorite: null, image: '', title: '',
    ),
    ProductModel(
      id: 'b4', name: 'Turkey Burger', category: 'Burger', rating: 4.8, price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?q=80&w=500',
      description: 'Lean turkey patty with avocado and roasted peppers', image: '', title: '',
    ),

    // 🍕 PIZZA
    ProductModel(
      id: 'p1', name: 'Margherita Pizza', category: 'Pizza', rating: 4.9, price: 12.00, oldPrice: 16.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=500',
      description: 'Classic pizza with fresh mozzarella and basil', image: '', title: '',
    ),
    ProductModel(
      id: 'p2', name: 'Pepperoni Pizza', category: 'Pizza', rating: 4.8, price: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=500',
      description: 'Classic pepperoni pizza with extra cheese', image: '', title: '',
    ),

    // 🌮 TACO
    ProductModel(
      id: 't1', name: 'Chicken Soft Taco', category: 'Taco', rating: 4.8, price: 5.50, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?q=80&w=500',
      description: 'Soft flour tortilla with grilled chicken and fresh salsa', image: '', title: '',
    ),
    ProductModel(
      id: 't2', name: 'Beef Crunchy Taco', category: 'Taco', rating: 4.9, price: 6.50,
      imageUrl: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      description: 'Crispy shell with seasoned beef and cheese', image: '', title: '',
    ),

    // 🥗 SALAD
    ProductModel(
      id: 's1', name: 'Mediterranean Salad', category: 'Salad', rating: 4.9, price: 7.00, oldPrice: 9.50,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500',
      description: 'Fresh salad with feta cheese, olives and vinaigrette', image: '', title: '',
    ),
    ProductModel(
      id: 's2', name: 'Caesar Salad', category: 'Salad', rating: 4.7, price: 8.00,
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=500',
      description: 'Classic Caesar salad with grilled chicken', image: '', title: '',
    ),

    // 🥤 DRINK
    ProductModel(
      id: 'd1', name: 'Iced Latte Coffee', category: 'Drink', rating: 4.9, price: 4.00,
      imageUrl: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?q=80&w=500',
      description: 'Smooth iced latte with a hint of vanilla', isFavorite: null, image: '', title: '',
    ),
    ProductModel(
      id: 'd2', name: 'Fresh Lemonade', category: 'Drink', rating: 4.8, price: 3.50,
      imageUrl: 'https://images.unsplash.com/photo-1621263764928-df1444c5e859?q=80&w=500',
      description: 'Refreshing homemade lemonade', image: '', title: '',
    ),

    // 🍝 PASTA
    ProductModel(
      id: 'ps1', name: 'Creamy Alfredo Pasta', category: 'Pasta', rating: 4.9, price: 11.00, oldPrice: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=500',
      description: 'Rich and creamy Alfredo pasta with parmesan', image: '', title: '',
    ),
    ProductModel(
      id: 'ps2', name: 'Spaghetti Bolognese', category: 'Pasta', rating: 4.8, price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?q=80&w=500',
      description: 'Classic spaghetti with meat sauce', image: '', title: '',
    ),

    // 🍜 NOODLES
    ProductModel(
      id: 'n1', name: 'Spicy Ramen Noodles', category: 'Noodles', rating: 4.9, price: 9.00, oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?q=80&w=500',
      description: 'Authentic ramen with spicy broth and toppings', image: '', title: '',
    ),
    ProductModel(
      id: 'n2', name: 'Chow Mein', category: 'Noodles', rating: 4.7, price: 8.50,
      imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=500',
      description: 'Stir-fried noodles with vegetables', image: '', title: '',
    ),

    // 🥪 SANDWICH
    ProductModel(
      id: 'sw1', name: 'Club Grilled Sandwich', category: 'Sandwich', rating: 4.7, price: 5.00, oldPrice: 7.00,
      imageUrl: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?q=80&w=500',
      description: 'Grilled club sandwich with turkey, bacon and cheese', image: '', title: '',
    ),

    // 🍦 ICE CREAM
    ProductModel(
      id: 'ic1', name: 'Double Chocolate Fudge', category: 'Ice Cream', rating: 4.9, price: 4.50, oldPrice: 6.00,
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?q=80&w=500',
      description: 'Rich chocolate ice cream with fudge chunks', image: '', title: '',
    ),

    // 🍩 DONUT
    ProductModel(
      id: 'dn1', name: 'Choco Glazed Donut', category: 'Donut', rating: 4.8, price: 2.50,
      imageUrl: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=500',
      description: 'Delicious chocolate glazed donut with sprinkles', image: '', title: '',
    ),

    // 🌯 BURRITO
    ProductModel(
      id: 'br1', name: 'Loaded Beef Burrito', category: 'Burrito', rating: 4.6, price: 8.50, oldPrice: 11.00,
      imageUrl: 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?q=80&w=500',
      description: 'Large burrito filled with beef, rice, beans and guacamole', image: '', title: '',
    ),

    // 🍽️ MORE
    ProductModel(
      id: 'm1', name: 'Crispy French Fries', category: 'More', rating: 4.8, price: 3.00, oldPrice: 4.50,
      imageUrl: 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?q=80&w=500',
      description: 'Golden crispy fries with sea salt', image: '', title: '',
    ),
  ];
}