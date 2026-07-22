// share_helper.dart
import 'dart:convert';
import 'package:food_hjoiopk/app/core/models/user/user.dart';
import 'package:food_hjoiopk/app/core/remote/constant/constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';

class ShareHelper {
  static SharedPreferences? _prefs;
  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      print('✅ ShareHelper initialized successfully');
    } catch (e) {
      print('❌ ShareHelper init error: $e');
      _isInitialized = false;
      // Retry once
      try {
        _prefs = await SharedPreferences.getInstance();
        _isInitialized = true;
        print('✅ ShareHelper initialized on retry');
      } catch (e2) {
        print('❌ ShareHelper retry failed: $e2');
        _isInitialized = false;
      }
    }
  }

  static bool get isInitialized => _isInitialized && _prefs != null;

  static SharedPreferences get prefs {
    if (!isInitialized) {
      throw Exception('ShareHelper not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ========== Auth Token ==========
  static String? getAuthToken() {
    try {
      if (isInitialized) {
        return prefs.getString(AppConstant.authToken);
      }
    } catch (e) {
      print('❌ Error getting auth token: $e');
    }
    return null;
  }

  static Future<void> setAuthToken(String token) async {
    try {
      if (isInitialized) {
        await prefs.setString(AppConstant.authToken, token);
      }
    } catch (e) {
      print('❌ Error setting auth token: $e');
    }
  }

  // ========== User Data ==========
  static Future<void> setUser(User user) async {
    try {
      if (isInitialized) {
        final String userJson = json.encode(user.toJson());
        await prefs.setString(AppConstant.user, userJson);
      }
    } catch (e) {
      print('❌ Error setting user: $e');
    }
  }

  static User? getUser() {
    try {
      if (isInitialized) {
        final String? userString = prefs.getString(AppConstant.user);
        if (userString != null && userString.isNotEmpty) {
          final Map<String, dynamic> userMap = json.decode(userString);
          return User.fromJson(userMap);
        }
      }
    } catch (e) {
      print('❌ Error parsing user data: $e');
    }
    return null;
  }

  // ========== Check Login Status ==========
  static bool isLoggedIn() {
    try {
      if (isInitialized) {
        final String? token = getAuthToken();
        final User? user = getUser();
        return token != null && token.isNotEmpty && user != null;
      }
    } catch (e) {
      print('❌ Error checking login: $e');
    }
    return false;
  }

  // ========== Clear All ==========
  static Future<void> clear() async {
    try {
      if (isInitialized) {
        await prefs.clear();
        print('✅ All data cleared');
      }
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }

  // ========== Logout ==========
  static Future<void> logout() async {
    try {
      await clear();
      token = null;
      user = null;
      Get.offAllNamed(Routes.AUTH);
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  // ========== Set User Data ==========
  static Future<void> setUserData({
    required String token,
    required User user,
  }) async {
    try {
      await setAuthToken(token);
      await setUser(user);
      // Global variables update
      token = token;
      user = user;
      print('✅ User data saved successfully');
    } catch (e) {
      print('❌ Error saving user data: $e');
      rethrow;
    }
  }

  // ========== Get User Info ==========
  static String getUserName() {
    final User? user = getUser();
    return user?.name ?? 'Guest';
  }

  static String getUserPhone() {
    final User? user = getUser();
    return user?.phone ?? '';
  }

  static String getUserEmail() {
    final User? user = getUser();
    return user?.email ?? '';
  }

  static String getUserId() {
    final User? user = getUser();
    return user?.id ?? '';
  }

  // ========== Update User ==========
  static Future<void> updateUser(User updatedUser) async {
    await setUser(updatedUser);
    user = updatedUser;
  }
}

// ========== Global Variables ==========
String? token;
User? user;