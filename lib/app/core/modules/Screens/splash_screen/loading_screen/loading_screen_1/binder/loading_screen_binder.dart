import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_1/controller/loading_screen_controller.dart';
import 'package:get/get.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}