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

    // Special Offer
    if (command.contains('special offer') || 
        command.contains('offer') || 
        command.contains('deal')) {
      Get.toNamed(Routes.SPECIAL_OFFER);
    }
    
    // Cart
    else if (command.contains('cart') || 
             command.contains('my cart') || 
             command.contains('shopping cart')) {
      Get.toNamed(Routes.CART_ITEM);
    }
    
    // Review
    else if (command.contains('review') || 
             command.contains('rating') || 
             command.contains('feedback')) {
      Get.toNamed(Routes.REVIEW_ITEM);
    }
    
    // Payment Method
    else if (command.contains('payment') || 
             command.contains('pay') || 
             command.contains('payment method')) {
      Get.toNamed(Routes.PAYMENT_METHOD);
    }
    
    // Help Center
    else if (command.contains('help') || 
             command.contains('support') || 
             command.contains('assistance') || 
             command.contains('help center')) {
      Get.toNamed(Routes.HELP_CENTER);
    }
    
    // Order Details
    else if (command.contains('order') || 
             command.contains('my order') || 
             command.contains('orders')) {
      Get.toNamed(Routes.ORDER_DETAILS);
    }
    
    // Liked/Favourites
    else if (command.contains('favourite') || 
             command.contains('favorite') || 
             command.contains('liked') || 
             command.contains('wishlist') || 
             command.contains('saved')) {
      Get.toNamed(Routes.LIKED_SCREEN);
    }
    
    // Profile Edit
    else if (command.contains('profile') || 
             command.contains('edit profile') || 
             command.contains('my profile')) {
      Get.toNamed(Routes.PROFILE_EDIT);
    }
    
    // Track Order
    else if (command.contains('track') || 
             command.contains('track order') || 
             command.contains('tracking') || 
             command.contains('where is my order')) {
      Get.toNamed(Routes.TRACK_ORDER);
    }
    
    // Security
    else if (command.contains('security') || 
             command.contains('password') || 
             command.contains('privacy') || 
             command.contains('secure')) {
      Get.toNamed(Routes.SECURITY);
    }
    
    // About App
    else if (command.contains('about') || 
             command.contains('about app') || 
             command.contains('information')) {
      Get.toNamed(Routes.ABOUT_APP);
    }
    
    // Voucher
    else if (command.contains('voucher') || 
             command.contains('coupon') || 
             command.contains('discount') || 
             command.contains('promo')) {
      Get.toNamed(Routes.VOUCHER);
    }
    
    // Add to Cart List Item
    else if (command.contains('add to cart') || 
             command.contains('add item') || 
             command.contains('add product')) {
      Get.toNamed(Routes.ADD_TO_CART_LIST_ITEM);
    }
    
    // Invite Friends
    else if (command.contains('invite') || 
             command.contains('share') || 
             command.contains('invite friends') || 
             command.contains('refer')) {
      Get.toNamed(Routes.INVITE_FRIENDS);
    }
    
    // Message
    else if (command.contains('message') || 
             command.contains('inbox') || 
             command.contains('chat') || 
             command.contains('messages')) {
      Get.toNamed(Routes.MESSAGE);
    }
    
    // Terms and Services
    else if (command.contains('terms') || 
             command.contains('service') || 
             command.contains('terms and services') || 
             command.contains('term')) {
      Get.toNamed(Routes.TERMS_AND_SERVICES);
    }
    
    // Privacy and Policy
    else if (command.contains('privacy') || 
             command.contains('policy') || 
             command.contains('privacy policy')) {
      Get.toNamed(Routes.PRIVACY_AND_POLICY);
    }
    

    
 
    
    // Home (default)
    else if (command.contains('home') || 
             command.contains('main') || 
             command.contains('dashboard') || 
             command.contains('go back home')) {
      Get.toNamed(Routes.HOME);
    }
    
    // Notification (if you have this route defined)
    else if (command.contains('notification') || 
             command.contains('alert') || 
             command.contains('bell') || 
             command.contains('notify')) {
      Get.toNamed(Routes.NOTIFICATION);
    }
    
    // Product Search with category
    else if (command.startsWith('search') || 
             command.contains('find') || 
             command.contains('looking for') || 
             command.contains('show me') || 
             command.contains('find me')) {
      String query = command
          .replaceFirst('search', '')
          .replaceFirst('find me', '')
          .replaceFirst('looking for', '')
          .replaceFirst('show me', '')
          .replaceFirst('find', '')
          .replaceFirst('for', '')
          .trim();
      
      if (query.isNotEmpty) {
        Get.toNamed(Routes.PRODUCT_LIST, arguments: {
          'category': query, 
          'icon': '',
          'isSearch': true // Optional: add this if you want to handle search differently
        });
      } else {
        // If no specific product mentioned, show general product list
        Get.toNamed(Routes.PRODUCT_LIST, arguments: {
          'category': 'all', 
          'icon': '',
          'isSearch': false
        });
      }
    }
    
    // Unknown command - provide feedback
    else {
      _tts.speak("I didn't understand that. Please try again.");
    }
  }
}