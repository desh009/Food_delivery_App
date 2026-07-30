// lib/app/core/modules/Screens/home_screen/view/home_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/location/location_selection/location_selection.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/widget/bottom_navigation_widget.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});

  // ============================================================
  // BANNER DATA
  // ============================================================

  final List<Map<String, dynamic>> bannerData = [
    {
      'id': 'banner_1',
      'title': 'GREEN DAY',
      'subtitle': 'UP TO\n60% OFF',
      'category': 'Salad Category',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
      'gradient': [const Color(0xFF0F7A54), const Color(0xFF1BA375)],
    },
    {
      'id': 'banner_2',
      'title': 'BURGER FEST',
      'subtitle': 'GET\n20% OFF',
      'category': 'Burger Category',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop',
      'gradient': [const Color(0xFFD35400), const Color(0xFFE67E22)],
    },
    {
      'id': 'banner_3',
      'title': 'PIZZA DEAL',
      'subtitle': 'BUY 1\nGET 1 FREE',
      'category': 'Pizza Category',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500&auto=format&fit=crop',
      'gradient': [const Color(0xFF8B0000), const Color(0xFFC0392B)],
    },
    {
      'id': 'banner_4',
      'title': 'DRINKS SPECIAL',
      'subtitle': 'UP TO\n50% OFF',
      'category': 'Drinks Category',
      'image':
          'https://images.unsplash.com/photo-1543854932-4d2e5d5fe46b?q=80&w=500&auto=format&fit=crop',
      'gradient': [const Color(0xFF1A237E), const Color(0xFF283593)],
    },
  ];

  // ============================================================
  // SPECIAL OFFERS
  // ============================================================

  final List<Map<String, dynamic>> specialOffers = [
    {
      'id': 'offer_1',
      'title': 'Cheese Burger',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      'rating': '4.8',
      'price': '\$12.99',
      'discount': '20% OFF',
      'category': 'Burger',
    },
    {
      'id': 'offer_2',
      'title': 'Pepperoni Pizza',
      'image':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      'rating': '4.9',
      'price': '\$15.99',
      'discount': '15% OFF',
      'category': 'Pizza',
    },
    {
      'id': 'offer_3',
      'title': 'Caesar Salad',
      'image':
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?q=80&w=500',
      'rating': '4.6',
      'price': '\$9.99',
      'discount': '10% OFF',
      'category': 'Salad',
    },
    {
      'id': 'offer_4',
      'title': 'Chicken Tacos',
      'image':
          'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?q=80&w=500',
      'rating': '4.7',
      'price': '\$11.99',
      'discount': '25% OFF',
      'category': 'Tacos',
    },
    {
      'id': 'offer_5',
      'title': 'Margarita Pizza',
      'image':
          'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?q=80&w=500',
      'rating': '4.5',
      'price': '\$14.99',
      'discount': '18% OFF',
      'category': 'Pizza',
    },
    {
      'id': 'offer_6',
      'title': 'Veggie Burger',
      'image':
          'https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=500',
      'rating': '4.3',
      'price': '\$10.99',
      'discount': '12% OFF',
      'category': 'Burger',
    },
  ];

  // ============================================================
  // CATEGORIES
  // ============================================================

  final List<Map<String, String>> categories = const [
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

  // ============================================================
  // RESPONSIVE HELPERS
  // ============================================================

  int _getCategoryColumns(double width) {
    if (width < 350) {
      return 3;
    } else if (width < 600) {
      return 4;
    } else if (width < 900) {
      return 5;
    } else {
      return 6;
    }
  }

  int _getOfferColumns(double width) {
    if (width < 370) {
      return 1;
    } else if (width < 700) {
      return 2;
    } else if (width < 1100) {
      return 3;
    } else {
      return 4;
    }
  }

  double _getBannerHeight(double width) {
    if (width < 350) {
      return 135.h;
    } else if (width < 600) {
      return 150.h;
    } else if (width < 900) {
      return 175.h;
    } else {
      return 200.h;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Favorite Service
    if (!Get.isRegistered<FavoriteService>()) {
      Get.put<FavoriteService>(FavoriteService(), permanent: true);
    }

    final homeController = Get.find<HomeController>();
    final favoriteService = Get.find<FavoriteService>();

    // Set offers after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.setSpecialOffers(specialOffers);

      try {
        BottomNavController.to.changeIndex(0);
      } catch (_) {}
    });

    final categoryColumns = _getCategoryColumns(screenWidth);
    final offerColumns = _getOfferColumns(screenWidth);
    final bannerHeight = _getBannerHeight(screenWidth);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ====================================================
            // MAIN SCROLL
            // ====================================================
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 90.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // ==================================================
                  // HEADER - 🔥 Dark Mode Support
                  // ==================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
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
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF333333) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10.r,
                                  offset: Offset(0, 4.h),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: isDark ? Colors.white : Colors.black87,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // BANNER
                  // ==================================================
                  SizedBox(
                    height: bannerHeight,
                    child: PageView.builder(
                      itemCount: bannerData.length,
                      controller: homeController.pageController,
                      onPageChanged: (index) {
                        homeController.onBannerPageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        final banner = bannerData[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.SPECIAL_OFFER);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20.r),
                                      child: FractionallySizedBox(
                                        widthFactor: screenWidth < 400
                                            ? 0.55
                                            : 0.60,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              banner['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                                fontSize: screenWidth < 350
                                                    ? 20.sp
                                                    : 24.sp,
                                                fontWeight: FontWeight.w900,
                                                height: 1.1,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              banner['category'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                    ),
                                    Positioned(
                                      right: -10.w,
                                      top: -10.h,
                                      bottom: -10.h,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: Image.network(
                                          banner['image'],
                                          width: screenWidth < 400
                                              ? 140.w
                                              : 160.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: screenWidth < 400
                                                      ? 140.w
                                                      : 160.w,
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
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ==================================================
                  // BANNER DOTS - 🔥 Dark Mode Support
                  // ==================================================
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(bannerData.length, (index) {
                        final isActive =
                            homeController.currentBannerIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 3.w),
                          height: 6.h,
                          width: isActive ? 18.w : 6.w,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.tomato
                                : (isDark ? Colors.grey.shade700 : Colors.black12),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        );
                      }),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // ==================================================
                  // SEARCH BAR - 🔥 Dark Mode Support
                  // ==================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 58.h),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: isDark ? Colors.white54 : Colors.black38,
                            size: 26.sp,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Obx(
                              () => TextField(
                                onChanged: (value) {
                                  homeController.updateSearch(value);
                                },
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: homeController.isFilterApplied.value
                                      ? 'Search with filters...'
                                      : 'Search products...',
                                  hintStyle: TextStyle(
                                    color: isDark ? Colors.white54 : Colors.black38,
                                    fontSize: 16.sp,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  suffixIcon:
                                      homeController.searchText.value.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            homeController.clearSearch();
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: isDark ? Colors.white54 : Colors.black38,
                                            size: 20.sp,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          // FILTER
                          Stack(
                            children: [
                              Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF444444) : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    homeController.showFilterBottomSheet(
                                      context,
                                    );
                                  },
                                  icon: Obx(
                                    () => Icon(
                                      homeController.isFilterApplied.value
                                          ? Icons.filter_alt
                                          : Icons.tune,
                                      color:
                                          homeController.isFilterApplied.value
                                          ? AppColors.tomato
                                          : (isDark ? Colors.white54 : Colors.black54),
                                      size: 22.sp,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => homeController.isFilterApplied.value
                                    ? Positioned(
                                        right: 2.w,
                                        top: 2.h,
                                        child: Container(
                                          width: 9.w,
                                          height: 9.w,
                                          decoration: BoxDecoration(
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

                  // ==================================================
                  // ACTIVE FILTER CHIPS - 🔥 Dark Mode Support
                  // ==================================================
                  Obx(
                    () => homeController.isFilterApplied.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 8.h,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  if (homeController.selectedCategory.value !=
                                      'All')
                                    _buildFilterChip(
                                      label:
                                          'Category: ${homeController.selectedCategory.value}',
                                      onDelete: () {
                                        homeController.selectedCategory.value =
                                            'All';
                                        homeController.applyFilters();
                                      },
                                    ),
                                  if (homeController.selectedSortBy.value !=
                                      'Popular')
                                    _buildFilterChip(
                                      label:
                                          'Sort: ${homeController.selectedSortBy.value}',
                                      onDelete: () {
                                        homeController.selectedSortBy.value =
                                            'Popular';
                                        homeController.applyFilters();
                                      },
                                    ),
                                  if (homeController.minPrice.value > 0 ||
                                      homeController.maxPrice.value < 100)
                                    _buildFilterChip(
                                      label:
                                          'Price: \$${homeController.minPrice.value.toInt()} - \$${homeController.maxPrice.value.toInt()}',
                                      onDelete: () {
                                        homeController.minPrice.value = 0;
                                        homeController.maxPrice.value = 100;
                                        homeController.applyFilters();
                                      },
                                    ),
                                  if (homeController
                                      .searchText
                                      .value
                                      .isNotEmpty)
                                    _buildFilterChip(
                                      label:
                                          'Search: ${homeController.searchText.value}',
                                      onDelete: () {
                                        homeController.clearSearch();
                                      },
                                    ),
                                  _buildFilterChip(
                                    label: 'Clear All',
                                    isClearAll: true,
                                    onDelete: () {
                                      homeController.resetFilter();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 24.h),

                  // ==================================================
                  // CATEGORIES - 🔥 Dark Mode Support
                  // ==================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: categoryColumns,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: screenWidth < 350 ? 0.80 : 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ProductListScreen(),
                              binding: ProductListBinding(),
                              arguments: {
                                'name': category['name'],
                                'icon': category['icon'],
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8.r,
                                  offset: Offset(0, 2.h),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category['icon']!,
                                  style: TextStyle(
                                    fontSize: screenWidth < 350 ? 24.sp : 28.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: Text(
                                    category['name']!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
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

                  // ==================================================
                  // SPECIAL OFFERS HEADER - 🔥 Dark Mode Support
                  // ==================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Special Offers',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.SPECIAL_OFFER);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                  color: AppColors.tomato,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 4.w),
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

                  // ==================================================
                  // SPECIAL OFFERS GRID - 🔥 Dark Mode Support
                  // ==================================================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Obx(() {
                      final offers = homeController.filteredOffers.isNotEmpty
                          ? homeController.filteredOffers
                          : specialOffers;

                      if (offers.isEmpty &&
                          homeController.isFilterApplied.value) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.r),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64.sp,
                                  color: isDark ? Colors.grey.shade600 : Colors.black26,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'No offers found!',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.black45,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Try adjusting your filters',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade500 : Colors.black38,
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
                            padding: EdgeInsets.all(40.r),
                            child: Text(
                              'No special offers available',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade400 : Colors.black45,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: offers.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: offerColumns,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: screenWidth < 370
                              ? 0.70
                              : screenWidth < 700
                              ? 0.72
                              : 0.78,
                        ),
                        itemBuilder: (context, index) {
                          final offer = offers[index];
                          return _buildSpecialOfferCard(
                            id: offer['id'] ?? 'offer_$index',
                            imageUrl: offer['image'],
                            title: offer['title'],
                            rating: offer['rating'],
                            price: offer['price'],
                            discount: offer['discount'],
                            isDark: isDark,
                          );
                        },
                      );
                    }),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),

            // ======================================================
            // BOTTOM NAVIGATION
            // ======================================================
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
  // SPECIAL OFFER CARD - 🔥 Dark Mode Support
  // ============================================================

  Widget _buildSpecialOfferCard({
    required String id,
    required String imageUrl,
    required String title,
    required String rating,
    required String price,
    required String discount,
    required bool isDark,
  }) {
    final favoriteService = Get.find<FavoriteService>();

    final double priceValue =
        double.tryParse(price.replaceAll('\$', '')) ?? 0.0;

    final double ratingValue = double.tryParse(rating) ?? 0.0;

    return Obx(() {
      final isFavorite = favoriteService.isFavorite(id);

      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 35.sp,
                                color: isDark ? Colors.grey.shade600 : Colors.black26,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // DISCOUNT
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
                  // FAVORITE
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
            // DETAILS - 🔥 Dark Mode Support
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14.sp),
                      SizedBox(width: 2.w),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // FILTER CHIP
  // ============================================================

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