import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/controller/product_details_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/controller/add_to-cart_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/view/add_to_cart_view.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/animated_favourite_button.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends GetView<ProductDetailsController> {
  ProductDetailsScreen({super.key});

  final GlobalKey _cartKey = GlobalKey();
  bool _isAddingToCart = false;

  // ========== CartController Getter ==========
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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.tomato, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(controller.product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }


  // ========== Add to Cart with Animation & Navigation ==========
  void _addToCartWithAnimation(BuildContext context) {
    if (_isAddingToCart) return;
    _isAddingToCart = true;

    // 1. Cart Controller এ Add করুন
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
      name: controller.product.name,
      imageUrl: controller.product.imageUrl,
      price: controller.product.price,
      oldPrice: controller.product.oldPrice,
      quantity: controller.quantity.value,
      addOns: selectedAddOns,
    );

    // 2. Fly Animation চালান
    _runFlyToCartAnimation(context, () {
      _isAddingToCart = false;
      // Cart Screen এ Navigate করুন
      Get.to(
        () => const MyBasketScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  // ========== Navigate to Cart ==========
  void _navigateToCart() {
    Get.to(
      () => const MyBasketScreen(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ========== Scrollable Content ==========
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(24),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(controller.product.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Back Button
                      Positioned(
                        top: 44,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
      
                      // Wishlist Button
                      Positioned(
                        bottom: 16,
                        right: 20,
                        child: Obx(
                          () => AnimatedFavoriteButton(
                            isFavorite: controller.isFavorite.value,
                            size: 24,
                            onTap: (newValue) {
                              controller.isFavorite.value = newValue;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 20),
      
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
      
                            // ========== Cart Icon ==========
                            GestureDetector(
                              onTap: _navigateToCart,
                              child: Container(
                                key: _cartKey,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.tomato,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Obx(
                                  () => Stack(
                                    children: [
                                      const Icon(
                                        Icons.shopping_cart_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      if (_cartController.cartItems.isNotEmpty)
                                        Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${_cartController.totalItems}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
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
                        const SizedBox(height: 8),
      
                        Row(
                          children: [
                            if (controller.product.oldPrice != null) ...[
                              Text(
                                "£ ${controller.product.oldPrice!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black38,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              "£ ${controller.product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tomato,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
      
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              "${controller.product.rating}  (1,205)",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
      
                              onTap: () => Get.toNamed(Routes.REVIEW_ITEM),
                              child: Text(
                                "See all reviews",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tomato,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
      
                        const Text(
                          "A delicious chicken burger served on a toasted bun with fresh lettuce, tomato slices, and mayonnaise. Juicy grilled chicken patty seasoned to perfection...",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
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
      
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black12),
                        const SizedBox(height: 10),
      
                        // Additional Options
                        const Text(
                          "Additional Options :",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
      
                        Obx(
                          () => _buildOptionRow(
                            "Add Cheese",
                            "+ £0.50",
                            controller.addCheese.value,
                            (val) => controller.addCheese.value = val!,
                          ),
                        ),
                        Obx(
                          () => _buildOptionRow(
                            "Add Bacon",
                            "+ £1.00",
                            controller.addBacon.value,
                            (val) => controller.addBacon.value = val!,
                          ),
                        ),
                        Obx(
                          () => _buildOptionRow(
                            "Add Meat",
                            "+ £2.00",
                            controller.addMeat.value,
                            (val) => controller.addMeat.value = val!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            // ========== Pinned Bottom Navigation Bar ==========
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                    // Quantity Selector
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: controller.decrement,
                            icon: const Icon(Icons.remove, size: 20),
                          ),
                          Obx(
                            () => Text(
                              "${controller.quantity.value}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: controller.increment,
                            icon: const Icon(Icons.add, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
      
                    // Add to Basket Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isAddingToCart
                            ? null
                            : () => _addToCartWithAnimation(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isAddingToCart
                              ? Colors.grey
                              : AppColors.tomato,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        icon: _isAddingToCart
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                              ),
                        label: Text(
                          _isAddingToCart ? "Adding..." : "Add to Basket",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
      ),
    );
  }

  Widget _buildOptionRow(
    String title,
    String price,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.tomato,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
