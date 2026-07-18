import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_3.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class TomatoLoadingScreen extends StatefulWidget {
  const TomatoLoadingScreen({super.key});

  @override
  State<TomatoLoadingScreen> createState() => _TomatoLoadingScreenState();
}

class _TomatoLoadingScreenState extends State<TomatoLoadingScreen> {
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
          Get.off(() => const IntroduceStepOneScreen());
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.tomato,
                  AppColors.tomato.withOpacity(0.7),
                ],
              ),
              // borderRadius: BorderRadius.circular(24.0),
              // border: Border.all(color: Colors.white, width: 2.0),
            ),
            child: Stack(
              children: [
                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/Logo Speedy Chow.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
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
                              Icons.food_bank,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Speedy Chow",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                
                // Bottom Content
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "As fast as lightning,\nas delicious as thunder!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${(_progressValue * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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