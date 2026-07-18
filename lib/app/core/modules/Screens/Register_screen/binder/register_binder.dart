import 'package:food_hjoiopk/app/core/modules/Screens/Register_screen/controller/Register_controller.dart';
import 'package:get/get.dart';


class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
  }
}