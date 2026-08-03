// lib/app/core/modules/Screens/Special_offer_screen/view/special_offer_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/controller/special_offer_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';
import 'package:get/get.dart';

class SpecialOffersScreen extends GetView<SpecialOffersController> {
  const SpecialOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // ========== অ্যাপ বার - 🔥 Dark Mode Support ==========
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF333333) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black54 : Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : Colors.black87,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Special Offers",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),

              SizedBox(height: 20.h),

              // ========== সার্চ বার - 🔥 Dark Mode Support ==========
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF333333) : const Color(0xFFF3F3F4),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey.shade500 : Colors.black38,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.grey.shade500 : Colors.black38,
                      size: 20.sp,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      onPressed: controller.onFilterTap,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ========== Products Grid - 🔥 Dark Mode Support ==========
              Expanded(
                child: Obx(() {
                  // 🔥 Loading State
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.tomato,
                      ),
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
                            size: 60.sp,
                            color: isDark ? Colors.red.shade300 : Colors.red,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isDark ? Colors.red.shade300 : Colors.red,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => controller.loadProducts(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = controller.filteredProducts;

                  // 🔥 Empty State - Dark Mode Support
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60.sp,
                            color: isDark ? Colors.grey.shade600 : Colors.black26,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: isDark ? Colors.grey.shade400 : Colors.black38,
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            color: isDark ? const Color(0xFF242424) : Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black54 : Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: Offset(0, 5),
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
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14.r),
                                    ),
                                    child: Image.network(
                                      product['image'] ?? '',
                                      height: 85.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 85.h,
                                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                                          child: Icon(
                                            Icons.broken_image,
                                            color: isDark ? Colors.grey[600] : Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.h,
                                    right: 6.w,
                                    child: AnimatedFavoriteButton(
                                      isFavorite:
                                          product['isFavorite'] ?? false,
                                      size: 14.sp,
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

                              // ===== Product Info - Dark Mode Support =====
                              Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 3.h),

                                    // Rating
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 12.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          product['rating'] ?? '0.0',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: isDark ? Colors.grey.shade400 : Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),

                                    // Price
                                    Row(
                                      children: [
                                        Text(
                                          "£ ${(product['oldPrice'] ?? 0.0).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: isDark ? Colors.grey.shade500 : Colors.black38,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(
                                          "£ ${(product['newPrice'] ?? 0.0).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
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