import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/controller/login_screen_controller.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login1Screen extends GetView<Login1Controller> {
  const Login1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                const Spacer(flex: 2),
      
                // Title: Login
                const Text(
                  "Login",
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
      
                const SizedBox(height: 32),
                // intl_phone_field
                IntlPhoneField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.tomato,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  initialCountryCode: 'GB',
                  onChanged: (phone) {
                    controller.completePhoneNumber.value =
                        phone.completeNumber;
                  },
                  dropdownIconPosition: IconPosition.trailing,
                  dropdownIcon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black87,
                  ),
                  flagsButtonPadding: const EdgeInsets.only(left: 8),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
      
                const SizedBox(height: 24),
      
                // Remember Me Checkbox Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => controller.toggleRememberMe(),
                      child: Obx(
                        () => Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: controller.isRememberMeChecked.value
                                ? AppColors.tomato
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: controller.isRememberMeChecked.value
                                  ? AppColors.tomato
                                  : Colors.black26,
                              width: 1.5,
                            ),
                          ),
                          child: controller.isRememberMeChecked.value
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Remember me",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
      
                const Spacer(flex: 5),
      
                // Sign In Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.signIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isRememberMeChecked.value
                            ? AppColors.tomato
                            : Colors.white,
                        foregroundColor: controller.isRememberMeChecked.value
                            ? Colors.white
                            : Colors.black,
                        elevation: controller.isRememberMeChecked.value ? 4 : 0,
                        shadowColor: controller.isRememberMeChecked.value
                            ? AppColors.tomato.withOpacity(0.4)
                            : Colors.transparent,
                        side: BorderSide(
                          color: controller.isRememberMeChecked.value
                              ? AppColors.tomato
                              : Colors.black26,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: controller.isRememberMeChecked.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          : Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: controller.isRememberMeChecked.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
      
                const SizedBox(height: 24),
      
                // "Or sign in with" Divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Or sign in with",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Colors.black12, thickness: 1),
                    ),
                  ],
                ),
      
                const SizedBox(height: 24),
      
                // Social Media Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      fallbackIcon: Icons.g_mobiledata,
                      iconColor: Colors.red,
                      onTap: () {
                        Get.snackbar('Info', 'Google Sign-in coming soon!');
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      fallbackIcon: Icons.facebook,
                      iconColor: Colors.blue,
                      onTap: () {
                        Get.snackbar('Info', 'Facebook Sign-in coming soon!');
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      fallbackIcon: Icons.apple,
                      iconColor: Colors.black,
                      onTap: () {
                        Get.snackbar('Info', 'Apple Sign-in coming soon!');
                      },
                    ),
                  ],
                ),
      
                const SizedBox(height: 28),
      
                // Footer Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account? ",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.tomato,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData fallbackIcon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 1),
        ),
        child: Center(child: Icon(fallbackIcon, size: 28, color: iconColor)),
      ),
    );
  }
}