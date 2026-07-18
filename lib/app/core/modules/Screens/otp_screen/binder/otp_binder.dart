import 'package:food_hjoiopk/app/core/modules/Screens/otp_screen/controller/otp_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class OtpBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationController>(() => VerificationController());
  }
}