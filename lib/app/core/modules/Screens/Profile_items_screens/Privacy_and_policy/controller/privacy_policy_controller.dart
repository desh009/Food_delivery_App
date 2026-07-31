// lib/app/core/modules/Screens/Profile_items_screens/Privacy_Policy_Screen/controller/privacy_policy_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class PrivacyPolicyController extends GetxController {
  // ============================================================
  // OBSERVABLE VARIABLES
  // ============================================================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // ============================================================
  // PRIVACY POLICY SECTIONS
  // ============================================================
  final RxList<Map<String, dynamic>> privacySections = <Map<String, dynamic>>[
    {
      'id': 'overview',
      'title': '1. Overview',
      'content': 'We respect your privacy and are committed to protecting your personal data. This Privacy Policy explains how we collect, use, store, and share your personal information when you use our mobile application.',
      'bulletPoints': [],
    },
    {
      'id': 'collect',
      'title': '2. Information We Collect',
      'content': 'To deliver food to your doorstep and provide a personalized experience, we collect the following types of information:',
      'bulletPoints': [
        {'title': 'Personal Info: ', 'desc': 'Name, phone number, email address, and saved delivery addresses.'},
        {'title': 'Location Data: ', 'desc': 'Real-time GPS location to accurately detect nearby restaurants and track delivery drivers.'},
        {'title': 'Payment Details: ', 'desc': 'Transaction details processed securely through encrypted third-party payment gateways.'},
        {'title': 'Device & Usage Data: ', 'desc': 'Device model, app version, IP address, and crash reports to improve performance.'},
      ],
    },
    {
      'id': 'use',
      'title': '3. How We Use Your Information',
      'content': 'Your information helps us operate effectively and improve our services:',
      'bulletPoints': [
        {'title': 'Order Processing: ', 'desc': 'To confirm orders, dispatch riders, and process payments.'},
        {'title': 'Communication: ', 'desc': 'To send order status updates, OTPs, and customer support responses.'},
        {'title': 'Personalization: ', 'desc': 'To recommend food items and offer personalized vouchers or discounts.'},
      ],
    },
    {
      'id': 'sharing',
      'title': '4. Data Sharing & Disclosure',
      'content': 'We do not sell your personal information. We only share necessary information with authorized parties such as:',
      'bulletPoints': [
        {'title': 'Delivery Partners: ', 'desc': 'Riders receive your address and phone number solely to complete delivery.'},
        {'title': 'Restaurant Partners: ', 'desc': 'Restaurants receive order items and delivery notes.'},
        {'title': 'Legal Authorities: ', 'desc': 'When required by law to comply with legal processes or regulations.'},
      ],
    },
    {
      'id': 'security',
      'title': '5. Data Security',
      'content': 'We implement strict security measures, including SSL encryption and secure server infrastructure, to protect your data against unauthorized access, loss, or alteration.',
      'bulletPoints': [],
    },
    {
      'id': 'rights',
      'title': '6. Your Rights & Control',
      'content': 'You can view, update, or request the deletion of your account and associated personal data at any time through the profile settings in the application.',
      'bulletPoints': [],
    },
  ].obs;

  // ============================================================
  // CONTACT INFO
  // ============================================================
  final RxString privacyEmail = 'privacy@pertoeats.com'.obs;
  final RxString effectiveDate = 'October 2024'.obs;

  // ============================================================
  // LIFE CYCLE
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    loadPrivacyData();
  }

  // ============================================================
  // LOAD DATA
  // ============================================================
  void loadPrivacyData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to load privacy policy. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================
  void goBack() {
    Get.back();
  }

  // ============================================================
  // CONTACT
  // ============================================================
  void contactPrivacyOfficer() {
    Get.snackbar(
      'Privacy Concern',
      'Email us at: ${privacyEmail.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.tomato,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}