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

  // Home page products list - এখানে আপনার প্রোডাক্ট গুলো যোগ করুন
  final List<String> homeProducts = [
    'pizza',
    'burger',
    'pasta',
    'sandwich',
    'salad',
    'steak',
    'sushi',
    'taco',
    'noodles',
    'rice',
    'chicken',
    'fish',
    'cake',
    'ice cream',
    'coffee',
    'tea',
    'juice',
    'smoothie',
    'fries',
    'pancake',
    // আপনার আরও প্রোডাক্ট যোগ করুন
  ];

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

    // প্রথমে চেক করুন এটি কোনো প্রোডাক্টের নাম কিনা
    String? foundProduct = _findProductInCommand(command);
    
    if (foundProduct != null) {
      // যদি প্রোডাক্ট পাওয়া যায়, তাহলে প্রোডাক্ট লিস্টে নিয়ে যান
      _tts.speak("Showing $foundProduct products");
      Get.toNamed(Routes.PRODUCT_LIST, arguments: {
        'category': foundProduct,
        'icon': '',
        'isSearch': true,
        'searchQuery': foundProduct,
      });
      return;
    }

    // যদি প্রোডাক্ট না পাওয়া যায়, তাহলে অন্যান্য কমান্ড চেক করুন
    _handleOtherCommands(command);
  }

  String? _findProductInCommand(String command) {
    // প্রথমে পুরো কমান্ড চেক করুন
    for (String product in homeProducts) {
      if (command.contains(product)) {
        return product;
      }
    }

    // যদি সরাসরি ম্যাচ না পায়, তাহলে কিছু স্মার্ট ডিটেকশন
    // যেমন: "I want pizza" -> "pizza"
    // "Show me burgers" -> "burger"
    // "Get some pasta" -> "pasta"
    
    // কিছু কমন প্যাটার্ন
    if (command.contains('i want') || 
        command.contains('i need') || 
        command.contains('show me') || 
        command.contains('get') || 
        command.contains('order') ||
        command.contains('buy') ||
        command.contains('bring')) {
      
      // প্যাটার্নের পরের অংশটি বের করুন
      List<String> words = command.split(' ');
      for (String word in words) {
        // Singular/Plural handling
        String singularWord = word.replaceAll(RegExp(r's$'), '');
        for (String product in homeProducts) {
          if (word.contains(product) || singularWord.contains(product)) {
            return product;
          }
        }
      }
    }

    return null;
  }

  void _handleOtherCommands(String command) {
    // Special Offer
    if (command.contains('special offer') || 
        command.contains('offer') || 
        command.contains('deal')) {
      _tts.speak("Opening special offers");
      Get.toNamed(Routes.SPECIAL_OFFER);
    }
    
    // Cart
    else if (command.contains('cart') || 
             command.contains('my cart') || 
             command.contains('shopping cart')) {
      _tts.speak("Opening your cart");
      Get.toNamed(Routes.CART_ITEM);
    }
    
    // Review
    else if (command.contains('review') || 
             command.contains('rating') || 
             command.contains('feedback')) {
      _tts.speak("Opening reviews");
      Get.toNamed(Routes.REVIEW_ITEM);
    }
    
    // Payment Method
    else if (command.contains('payment') || 
             command.contains('pay') || 
             command.contains('payment method')) {
      _tts.speak("Opening payment methods");
      Get.toNamed(Routes.PAYMENT_METHOD);
    }
    
    // Help Center
    else if (command.contains('help') || 
             command.contains('support') || 
             command.contains('assistance') || 
             command.contains('help center')) {
      _tts.speak("Opening help center");
      Get.toNamed(Routes.HELP_CENTER);
    }
    
    // Order Details
    else if (command.contains('order') || 
             command.contains('my order') || 
             command.contains('orders')) {
      _tts.speak("Opening your orders");
      Get.toNamed(Routes.ORDER_DETAILS);
    }
    
    // Liked/Favourites
    else if (command.contains('favourite') || 
             command.contains('favorite') || 
             command.contains('liked') || 
             command.contains('wishlist') || 
             command.contains('saved')) {
      _tts.speak("Opening your favourites");
      Get.toNamed(Routes.LIKED_SCREEN);
    }
    
    // Profile Edit
    else if (command.contains('profile') || 
             command.contains('edit profile') || 
             command.contains('my profile')) {
      _tts.speak("Opening profile");
      Get.toNamed(Routes.PROFILE_EDIT);
    }
    
    // Track Order
    else if (command.contains('track') || 
             command.contains('track order') || 
             command.contains('tracking')) {
      _tts.speak("Opening order tracking");
      Get.toNamed(Routes.TRACK_ORDER);
    }
    
    // Security
    else if (command.contains('security') || 
             command.contains('password') || 
             command.contains('privacy')) {
      _tts.speak("Opening security settings");
      Get.toNamed(Routes.SECURITY);
    }
    
    // About App
    else if (command.contains('about') || 
             command.contains('about app')) {
      _tts.speak("Opening about app");
      Get.toNamed(Routes.ABOUT_APP);
    }
    
    // Voucher
    else if (command.contains('voucher') || 
             command.contains('coupon') || 
             command.contains('discount') || 
             command.contains('promo')) {
      _tts.speak("Opening vouchers");
      Get.toNamed(Routes.VOUCHER);
    }
    
    // Add to Cart List Item
    else if (command.contains('add to cart') || 
             command.contains('add item') || 
             command.contains('add product')) {
      _tts.speak("Opening add to cart");
      Get.toNamed(Routes.ADD_TO_CART_LIST_ITEM);
    }
    
    // Invite Friends
    else if (command.contains('invite') || 
             command.contains('share') || 
             command.contains('invite friends') || 
             command.contains('refer')) {
      _tts.speak("Opening invite friends");
      Get.toNamed(Routes.INVITE_FRIENDS);
    }
    
    // Message
    else if (command.contains('message') || 
             command.contains('inbox') || 
             command.contains('chat') || 
             command.contains('messages')) {
      _tts.speak("Opening messages");
      Get.toNamed(Routes.MESSAGE);
    }
    
    // Terms and Services
    else if (command.contains('terms') || 
             command.contains('service') || 
             command.contains('terms and services')) {
      _tts.speak("Opening terms and services");
      Get.toNamed(Routes.TERMS_AND_SERVICES);
    }
    
    // Privacy and Policy
    else if (command.contains('privacy') || 
             command.contains('policy') || 
             command.contains('privacy policy')) {
      _tts.speak("Opening privacy policy");
      Get.toNamed(Routes.PRIVACY_AND_POLICY);
    }
    
    // Forget Password
    else if (command.contains('forget password') || 
             command.contains('forgot password') || 
             command.contains('reset password')) {
      _tts.speak("Opening password reset");
      Get.toNamed(Routes.FORGET_PASSWORD);
    }
    
    // Code Verify
    else if (command.contains('verify') || 
             command.contains('verification') || 
             command.contains('code')) {
      _tts.speak("Opening verification");
      Get.toNamed(Routes.CODE_VERIFY);
    }
    
    // Home
    else if (command.contains('home') || 
             command.contains('main') || 
             command.contains('dashboard')) {
      _tts.speak("Going to home");
      Get.toNamed(Routes.HOME);
    }
    
    // Search (if no specific product found but search keyword present)
    else if (command.startsWith('search') || 
             command.contains('find') || 
             command.contains('looking for') || 
             command.contains('show me') || 
             command.contains('find me') ||
             command.contains('get me')) {
      
      String query = command
          .replaceFirst('search', '')
          .replaceFirst('find me', '')
          .replaceFirst('looking for', '')
          .replaceFirst('show me', '')
          .replaceFirst('find', '')
          .replaceFirst('get me', '')
          .replaceFirst('for', '')
          .trim();
      
      if (query.isNotEmpty) {
        _tts.speak("Searching for $query");
        Get.toNamed(Routes.PRODUCT_LIST, arguments: {
          'category': query,
          'icon': '',
          'isSearch': true,
          'searchQuery': query,
        });
      } else {
        _tts.speak("Please specify what you want to search");
        // Default product list
        Get.toNamed(Routes.PRODUCT_LIST, arguments: {
          'category': 'all',
          'icon': '',
          'isSearch': false,
        });
      }
    }
    
    // Unknown command
    else {
      _tts.speak("I didn't understand. Please try saying product name or a valid command.");
    }
  }

  // হোম প্রোডাক্ট লিস্ট আপডেট করার জন্য মেথড (যদি প্রয়োজন হয়)
  void updateHomeProducts(List<String> newProducts) {
    homeProducts.clear();
    homeProducts.addAll(newProducts);
  }
}