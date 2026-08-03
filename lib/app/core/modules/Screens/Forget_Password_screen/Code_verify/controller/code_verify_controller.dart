import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool isNewPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void resetPassword() async {
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in both password fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters long.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar(
        'Password Mismatch',
        'New password and confirm password do not match!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    showSuccessCatDialog();
  }

  void showSuccessCatDialog() {
    Get.generalDialog(
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 500),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
        );
        return ScaleTransition(
          scale: curve,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 10,
          backgroundColor: Theme.of(context).cardColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Cat Lottie
                Lottie.network(
                  'https://lottie.host/80e9270e-1147-4f6f-a3e9-74d3d2db7e16/jR5sL1J6dD.json',
                  height: 140.h,
                  width: 140.w,
                  repeat: true,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.check_circle_outline_rounded,
                      size: 80.sp,
                      color: Colors.green,
                    );
                  },
                ),

                SizedBox(height: 12.h),

                Text(
                  "Success! 🎉",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Your password has been reset successfully. Please log in with your new password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 20.h),

                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close Dialog
                      Get.offAllNamed('/login'); // Navigate to Login
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Back to Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}