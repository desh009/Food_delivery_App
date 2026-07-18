import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/otp_screen/controller/otp_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class VerificationScreen extends GetView<VerificationController> {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());

    return Scaffold(
      backgroundColor: AppColors.tomato, // ✅ Scaffold-এর color Tomato করুন
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                ),
              ),
      
              const SizedBox(height: 24),
      
              // Title
              const Text(
                "Verification",
                style: TextStyle(
                  color: AppColors.tomato,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
      
              const SizedBox(height: 16),
      
              // Subtitle
            Obx(
                  () => Column(
                    children: [
                      const Text(
                        "Code has been sent to",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${controller.countryCode.value} ${controller.phoneNumber.value}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.tomato,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 36),
      
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpBox(context, controller.txt1, controller.f1, controller.f2, controller),
                  _buildOtpBox(context, controller.txt2, controller.f2, controller.f3, controller),
                  _buildOtpBox(context, controller.txt3, controller.f3, controller.f4, controller),
                  _buildOtpBox(context, controller.txt4, controller.f4, null, controller),
                ],
              ),
      
              const SizedBox(height: 40),
      
              // Resend Timer Section
              const Text(
                "Didn’t receive code?",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 16),
      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, color: Colors.black87, size: 20),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      controller.formattedTime.value,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 16),
      
              Obx(
                () => GestureDetector(
                  onTap: controller.canResend.value
                      ? () => controller.startTimer()
                      : null,
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: controller.canResend.value
                          ? AppColors.tomato
                          : Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
      
              const Spacer(),
      
              // Verify Button (Dynamic Color)
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isOtpComplete.value && !controller.isLoading.value
                        ? () => controller.verifyOTP()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isOtpComplete.value
                          ? AppColors.tomato
                          : Colors.white,
                      foregroundColor: controller.isOtpComplete.value
                          ? Colors.white
                          : Colors.black,
                      elevation: controller.isOtpComplete.value ? 4 : 0,
                      shadowColor: controller.isOtpComplete.value
                          ? AppColors.tomato.withOpacity(0.4)
                          : Colors.transparent,
                      side: BorderSide(
                        color: controller.isOtpComplete.value
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
                              color: controller.isOtpComplete.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        : Text(
                            "Verify",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: controller.isOtpComplete.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
      
              const SizedBox(height: 24),
      
              // Footer Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Back to ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      "Sign In",
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
    );
  }

  Widget _buildOtpBox(
    BuildContext context,
    TextEditingController textController,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    VerificationController controller,
  ) {
    return Container(
      width: 64,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          controller: textController,
          focusNode: currentFocus,
          onChanged: (value) {
            controller.checkOtpComplete();
            
            if (value.length == 1) {
              if (nextFocus != null) {
                FocusScope.of(context).requestFocus(nextFocus);
              } else {
                currentFocus.unfocus();
              }
            }
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          },
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }
}