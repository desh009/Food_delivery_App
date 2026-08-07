// lib/app/core/widgets/Voice_controller/global_voice_button/global_voice_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/Voice_controller/voice_controller.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class VoiceFloatingButton extends StatelessWidget {
  const VoiceFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final VoiceActionController voiceController = Get.find<VoiceActionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isListening = voiceController.isListening.value;
      final speechText = voiceController.userSpeechText.value;
      
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Speech Text Bubble
          if (speechText.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                speechText.length > 20 ? '${speechText.substring(0, 20)}...' : speechText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          
          // Mic Button with Ripple Effect
          GestureDetector(
            onTap: () {
              if (isListening) {
                voiceController.stopListening();
              } else {
                voiceController.startListening();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: isListening
                    ? LinearGradient(
                        colors: [
                          Colors.redAccent,
                          Colors.redAccent.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.tomato,
                          AppColors.tomato.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isListening ? Colors.redAccent : AppColors.tomato).withOpacity(0.4),
                    blurRadius: isListening ? 20 : 12,
                    spreadRadius: isListening ? 4 : 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ripple Effect (when listening)
                  if (isListening)
                    ...List.generate(2, (index) {
                      return Positioned.fill(
                        child: TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.8, end: 1.6),
                          duration: Duration(milliseconds: 1200 + index * 400),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: 1 - (value - 0.8) / 0.8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.redAccent.withOpacity(0.3 - index * 0.1),
                                      width: 2.w,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  
                  Icon(
                    isListening ? Icons.stop : Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}