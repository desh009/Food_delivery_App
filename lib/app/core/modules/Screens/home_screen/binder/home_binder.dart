import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:get/instance_manager.dart';

class HomeBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}