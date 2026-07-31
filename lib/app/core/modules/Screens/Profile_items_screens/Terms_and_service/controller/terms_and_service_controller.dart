// lib/app/core/modules/Screens/Profile_items_screens/Terms_and_Services_Screen/controller/terms_and_services_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class TermsAndServicesController extends GetxController {
  // ============================================================
  // OBSERVABLE VARIABLES
  // ============================================================
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ============================================================
  // TERMS DATA
  // ============================================================
  final RxList<Map<String, dynamic>> termsSections = <Map<String, dynamic>>[
    {
      'id': 'intro',
      'title': '1. Introduction',
      'content':
          'Welcome to Perto Eats! By accessing or using our services, you agree to be bound by these Terms of Service. Please read them carefully before placing any orders.',
      'bulletPoints': [],
    },
    {
      'id': 'account',
      'title': '2. User Account & Security',
      'content':
          'To use certain features of our app, you must create an account. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
      'bulletPoints': [
        {
          'title': 'Accurate Info: ',
          'desc':
              'You must provide accurate and complete registration information.',
        },
        {
          'title': 'Account Safety: ',
          'desc':
              'Notify us immediately if you suspect any unauthorized access.',
        },
      ],
    },
    {
      'id': 'orders',
      'title': '3. Orders & Payments',
      'content':
          'All orders placed through the app are subject to availability and acceptance by the restaurant partner. Prices are subject to change without prior notice.',
      'bulletPoints': [
        {
          'title': 'Payment Methods: ',
          'desc':
              'We accept Cash on Delivery, Credit/Debit Cards, and supported Digital Wallets.',
        },
        {
          'title': 'Cancellation: ',
          'desc':
              'Orders once confirmed by the restaurant cannot be canceled after preparation begins.',
        },
      ],
    },
    {
      'id': 'delivery',
      'title': '4. Delivery & Refunds',
      'content':
          'Delivery times are estimates and may vary due to traffic, weather, or restaurant delays. Refunds will be evaluated on a case-by-case basis for damaged or incorrect items.',
      'bulletPoints': [],
    },
    {
      'id': 'vouchers',
      'title': '5. Vouchers & Promotions',
      'content':
          'Promotional codes and vouchers are valid for a limited time and subject to minimum spend requirements. Vouchers cannot be exchanged for cash or transferred to another account.',
      'bulletPoints': [],
    },
    {
      'id': 'intellectual',
      'title': '6. Intellectual Property',
      'content':
          'All logos, food images, software code, and design elements within this application are owned by or licensed to us and are protected under copyright laws.',
      'bulletPoints': [],
    },
  ].obs;

  // ============================================================
  // CONTACT INFO
  // ============================================================
  final RxString supportEmail = 'support@pertoeats.com'.obs;
  final RxString supportPhone = '+880 1234 567890'.obs;

  // ============================================================
  // LAST UPDATED
  // ============================================================
  final RxString lastUpdated = 'October 2024'.obs;

  // ============================================================
  // LIFE CYCLE
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    loadTermsData(); // 🔥 private (_) সরিয়ে public করুন
  }

  // ============================================================
  // LOAD DATA - 🔥 public method করুন
  // ============================================================
  void loadTermsData() async {
    isLoading.value = true;
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Data already loaded in observable
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to load terms. Please try again.';
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
  // CONTACT SUPPORT
  // ============================================================
}
