// lib/app/core/modules/Screens/message_screen/view/message_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/Massage_Screen/controller/massage_screen_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen>
    with TickerProviderStateMixin {
  late final MessageController controller;

  // 🔥 Dark Mode Helpers
  bool get isDark => Get.theme.brightness == Brightness.dark;
  Color get textColor => isDark ? AppColors.darkText : AppColors.darkBackground;
  Color get bgColor => isDark ? AppColors.darkBackground : const Color(0xFFF9FAFB);
  Color get cardColor => isDark ? AppColors.darkCard : AppColors.lightBackground;
  Color get hintColor => isDark ? Colors.grey.shade600 : Colors.grey.shade400;
  Color get subtitleColor => isDark ? Colors.grey.shade400 : Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MessageController>()) {
      Get.put<MessageController>(MessageController());
    }
    controller = Get.find<MessageController>();
    controller.initAnimations(this);
  }

  @override
  void dispose() {
    controller.disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return _buildMessageBubble(message, index);
                  },
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3) 
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.goBack,
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: isDark 
                    ? AppColors.darkCard 
                    : AppColors.lightAsh.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                size: 18.r,
                color: textColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          Stack(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=200',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 2.w,
                bottom: 2.h,
                child: Container(
                  width: 11.r,
                  height: 11.r,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkBackground : AppColors.lightBackground, 
                      width: 2.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'David Miller',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Obx(
                  () => Text(
                    controller.isRecording.value ? 'Listening...' : 'Delivery Partner • Active',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: controller.isRecording.value
                          ? AppColors.tomato
                          : Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: controller.makeCall,
            icon: Icon(
              Icons.phone_outlined,
              color: textColor,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGE BUBBLE - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildMessageBubble(Map<String, dynamic> message, int index) {
    final bool isMe = message['isMe'];
    final bool isVoice = message['type'] == 'voice';

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          constraints: BoxConstraints(maxWidth: 0.78.sw),
          decoration: BoxDecoration(
            color: isMe 
                ? AppColors.tomato 
                : (isDark ? AppColors.darkCard.withOpacity(0.8) : AppColors.lightBackground),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
              bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
              bottomRight: Radius.circular(isMe ? 4.r : 18.r),
            ),
            boxShadow: [
              BoxShadow(
                color: isMe
                    ? AppColors.tomato.withOpacity(0.25)
                    : (isDark 
                        ? Colors.black.withOpacity(0.2) 
                        : Colors.black.withOpacity(0.04)),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isVoice)
                Text(
                  message['message'] ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.35,
                    color: isMe 
                        ? Colors.white 
                        : textColor,
                  ),
                )
              else
                _buildVoiceMessage(message, isMe, index),

              SizedBox(height: 4.h),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message['time'] ?? '',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : subtitleColor,
                    ),
                  ),
                  if (isMe) ...[
                    SizedBox(width: 4.w),
                    Builder(
                      builder: (_) {
                        final status = message['status'] ?? 'sent';
                        return Icon(
                          status == 'read'
                              ? Icons.done_all_rounded
                              : Icons.done_rounded,
                          size: 14.r,
                          color: status == 'read'
                              ? Colors.cyanAccent
                              : Colors.white.withOpacity(0.7),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VOICE MESSAGE - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildVoiceMessage(Map<String, dynamic> message, bool isMe, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(
          () {
            final bool isPlaying = controller.playingIndex.value == index;
            return GestureDetector(
              onTap: () => controller.togglePlayVoice(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withOpacity(0.25)
                      : (isDark 
                          ? AppColors.darkCard 
                          : AppColors.tomato.withOpacity(0.12)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isMe 
                      ? Colors.white 
                      : AppColors.tomato,
                  size: 22.r,
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => LinearProgressIndicator(
                  value: controller.playingIndex.value == index
                      ? controller.playProgress.value
                      : 0.0,
                  backgroundColor: isMe
                      ? Colors.white.withOpacity(0.3)
                      : (isDark 
                          ? Colors.grey.shade700 
                          : AppColors.lightAsh.withOpacity(0.5)),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isMe ? Colors.white : AppColors.tomato,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                message['duration'] ?? '0:00',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: isMe
                      ? Colors.white.withOpacity(0.85)
                      : subtitleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM BAR - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3) 
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Input container
          Expanded(
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: controller.isRecording.value
                      ? AppColors.tomato.withOpacity(0.08)
                      : (isDark 
                          ? AppColors.darkCard 
                          : AppColors.lightAsh.withOpacity(0.25)),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: controller.isRecording.value
                        ? AppColors.tomato.withOpacity(0.4)
                        : Colors.transparent,
                  ),
                ),
                child: controller.isRecording.value
                    ? _buildRecordingUI()
                    : TextField(
                        controller: controller.messageController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: hintColor,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Send/Mic Button
          Obx(
            () => GestureDetector(
              onTap: () {
                if (controller.isTyping.value) {
                  controller.sendTextMessage();
                } else if (controller.isRecording.value) {
                  controller.stopAndSendVoice();
                } else {
                  controller.startRecording();
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tomato.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: Icon(
                    controller.isTyping.value
                        ? Icons.send_rounded
                        : (controller.isRecording.value
                            ? Icons.check_rounded
                            : Icons.mic_rounded),
                    key: ValueKey<String>(
                      controller.isTyping.value
                          ? 'send'
                          : (controller.isRecording.value
                              ? 'check'
                              : 'mic'),
                    ),
                    color: Colors.white,
                    size: 22.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECORDING UI - 🔥 Dark Mode Support
  // ============================================================
  Widget _buildRecordingUI() {
    return Row(
      children: [
        Row(
          children: List.generate(
            4,
            (index) => ScaleTransition(
              scale: Tween(begin: 0.5, end: 1.4).animate(
                CurvedAnimation(
                  parent: controller.waveController!,
                  curve: Interval(
                    index * 0.2,
                    1.0,
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
              child: Container(
                width: 6.r,
                height: 6.r,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: const BoxDecoration(
                  color: AppColors.tomato,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),

        Obx(
          () => Text(
            '0:${controller.recordSeconds.value < 10 ? '0' : ''}${controller.recordSeconds.value}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.tomato,
            ),
          ),
        ),
        const Spacer(),

        GestureDetector(
          onTap: controller.cancelRecording,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: isDark
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 18.r,
            ),
          ),
        ),
      ],
    );
  }
}