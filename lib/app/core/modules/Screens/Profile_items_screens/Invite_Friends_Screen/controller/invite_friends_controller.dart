// lib/app/core/modules/Screens/invite_friend/controller/invite_friend_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InviteFriendController extends GetxController {
  static InviteFriendController get to => Get.find();

  // ========== Observable Variables ==========
  var isLoading = false.obs;
  var appLink = 'https://pertoeats.com/download'.obs;
  var totalInvites = 0.obs;
  var totalRewards = 0.0.obs;
  var isCopied = false.obs;

  // ========== Share Message ==========
  String get shareMessage =>
      "Hey! Check out Perto Eats - Order delicious food online! 🍕🍔\nDownload the app now: ${appLink.value}";

  @override
  void onInit() {
    super.onInit();
    _loadInviteData();
    _getAppLink();
  }

  // ========== Get App Link ==========
  Future<void> _getAppLink() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      // এখানে আপনার app এর download link দিন
      // iOS: https://apps.apple.com/app/id...
      // Android: https://play.google.com/store/apps/details?id=...
      
      // উদাহরণ:
      // appLink.value = 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}';
      // অথবা কাস্টম লিংক
      appLink.value = 'https://pertoeats.com/download';
      
      print('📱 App Link: ${appLink.value}');
    } catch (e) {
      print('❌ Failed to get app link: $e');
      appLink.value = 'https://pertoeats.com/download';
    }
  }

  // ========== Load Saved Invite Data ==========
  Future<void> _loadInviteData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      totalInvites.value = prefs.getInt('total_invites') ?? 0;
      totalRewards.value = prefs.getDouble('total_rewards') ?? 0.0;

      print('📂 Invite Data Loaded: Invites=${totalInvites.value}, Rewards=${totalRewards.value}');
    } catch (e) {
      print('❌ Failed to load invite data: $e');
    }
  }

  // ========== Save Invite Data ==========
  Future<void> _saveInviteData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('total_invites', totalInvites.value);
      await prefs.setDouble('total_rewards', totalRewards.value);
      print('💾 Invite Data Saved');
    } catch (e) {
      print('❌ Failed to save invite data: $e');
    }
  }

  // ========== Share App Link ==========
  Future<void> shareAppLink() async {
    try {
      isLoading.value = true;
      
      await Share.share(
        shareMessage,
        subject: 'Join Perto Eats and Get Rewards!',
      );
      
      // শেয়ার করলে invite count বাড়ান
      totalInvites.value++;
      totalRewards.value += 5.0; // প্রতি শেয়ারে $5
      await _saveInviteData();
      
      Get.snackbar(
        '✅ Shared Successfully!',
        'You earned \$5 reward! 🎉',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to share. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ========== Copy App Link ==========
  Future<void> copyAppLink() async {
    try {
      await Clipboard.setData(ClipboardData(text: appLink.value));
      isCopied.value = true;
      
      Get.snackbar(
        '✅ Copied!',
        'App link copied to clipboard!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        isCopied.value = false;
      });
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to copy link. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ========== Reset Invite Data ==========
  Future<void> resetInviteData() async {
    try {
      isLoading.value = true;
      
      totalInvites.value = 0;
      totalRewards.value = 0.0;
      
      await _saveInviteData();
      
      Get.snackbar(
        '🔄 Reset Complete',
        'All invite data has been reset.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        '❌ Error',
        'Failed to reset data.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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