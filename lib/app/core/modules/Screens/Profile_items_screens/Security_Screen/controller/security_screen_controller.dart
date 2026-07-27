// lib/app/core/modules/Screens/security_screen/controller/security_controller.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class SecurityController extends GetxController {
  // ============ OBSERVABLE VARIABLES ============
  
  // Biometric
  final isBiometricEnabled = false.obs;
  
  // Pin
  final isPinEnabled = false.obs;
  final pinCode = ''.obs;
  final confirmPin = ''.obs;
  final isPinSet = false.obs;
  
  // Two Factor
  final isTwoFactorEnabled = false.obs;
  final twoFactorMethod = 'SMS'.obs; // 'SMS', 'Email', 'Authenticator'
  
  // 🔥 Security Questions - Observable List
  final securityQuestions = <Map<String, String>>[
    {'question': 'What is your mother\'s maiden name?', 'answer': ''},
    {'question': 'What was the name of your first pet?', 'answer': ''},
    {'question': 'What is your favorite food?', 'answer': ''},
  ].obs; // 🔥 এখানে .obs দেওয়া আছে
  
  // Session
  final isSessionActive = true.obs;
  final sessionTimeout = 30.obs;
  
  // Login History
  final loginHistory = <Map<String, dynamic>>[
    {
      'device': 'iPhone 15 Pro',
      'location': 'New York, USA',
      'time': 'Today, 2:30 PM',
      'status': 'Success',
    },
    {
      'device': 'MacBook Pro',
      'location': 'New York, USA',
      'time': 'Today, 9:00 AM',
      'status': 'Success',
    },
    {
      'device': 'Unknown Device',
      'location': 'London, UK',
      'time': 'Yesterday, 11:45 PM',
      'status': 'Failed',
    },
  ].obs; // 🔥 এখানে .obs দেওয়া আছে
  
  @override
  void onInit() {
    super.onInit();
    _loadSecuritySettings();
  }
  
  void _loadSecuritySettings() {
    isBiometricEnabled.value = false;
    isPinEnabled.value = false;
    isTwoFactorEnabled.value = false;
  }
  
  // ============ BIOMETRIC ============
  void toggleBiometric(bool value) async {
    if (value) {
      final isAvailable = await _checkBiometricAvailability();
      if (!isAvailable) {
        Get.snackbar(
          'Not Available',
          'Biometric is not available on this device',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      final isAuthenticated = await _authenticateWithBiometric();
      if (isAuthenticated) {
        isBiometricEnabled.value = true;
        _showSuccessMessage('Biometric enabled successfully');
      }
    } else {
      isBiometricEnabled.value = false;
      _showSuccessMessage('Biometric disabled');
    }
  }
  
  Future<bool> _checkBiometricAvailability() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
  
  Future<bool> _authenticateWithBiometric() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
  
  // ============ PIN ============
  void togglePin(bool value) {
    if (value) {
      _showSetupPinDialog();
    } else {
      if (isPinSet.value) {
        _showVerifyPinDialog();
      } else {
        isPinEnabled.value = false;
        _showSuccessMessage('PIN disabled');
      }
    }
  }
  
  void _showSetupPinDialog() {
    pinCode.value = '';
    confirmPin.value = '';
    
    Get.dialog(
      AlertDialog(
        title: const Text('Set PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextField(
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter PIN (4 digits)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                pinCode.value = value;
              },
            )),
            const SizedBox(height: 16),
            Obx(() => TextField(
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Confirm PIN',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                confirmPin.value = value;
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _savePin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
            ),
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
  }
  
  void _savePin() {
    if (pinCode.value.isEmpty || confirmPin.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter PIN and confirm',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (pinCode.value.length != 4) {
      Get.snackbar(
        'Error',
        'PIN must be exactly 4 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    if (pinCode.value != confirmPin.value) {
      Get.snackbar(
        'Error',
        'PINs do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    isPinSet.value = true;
    isPinEnabled.value = true;
    Get.back();
    _showSuccessMessage('PIN set successfully');
  }
  
  void _showVerifyPinDialog() {
    final enteredPin = ''.obs;
    
    Get.dialog(
      AlertDialog(
        title: const Text('Verify PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => TextField(
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter current PIN',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                enteredPin.value = value;
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (enteredPin.value == pinCode.value) {
                isPinEnabled.value = false;
                isPinSet.value = false;
                pinCode.value = '';
                confirmPin.value = '';
                Get.back();
                _showSuccessMessage('PIN disabled');
              } else {
                Get.snackbar(
                  'Error',
                  'Incorrect PIN',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
            ),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
  
  // ============ TWO FACTOR ============
  void toggleTwoFactor(bool value) {
    if (value) {
      _showTwoFactorSetupDialog();
    } else {
      isTwoFactorEnabled.value = false;
      _showSuccessMessage('Two-factor authentication disabled');
    }
  }
  
  void _showTwoFactorSetupDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Setup 2FA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => DropdownButtonFormField<String>(
              value: twoFactorMethod.value,
              decoration: const InputDecoration(
                labelText: 'Select Method',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'SMS', child: Text('SMS')),
                DropdownMenuItem(value: 'Email', child: Text('Email')),
                DropdownMenuItem(value: 'Authenticator', child: Text('Authenticator App')),
              ],
              onChanged: (value) {
                if (value != null) {
                  twoFactorMethod.value = value;
                }
              },
            )),
            const SizedBox(height: 16),
            const Text(
              'You will receive a verification code via selected method',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              isTwoFactorEnabled.value = true;
              Get.back();
              _showSuccessMessage('2FA enabled successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
            ),
            child: const Text('Enable 2FA'),
          ),
        ],
      ),
    );
  }
  
  // ============ SECURITY QUESTIONS ============
  void updateSecurityQuestion(int index, String answer) {
    securityQuestions[index]['answer'] = answer;
    securityQuestions.refresh(); // 🔥 এখানে refresh() কল করা হয়েছে
    _showSuccessMessage('Security question updated');
  }
  
  void resetSecurityQuestions() {
    Get.dialog(
      AlertDialog(
        title: const Text('Reset Security Questions'),
        content: const Text(
          'Are you sure you want to reset all security questions?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              for (var question in securityQuestions) {
                question['answer'] = '';
              }
              securityQuestions.refresh(); // 🔥 এখানে refresh() কল করা হয়েছে
              Get.back();
              _showSuccessMessage('Security questions reset');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
  
  // ============ SESSION ============
  void updateSessionTimeout(int minutes) {
    sessionTimeout.value = minutes;
    _showSuccessMessage('Session timeout updated to $minutes minutes');
  }
  
  void endSession() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Session'),
        content: const Text(
          'Are you sure you want to end your current session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              isSessionActive.value = false;
              Get.back();
              _showSuccessMessage('Session ended');
              Get.offAllNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }
  
  // ============ CHANGE PASSWORD ============
  void changePassword() {
    Get.dialog(
      AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _showSuccessMessage('Password changed successfully');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
            ),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }
  
  // ============ HELPER ============
  void _showSuccessMessage(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  
  void goBack() {
    Get.back();
  }
}