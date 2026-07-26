// lib/app/core/modules/Screens/Your_Profile_screen/binder/your_profile_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/profile_edit_screen/controller/profile_edit_controller.dart';
import 'package:get/get.dart';

class YourProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourProfileController>(
      () => YourProfileController(),
      fenix: true,
    );
  }
}