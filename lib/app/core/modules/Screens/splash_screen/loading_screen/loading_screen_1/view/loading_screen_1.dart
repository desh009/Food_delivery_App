import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_2.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

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
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TomatoLoadingScreen()),
          );
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
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.tomato,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: const Color(0xFFE2533B),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 5,
                    ),
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