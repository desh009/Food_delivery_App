import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // শুধু HomeController রাখুন
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}