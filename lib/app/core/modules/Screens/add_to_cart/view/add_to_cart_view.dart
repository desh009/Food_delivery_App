import 'package:flutter/material.dart';
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
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildOrderSummaryHeader(),
                const SizedBox(height: 16),

                Obx(() {
                  if (cartController.cartItems.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Text(
                          "Your basket is empty!",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCartItem(item, cartController),
                      );
                    },
                  );
                }),

                const SizedBox(height: 24),

                // ========== Deliver To Tile ==========
                _buildInfoTile(
                  Icons.location_on_rounded,
                  "Deliver to",
                  "Select Your Location",
                ),
                const SizedBox(height: 12),

                // ========== Payment Method Tile (Opens BottomSheet) ==========
                _buildPaymentMethodTile(context, cartController),

                const SizedBox(height: 12),

                // ========== Promotions Tile ==========
                _buildInfoTile(
                  Icons.confirmation_number_rounded,
                  "Promotions",
                  "Select Your Discounts",
                ),
                const SizedBox(height: 24),

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        const Expanded(
          child: Text(
            "My Basket",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 44),
      ],
    );
  }

  // ========== Order Summary Header ==========
  Widget _buildOrderSummaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Order Summary",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            side: BorderSide(color: AppColors.tomato, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: Text(
            "Add Items",
            style: TextStyle(
              color: AppColors.tomato,
              fontSize: 12,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showPaymentBottomSheet(context, controller),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.credit_card_rounded,
            color: AppColors.tomato,
            size: 20,
          ),
        ),
        title: const Text(
          "Payment method",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Obx(
          () => Text(
            controller.selectedPaymentMethod.value.isEmpty
                ? "Select Payment Method"
                : controller.selectedPaymentMethod.value,
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Payment Methods",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Alignment Balance
                ],
              ),
              const SizedBox(height: 24),

              // Payment Options
              Obx(
                () => Column(
                  children: [
                    _buildBottomSheetOptionItem(
                      title: "Cash",
                      iconWidget: const Icon(
                        Icons.payments_rounded,
                        color: Colors.green,
                        size: 22,
                      ),
                      value: "Cash",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetOptionItem(
                      title: "PayPal",
                      iconWidget: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Colors.blue,
                        size: 22,
                      ),
                      value: "PayPal",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetOptionItem(
                      title: "Google Pay",
                      iconWidget: const Icon(
                        Icons.g_mobiledata_rounded,
                        color: Colors.deepOrange,
                        size: 28,
                      ),
                      value: "Google Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetOptionItem(
                      title: "Apple Pay",
                      iconWidget: const Icon(
                        Icons.apple_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                      value: "Apple Pay",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 0895",
                      iconWidget: const Icon(
                        Icons.credit_card_rounded,
                        color: Colors.indigo,
                        size: 22,
                      ),
                      value: "**** **** **** 0895",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                    const SizedBox(height: 12),
                    _buildBottomSheetOptionItem(
                      title: "**** **** **** 2259",
                      iconWidget: const Icon(
                        Icons.credit_card_rounded,
                        color: Colors.orange,
                        size: 22,
                      ),
                      value: "**** **** **** 2259",
                      groupValue: tempSelected.value,
                      onSelect: (val) => tempSelected.value = val,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Add New Card Button
              InkWell(
                onTap: () {
                  Get.back();
                  AddNewCardBottomSheet.show(context);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.tomato, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Add New Card",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Apply Button
              SizedBox(
                width: double.infinity,
                height: 50,
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
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            SizedBox(width: 30, height: 30, child: Center(child: iconWidget)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Custom Radio Circle
            Container(
              width: 20,
              height: 20,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.tomato.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.tomato, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black38),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tomato,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              "${item.quantity.value}",
                              style: const TextStyle(
                                fontSize: 14,
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
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.black38,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black38,
                    ),
                    onPressed: () => controller.removeItem(item),
                  ),
                ],
              ),
            ],
          ),

          if (item.addOns.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Color(0xFFF5F5F5)),
            ),
            Column(
              children: item.addOns.map((addOn) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addOn["name"]!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        "+ £${(addOn["price"] as double).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12,
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
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 14, color: Colors.black87),
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
        const SizedBox(height: 8),
        _buildBillRow(
          "Delivery Fee",
          controller.selectedPaymentMethod.value.isEmpty ? "—" : "£ 0.00",
        ),
        const SizedBox(height: 8),
        _buildBillRow("Discount", "—"),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(color: Colors.black12),
        ),
        _buildBillRow(
          "Total",
          "£ ${controller.total.toStringAsFixed(2)}",
          isBold: true,
          fontSize: 16,
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
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "£ ${controller.total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 20,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Place Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Order Placed!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Your order has been placed successfully!",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tomato.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Total: £${controller.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tomato,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Items",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "${controller.totalItems} items",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Estimated Delivery",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const Text(
                            "20-30 min",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Payment Method",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              controller.selectedPaymentMethod.value.isEmpty
                                  ? "Cash on Delivery"
                                  : controller.selectedPaymentMethod.value,
                              style: const TextStyle(
                                fontSize: 13,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.clearCart();
                      Get.offAllNamed('/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tomato,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Continue Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 45,
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
                      side: BorderSide(color: AppColors.tomato, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Track Order",
                      style: TextStyle(
                        color: AppColors.tomato,
                        fontSize: 15,
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
