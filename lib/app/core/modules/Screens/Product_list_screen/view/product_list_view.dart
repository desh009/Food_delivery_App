// lib/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/Voice_controller/voice_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class ProductListScreen extends GetView<ProductListController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String category = Get.arguments?['category'] ?? '';
    final String name = Get.arguments?['name'] ?? category;
    final String icon = Get.arguments?['icon'] ?? '🍽️';
    final bool isVoiceSearch = Get.arguments?['isVoiceSearch'] ?? false;
    final String searchQuery = Get.arguments?['searchQuery'] ?? '';

    // ✅ ভয়েস সার্চ হলে স্বয়ংক্রিয়ভাবে সার্চ করুন
    if (isVoiceSearch && searchQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.searchQuery.value = searchQuery;
        controller.filterProductsBySearch(searchQuery);
      });
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // ============================================================
            // HEADER SECTION - 🔥 Dark Mode Support
            // ============================================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.categoryIcon,
                          style: TextStyle(fontSize: 26.sp),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          controller.categoryName,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(width: 44.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // ============================================================
            // SEARCH BAR - 🔥 Dark Mode Support
            // ============================================================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF333333)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: isDark ? Colors.white54 : Colors.black38,
                      size: 26.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          controller.searchQuery.value = value;
                          controller.filterProductsBySearch(value);
                        },
                        controller: TextEditingController(
                          text: isVoiceSearch ? searchQuery : '',
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search products...",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black38,
                            fontSize: 16.sp,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // ভয়েস সার্চ ইন্ডিকেটর
                    if (isVoiceSearch)
                      Container(
                        margin: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          Icons.mic,
                          color: AppColors.tomato,
                          size: 22.sp,
                        ),
                      ),
                    // Filter Button with Badge
                    Obx(() {
                      final filterCount = controller.getActiveFilterCount();
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF444444)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: isDark ? Colors.white54 : Colors.black54,
                                size: 24.sp,
                              ),
                              onPressed: () =>
                                  _showFilterBottomSheet(context, isDark),
                            ),
                          ),
                          if (filterCount > 0)
                            Positioned(
                              right: 4.w,
                              top: 4.h,
                              child: Container(
                                padding: EdgeInsets.all(3.r),
                                decoration: BoxDecoration(
                                  color: AppColors.tomato,
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16.w,
                                  minHeight: 16.h,
                                ),
                                child: Text(
                                  filterCount.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // ============================================================
            // ACTIVE FILTERS CHIPS - 🔥 Dark Mode Support
            // ============================================================
            Obx(() {
              if (controller.activeFilters.isEmpty)
                return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.activeFilters.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: Chip(
                          label: Text(
                            '${_getFilterLabel(entry.key)}: ${entry.value}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          backgroundColor: isDark
                              ? AppColors.tomato.withOpacity(0.2)
                              : AppColors.tomato.withOpacity(0.1),
                          deleteIcon: Icon(
                            Icons.close,
                            size: 16.sp,
                            color: AppColors.tomato,
                          ),
                          onDeleted: () {
                            controller.clearFilter(entry.key);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),

            SizedBox(height: 10.h),

            // ============================================================
            // PRODUCTS GRID - 🔥 Dark Mode Support
            // ============================================================
            Expanded(
              child: Obx(() {
                final products = controller.filteredProducts;

                if (products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: isDark ? Colors.grey.shade600 : Colors.black26,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No products found!",
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.black45,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          isVoiceSearch
                              ? "Try saying a different product name"
                              : "Try adjusting your filters",
                          style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.black38,
                            fontSize: 14.sp,
                          ),
                        ),
                        if (isVoiceSearch) ...[
                          SizedBox(height: 12.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              // ভয়েস সার্চ আবার শুরু করুন
                              Get.find<VoiceActionController>().startListening();
                            },
                            icon: Icon(Icons.mic, color: Colors.white),
                            label: Text(
                              "Try Voice Search Again",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  itemCount: products.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.76,
                  ),
                  itemBuilder: (context, index) {
                    return _buildProductCard(products[index], isDark);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTER BOTTOM SHEET - 🔥 Dark Mode Support
  // ============================================================
  void _showFilterBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242424) : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearAllFilters();
                          Get.back();
                        },
                        child: Text(
                          "Clear All",
                          style: TextStyle(color: AppColors.tomato),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1.h,
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Range Filter
                        _buildFilterSection(
                          title: "Price Range",
                          isDark: isDark,
                          child: Obx(() {
                            return Column(
                              children: [
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8,
                                  children: [
                                    _buildFilterChip(
                                      label: "All",
                                      isSelected:
                                          controller.selectedPriceRange.value ==
                                          'all',
                                      onSelected: () =>
                                          controller.setPriceRange('all'),
                                      isDark: isDark,
                                    ),
                                    _buildFilterChip(
                                      label: "Under £10",
                                      isSelected:
                                          controller.selectedPriceRange.value ==
                                          'under10',
                                      onSelected: () =>
                                          controller.setPriceRange('under10'),
                                      isDark: isDark,
                                    ),
                                    _buildFilterChip(
                                      label: "£10-£25",
                                      isSelected:
                                          controller.selectedPriceRange.value ==
                                          '10to25',
                                      onSelected: () =>
                                          controller.setPriceRange('10to25'),
                                      isDark: isDark,
                                    ),
                                    _buildFilterChip(
                                      label: "£25-£50",
                                      isSelected:
                                          controller.selectedPriceRange.value ==
                                          '25to50',
                                      onSelected: () =>
                                          controller.setPriceRange('25to50'),
                                      isDark: isDark,
                                    ),
                                    _buildFilterChip(
                                      label: "Over £50",
                                      isSelected:
                                          controller.selectedPriceRange.value ==
                                          'over50',
                                      onSelected: () =>
                                          controller.setPriceRange('over50'),
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),

                        SizedBox(height: 24.h),

                        // Rating Filter
                        _buildFilterSection(
                          title: "Rating",
                          isDark: isDark,
                          child: Obx(() {
                            return Wrap(
                              spacing: 8.w,
                              runSpacing: 8,
                              children: [
                                _buildFilterChip(
                                  label: "All",
                                  isSelected:
                                      controller.selectedRating.value == 0,
                                  onSelected: () => controller.setRating(0),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "3+ ⭐",
                                  isSelected:
                                      controller.selectedRating.value == 3,
                                  onSelected: () => controller.setRating(3),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "3.5+ ⭐",
                                  isSelected:
                                      controller.selectedRating.value == 3.5,
                                  onSelected: () => controller.setRating(3.5),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "4+ ⭐",
                                  isSelected:
                                      controller.selectedRating.value == 4,
                                  onSelected: () => controller.setRating(4),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "4.5+ ⭐",
                                  isSelected:
                                      controller.selectedRating.value == 4.5,
                                  onSelected: () => controller.setRating(4.5),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "5 ⭐",
                                  isSelected:
                                      controller.selectedRating.value == 5,
                                  onSelected: () => controller.setRating(5),
                                  isDark: isDark,
                                ),
                              ],
                            );
                          }),
                        ),

                        SizedBox(height: 24.h),

                        // Sort Options
                        _buildFilterSection(
                          title: "Sort By",
                          isDark: isDark,
                          child: Obx(() {
                            return Wrap(
                              spacing: 8.w,
                              runSpacing: 8,
                              children: [
                                _buildFilterChip(
                                  label: "Popular",
                                  isSelected:
                                      controller.selectedSort.value ==
                                      'popular',
                                  onSelected: () =>
                                      controller.setSort('popular'),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "Price: Low-High",
                                  isSelected:
                                      controller.selectedSort.value ==
                                      'priceAsc',
                                  onSelected: () =>
                                      controller.setSort('priceAsc'),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "Price: High-Low",
                                  isSelected:
                                      controller.selectedSort.value ==
                                      'priceDesc',
                                  onSelected: () =>
                                      controller.setSort('priceDesc'),
                                  isDark: isDark,
                                ),
                                _buildFilterChip(
                                  label: "Rating",
                                  isSelected:
                                      controller.selectedSort.value == 'rating',
                                  onSelected: () =>
                                      controller.setSort('rating'),
                                  isDark: isDark,
                                ),
                              ],
                            );
                          }),
                        ),

                        SizedBox(height: 24.h),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.applyFilters();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required bool isDark,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.white : Colors.black87),
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey[100],
      selectedColor: AppColors.tomato,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      side: BorderSide(
        color: isSelected ? AppColors.tomato : Colors.transparent,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
    );
  }

  // Helper method to get filter label
  String _getFilterLabel(String key) {
    switch (key) {
      case 'priceRange':
        return 'Price';
      case 'rating':
        return 'Rating';
      case 'sort':
        return 'Sort';
      default:
        return key;
    }
  }

  // ============================================================
  // PRODUCT CARD - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildProductCard(ProductModel item, bool isDark) {
    return GestureDetector(
      onTap: () => controller.goToProductDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF242424) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
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
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Obx(
                      () => AnimatedFavoriteButton(
                        isFavorite: controller.isFavorite(item),
                        size: 18.sp,
                        navigateOnAdd: false,
                        onTap: (newValue) async {
                          await controller.toggleFavorite(item);
                          controller.update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
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
                      Icon(Icons.star, color: Colors.amber, size: 16.sp),
                      SizedBox(width: 4.w),
                      Text(
                        item.rating.toString(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      if (item.oldPrice != null) ...[
                        Text(
                          "£ ${item.oldPrice!.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark
                                ? Colors.grey.shade600
                                : Colors.black38,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        "£ ${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 15.sp,
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