import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/controller/special_offer_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:get/get.dart';

class SpecialOffersScreen extends GetView<SpecialOffersController> {
  const SpecialOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ========== অ্যাপ বার ==========
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Special Offers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),

              const SizedBox(height: 20),

              // ========== সার্চ বার (Filter সহ) ==========
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black38,
                      size: 20,
                    ),
                    // ✅ Filter Icon - BottomSheet Call করবে
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.black87),
                      onPressed: controller.onFilterTap,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ========== Products Grid ==========
              Expanded(
                child: Obx(() {
                  // 🔥 Loading State
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.tomato),
                    );
                  }

                  // 🔥 Error State
                  if (controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.loadProducts(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = controller.filteredProducts;

                  // 🔥 Empty State
                  if (products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.black26,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // 🔥 Products Grid
                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () => controller.goToProductDetails(product),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ===== Image =====
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(14),
                                    ),
                                    child: Image.network(
                                      product['image'] ?? '',
                                      height: 85,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 85,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: AnimatedFavoriteButton(
                                      isFavorite:
                                          product['isFavorite'] ?? false,
                                      size: 14,
                                      onTap: (newValue) {
                                        final originalIndex = controller
                                            .specialProducts
                                            .indexWhere(
                                              (p) => p['id'] == product['id'],
                                            );
                                        if (originalIndex != -1) {
                                          controller.toggleFavorite(
                                            originalIndex,
                                            newValue,
                                          );
                                        }
                                      },
                                      navigateOnAdd: false,
                                    ),
                                  ),
                                ],
                              ),

                              // ===== Product Info =====
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] ?? 'Unknown',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),

                                    // Rating
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          product['rating'] ?? '0.0',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),

                                    // Price
                                    Row(
                                      children: [
                                        Text(
                                          "£ ${(product['oldPrice'] ?? 0.0).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "£ ${(product['newPrice'] ?? 0.0).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 12,
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
}
