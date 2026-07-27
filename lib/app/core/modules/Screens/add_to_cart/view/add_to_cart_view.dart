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
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              bottom: 120.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildOrderSummaryHeader(),
                SizedBox(height: 16.h),

                Obx(() {
                  if (cartController.cartItems.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.0.h),
                        child: Text(
                          "Your basket is empty!",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0.h),
                        child: _buildCartItem(item, cartController),
                      );
                    },
                  );
                }),

                SizedBox(height: 24.h),

                // ========== Deliver To Tile ==========
                _buildInfoTile(
                  Icons.location_on_rounded,
                  "Deliver to",
                  "Select Your Location",
                ),
                SizedBox(height: 12.h),

                // ========== Payment Method Tile (Opens BottomSheet) ==========
                _buildPaymentMethodTile(context, cartController),

                SizedBox(height: 12.h),

                // ========== Promotions Tile ==========
                _buildInfoTile(
                  Icons.confirmation_number_rounded,
                  "Promotions",
                  "Select Your Discounts",
                ),
                SizedBox(height: 24.h),

                Obx(() => _buildBillDetails(cartController)),
              ],
            ),
          ),

          Obx(() => _buildPinnedBottomBar(cartController, context)),
        ],
      ),
    );
  }

  // ========== Header ==========
  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            padding: EdgeInsets.all(10.r),
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
            child: Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        Expanded(
          child: Text(
            "My Basket",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(width: 44.w),
      ],
    );
  }

  // ========== Order Summary Header ==========
  Widget _buildOrderSummaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            side: BorderSide(color: AppColors.tomato, width: 1.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          ),
          child: Text(
            "Add Items",
            style: TextStyle(
              color: AppColors.tomato,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ========== ✅ Payment Method Tile (Opens BottomSheet) ==========
  Widget _buildPaymentMethodTile(
    BuildContext context,
    CartController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showPaymentBottomSheet(context, controller),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.credit_card_rounded,
            color: AppColors.tomato,
            size: 20.sp,
          ),
        ),
        title: Text(
          "Payment method",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Obx(
          () => Text(
            controller.selectedPaymentMethod.value.isEmpty
                ? "Select Payment Method"
                : controller.selectedPaymentMethod.value,
            style: TextStyle(fontSize: 12.sp, color: Colors.black38),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp,
          color: Colors.black38,
        ),
      ),
    );
  }

  // ========== 🟢 Bottom Sheet for Payment Selection (Pixel Perfect UI) ==========
  void _showPaymentBottomSheet(
    BuildContext context,
    CartController controller,
  ) {
    // Temp variable to hold user selection before clicking 'Apply'
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        size: 20.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Payment Methods",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: 36.w), // Alignment Balance
                ],
              ),
              SizedBox(height: 24.h),

              // Payment Options
              Obx(
                () => Column(
                  children: [
                    _buildBottomSheetOptionItem(
                      title: "Cash",
                      iconWidget: Icon(
                        Icons.payments_rounded,
                        color: Colors.green,
                        size: 22.sp,
                      ),
                      value: "Cash",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetOptionItem(
                      title: "PayPal",
                      iconWidget: Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.blue,
                        size: 22.sp,
                      ),
                      value: "PayPal",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetOptionItem(
                      title: "Google Pay",
                      iconWidget: Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.deepOrange,
                        size: 28.sp,
                      ),
                      value: "Google Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetOptionItem(
                      title: "Apple Pay",
                      iconWidget: Icon(
                        Icons.apple_rounded,
                        color: Colors.black,
                        size: 24.sp,
                      ),
                      value: "Apple Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 0895",
                      iconWidget: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.indigo,
                        size: 22.sp,
                      ),
                      value: "**** **** **** 0895",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    SizedBox(height: 12.h),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 2259",
                      iconWidget: Icon(
                        Icons.credit_card_rounded,
                        color: Colors.orange,
                        size: 22.sp,
                      ),
                      value: "**** **** **** 2259",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Add New Card Button
              InkWell(
                onTap: () {
                  Get.back();
                  AddNewCardBottomSheet.show(context);
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.tomato, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "Add New Card",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
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
                      duration: Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tomato,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ========== Bottom Sheet Option Tile Builder ==========
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200, width: 1.w),
        ),
        child: Row(
          children: [
            SizedBox(width: 30.w, height: 30.h, child: Center(child: iconWidget)),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Custom Radio Circle
            Container(
              width: 20.w,
              height: 20.h,
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

  // ========== Info Tile ==========
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
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
            duration: Duration(seconds: 2),
          );
        },
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.tomato, size: 20.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12.sp, color: Colors.black38),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16.sp,
          color: Colors.black38,
        ),
      ),
    );
  }

  // ========== Cart Item ==========
  Widget _buildCartItem(CartItem item, CartController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.r),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  item.imageUrl,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70.w,
                      height: 70.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (item.oldPrice != null) ...[
                          Text(
                            "£ ${item.oldPrice!.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black38,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          "£ ${item.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
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
                              horizontal: 12.0.w,
                            ),
                            child: Text(
                              "${item.quantity.value}",
                              style: TextStyle(
                                fontSize: 14.sp,
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18.sp,
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: Colors.black38,
                    ),
                    onPressed: () => controller.removeItem(item),
                  ),
                ],
              ),
            ],
          ),

          if (item.addOns.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.h),
              child: Divider(color: Color(0xFFF5F5F5)),
            ),
            Column(
              children: item.addOns.map((addOn) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addOn["name"]!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "+ £${(addOn["price"] as double).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12.sp,
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
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 14.sp, color: Colors.black87),
      ),
    );
  }

  // ========== Bill Details ==========
  Widget _buildBillDetails(CartController controller) {
    return Column(
      children: [
        _buildBillRow(
          "Subtotal",
          "£ ${controller.subtotal.toStringAsFixed(2)}",
          isBold: true,
        ),
        SizedBox(height: 8.h),
        _buildBillRow(
          "Delivery Fee",
          controller.selectedPaymentMethod.value.isEmpty ? "—" : "£ 0.00",
        ),
        SizedBox(height: 8.h),
        _buildBillRow("Discount", "—"),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0.h),
          child: Divider(color: Colors.black12),
        ),
        _buildBillRow(
          "Total",
          "£ ${controller.total.toStringAsFixed(2)}",
          isBold: true,
          fontSize: 16.sp,
        ),
      ],
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ========== Pinned Bottom Bar ==========
  Widget _buildPinnedBottomBar(
    CartController controller,
    BuildContext context,
  ) {
    return Positioned(
      bottom: 20.h,
      left: 20.w,
      right: 20.w,
      child: Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "£ ${controller.total.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 20.sp,
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
                  horizontal: 36.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
              ),
              child: Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== Place Order Dialog ==========
  void _showPlaceOrderDialog(BuildContext context, CartController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 50.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Order Placed!",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Your order has been placed successfully!",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "Total: £${controller.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tomato,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "${controller.totalItems} items",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Estimated Delivery",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "20-30 min",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              controller.selectedPaymentMethod.value.isEmpty
                                  ? "Cash on Delivery"
                                  : controller.selectedPaymentMethod.value,
                              style: TextStyle(
                                fontSize: 13.sp,
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
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.clearCart();
                      Get.offAllNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  height: 45.h,
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
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      "Track Order",
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 15.sp,
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
