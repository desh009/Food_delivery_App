// lib/app/core/modules/Screens/message_screen/controller/message_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  // ========== Observable Variables ==========
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Observable states
  final RxBool isTyping = false.obs;
  final RxBool isRecording = false.obs;
  final RxInt recordSeconds = 0.obs;
  Timer? recordTimer;

  // Audio Playback States
  final RxInt playingIndex = (-1).obs;
  final RxDouble playProgress = 0.0.obs;
  Timer? playTimer;

  // Animation Controllers
  AnimationController? pulseController;
  AnimationController? waveController;

  // ========== Messages ==========
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[
    {
      'id': '1',
      'isMe': false,
      'type': 'text',
      'message': 'Hello! I am on my way with your hot meal. 🍕',
      'time': '10:20 AM',
      'status': 'read',
    },
    {
      'id': '2',
      'isMe': true,
      'type': 'text',
      'message': 'Awesome! Please make sure the drinks are extra cold. 🥤',
      'time': '10:21 AM',
      'status': 'read',
    },
    {
      'id': '3',
      'isMe': false,
      'type': 'voice',
      'duration': '0:12',
      'time': '10:22 AM',
      'status': 'read',
    },
    {
      'id': '4',
      'isMe': true,
      'type': 'text',
      'message': 'Got it, thanks a lot!',
      'time': '10:23 AM',
      'status': 'delivered',
    },
  ].obs;

  // ========== Getters ==========
  bool get hasText => messageController.text.trim().isNotEmpty;

  // ========== Lifecycle Methods ==========
  @override
  void onInit() {
    super.onInit();
    messageController.addListener(_onTextChanged);
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    recordTimer?.cancel();
    playTimer?.cancel();
    // 🔥 এখানে dispose করার চেষ্টা করা হচ্ছে (যদি View নিজে থেকে আগেই না করে থাকে)
    disposeAnimations();
    super.onClose();
  }

  // ========== Initialize Animations ==========
  // View-এর initState() থেকে vsync (TickerProvider) পাস করে কল হয়
  void initAnimations(TickerProvider vsync) {
    // 🔥 যদি আগের কোনো controller এখনো active থাকে (রি-এন্ট্রি করলে), আগে সেটা সরিয়ে দিন
    disposeAnimations();

    pulseController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    waveController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  // 🔥 NEW: View dispose হওয়ার সময় এইটা কল করতে হবে, কারণ এই AnimationController গুলো
  // View-এর TickerProvider (vsync: this) দিয়ে বানানো — controller নিজে GetX দিয়ে
  // permanent/find করা হলে onClose() ট্রিগার নাও হতে পারে, তাই View নিজে থেকেই
  // dispose নিশ্চিত করা দরকার, নাহলে "disposed with an active Ticker" error আসবে।
  void disposeAnimations() {
    pulseController?.dispose();
    pulseController = null;
    waveController?.dispose();
    waveController = null;
  }

  // ========== Text Change Listener ==========
  void _onTextChanged() {
    isTyping.value = messageController.text.trim().isNotEmpty;
  }

  // ========== Voice Recording Logic ==========
  void startRecording() {
    isRecording.value = true;
    recordSeconds.value = 0;

    recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordSeconds.value++;
    });
  }

  void stopAndSendVoice() {
    if (recordSeconds.value < 1) {
      cancelRecording();
      return;
    }

    final durationString =
        '0:${recordSeconds.value < 10 ? '0' : ''}${recordSeconds.value}';

    recordTimer?.cancel();
    isRecording.value = false;

    messages.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'isMe': true,
      'type': 'voice',
      'duration': durationString,
      'time': 'Just now',
      'status': 'sent',
    });

    recordSeconds.value = 0;
    scrollToBottom();
  }

  void cancelRecording() {
    recordTimer?.cancel();
    isRecording.value = false;
    recordSeconds.value = 0;
  }

  // ========== Send Text Message ==========
  void sendTextMessage() {
    if (messageController.text.trim().isEmpty) return;

    messages.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'isMe': true,
      'type': 'text',
      'message': messageController.text.trim(),
      'time': 'Just now',
      'status': 'sent',
    });

    messageController.clear();
    isTyping.value = false;
    scrollToBottom();
  }

  // ========== Audio Playback ==========
  void togglePlayVoice(int index) {
    if (playingIndex.value == index) {
      stopVoicePlayback();
    } else {
      stopVoicePlayback();
      playingIndex.value = index;
      playProgress.value = 0.0;

      playTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        playProgress.value += 0.05;
        if (playProgress.value >= 1.0) {
          stopVoicePlayback();
        }
      });
    }
  }

  void stopVoicePlayback() {
    playTimer?.cancel();
    playingIndex.value = -1;
    playProgress.value = 0.0;
  }

  // ========== Update Message Status ==========
  void updateMessageStatus(String messageId, String newStatus) {
    final index = messages.indexWhere((msg) => msg['id'] == messageId);
    if (index != -1) {
      messages[index]['status'] = newStatus;
      messages.refresh();
    }
  }

  // ========== Scroll to Bottom ==========
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  // ========== Navigation ==========
  void goBack() {
    Get.back();
  }

  // ========== Call Action ==========
  void makeCall() {
    Get.snackbar(
      'Call',
      'Calling delivery partner...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}