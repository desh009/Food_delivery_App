// lib/app/core/modules/Screens/home_screen/view/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/view/profile_view.dart'
    hide ProfileController;
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/location/location_selection/location_selection.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> bannerData = [
    {
      'id': 'banner_1',
      'title': 'GREEN DAY',
      'subtitle': 'UP TO\n60% OFF',
      'category': 'Salad Category',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF0F7A54), Color(0xFF1BA375)],
    },
    {
      'id': 'banner_2',
      'title': 'BURGER FEST',
      'subtitle': 'GET\n20% OFF',
      'category': 'Burger Category',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFFD35400), Color(0xFFE67E22)],
    },
    {
      'id': 'banner_3',
      'title': 'PIZZA DEAL',
      'subtitle': 'BUY 1\nGET 1 FREE',
      'category': 'Pizza Category',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF8B0000), Color(0xFFC0392B)],
    },
    {
      'id': 'banner_4',
      'title': 'DRINKS SPECIAL',
      'subtitle': 'UP TO\n50% OFF',
      'category': 'Drinks Category',
      'image':
          'https://images.unsplash.com/photo-1543854932-4d2e5d5fe46b?q=80&w=500&auto=format&fit=crop',
      'gradient': [Color(0xFF1A237E), Color(0xFF283593)],
    },
  ];

  final List<Map<String, dynamic>> specialOffers = [
    {
      'id': 'offer_1',
      'title': 'Cheese Burger',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      'rating': '4.8',
      'price': '\$12.99',
      'discount': '20% OFF',
      'category': 'Burger', // 🔥 Added category
    },
    {
      'id': 'offer_2',
      'title': 'Pepperoni Pizza',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'rating': '4.9',
      'price': '\$15.99',
      'discount': '15% OFF',
      'category': 'Pizza', // 🔥 Added category
    },
    {
      'id': 'offer_3',
      'title': 'Caesar Salad',
      'image':
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=500',
      'rating': '4.6',
      'price': '\$9.99',
      'discount': '10% OFF',
      'category': 'Salad', // 🔥 Added category
    },
    {
      'id': 'offer_4',
      'title': 'Chicken Tacos',
      'image':
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      'rating': '4.7',
      'price': '\$11.99',
      'discount': '25% OFF',
      'category': 'Tacos', // 🔥 Added category
    },
    {
      'id': 'offer_5',
      'title': 'Margarita Pizza',
      'image':
          'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?q=80&w=500',
      'rating': '4.5',
      'price': '\$14.99',
      'discount': '18% OFF',
      'category': 'Pizza', // 🔥 Added category
    },
    {
      'id': 'offer_6',
      'title': 'Veggie Burger',
      'image':
          'https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=500',
      'rating': '4.3',
      'price': '\$10.99',
      'discount': '12% OFF',
      'category': 'Burger', // 🔥 Added category
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize FavoriteService
    if (!Get.isRegistered<FavoriteService>()) {
      Get.put<FavoriteService>(FavoriteService(), permanent: true);
    }

    final controller = Get.find<HomeController>();
    final favoriteService = Get.find<FavoriteService>();

    // 🔥 Set special offers to controller for filtering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setSpecialOffers(specialOffers);
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

    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: LocationPicker(onLocationSelected: null),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/profile-edit');
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.black87,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Banner Slider
                    SizedBox(
                      height: 150.h,
                      child: PageView.builder(
                        itemCount: bannerData.length,
                        onPageChanged: (index) {
                          controller.onBannerPageChanged(index);
                        },
                        controller: controller.pageController,
                        itemBuilder: (context, index) {
                          final banner = bannerData[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.0.w,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.SPECIAL_OFFER);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      banner['gradient'][0],
                                      banner['gradient'][1],
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20.0.r),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            banner['title'],
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            banner['subtitle'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w900,
                                              height: 1.1.h,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            banner['category'],
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: -10.w,
                                      bottom: -10.h,
                                      top: -10.h,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: Image.network(
                                          banner['image'],
                                          width: 160.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 160.w,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 40.sp,
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

                    SizedBox(height: 12.h),

                    // Banner Indicator Dots
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(bannerData.length, (index) {
                          bool isActive =
                              controller.currentBannerIndex.value == index;
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                            height: 6.h,
                            width: isActive ? 18 : 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.tomato
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ========== SEARCH BAR WITH FILTER ==========
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black38,
                              size: 26.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Obx(
                                () => TextField(
                                  onChanged: (value) {
                                    controller.updateSearch(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: controller.isFilterApplied.value
                                        ? "Search with filters..."
                                        : "Search products...",
                                    hintStyle: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 16.sp,
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon:
                                        controller.searchText.value.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              controller.clearSearch();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.black38,
                                              size: 20.sp,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            // 🔥 FILTER BUTTON WITH BADGE
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: IconButton(
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
                                        size: 24.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                // 🔥 Filter Active Indicator Dot
                                Obx(
                                  () => controller.isFilterApplied.value
                                      ? Positioned(
                                          right: 4.w,
                                          top: 4.h,
                                          child: Container(
                                            width: 10.w,
                                            height: 10.h,
                                            decoration: BoxDecoration(
                                              color: AppColors.tomato,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ========== ACTIVE FILTERS CHIPS ==========
                    Obx(
                      () => controller.isFilterApplied.value
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0.w,
                                vertical: 8.0.h,
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    if (controller.selectedCategory.value !=
                                        'All')
                                      _buildFilterChip(
                                        label:
                                            'Category: ${controller.selectedCategory.value}',
                                        onDelete: () {
                                          controller.selectedCategory.value =
                                              'All';
                                          controller.applyFilters();
                                        },
                                      ),
                                    if (controller.selectedSortBy.value !=
                                        'Popular')
                                      _buildFilterChip(
                                        label:
                                            'Sort: ${controller.selectedSortBy.value}',
                                        onDelete: () {
                                          controller.selectedSortBy.value =
                                              'Popular';
                                          controller.applyFilters();
                                        },
                                      ),
                                    if (controller.minPrice.value > 0 ||
                                        controller.maxPrice.value < 100)
                                      _buildFilterChip(
                                        label:
                                            'Price: £${controller.minPrice.value.toInt()} - £${controller.maxPrice.value.toInt()}',
                                        onDelete: () {
                                          controller.minPrice.value = 0;
                                          controller.maxPrice.value = 100;
                                          controller.applyFilters();
                                        },
                                      ),
                                    if (controller.searchText.value.isNotEmpty)
                                      _buildFilterChip(
                                        label:
                                            'Search: ${controller.searchText.value}',
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
                          : SizedBox.shrink(),
                    ),

                    SizedBox(height: 24.h),

                    // Categories
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 16.h,
                              crossAxisSpacing: 16.w,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ProductListScreen(),
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
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categories[index]['icon']!,
                                    style: TextStyle(fontSize: 28.sp),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    categories[index]['name']!,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12.sp,
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

                    SizedBox(height: 28.h),

                    // Special Offers Header
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Special Offers",
                            style: TextStyle(
                              fontSize: 20.sp,
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
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14.sp,
                                  color: AppColors.tomato,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ========== 🔥 SPECIAL OFFERS GRID (FILTERED) ==========
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Obx(() {
                        final offers = controller.filteredOffers.isNotEmpty 
                            ? controller.filteredOffers 
                            : specialOffers;
                        
                        // 🔥 Show empty state when no results
                        if (offers.isEmpty && controller.isFilterApplied.value) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0.r),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64.sp,
                                    color: Colors.black26,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "No offers found!",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Text(
                                    "Try adjusting your filters",
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        
                        if (offers.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0.r),
                              child: Text(
                                "No special offers available",
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          );
                        }
                        
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: offers.length,
                          itemBuilder: (context, index) {
                            final offer = offers[index];
                            return _buildSpecialOfferCard(
                              id: offer['id'] ?? 'offer_$index',
                              imageUrl: offer['image'],
                              title: offer['title'],
                              rating: offer['rating'],
                              price: offer['price'],
                              discount: offer['discount'],
                            );
                          },
                        );
                      }),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),

              // Bottom Navigation
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: BottomNavigationWidget(),
              ),
            ],
          ),
        ),
      );
  }

  // ========== Special Offer Card ==========
  Widget _buildSpecialOfferCard({
    required String id,
    required String imageUrl,
    required String title,
    required String rating,
    required String price,
    required String discount,
  }) {
    final favoriteService = Get.find<FavoriteService>();
    final double priceValue =
        double.tryParse(price.replaceAll('\$', '')) ?? 0.0;
    final double ratingValue = double.tryParse(rating) ?? 0.0;

    return Obx(() {
      final isFavorite = favoriteService.isFavorite(id);

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Discount Badge
                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.tomato,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            discount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 🔥 Favorite Button
                      Positioned(
                        top: 10.h,
                        right: 10.w,
                        child: AnimatedFavoriteButton(
                          isFavorite: isFavorite,
                          size: 18.sp,
                          navigateOnAdd: false,
                          onTap: (newValue) async {
                            final item = FavoriteItem(
                              id: id,
                              title: title,
                              image: imageUrl,
                              rating: ratingValue,
                              price: priceValue,
                            );

                            if (newValue) {
                              await favoriteService.addFavorite(
                                item,
                                navigateToLikedScreen: false,
                              );
                            } else {
                              await favoriteService.removeFavorite(id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Details
                Padding(
                  padding: EdgeInsets.all(12.0.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14.sp),
                          Text(
                            " $rating",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Spacer(),
                          Text(
                            price,
                            style: TextStyle(
                              fontSize: 14.sp,
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
    });
  }

  // ========== Filter Chip ==========
  Widget _buildFilterChip({
    required String label,
    bool isClearAll = false,
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isClearAll
            ? Colors.red.withOpacity(0.1)
            : AppColors.tomato.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isClearAll ? Colors.red : AppColors.tomato,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isClearAll ? Colors.red : AppColors.tomato,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              size: 16.sp,
              color: isClearAll ? Colors.red : AppColors.tomato,
            ),
          ),
        ],
      ),
    );
  }
}