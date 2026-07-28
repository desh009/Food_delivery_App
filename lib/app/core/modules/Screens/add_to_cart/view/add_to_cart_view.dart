// lib/app/core/modules/Screens/add_to_cart/view/add_to_cart_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/controller/add_to-cart_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/add_new_card/add_new_card.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class MyBasketScreen extends StatelessWidget {
  const MyBasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CartController চেক ও ইনিশিয়ালাইজেশন
    final CartController cartController;
    if (Get.isRegistered<CartController>()) {
      cartController = Get.find<CartController>();
    } else {
      cartController = Get.put(CartController());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                top: 16.h, // ✅ 50.h → 16.h
                left: 16.w, // ✅ 20.w → 16.w
                right: 16.w, // ✅ 20.w → 16.w
                bottom: 120.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h), // ✅ 24.h → 20.h
                  _buildOrderSummaryHeader(),
                  SizedBox(height: 14.h), // ✅ 16.h → 14.h

                  Obx(() {
                    if (cartController.cartItems.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartController.cartItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h), // ✅ 16.h → 14.h
                          child: _buildCartItem(item, cartController),
                        );
                      },
                    );
                  }),

                  SizedBox(height: 20.h), // ✅ 24.h → 20.h

                  // ========== Deliver To Tile ==========
                  _buildInfoTile(
                    Icons.location_on_rounded,
                    "Deliver to",
                    "Select Your Location",
                  ),
                  SizedBox(height: 10.h), // ✅ 12.h → 10.h

                  // ========== Payment Method Tile ==========
                  _buildPaymentMethodTile(context, cartController),

                  SizedBox(height: 10.h), // ✅ 12.h → 10.h

                  // ========== Promotions Tile ==========
                  _buildInfoTile(
                    Icons.confirmation_number_rounded,
                    "Promotions",
                    "Select Your Discounts",
                  ),
                  SizedBox(height: 20.h), // ✅ 24.h → 20.h

                  Obx(() => _buildBillDetails(cartController)),
                  
                  SizedBox(height: 16.h),
                ],
              ),
            ),

            // ========== Bottom Bar ==========
            Obx(() => _buildPinnedBottomBar(cartController, context)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 80.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              "Your basket is empty!",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Add some delicious items",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tomato,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
              ),
              child: Text(
                "Browse Food",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(8.r), // ✅ 10.r → 8.r
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black87,
              size: 20.sp, // ✅ added size
            ),
          ),
        ),
        Expanded(
          child: Text(
            "My Basket",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp, // ✅ 20.sp → 18.sp
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 36.w), // ✅ 44.w → 36.w
      ],
    );
  }

  // ============================================================
  // ORDER SUMMARY HEADER
  // ============================================================
  Widget _buildOrderSummaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 15.sp, // ✅ 16.sp → 15.sp
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            side: BorderSide(color: AppColors.tomato, width: 1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r), // ✅ 20.r → 16.r
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 10.w, // ✅ 12.w → 10.w
              vertical: 3.h, // ✅ 4.h → 3.h
            ),
          ),
          child: Text(
            "Add Items",
            style: TextStyle(
              color: AppColors.tomato,
              fontSize: 11.sp, // ✅ 12.sp → 11.sp
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT METHOD TILE
  // ============================================================
  Widget _buildPaymentMethodTile(
    BuildContext context,
    CartController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), // ✅ 14.r → 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showPaymentBottomSheet(context, controller),
        leading: Container(
          padding: EdgeInsets.all(6.r), // ✅ 8.r → 6.r
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.credit_card_rounded,
            color: AppColors.tomato,
            size: 18.sp, // ✅ 20.sp → 18.sp
          ),
        ),
        title: Text(
          "Payment method",
          style: TextStyle(
            fontSize: 13.sp, // ✅ 14.sp → 13.sp
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Obx(
          () => Text(
            controller.selectedPaymentMethod.value.isEmpty
                ? "Select Payment Method"
                : controller.selectedPaymentMethod.value,
            style: TextStyle(
              fontSize: 11.sp, // ✅ 12.sp → 11.sp
              color: Colors.black38,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp, // ✅ 16.sp → 14.sp
          color: Colors.black38,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w, // ✅ added
          vertical: 4.h,
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT BOTTOM SHEET
  // ============================================================
  void _showPaymentBottomSheet(
    BuildContext context,
    CartController controller,
  ) {
    final RxString tempSelected =
        (controller.selectedPaymentMethod.value.isEmpty
                ? 'Cash'
                : controller.selectedPaymentMethod.value)
            .obs;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, // ✅ 20.w → 16.w
          vertical: 14.h, // ✅ 16.h → 14.h
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)), // ✅ 28.r → 24.r
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(6.r), // ✅ 8.r → 6.r
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8.r,
                            offset: Offset(0, 2.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 18.sp, // ✅ 20.sp → 18.sp
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Payment Methods",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp, // ✅ 18.sp → 16.sp
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.w), // ✅ 36.w → 30.w
                ],
              ),
              SizedBox(height: 20.h), // ✅ 24.h → 20.h

              // Payment Options
              Obx(
                () => Column(
                  children: [
                    _buildBottomSheetOptionItem(
                      title: "Cash",
                      iconWidget: Icon(
                        Icons.payments_rounded,
                        color: Colors.green,
                        size: 20.sp, // ✅ 22.sp → 20.sp
                      ),
                      value: "Cash",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 10.h), // ✅ 12.h → 10.h
                    _buildBottomSheetOptionItem(
                      title: "PayPal",
                      iconWidget: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.blue,
                        size: 20.sp,
                      ),
                      value: "PayPal",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 10.h),
                    _buildBottomSheetOptionItem(
                      title: "Google Pay",
                      iconWidget: Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.deepOrange,
                        size: 24.sp, // ✅ 28.sp → 24.sp
                      ),
                      value: "Google Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 10.h),
                    _buildBottomSheetOptionItem(
                      title: "Apple Pay",
                      iconWidget: Icon(
                        Icons.apple_rounded,
                        color: Colors.black,
                        size: 22.sp, // ✅ 24.sp → 22.sp
                      ),
                      value: "Apple Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 10.h),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 0895",
                      iconWidget: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.indigo,
                        size: 20.sp,
                      ),
                      value: "**** **** **** 0895",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 10.h),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 2259",
                      iconWidget: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.orange,
                        size: 20.sp,
                      ),
                      value: "**** **** **** 2259",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 14.h), // ✅ 16.h → 14.h

              // Add New Card
              InkWell(
                onTap: () {
                  Get.back();
                  AddNewCardBottomSheet.show(context);
                },
                borderRadius: BorderRadius.circular(12.r), // ✅ 14.r → 12.r
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h), // ✅ 14.h → 12.h
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.tomato,
                        size: 16.sp, // ✅ 18.sp → 16.sp
                      ),
                      SizedBox(width: 6.w), // ✅ 8.w → 6.w
                      Text(
                        "Add New Card",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 13.sp, // ✅ 14.sp → 13.sp
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h), // ✅ 24.h → 20.h

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 46.h, // ✅ 50.h → 46.h
                child: ElevatedButton(
                  onPressed: () {
                    controller.selectedPaymentMethod.value = tempSelected.value;
                    controller.update();
                    Get.back();

                    Get.snackbar(
                      'Success',
                      'Payment method set to ${tempSelected.value}',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tomato,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r), // ✅ 25.r → 22.r
                    ),
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp, // ✅ 16.sp → 15.sp
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h), // ✅ 10.h → 8.h
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ============================================================
  // BOTTOM SHEET OPTION ITEM
  // ============================================================
  Widget _buildBottomSheetOptionItem({
    required String title,
    required Widget iconWidget,
    required String value,
    required String groupValue,
    required Function(String) onSelect,
  }) {
    final isSelected = groupValue == value;

    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w, // ✅ 16.w → 14.w
          vertical: 12.h, // ✅ 14.h → 12.h
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r), // ✅ 14.r → 12.r
          border: Border.all(
            color: isSelected ? AppColors.tomato : Colors.grey.shade200,
            width: isSelected ? 2.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 26.w,
              height: 26.h,
              child: Center(child: iconWidget),
            ),
            SizedBox(width: 12.w), // ✅ 14.w → 12.w
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp, // ✅ 14.sp → 13.sp
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Container(
              width: 18.w, // ✅ 20.w → 18.w
              height: 18.h, // ✅ 20.h → 18.h
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.tomato : Colors.grey.shade300,
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO TILE
  // ============================================================
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), // ✅ 14.r → 12.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Get.snackbar(
            title,
            'Feature coming soon!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        leading: Container(
          padding: EdgeInsets.all(6.r), // ✅ 8.r → 6.r
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.tomato,
            size: 18.sp, // ✅ 20.sp → 18.sp
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp, // ✅ 14.sp → 13.sp
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11.sp, // ✅ 12.sp → 11.sp
            color: Colors.black38,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp, // ✅ 16.sp → 14.sp
          color: Colors.black38,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 2.h,
        ),
      ),
    );
  }

  // ============================================================
  // CART ITEM
  // ============================================================
  Widget _buildCartItem(CartItem item, CartController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r), // ✅ 16.r → 14.r
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.r), // ✅ 12.r → 10.r
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r), // ✅ 12.r → 10.r
                child: Image.network(
                  item.imageUrl,
                  width: 60.w, // ✅ 70.w → 60.w
                  height: 60.h, // ✅ 70.h → 60.h
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60.w,
                      height: 60.h,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 24.sp,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10.w), // ✅ 12.w → 10.w
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 13.sp, // ✅ 14.sp → 13.sp
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 3.h), // ✅ 4.h → 3.h
                    Row(
                      children: [
                        if (item.oldPrice != null) ...[
                          Text(
                            "£ ${item.oldPrice!.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 12.sp, // ✅ 13.sp → 12.sp
                              color: Colors.black38,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w), // ✅ 8.w → 6.w
                        ],
                        Text(
                          "£ ${item.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 13.sp, // ✅ 14.sp → 13.sp
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h), // ✅ 8.h → 6.h
                    Obx(
                      () => Row(
                        children: [
                          _buildCounterButton(Icons.remove, () {
                            if (item.quantity.value > 1) {
                              item.quantity.value--;
                              controller.cartItems.refresh();
                            }
                          }),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w, // ✅ 12.w → 10.w
                            ),
                            child: Text(
                              "${item.quantity.value}",
                              style: TextStyle(
                                fontSize: 13.sp, // ✅ 14.sp → 13.sp
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildCounterButton(Icons.add, () {
                            item.quantity.value++;
                            controller.cartItems.refresh();
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 16.sp, // ✅ 18.sp → 16.sp
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: Colors.black38,
                    ),
                    onPressed: () => controller.removeItem(item),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),

          if (item.addOns.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h), // ✅ 8.h → 6.h
              child: Divider(color: const Color(0xFFF5F5F5)),
            ),
            Column(
              children: item.addOns.map((addOn) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h), // ✅ 2.h → 1.h
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addOn["name"]!,
                        style: TextStyle(
                          fontSize: 11.sp, // ✅ 12.sp → 11.sp
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "+ £${(addOn["price"] as double).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.tomato,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.r), // ✅ 4.r → 3.r
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(
          icon,
          size: 12.sp, // ✅ 14.sp → 12.sp
          color: Colors.black87,
        ),
      ),
    );
  }

  // ============================================================
  // BILL DETAILS
  // ============================================================
  Widget _buildBillDetails(CartController controller) {
    return Container(
      padding: EdgeInsets.all(14.r), // ✅ added padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBillRow(
            "Subtotal",
            "£ ${controller.subtotal.toStringAsFixed(2)}",
            isBold: true,
          ),
          SizedBox(height: 6.h), // ✅ 8.h → 6.h
          _buildBillRow(
            "Delivery Fee",
            controller.selectedPaymentMethod.value.isEmpty ? "—" : "£ 0.00",
          ),
          SizedBox(height: 6.h),
          _buildBillRow("Discount", "—"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h), // ✅ 12.h → 10.h
            child: Divider(color: Colors.black12),
          ),
          _buildBillRow(
            "Total",
            "£ ${controller.total.toStringAsFixed(2)}",
            isBold: true,
            fontSize: 15.sp, // ✅ 16.sp → 15.sp
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 13.0, // default size when no scaled size is provided
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black87 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: isBold ? AppColors.tomato : Colors.black87,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PINNED BOTTOM BAR
  // ============================================================
  Widget _buildPinnedBottomBar(
    CartController controller,
    BuildContext context,
  ) {
    return Positioned(
      bottom: 0, // ✅ 20.h → 0
      left: 0, // ✅ 20.w → 0
      right: 0, // ✅ 20.w → 0
      child: Container(
        height: 70.h, // ✅ 80.h → 70.h
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, // ✅ 24.w → 16.w
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r), // ✅ 24.r → 20.r
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16.r,
              offset: Offset(0, -4.h),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "£ ${controller.total.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18.sp, // ✅ 20.sp → 18.sp
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            ElevatedButton(
              onPressed: controller.cartItems.isEmpty
                  ? null
                  : () => _showPlaceOrderDialog(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tomato,
                padding: EdgeInsets.symmetric(
                  horizontal: 28.w, // ✅ 36.w → 28.w
                  vertical: 12.h, // ✅ 14.h → 12.h
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r), // ✅ 18.r → 16.r
                ),
              ),
              child: Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp, // ✅ 16.sp → 14.sp
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PLACE ORDER DIALOG
  // ============================================================
  void _showPlaceOrderDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r), // ✅ 24.r → 20.r
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20.r), // ✅ 24.r → 20.r
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70.w, // ✅ 80.w → 70.w
                  height: 70.h, // ✅ 80.h → 70.h
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 44.sp, // ✅ 50.sp → 44.sp
                  ),
                ),
                SizedBox(height: 14.h), // ✅ 16.h → 14.h
                Text(
                  "Order Placed!",
                  style: TextStyle(
                    fontSize: 22.sp, // ✅ 24.sp → 22.sp
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h), // ✅ 8.h → 6.h
                Text(
                  "Your order has been placed successfully!",
                  style: TextStyle(
                    fontSize: 13.sp, // ✅ 14.sp → 13.sp
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w, // ✅ 16.w → 14.w
                    vertical: 6.h, // ✅ 8.h → 6.h
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r), // ✅ 12.r → 10.r
                  ),
                  child: Text(
                    "Total: £${controller.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 15.sp, // ✅ 16.sp → 15.sp
                      fontWeight: FontWeight.bold,
                      color: AppColors.tomato,
                    ),
                  ),
                ),
                SizedBox(height: 16.h), // ✅ 20.h → 16.h
                Container(
                  padding: EdgeInsets.all(10.r), // ✅ 12.r → 10.r
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10.r), // ✅ 12.r → 10.r
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 12.sp, // ✅ 13.sp → 12.sp
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "${controller.totalItems} items",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h), // ✅ 4.h → 3.h
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Estimated Delivery",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "20-30 min",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              controller.selectedPaymentMethod.value.isEmpty
                                  ? "Cash on Delivery"
                                  : controller.selectedPaymentMethod.value,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h), // ✅ 20.h → 16.h
                SizedBox(
                  width: double.infinity,
                  height: 46.h, // ✅ 50.h → 46.h
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.clearCart();
                      Get.offAllNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r), // ✅ 16.r → 14.r
                      ),
                    ),
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp, // ✅ 16.sp → 15.sp
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h), // ✅ 12.h → 10.h
                SizedBox(
                  width: double.infinity,
                  height: 42.h, // ✅ 45.h → 42.h
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Get.snackbar(
                        "Order Tracking",
                        "Your order is on the way!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.tomato, width: 1.5.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      "Track Order",
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 14.sp, // ✅ 15.sp → 14.sp
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}