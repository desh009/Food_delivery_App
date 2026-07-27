// lib/app/core/modules/Screens/security_screen/binder/security_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/controller/security_screen_controller.dart';
import 'package:get/get.dart';

class SecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityController>(
      () => SecurityController(),
    );
  }
}