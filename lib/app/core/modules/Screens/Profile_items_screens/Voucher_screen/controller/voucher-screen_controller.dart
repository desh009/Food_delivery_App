// lib/app/core/modules/Screens/voucher_screen/controller/voucher_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/controller/add_to-cart_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class VoucherController extends GetxController {
  static VoucherController get to => Get.find();

  // ========== Observable Variables ==========
  var isLoading = false.obs;
  var selectedVoucher = ''.obs;
  var selectedVoucherIndex = (-1).obs;
  var usedVouchers = <String>[].obs;
  var appliedVoucher = ''.obs;
  var appliedVoucherDiscount = 0.0.obs;
  var appliedVoucherCode = ''.obs;

  // ========== Voucher Data ==========
  final List<Map<String, dynamic>> availableVouchers = [
    {
      'code': 'WELCOME20',
      'discount': '20% OFF',
      'discountValue': 20.0,
      'type': 'percentage',
      'title': 'Special Welcome Offer',
      'minSpend': 15.00,
      'validity': 'Valid till 15 Aug 2026',
    },
    {
      'code': 'FREEDEL',
      'discount': 'FREE DEL',
      'discountValue': 5.0,
      'type': 'fixed',
      'title': 'Free Delivery Pass',
      'minSpend': 10.00,
      'validity': 'Valid till 20 Aug 2026',
    },
    {
      'code': 'PERTO50',
      'discount': '\$5.00 OFF',
      'discountValue': 5.0,
      'type': 'fixed',
      'title': 'Mega Foodie Discount',
      'minSpend': 25.00,
      'validity': 'Valid till 31 Aug 2026',
    },
    {
      'code': 'MORNING15',
      'discount': '15% OFF',
      'discountValue': 15.0,
      'type': 'percentage',
      'title': 'Breakfast Special',
      'minSpend': 12.00,
      'validity': 'Valid till 10 Aug 2026',
    },
  ];

  CartController get cartController => CartController.instance;

  @override
  void onInit() {
    super.onInit();
    _loadUsedVouchers();
  }

  // ========== SharedPreferences ব্যবহার করে ভাউচার লোড করুন ==========
  void _loadUsedVouchers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? vouchersJson = prefs.getString('used_vouchers');

      if (vouchersJson != null && vouchersJson.isNotEmpty) {
        final List<String> savedVouchers = List<String>.from(
          jsonDecode(vouchersJson),
        );
        usedVouchers.value = savedVouchers;
        print('📂 ভাউচার লোড করা হয়েছে: $savedVouchers');
      } else {
        usedVouchers.value = [];
        print('📂 কোনো সংরক্ষিত ভাউচার নেই');
      }
    } catch (e) {
      print('❌ ভাউচার লোড করতে সমস্যা: $e');
      usedVouchers.value = [];
    }
  }

  // ========== ✅ Public মেথড - অন্য ফাইল থেকে কল করা যাবে ==========
  void saveUsedVouchers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String vouchersJson = jsonEncode(usedVouchers.toList());
      await prefs.setString('used_vouchers', vouchersJson);
      print('💾 ভাউচার সংরক্ষণ করা হয়েছে: ${usedVouchers.toList()}');
    } catch (e) {
      print('❌ ভাউচার সংরক্ষণ করতে সমস্যা: $e');
    }
  }

  // ========== Private মেথড - শুধুমাত্র এই ক্লাসের ভিতরে ব্যবহারের জন্য ==========
  // এখন আর দরকার নেই, উপরের public মেথড ব্যবহার করুন

  // ========== ভাউচার ব্যবহার করা হয়েছে কিনা চেক করুন ==========
  bool isVoucherUsed(String code) => usedVouchers.contains(code);
  bool isVoucherAvailable(String code) => !isVoucherUsed(code);

  // ========== Select Voucher ==========
  void selectVoucher(int index, String code) {
    if (isVoucherUsed(code)) {
      Get.snackbar(
        'Already Used ❌',
        'এই ভাউচারটি ইতিমধ্যে ব্যবহার করা হয়েছে!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (selectedVoucher.value == code) {
      selectedVoucher.value = '';
      selectedVoucherIndex.value = -1;
      Get.snackbar(
        'Deselected',
        'ভাউচার "$code" সরানো হয়েছে',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } else {
      selectedVoucher.value = code;
      selectedVoucherIndex.value = index;
      Get.snackbar(
        'Voucher Selected 🎉',
        '"$code" নির্বাচিত হয়েছে!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ========== Apply Voucher (Navigation বাদ) ==========
  void applyVoucher() async {
    if (selectedVoucher.value.isEmpty) {
      // Get.snackbar(
      //   'Error',
      //   'দয়া করে একটি ভাউচার সিলেক্ট করুন!',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      // );
      return;
    }

    final code = selectedVoucher.value;

    if (isVoucherUsed(code)) {
      // Get.snackbar(
      //   'Already Used ❌',
      //   'এই ভাউচারটি ইতিমধ্যে ব্যবহার করা হয়েছে!',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 2),
      // );
      return;
    }

    final voucher = availableVouchers.firstWhere((v) => v['code'] == code);
    final discountValue = voucher['discountValue'] as double;
    final discountType = voucher['type'] as String;
    final title = voucher['title'] as String;
    final minSpend = voucher['minSpend'] as double;

    // ========== Price Match চেক করুন (Min Spend) ==========
    if (cartController.subtotal < minSpend) {
      // Get.snackbar(
      //   '❌ Price Not Matched',
      //   'ন্যূনতম খরচ £${minSpend.toStringAsFixed(2)} প্রয়োজন৷\nবর্তমান সাবটোটাল: £${cartController.subtotal.toStringAsFixed(2)}',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      // );
      return;
    }

    // ডিসকাউন্ট ক্যালকুলেট করুন
    double discountAmount = 0.0;
    if (discountType == 'percentage') {
      discountAmount = (cartController.subtotal * discountValue) / 100;
    } else {
      discountAmount = discountValue;
    }

    // CartController এ Apply করুন
    cartController.applyVoucher(
      code: code,
      discountAmount: discountAmount,
      voucherTitle: title,
    );

    // ✅ ভাউচার ব্যবহার করা হয়েছে হিসেবে চিহ্নিত করুন
    usedVouchers.add(code);
    saveUsedVouchers(); // ✅ public মেথড কল করুন

    appliedVoucher.value = code;
    appliedVoucherDiscount.value = discountAmount;
    appliedVoucherCode.value = code;

    selectedVoucher.value = '';
    selectedVoucherIndex.value = -1;

    await Clipboard.setData(ClipboardData(text: code));

    // Get.snackbar(
    //   '✅ Voucher Applied!',
    //   '"$code" এপ্লাই করা হয়েছে!\nডিসকাউন্ট: £${discountAmount.toStringAsFixed(2)}\n✅ Price Matched!',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    // );
  }

  // ========== Copy Voucher Code ==========
  void copyVoucherCode(String code) async {
    if (isVoucherUsed(code)) {
      Get.snackbar(
        'Already Used ❌',
        'এই ভাউচারটি ইতিমধ্যে ব্যবহার করা হয়েছে!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      'Copied 📋',
      'কোড "$code" কপি করা হয়েছে!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void clearSelection() {
    selectedVoucher.value = '';
    selectedVoucherIndex.value = -1;
  }

  // ========== সব ভাউচার রিসেট করুন ==========
  void resetUsedVouchers() async {
    usedVouchers.clear();
    saveUsedVouchers(); // ✅ public মেথড কল করুন
    appliedVoucher.value = '';
    appliedVoucherDiscount.value = 0.0;
    appliedVoucherCode.value = '';
    cartController.clearVoucher();
    Get.snackbar(
      'Reset',
      'সব ভাউচার রিসেট করা হয়েছে!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void goBack() => Get.back();

  List<Map<String, dynamic>> getAvailableVouchers() {
    return availableVouchers.where((v) => !isVoucherUsed(v['code']!)).toList();
  }

  List<Map<String, dynamic>> getUsedVouchers() {
    return availableVouchers.where((v) => isVoucherUsed(v['code']!)).toList();
  }

  int getAvailableVouchersCount() {
    return availableVouchers.length - usedVouchers.length;
  }

  int getUsedVouchersCount() => usedVouchers.length;

  @override
  void onClose() {
    super.onClose();
  }
}
