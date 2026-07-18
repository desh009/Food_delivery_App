import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_2.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class TomatoSplashScreen extends StatefulWidget {
  const TomatoSplashScreen({super.key});

  @override
  State<TomatoSplashScreen> createState() => _TomatoSplashScreenState();
}

class _TomatoSplashScreenState extends State<TomatoSplashScreen> {
  double _progressValue = 0.0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        if (_progressValue < 1.0) {
          _progressValue += 0.02;
        } else {
          _progressTimer?.cancel();
          Get.off(() => const TomatoLoadingScreen());
        }
      });
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tomato, // ✅ Scaffold-এর color Tomato করুন
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.tomato,
              // borderRadius: BorderRadius.circular(24.0),
              // border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: Stack(
              children: [
                // Logo / Content (Center)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Food App",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Delicious food at your doorstep",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // Progress Bar (Bottom)
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: const Color(0xFFE2533B),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(_progressValue * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}