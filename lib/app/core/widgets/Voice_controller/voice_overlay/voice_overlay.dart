// lib/app/core/widgets/Voice_controller/voice_overlay.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ এই লাইন যোগ করুন
import 'package:food_hjoiopk/app/core/widgets/Voice_controller/global_voice_button/global_voice_button.dart';

class VoiceOverlay extends StatelessWidget {
  final Widget child;

  const VoiceOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // ভয়েস বাটন - সব স্ক্রিনের উপরে
        Positioned(
          bottom: 100.h,  // এখন কাজ করবে
          right: 20.w,    // এখন কাজ করবে
          child: const VoiceFloatingButton(),
        ),
      ],
    );
  }
}