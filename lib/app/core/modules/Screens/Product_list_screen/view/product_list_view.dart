// lib/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class ProductListScreen extends GetView<ProductListController> {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.categoryIcon,
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.categoryName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 44),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Search Bar with Filter Button
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
                        child: TextField(
                          onChanged: (value) =>
                              controller.searchQuery.value = value,
                          decoration: const InputDecoration(
                            hintText: "Search products...",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Filter Button with Badge
                      Obx(() {
                        final filterCount = controller.getActiveFilterCount();
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.filter_list,
                                  color: Colors.black54,
                                  size: 24,
                                ),
                                onPressed: () => _showFilterBottomSheet(context),
                              ),
                            ),
                            if (filterCount > 0)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppColors.tomato,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    filterCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
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

              const SizedBox(height: 10),

              // Active Filters Chips
              Obx(() {
                if (controller.activeFilters.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: controller.activeFilters.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(
                              '${_getFilterLabel(entry.key)}: ${entry.value}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: AppColors.tomato.withOpacity(0.1),
                            deleteIcon: const Icon(
                              Icons.close,
                              size: 16,
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

              const SizedBox(height: 10),

              // Products Grid
              Expanded(
                child: Obx(() {
                  final products = controller.filteredProducts;

                  if (products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No products found!",
                            style: TextStyle(color: Colors.black45, fontSize: 16),
                          ),
                          Text(
                            "Try adjusting your filters",
                            style: TextStyle(color: Colors.black38, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: products.length,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.76,
                    ),
                    itemBuilder: (context, index) {
                      return _buildProductCard(products[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Filter Bottom Sheet
  void _showFilterBottomSheet(BuildContext context) {
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
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filters",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearAllFilters();
                          Get.back();
                        },
                        child: const Text(
                          "Clear All",
                          style: TextStyle(color: AppColors.tomato),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Range Filter
                        _buildFilterSection(
                          title: "Price Range",
                          child: Obx(() {
                            return Column(
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildFilterChip(
                                      label: "All",
                                      isSelected: controller.selectedPriceRange.value == 'all',
                                      onSelected: () => controller.setPriceRange('all'),
                                    ),
                                    _buildFilterChip(
                                      label: "Under £10",
                                      isSelected: controller.selectedPriceRange.value == 'under10',
                                      onSelected: () => controller.setPriceRange('under10'),
                                    ),
                                    _buildFilterChip(
                                      label: "£10-£25",
                                      isSelected: controller.selectedPriceRange.value == '10to25',
                                      onSelected: () => controller.setPriceRange('10to25'),
                                    ),
                                    _buildFilterChip(
                                      label: "£25-£50",
                                      isSelected: controller.selectedPriceRange.value == '25to50',
                                      onSelected: () => controller.setPriceRange('25to50'),
                                    ),
                                    _buildFilterChip(
                                      label: "Over £50",
                                      isSelected: controller.selectedPriceRange.value == 'over50',
                                      onSelected: () => controller.setPriceRange('over50'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // Rating Filter
                        _buildFilterSection(
                          title: "Rating",
                          child: Obx(() {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildFilterChip(
                                  label: "All",
                                  isSelected: controller.selectedRating.value == 0,
                                  onSelected: () => controller.setRating(0),
                                ),
                                _buildFilterChip(
                                  label: "3+ ⭐",
                                  isSelected: controller.selectedRating.value == 3,
                                  onSelected: () => controller.setRating(3),
                                ),
                                _buildFilterChip(
                                  label: "3.5+ ⭐",
                                  isSelected: controller.selectedRating.value == 3.5,
                                  onSelected: () => controller.setRating(3.5),
                                ),
                                _buildFilterChip(
                                  label: "4+ ⭐",
                                  isSelected: controller.selectedRating.value == 4,
                                  onSelected: () => controller.setRating(4),
                                ),
                                _buildFilterChip(
                                  label: "4.5+ ⭐",
                                  isSelected: controller.selectedRating.value == 4.5,
                                  onSelected: () => controller.setRating(4.5),
                                ),
                                _buildFilterChip(
                                  label: "5 ⭐",
                                  isSelected: controller.selectedRating.value == 5,
                                  onSelected: () => controller.setRating(5),
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // Sort Options
                        _buildFilterSection(
                          title: "Sort By",
                          child: Obx(() {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildFilterChip(
                                  label: "Popular",
                                  isSelected: controller.selectedSort.value == 'popular',
                                  onSelected: () => controller.setSort('popular'),
                                ),
                                _buildFilterChip(
                                  label: "Price: Low-High",
                                  isSelected: controller.selectedSort.value == 'priceAsc',
                                  onSelected: () => controller.setSort('priceAsc'),
                                ),
                                _buildFilterChip(
                                  label: "Price: High-Low",
                                  isSelected: controller.selectedSort.value == 'priceDesc',
                                  onSelected: () => controller.setSort('priceDesc'),
                                ),
                                _buildFilterChip(
                                  label: "Rating",
                                  isSelected: controller.selectedSort.value == 'rating',
                                  onSelected: () => controller.setSort('rating'),
                                ),
                              ],
                            );
                          }),
                        ),

                        const SizedBox(height: 24),

                        // Apply Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.applyFilters();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontSize: 16,
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.tomato,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide(
        color: isSelected ? AppColors.tomato : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

  // Product Card
  Widget _buildProductCard(ProductModel item) {
    return GestureDetector(
      onTap: () => controller.goToProductDetails(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Obx(
                      () => AnimatedFavoriteButton(
                        isFavorite: controller.isFavorite(item),
                        size: 18,
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
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (item.oldPrice != null) ...[
                        Text(
                          "£ ${item.oldPrice!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black38,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        "£ ${item.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 15,
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