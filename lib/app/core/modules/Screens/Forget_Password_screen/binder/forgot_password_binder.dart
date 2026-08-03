import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/controller/forget_password_controller.dart';
import 'package:get/get.dart';

// Forgot Password Screen Binding
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}

// Active Sessions Screen Binding
// class ActiveSessionBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ActiveSessionController>(
//       () => ActiveSessionController(),
//     );
//   }
// }