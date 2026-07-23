import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class HelpCenterController extends GetxController {
  // ========== Observable Variables ==========
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  // ========== FAQ Data ==========
  var faqList = <Map<String, String>>[].obs;
  
  // ========== Contact Info ==========
  var contactEmail = 'support@foodapp.com'.obs;
  var contactPhone = '+880 1234-567890'.obs;
  var contactAddress = 'Dhaka, Bangladesh'.obs;
  
  // ========== Support Hours ==========
  var supportHours = '24/7'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadFAQData();
  }
  
  // ========== Load FAQ Data ==========
  void loadFAQData() {
    try {
      isLoading.value = true;
      
      faqList.value = [
        {
          'question': 'How to place an order?',
          'answer': '1. Browse products from the home screen\n2. Add items to your cart\n3. Proceed to checkout\n4. Confirm your order',
        },
        {
          'question': 'How to track my order?',
          'answer': 'Go to the Orders section in the bottom navigation bar and tap on your active order to see real-time tracking information.',
        },
        {
          'question': 'Payment methods accepted?',
          'answer': 'We accept Credit/Debit cards, Mobile Banking (bKash/Nagad/Rocket), and Cash on Delivery.',
        },
        {
          'question': 'How to get a refund?',
          'answer': 'Contact our support team within 24 hours of delivery. Refunds are processed within 3-5 business days.',
        },
        {
          'question': 'Delivery time?',
          'answer': 'Standard delivery takes 30-45 minutes. Express delivery (within 20 minutes) is available in selected areas.',
        },
        {
          'question': 'How to change my address?',
          'answer': 'Go to "My Locations" from your profile and add or edit your delivery address.',
        },
        {
          'question': 'Is there a minimum order?',
          'answer': 'Yes, minimum order amount is £5.00 for delivery. Pickup orders have no minimum.',
        },
        {
          'question': 'How to apply a promo code?',
          'answer': 'Enter your promo code at the checkout page before confirming your order.',
        },
      ];
      
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to load FAQs: $e';
      isLoading.value = false;
    }
  }
  
  // ========== Contact Support ==========
  void contactSupport() {
    Get.snackbar(
      'Contact Support',
      '📧 ${contactEmail.value}\n📱 ${contactPhone.value}\n📍 ${contactAddress.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.tomato,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.support_agent, color: Colors.white),
    );
  }
  
  // ========== Email Support ==========
  void emailSupport() {
    Get.snackbar(
      'Email Support',
      '📧 ${contactEmail.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.email_outlined, color: Colors.white),
    );
  }
  
  // ========== Call Support ==========
  void callSupport() {
    Get.snackbar(
      'Call Support',
      '📱 ${contactPhone.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.phone_outlined, color: Colors.white),
    );
  }
  
  // ========== Search FAQ ==========
  void searchFAQ(String query) {
    if (query.isEmpty) {
      loadFAQData();
    } else {
      final lowerQuery = query.toLowerCase();
      final filtered = faqList.value.where(
        (item) => item['question']!.toLowerCase().contains(lowerQuery),
      ).toList();
      faqList.value = filtered;
    }
  }
  
  // ========== Go Back ==========
  void goBack() {
    Get.back();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
}