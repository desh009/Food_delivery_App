// lib/app/core/widgets/Voice_controller/voice_controller.dart

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class VoiceActionController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString userSpeechText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    isAvailable.value = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          isListening.value = false;
        }
      },
      onError: (error) {
        isListening.value = false;
      },
    );
  }

  Future<void> startListening() async {
    var micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      micStatus = await Permission.microphone.request();
    }
    if (!micStatus.isGranted) return;

    if (!isAvailable.value) {
      await _initSpeech();
    }
    if (!isAvailable.value) return;

    userSpeechText.value = '';
    isListening.value = true;

    await _speech.listen(
      onResult: (result) {
        userSpeechText.value = result.recognizedWords;
        if (result.finalResult) {
          isListening.value = false;
          _handleCommand(result.recognizedWords);
        }
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  void _handleCommand(String rawText) {
    final command = rawText.toLowerCase().trim();
    if (command.isEmpty) return;

    if (command.contains('cart')) {
      Get.toNamed(Routes.CART_ITEM);
    } else if (command.contains('order')) {
      Get.toNamed(Routes.ORDER_DETAILS);
    } else if (command.contains('notification')) {
      Get.toNamed(Routes.NOTIFICATION);
    } else if (command.contains('favourite') || command.contains('favorite') || command.contains('liked')) {
      Get.toNamed(Routes.LIKED_SCREEN);
    } else if (command.contains('help')) {
      Get.toNamed(Routes.HELP_CENTER);
    } else if (command.contains('home')) {
      Get.toNamed(Routes.HOME);
    } else if (command.startsWith('search')) {
      final query = command.replaceFirst('search', '').replaceFirst('for', '').trim();
      Get.toNamed(Routes.PRODUCT_LIST, arguments: {'category': query, 'icon': ''});
    }
  }
}
