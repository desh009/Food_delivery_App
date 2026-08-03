import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/Code_verify/controller/code_verify_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
  }
}