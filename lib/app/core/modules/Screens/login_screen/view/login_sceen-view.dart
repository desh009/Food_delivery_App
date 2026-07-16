import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/controller/login_screen_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class Login1Screen extends GetView<Login1Controller> {
  const Login1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
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

                  // Phone Number Input Field
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text("🇬🇧", style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 12),

                        const Text(
                          "(+44)",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),

                        Expanded(
                          child: TextField(
                            controller: controller
                                .phoneController, // কন্ট্রোলার যুক্ত করা হয়েছে
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: "00 0000 0000",
                              hintStyle: TextStyle(
                                color: Colors.black26,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

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

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => controller.signIn(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tomato.withOpacity(0.25),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.black12, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        fallbackIcon: Icons.g_mobiledata,
                        iconColor: Colors.red,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        fallbackIcon: Icons.facebook,
                        iconColor: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                        fallbackIcon: Icons.apple,
                        iconColor: Colors.black,
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
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData fallbackIcon,
    required Color iconColor,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Center(child: Icon(fallbackIcon, size: 28, color: iconColor)),
    );
  }
}
