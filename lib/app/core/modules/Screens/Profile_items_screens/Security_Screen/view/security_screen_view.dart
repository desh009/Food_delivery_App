// lib/app/core/modules/Screens/security_screen/view/security_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/controller/security_screen_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class SecurityScreen extends GetView<SecurityController> {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Overview
                _buildSecurityOverview(),

                SizedBox(height: 24.h),

                // Biometric Authentication
                _buildBiometricSection(),

                SizedBox(height: 20.h),

                // PIN/Password
                _buildPinSection(),

                SizedBox(height: 20.h),

                // Two Factor Authentication
                _buildTwoFactorSection(),

                SizedBox(height: 20.h),

                // Security Questions
                _buildSecurityQuestions(),

                SizedBox(height: 20.h),

                // Session Management
                _buildSessionManagement(),

                SizedBox(height: 20.h),

                // Login History
                _buildLoginHistory(),

                SizedBox(height: 20.h),

                // Change Password
                _buildChangePasswordButton(),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: controller.goBack,
      ),
      title: Text(
        "Security",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline, color: Colors.black87),
          onPressed: () {
            Get.snackbar(
              'Security Help',
              'Contact support for security assistance',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.tomato,
              colorText: Colors.white,
            );
          },
        ),
      ],
    );
  }

  // ========== Security Overview ==========
  Widget _buildSecurityOverview() {
    return Obx(() {
      final securityLevel = _calculateSecurityLevel();

      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.tomato, AppColors.tomato.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield, color: Colors.white, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  "Security Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  securityLevel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getSecurityLevelIcon(securityLevel),
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              _getSecurityLevelDescription(securityLevel),
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
          ],
        ),
      );
    });
  }

  String _calculateSecurityLevel() {
    var score = 0;
    if (controller.isBiometricEnabled.value) score++;
    if (controller.isPinEnabled.value) score++;
    if (controller.isTwoFactorEnabled.value) score++;
    if (controller.isSessionActive.value) score++;

    if (score >= 4) return 'High';
    if (score >= 2) return 'Medium';
    return 'Low';
  }

  String _getSecurityLevelIcon(String level) {
    switch (level) {
      case 'High':
        return '🛡️';
      case 'Medium':
        return '🔒';
      default:
        return '⚠️';
    }
  }

  String _getSecurityLevelDescription(String level) {
    switch (level) {
      case 'High':
        return 'Your account is well protected';
      case 'Medium':
        return 'Enable more features for better security';
      default:
        return 'Your account needs better protection';
    }
  }

  // ========== Biometric Section ==========
  Widget _buildBiometricSection() {
    return _buildSection(
      icon: Icons.fingerprint,
      title: "Biometric Authentication",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable Fingerprint/Face ID",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              Obx(
                () => Switch(
                  value: controller.isBiometricEnabled.value,
                  onChanged: controller.toggleBiometric,
                  activeColor: AppColors.tomato,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.black54, size: 16.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Use your fingerprint or face to quickly sign in",
                    style: TextStyle(color: Colors.black54, fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== PIN Section ==========
  Widget _buildPinSection() {
    return _buildSection(
      icon: Icons.pin,
      title: "PIN/Password Lock",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable PIN Lock",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              Obx(
                () => Switch(
                  value: controller.isPinEnabled.value,
                  onChanged: controller.togglePin,
                  activeColor: AppColors.tomato,
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.isPinEnabled.value) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "PIN is set and active",
                        style: TextStyle(color: Colors.green, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // ========== Two Factor Section ==========
  Widget _buildTwoFactorSection() {
    return _buildSection(
      icon: Icons.security,
      title: "Two-Factor Authentication",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Enable 2FA",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
              Obx(
                () => Switch(
                  value: controller.isTwoFactorEnabled.value,
                  onChanged: controller.toggleTwoFactor,
                  activeColor: AppColors.tomato,
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.isTwoFactorEnabled.value) {
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sms, color: Colors.blue, size: 16.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "Verification via ${controller.twoFactorMethod.value}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  // ========== Security Questions ==========
  Widget _buildSecurityQuestions() {
    return _buildSection(
      icon: Icons.question_answer,
      title: "Security Questions",
      child: Column(
        children: [
          // শুধুমাত্র যেখানে observable change হয় সেখানে Obx ব্যবহার করুন
          Obx(() {
            return Column(
              children: controller.securityQuestions.map((question) {
                final index = controller.securityQuestions.indexOf(question);
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // এখানে Obx এর প্রয়োজন নেই কারণ TextFormField এর onChanged ই update করে
                      TextFormField(
                        initialValue: question['answer'],
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        onChanged: (value) {
                          controller.updateSecurityQuestion(index, value);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.resetSecurityQuestions,
              child: Text('Reset All'),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Session Management ==========
  Widget _buildSessionManagement() {
    return _buildSection(
      icon: Icons.timer,
      title: "Session Management",
      child: Column(
        children: [
          Obx(
            () => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.timer_outlined, color: Colors.black54),
              title: Text('Session Timeout'),
              subtitle: Text('${controller.sessionTimeout.value} minutes'),
              trailing: DropdownButton<int>(
                value: controller.sessionTimeout.value,
                items: [
                  DropdownMenuItem(value: 15, child: Text('15 min')),
                  DropdownMenuItem(value: 30, child: Text('30 min')),
                  DropdownMenuItem(value: 45, child: Text('45 min')),
                  DropdownMenuItem(value: 60, child: Text('60 min')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.updateSessionTimeout(value);
                  }
                },
              ),
            ),
          ),
          Divider(height: 1.h),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.power_settings_new, color: Colors.red),
            title: Text('End Current Session'),
            subtitle: Text('Sign out from all devices'),
            trailing: OutlinedButton(
              onPressed: controller.endSession,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red),
              ),
              child: Text('End', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  // ========== Login History ==========
  Widget _buildLoginHistory() {
    return _buildSection(
      icon: Icons.history,
      title: "Login History",
      child: Column(
        children: controller.loginHistory.map((login) {
          final isFailed = login['status'] == 'Failed';
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: isFailed ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    isFailed ? Icons.close : Icons.check,
                    color: isFailed ? Colors.red : Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        login['device'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        '${login['location']} • ${login['time']}',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isFailed
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    login['status'],
                    style: TextStyle(
                      color: isFailed ? Colors.red : Colors.green,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ========== Change Password Button ==========
  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: controller.changePassword,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          side: BorderSide(color: AppColors.tomato),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, color: AppColors.tomato),
            SizedBox(width: 8.w),
            Text(
              "Change Password",
              style: TextStyle(
                color: AppColors.tomato,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== HELPER WIDGETS ==========

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.tomato, size: 22.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Divider(height: 16.h),
          child,
        ],
      ),
    );
  }
}
