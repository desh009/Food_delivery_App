// lib/app/core/modules/Screens/Profile_items_screens/about_app_screen/binder/about_app_binder.dart

import 'package:get/get.dart';
import '../controller/about_app_controller.dart';

class AboutAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutAppController>(
      () => AboutAppController(),
      fenix: true,
    );
  }
}