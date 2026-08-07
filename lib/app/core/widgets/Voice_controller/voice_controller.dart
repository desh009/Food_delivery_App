// lib/app/core/widgets/Voice_controller/voice_controller.dart

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';

class VoiceActionController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString userSpeechText = ''.obs;

  // ============================================================
  // 📦 হোম ক্যাটাগরি লিস্ট
  // ============================================================
  final List<String> homeCategories = [
    'burger',
    'pizza',
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
  ];

  // ============================================================
  // 📦 সব প্রোডাক্টের লিস্ট
  // ============================================================
  final List<ProductModel> allProducts = [
    // 🍔 BURGER
    ProductModel(
      id: 'b1',
      name: 'Chicken Burger',
      category: 'Burger',
      rating: 4.9,
      price: 6.00,
      oldPrice: 10.00,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500',
      description: 'Juicy grilled chicken burger with fresh lettuce and special sauce',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'b2',
      name: 'Beef Burger',
      category: 'Burger',
      rating: 4.9,
      price: 10.00,
      oldPrice: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500',
      description: 'Premium beef patty with melted cheese and caramelized onions',
      isFavorite: null,
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'b3',
      name: 'Fish Burger',
      category: 'Burger',
      rating: 4.7,
      price: 8.00,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?q=80&w=500',
      description: 'Crispy fish fillet with tartar sauce and lettuce',
      isFavorite: null,
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'b4',
      name: 'Turkey Burger',
      category: 'Burger',
      rating: 4.8,
      price: 7.50,
      imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?q=80&w=500',
      description: 'Lean turkey patty with avocado and roasted peppers',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'b5',
      name: 'Double Cheese Burger',
      category: 'Burger',
      rating: 4.9,
      price: 11.00,
      oldPrice: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=500',
      description: 'Double patty with extra cheese and bacon',
      image: '',
      title: '',
    ),

    // 🍕 PIZZA
    ProductModel(
      id: 'p1',
      name: 'Margherita Pizza',
      category: 'Pizza',
      rating: 4.9,
      price: 12.00,
      oldPrice: 16.00,
      imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?q=80&w=500',
      description: 'Classic pizza with fresh mozzarella and basil',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'p2',
      name: 'Pepperoni Pizza',
      category: 'Pizza',
      rating: 4.8,
      price: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?q=80&w=500',
      description: 'Classic pepperoni pizza with extra cheese',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'p3',
      name: 'Chicken Tandoori Pizza',
      category: 'Pizza',
      rating: 4.7,
      price: 13.00,
      imageUrl: 'https://images.unsplash.com/photo-1595853035070-59a39fe84de3?q=80&w=500',
      description: 'Spicy tandoori chicken with onions and peppers',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'p4',
      name: 'Four Cheese Pizza',
      category: 'Pizza',
      rating: 4.6,
      price: 15.00,
      oldPrice: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1590947132387-155cc02f3212?q=80&w=500',
      description: 'Mozzarella, cheddar, parmesan and gorgonzola',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'p5',
      name: 'Beef Pizza',
      category: 'Pizza',
      rating: 4.8,
      price: 16.00,
      oldPrice: 19.00,
      imageUrl: 'https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?q=80&w=500',
      description: 'Premium beef pizza with caramelized onions',
      image: '',
      title: '',
    ),

    // 🍝 PASTA
    ProductModel(
      id: 'ps1',
      name: 'Creamy Alfredo Pasta',
      category: 'Pasta',
      rating: 4.9,
      price: 11.00,
      oldPrice: 14.00,
      imageUrl: 'https://images.unsplash.com/photo-1645112411341-6c4fd023714a?q=80&w=500',
      description: 'Rich and creamy Alfredo pasta with parmesan',
      image: '',
      title: '',
    ),
    ProductModel(
      id: 'ps2',
      name: 'Spaghetti Bolognese',
      category: 'Pasta',
      rating: 4.8,
      price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1622973536968-3ead9e780960?q=80&w=500',
      description: 'Classic spaghetti with meat sauce',
      image: '',
      title: '',
    ),
  ];

  // ============================================================
  // 🚀 LIFECYCLE
  // ============================================================
  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  // ============================================================
  // 🎤 SPEECH INITIALIZATION
  // ============================================================
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

  // ============================================================
  // 🎤 START LISTENING
  // ============================================================
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

  // ============================================================
  // 🎤 STOP LISTENING
  // ============================================================
  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
  }

  // ============================================================
  // 🔊 TEXT TO SPEECH
  // ============================================================
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  // ============================================================
  // 🧠 MAIN COMMAND HANDLER
  // ============================================================
  void _handleCommand(String rawText) {
    final command = rawText.toLowerCase().trim();
    if (command.isEmpty) return;

    // ============================================================
    // 🔍 চেক করুন - এটি কি নির্দিষ্ট প্রোডাক্টের নাম?
    // "Chicken Burger" → Product Details Screen
    // ============================================================
    final ProductModel? matchedProduct = _findExactProduct(command);
    
    if (matchedProduct != null) {
      _tts.speak("Opening ${matchedProduct.name}");
      Get.toNamed(
        Routes.PRODUCT_DETAILS,
        arguments: matchedProduct,
      );
      return;
    }

    // ============================================================
    // 🔍 চেক করুন - এটি কি ক্যাটাগরি?
    // "burger" → Product List Screen
    // ============================================================
    String? foundCategory = _findCategoryInCommand(command);
    if (foundCategory != null) {
      _tts.speak("Showing $foundCategory products");
      Get.toNamed(
        Routes.PRODUCT_LIST,
        arguments: {
          'category': foundCategory,
          'icon': _getProductIcon(foundCategory),
          'isVoiceSearch': true,
          'searchQuery': foundCategory,
        },
      );
      return;
    }

    // ============================================================
    // 🌐 গ্লোবাল কমান্ড
    // ============================================================
    _handleGlobalCommands(command);
  }

  // ============================================================
  // 🔍 সঠিক প্রোডাক্ট খুঁজুন (পুরো ProductModel রিটার্ন করবে)
  // ============================================================
  ProductModel? _findExactProduct(String command) {
    String cleanCommand = command;
    
    // অপ্রয়োজনীয় শব্দ সরান
    cleanCommand = cleanCommand.replaceAll('add', '').trim();
    cleanCommand = cleanCommand.replaceAll('to cart', '').trim();
    cleanCommand = cleanCommand.replaceAll('to basket', '').trim();
    cleanCommand = cleanCommand.replaceAll('please', '').trim();
    cleanCommand = cleanCommand.replaceAll('my cart', '').trim();
    cleanCommand = cleanCommand.replaceAll('show', '').trim();
    cleanCommand = cleanCommand.replaceAll('open', '').trim();
    cleanCommand = cleanCommand.replaceAll('view', '').trim();
    cleanCommand = cleanCommand.replaceAll('go to', '').trim();
    cleanCommand = cleanCommand.replaceAll('i want', '').trim();
    cleanCommand = cleanCommand.replaceAll('i need', '').trim();
    
    if (cleanCommand.isEmpty) return null;
    
    // এক্সাক্ট ম্যাচ
    for (ProductModel product in allProducts) {
      if (product.name.toLowerCase() == cleanCommand) {
        return product;
      }
    }
    
    // Partial match (যেমন "Chicken" বললে "Chicken Burger" পাবে)
    final List<ProductModel> matches = allProducts.where(
      (p) => p.name.toLowerCase().contains(cleanCommand)
    ).toList();
    
    if (matches.length == 1) {
      return matches.first;
    } else if (matches.length > 1) {
      // একাধিক ম্যাচ - ইউজারকে বলুন স্পেসিফিক করতে
      _tts.speak("Found ${matches.length} products. Please say the full name.");
      return null;
    }
    
    return null;
  }

  // ============================================================
  // 🔍 ক্যাটাগরি খুঁজুন
  // ============================================================
  String? _findCategoryInCommand(String command) {
    for (String category in homeCategories) {
      if (command.contains(category)) {
        // চেক করুন এটি প্রোডাক্টের নাম না
        bool isProductName = false;
        for (ProductModel product in allProducts) {
          if (product.name.toLowerCase() == command) {
            isProductName = true;
            break;
          }
        }
        
        if (!isProductName) {
          return category;
        }
      }
    }
    return null;
  }

  // ============================================================
  // 🎨 প্রোডাক্ট আইকন
  // ============================================================
  String _getProductIcon(String product) {
    switch (product.toLowerCase()) {
      case 'pizza': return '🍕';
      case 'burger': return '🍔';
      case 'pasta': return '🍝';
      case 'sandwich': return '🥪';
      case 'salad': return '🥗';
      case 'steak': return '🥩';
      case 'sushi': return '🍣';
      case 'taco': return '🌮';
      case 'noodles': return '🍜';
      case 'rice': return '🍚';
      case 'chicken': return '🍗';
      case 'fish': return '🐟';
      case 'cake': return '🎂';
      case 'ice cream': return '🍦';
      case 'coffee': return '☕';
      case 'tea': return '🍵';
      case 'juice': return '🧃';
      case 'smoothie': return '🥤';
      case 'fries': return '🍟';
      case 'pancake': return '🥞';
      default: return '🍽️';
    }
  }

  // ============================================================
  // 🌐 গ্লোবাল কমান্ড
  // ============================================================
  void _handleGlobalCommands(String command) {
    // 🛒 My Basket / Cart
    if (command.contains('my basket') ||
        command.contains('basket') ||
        command.contains('my cart') ||
        command.contains('open cart') ||
        command.contains('go to cart') ||
        command.contains('show cart') ||
        command.contains('view cart') ||
        command.contains('cart')) {
      _tts.speak("Opening your cart");
      Get.toNamed(Routes.CART_ITEM);
    }

    // 🔔 Notification
    else if (command.contains('notification') ||
        command.contains('notifications') ||
        command.contains('alert') ||
        command.contains('bell')) {
      _tts.speak("Opening notifications");
      Get.toNamed(Routes.NOTIFICATION);
    }

    // 🎁 Special Offer
    else if (command.contains('special offer') ||
        command.contains('offer') ||
        command.contains('deal') ||
        command.contains('special deals')) {
      _tts.speak("Opening special offers");
      Get.toNamed(Routes.SPECIAL_OFFER);
    }

    // 📦 Order Details
    else if (command.contains('order') ||
        command.contains('my order') ||
        command.contains('orders') ||
        command.contains('order details')) {
      _tts.speak("Opening your orders");
      Get.toNamed(Routes.ORDER_DETAILS);
    }

    // ❤️ Liked/Favourites
    else if (command.contains('favourite') ||
        command.contains('favorite') ||
        command.contains('liked') ||
        command.contains('wishlist') ||
        command.contains('saved')) {
      _tts.speak("Opening your favourites");
      Get.toNamed(Routes.LIKED_SCREEN);
    }

    // 👤 Profile Edit
    else if (command.contains('profile') ||
        command.contains('edit profile') ||
        command.contains('my profile')) {
      _tts.speak("Opening profile");
      Get.toNamed(Routes.PROFILE_EDIT);
    }

    // 📍 Track Order
    else if (command.contains('track') ||
        command.contains('track order') ||
        command.contains('tracking')) {
      _tts.speak("Opening order tracking");
      Get.toNamed(Routes.TRACK_ORDER);
    }

    // 💳 Payment
    else if (command.contains('payment') ||
        command.contains('pay') ||
        command.contains('payment method') ||
        command.contains('checkout')) {
      _tts.speak("Opening payment methods");
      Get.toNamed(Routes.PAYMENT_METHOD);
    }

    // 🆘 Help
    else if (command.contains('help') ||
        command.contains('support') ||
        command.contains('help center') ||
        command.contains('customer support')) {
      _tts.speak("Opening help center");
      Get.toNamed(Routes.HELP_CENTER);
    }

    // 🔒 Security
    else if (command.contains('security') ||
        command.contains('password') ||
        command.contains('privacy') ||
        command.contains('security settings')) {
      _tts.speak("Opening security settings");
      Get.toNamed(Routes.SECURITY);
    }

    // ℹ️ About
    else if (command.contains('about') ||
        command.contains('about app') ||
        command.contains('app info')) {
      _tts.speak("Opening about app");
      Get.toNamed(Routes.ABOUT_APP);
    }

    // 🎫 Voucher
    else if (command.contains('voucher') ||
        command.contains('coupon') ||
        command.contains('discount') ||
        command.contains('promo')) {
      _tts.speak("Opening vouchers");
      Get.toNamed(Routes.VOUCHER);
    }

    // 👥 Invite Friends
    else if (command.contains('invite') ||
        command.contains('share') ||
        command.contains('invite friends') ||
        command.contains('refer')) {
      _tts.speak("Opening invite friends");
      Get.toNamed(Routes.INVITE_FRIENDS);
    }

    // 💬 Message
    else if (command.contains('message') ||
        command.contains('inbox') ||
        command.contains('chat') ||
        command.contains('messages')) {
      _tts.speak("Opening messages");
      Get.toNamed(Routes.MESSAGE);
    }

    // 🏠 Home
    else if (command.contains('home') ||
        command.contains('main') ||
        command.contains('dashboard') ||
        command.contains('go home')) {
      _tts.speak("Going to home");
      Get.offAllNamed(Routes.HOME);
    }

    // ⬅️ Back
    else if (command.contains('back') ||
        command.contains('previous') ||
        command.contains('go back')) {
      _tts.speak("Going back");
      Get.back();
    }

    // ❓ Unknown
    else {
      _tts.speak("I didn't understand. Please try again.");
    }
  }

  // ============================================================
  // 🔄 হোম ক্যাটাগরি আপডেট
  // ============================================================
  void updateHomeCategories(List<String> newCategories) {
    homeCategories.clear();
    homeCategories.addAll(newCategories);
  }

  // ============================================================
  // 📦 সব প্রোডাক্ট রিটার্ন
  // ============================================================
  List<ProductModel> getAllProducts() {
    return allProducts;
  }
}