// lib/app/core/modules/Screens/Liked_screen/binder/liked_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/controller/favourite_screen_controller.dart';
import 'package:get/get.dart';

class LikedBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy put - Controller will be created when first accessed
    Get.lazyPut<LikedController>(
      () => LikedController(),
      fenix: true, // Keeps controller alive even when not in use
    );
  }
}