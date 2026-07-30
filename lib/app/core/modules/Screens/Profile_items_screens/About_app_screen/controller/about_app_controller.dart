// lib/app/core/modules/Screens/Profile_items_screens/about_app_screen/controller/about_app_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../remote/theme/app_colors.dart';

class AboutAppController extends GetxController {
  static AboutAppController get to => Get.find();

  // ========== Observable Variables ==========
  var isLoading = false.obs;
  var appVersion = '1.0.0'.obs;
  var appName = 'Perto Eats'.obs;

  // ========== Social Media Links ==========
  final List<Map<String, dynamic>> socialLinks = [
    {
      'icon': Icons.facebook,
      'url': 'https://facebook.com/pertocats',
      'color': const Color(0xFF1877F2),
    },
    {
      'icon': Icons.camera_alt_outlined,
      'url': 'https://instagram.com/pertocats',
      'color': const Color(0xFFE4405F),
    },
    {
      'icon': Icons.language_rounded,
      'url': 'https://pertocats.com',
      'color': AppColors.tomato,
    },
    {
      'icon': Icons.youtube_searched_for,
      'url': 'https://youtube.com/pertocats',
      'color': const Color(0xFFFF0000),
    },
  ];

  // ========== Navigation Methods ==========
  void goBack() {
    Get.back();
  }

  // ========== Social Media Methods ==========
  void openSocialMedia(String url) async {
    if (url.isEmpty) return;
    
    isLoading.value = true;
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open link',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Error opening social media: $e');
      Get.snackbar(
        'Error',
        'Could not open link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    print('🗑️ AboutAppController disposed');
    super.onClose();
  }
}