// lib/app/core/modules/Screens/security_screen/view/security_view.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/controller/security_screen_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';

class SecurityScreen extends GetView<SecurityController> {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Security Overview
                _buildSecurityOverview(),

                const SizedBox(height: 24),

                // Biometric Authentication
                _buildBiometricSection(),

                const SizedBox(height: 20),

                // PIN/Password
                _buildPinSection(),

                const SizedBox(height: 20),

                // Two Factor Authentication
                _buildTwoFactorSection(),

                const SizedBox(height: 20),

                // Security Questions
                _buildSecurityQuestions(),

                const SizedBox(height: 20),

                // Session Management
                _buildSessionManagement(),

                const SizedBox(height: 20),

                // Login History
                _buildLoginHistory(),

                const SizedBox(height: 20),

                // Change Password
                _buildChangePasswordButton(),

                const SizedBox(height: 30),
              ],
            ),
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
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: controller.goBack,
      ),
      title: const Text(
        "Security",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.black87),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.tomato, AppColors.tomato.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  "Security Status",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  securityLevel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getSecurityLevelIcon(securityLevel),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getSecurityLevelDescription(securityLevel),
              style: const TextStyle(color: Colors.white70, fontSize: 14),
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
              const Text(
                "Enable Fingerprint/Face ID",
                style: TextStyle(fontSize: 14, color: Colors.black87),
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
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.black54, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Use your fingerprint or face to quickly sign in",
                    style: TextStyle(color: Colors.black54, fontSize: 13),
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
              const Text(
                "Enable PIN Lock",
                style: TextStyle(fontSize: 14, color: Colors.black87),
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
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text(
                        "PIN is set and active",
                        style: TextStyle(color: Colors.green, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
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
              const Text(
                "Enable 2FA",
                style: TextStyle(fontSize: 14, color: Colors.black87),
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
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sms, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Verification via ${controller.twoFactorMethod.value}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
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
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // এখানে Obx এর প্রয়োজন নেই কারণ TextFormField এর onChanged ই update করে
                      TextFormField(
                        initialValue: question['answer'],
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.resetSecurityQuestions,
              child: const Text('Reset All'),
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
              leading: const Icon(Icons.timer_outlined, color: Colors.black54),
              title: const Text('Session Timeout'),
              subtitle: Text('${controller.sessionTimeout.value} minutes'),
              trailing: DropdownButton<int>(
                value: controller.sessionTimeout.value,
                items: const [
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
          const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.power_settings_new, color: Colors.red),
            title: const Text('End Current Session'),
            subtitle: const Text('Sign out from all devices'),
            trailing: OutlinedButton(
              onPressed: controller.endSession,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('End', style: TextStyle(color: Colors.red)),
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isFailed ? Colors.red.shade50 : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isFailed ? Icons.close : Icons.check,
                    color: isFailed ? Colors.red : Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        login['device'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${login['location']} • ${login['time']}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isFailed
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    login['status'],
                    style: TextStyle(
                      color: isFailed ? Colors.red : Colors.green,
                      fontSize: 11,
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppColors.tomato),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: AppColors.tomato),
            const SizedBox(width: 8),
            const Text(
              "Change Password",
              style: TextStyle(
                color: AppColors.tomato,
                fontSize: 16,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.tomato, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          child,
        ],
      ),
    );
  }
}
