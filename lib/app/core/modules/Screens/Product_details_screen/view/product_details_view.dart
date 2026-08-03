// lib/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/controller/product_details_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/controller/add_to-cart_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/view/add_to_cart_view.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends GetView<ProductDetailsController> {
  final ProductModel product;

  ProductDetailsScreen({super.key, required this.product});

  final GlobalKey _cartKey = GlobalKey();
  bool _isAddingToCart = false;

  CartController get _cartController => CartController.instance;

  // ========== Fly to Cart Animation ==========
  void _runFlyToCartAnimation(BuildContext context, VoidCallback onComplete) {
    final RenderBox? cartBox =
        _cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null) {
      onComplete();
      return;
    }

    final Offset cartOffset = cartBox.localToGlobal(Offset.zero);
    final Size screenSize = MediaQuery.of(context).size;

    final Offset startOffset = Offset(
      screenSize.width / 2 - 25,
      screenSize.height - 100,
    );

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutQuad,
        tween: Tween<double>(begin: 0.0, end: 1.0),
        onEnd: () {
          overlayEntry.remove();
          onComplete();
        },
        builder: (context, value, child) {
          final Offset currentOffset = Offset.lerp(
            startOffset,
            cartOffset,
            value,
          )!;
          final double currentScale = 1.0 - (value * 0.7);
          final double opacity = 1.0 - (value * 0.3);

          return Positioned(
            left: currentOffset.dx,
            top: currentOffset.dy,
            child: Transform.scale(
              scale: currentScale,
              child: Opacity(opacity: opacity, child: child),
            ),
          );
        },
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.tomato, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  // ========== Add to Cart ==========
  void _addToCartWithAnimation(BuildContext context) {
    if (_isAddingToCart) return;
    _isAddingToCart = true;

    final cartController = _cartController;

    List<Map<String, dynamic>> selectedAddOns = [];
    if (controller.addCheese.value) {
      selectedAddOns.add({"name": "Add Cheese", "price": 0.50});
    }
    if (controller.addBacon.value) {
      selectedAddOns.add({"name": "Add Bacon", "price": 1.00});
    }
    if (controller.addMeat.value) {
      selectedAddOns.add({"name": "Add Meat (Extra Patty)", "price": 2.00});
    }

    cartController.addToCart(
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      oldPrice: product.oldPrice,
      quantity: controller.quantity.value,
      addOns: selectedAddOns,
    );

    controller.addCheese.value = false;
    controller.addBacon.value = false;
    controller.addMeat.value = false;
    controller.quantity.value = 1;

    _isAddingToCart = false;

    _runFlyToCartAnimation(context, () {
      _isAddingToCart = false;
      Get.to(
        () => const MyBasketScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    });

    Get.snackbar(
      'Added to Cart 🛒',
      '${product.name} added to your cart!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _navigateToCart() {
    Get.to(
      () => const MyBasketScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 Theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: Stack(
        children: [
          // ============================================================
          // MAIN CONTENT - Clickable Area (Bottom Sheet Close করার জন্য)
          // ============================================================
          GestureDetector(
            onTap: () {
              // 🔥 Bottom Sheet Open থাকলে Close করুন
              if (Get.isBottomSheetOpen ?? false) {
                Get.back();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 110.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(24.r),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 44.h,
                        left: 20.w,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: isDark ? Colors.white : Colors.black87,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        right: 20.w,
                        child: Obx(
                          () => AnimatedFavoriteButton(
                            isFavorite: controller.isFavorite.value,
                            size: 24.sp,
                            onTap: (newValue) {
                              controller.isFavorite.value = newValue;
                              controller.toggleFavorite();
                            },
                            navigateOnAdd: false,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: _navigateToCart,
                              child: Container(
                                key: _cartKey,
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.tomato,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Obx(
                                  () => Stack(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 24.sp,
                                      ),
                                      if (_cartController.cartItems.isNotEmpty)
                                        Positioned(
                                          right: -4.w,
                                          top: -4.h,
                                          child: Container(
                                            padding: EdgeInsets.all(4.r),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${_cartController.totalItems}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        Row(
                          children: [
                            if (product.oldPrice != null) ...[
                              Text(
                                "£ ${product.oldPrice!.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: isDark ? Colors.grey.shade500 : Colors.black38,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 12.w),
                            ],
                            Text(
                              "£ ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tomato,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20.sp),
                            SizedBox(width: 4.w),
                            Text(
                              "${product.rating}  (1,205)",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.grey.shade400 : Colors.black54,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.REVIEW_ITEM),
                              child: Text(
                                "See all reviews",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tomato,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        Text(
                          product.description.isNotEmpty
                              ? product.description
                              : "A delicious ${product.name} served with fresh ingredients. Made with love and care.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark ? Colors.grey.shade400 : Colors.black54,
                            height: 1.5.h,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "See more",
                            style: TextStyle(
                              color: AppColors.tomato,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),
                        Divider(
                          color: isDark ? Colors.grey.shade800 : Colors.black12,
                        ),
                        SizedBox(height: 10.h),

                        Text(
                          "Additional Options :",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        Obx(
                          () => _buildOptionRow(
                            "Add Cheese",
                            "+ £0.50",
                            controller.addCheese.value,
                            (val) => controller.addCheese.value = val!,
                            isDark,
                          ),
                        ),
                        Obx(
                          () => _buildOptionRow(
                            "Add Bacon",
                            "+ £1.00",
                            controller.addBacon.value,
                            (val) => controller.addBacon.value = val!,
                            isDark,
                          ),
                        ),
                        Obx(
                          () => _buildOptionRow(
                            "Add Meat",
                            "+ £2.00",
                            controller.addMeat.value,
                            (val) => controller.addMeat.value = val!,
                            isDark,
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // PINNED BOTTOM NAVIGATION BAR
          // ============================================================
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 80.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242424) : Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: controller.decrement,
                          icon: Icon(
                            Icons.remove,
                            size: 20.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Obx(
                          () => Text(
                            "${controller.quantity.value}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.increment,
                          icon: Icon(
                            Icons.add,
                            size: 20.sp,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isAddingToCart
                          ? null
                          : () => _addToCartWithAnimation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAddingToCart
                            ? (isDark ? Colors.grey.shade700 : Colors.grey)
                            : AppColors.tomato,
                        minimumSize: Size(double.infinity, 54.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        elevation: 0,
                      ),
                      icon: _isAddingToCart
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.r,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                            ),
                      label: Text(
                        _isAddingToCart ? "Adding..." : "Add to Basket",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
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
  }

  Widget _buildOptionRow(
    String title,
    String price,
    bool value,
    ValueChanged<bool?> onChanged,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Row(
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey.shade400 : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.tomato,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                checkColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}