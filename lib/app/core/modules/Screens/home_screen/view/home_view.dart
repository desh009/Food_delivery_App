import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/view/profile_view.dart'
    hide ProfileController;
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/location/location_selection/location_selection.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'dart:io';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  // Banner data
  final List<Map<String, dynamic>> bannerData = const [
    {
      'title': 'GREEN DAY',
      'subtitle': 'UP TO\n60% OFF',
      'category': 'Salad Category',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF0F7A54), Color(0xFF1BA375)],
    },
    {
      'title': 'BURGER FEST',
      'subtitle': 'GET\n20% OFF',
      'category': 'Burger Category',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFFD35400), Color(0xFFE67E22)],
    },
    {
      'title': 'PIZZA DEAL',
      'subtitle': 'BUY 1\nGET 1 FREE',
      'category': 'Pizza Category',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF8B0000), Color(0xFFC0392B)],
    },
    {
      'title': 'DRINKS SPECIAL',
      'subtitle': 'UP TO\n50% OFF',
      'category': 'Drinks Category',
      'image':
          'https://images.unsplash.com/photo-1543854932-4d2e5d5fe46b?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF1A237E), Color(0xFF283593)],
    },
  ];

  // Special offers data
  final List<Map<String, dynamic>> specialOffers = const [
    {
      'title': 'Cheese Burger',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      'rating': '4.8',
      'price': '\$12.99',
      'discount': '20% OFF',
    },
    {
      'title': 'Pepperoni Pizza',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'rating': '4.9',
      'price': '\$15.99',
      'discount': '15% OFF',
    },
    {
      'title': 'Caesar Salad',
      'image':
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=500',
      'rating': '4.6',
      'price': '\$9.99',
      'discount': '10% OFF',
    },
    {
      'title': 'Chicken Tacos',
      'image':
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      'rating': '4.7',
      'price': '\$11.99',
      'discount': '25% OFF',
    },
    {
      'title': 'Margarita Pizza',
      'image':
          'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?q=80&w=500',
      'rating': '4.5',
      'price': '\$14.99',
      'discount': '18% OFF',
    },
    {
      'title': 'Veggie Burger',
      'image':
          'https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=500',
      'rating': '4.3',
      'price': '\$10.99',
      'discount': '12% OFF',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();


      WidgetsBinding.instance.addPostFrameCallback((_) {
    try {
      BottomNavController.to.changeIndex(0);
    } catch (e) {
      // Ignore
    }
  });

    final List<Map<String, String>> categories = [
      {'name': 'Burger', 'icon': '🍔'},
      {'name': 'Taco', 'icon': '🌮'},
      {'name': 'Burrito', 'icon': '🌯'},
      {'name': 'Drink', 'icon': '🥤'},
      {'name': 'Pizza', 'icon': '🍕'},
      {'name': 'Donut', 'icon': '🍩'},
      {'name': 'Salad', 'icon': '🥗'},
      {'name': 'Noodles', 'icon': '🍜'},
      {'name': 'Sandwich', 'icon': '🥪'},
      {'name': 'Pasta', 'icon': '🍝'},
      {'name': 'Ice Cream', 'icon': '🍦'},
      {'name': 'More', 'icon': '👀'},
    ];

    // Create observables for favorite states
    final List<RxBool> favoriteStates = List.generate(
      specialOffers.length,
      (index) => false.obs,
    );

    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main Content (Scrollable)
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ========== HEADER ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: LocationPicker(onLocationSelected: null),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/profile');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.black87,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========== BANNER SLIDER ==========
                    SizedBox(
                      height: 150,
                      child: PageView.builder(
                        itemCount: bannerData.length,
                        onPageChanged: (index) {
                          controller.onBannerPageChanged(index);
                        },
                        controller: controller.pageController,
                        itemBuilder: (context, index) {
                          final banner = bannerData[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SPECIAL_OFFER);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      banner['gradient'][0],
                                      banner['gradient'][1],
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            banner['title'],
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            banner['subtitle'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                              height: 1.1,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            banner['category'],
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.9),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: -10,
                                      bottom: -10,
                                      top: -10,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: Image.network(
                                          banner['image'],
                                          width: 160,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 160,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Banner Indicator Dots
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(bannerData.length, (index) {
                          bool isActive =
                              controller.currentBannerIndex.value == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 6,
                            width: isActive ? 18 : 6,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.tomato : Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ========== SEARCH & FILTER ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.black38, size: 26),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  onChanged: (value) {
                                    controller.updateSearch(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.isFilterApplied.value
                                        ? "Search with filters..."
                                        : "Search",
                                    hintStyle: const TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon:
                                        controller.searchText.value.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              controller.clearSearch();
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.black38,
                                              size: 20,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            // Filter Button
                            Stack(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    controller.showFilterBottomSheet(context);
                                  },
                                  icon: Obx(
                                    () => Icon(
                                      controller.isFilterApplied.value
                                          ? Icons.filter_alt
                                          : Icons.tune,
                                      color: controller.isFilterApplied.value
                                          ? AppColors.tomato
                                          : Colors.black54,
                                      size: 26,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => controller.isFilterApplied.value
                                      ? Positioned(
                                          right: 8,
                                          top: 8,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.tomato,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Active Filters Chips
                    Obx(
                      () => controller.isFilterApplied.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 8.0,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (controller.selectedCategory.value != 'All')
                                      _buildFilterChip(
                                        label: 'Category: ${controller.selectedCategory.value}',
                                        onDelete: () {
                                          controller.selectedCategory.value = 'All';
                                          controller.checkFilterStatus();
                                        },
                                      ),
                                    if (controller.selectedSortBy.value != 'Popular')
                                      _buildFilterChip(
                                        label: 'Sort: ${controller.selectedSortBy.value}',
                                        onDelete: () {
                                          controller.selectedSortBy.value = 'Popular';
                                          controller.checkFilterStatus();
                                        },
                                      ),
                                    if (controller.minPrice.value > 0 ||
                                        controller.maxPrice.value < 100)
                                      _buildFilterChip(
                                        label: 'Price: £${controller.minPrice.value.toInt()} - £${controller.maxPrice.value.toInt()}',
                                        onDelete: () {
                                          controller.minPrice.value = 0;
                                          controller.maxPrice.value = 100;
                                          controller.checkFilterStatus();
                                        },
                                      ),
                                    if (controller.searchText.value.isNotEmpty)
                                      _buildFilterChip(
                                        label: 'Search: ${controller.searchText.value}',
                                        onDelete: () {
                                          controller.clearSearch();
                                        },
                                      ),
                                    _buildFilterChip(
                                      label: 'Clear All',
                                      isClearAll: true,
                                      onDelete: () {
                                        controller.resetFilter();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // ========== CATEGORIES ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => const ProductListScreen(),
                                binding: ProductListBinding(),
                                arguments: {
                                  'name': categories[index]['name'],
                                  'icon': categories[index]['icon'],
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categories[index]['icon']!,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    categories[index]['name']!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ========== SPECIAL OFFERS ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Special Offers",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SPECIAL_OFFER);
                            },
                            child: Row(
                              children: [
                                Text(
                                  "View All",
                                  style: TextStyle(
                                    color: AppColors.tomato,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: AppColors.tomato,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Special Offers Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: specialOffers.length,
                        itemBuilder: (context, index) {
                          final offer = specialOffers[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SPECIAL_OFFER);
                            },
                            child: _buildSpecialOfferCard(
                              imageUrl: offer['image'],
                              title: offer['title'],
                              rating: offer['rating'],
                              price: offer['price'],
                              discount: offer['discount'],
                              isFavorite: favoriteStates[index],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // ========== BOTTOM NAVIGATION ==========
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: const BottomNavigationWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== Special Offer Card ==========
  Widget _buildSpecialOfferCard({
    required String imageUrl,
    required String title,
    required String rating,
    required String price,
    required String discount,
    required RxBool isFavorite,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with Discount Badge
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Discount Badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.tomato,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Favorite Button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Obx(
                        () => AnimatedFavoriteButton(
                          isFavorite: isFavorite.value,
                          size: 16,
                          onTap: (newValue) {
                            isFavorite.value = newValue;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          " $rating",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 14,
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
        ],
      ),
    );
  }

  // ========== Filter Chip ==========
  Widget _buildFilterChip({
    required String label,
    bool isClearAll = false,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isClearAll
            ? Colors.red.withOpacity(0.1)
            : AppColors.tomato.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isClearAll ? Colors.red : AppColors.tomato,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isClearAll ? Colors.red : AppColors.tomato,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: 16,
              color: isClearAll ? Colors.red : AppColors.tomato,
            ),
          ),
        ],
      ),
    );
  }
}