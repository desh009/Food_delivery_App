import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/controller/login_screen_controller.dart';
import 'package:get/get.dart';

class Login1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Login1Controller>(
      () => Login1Controller(),
    );
  }
}