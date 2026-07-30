// lib/app/core/modules/Screens/message_screen/binding/message_binding.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/Massage_Screen/controller/massage_screen_controller.dart';
import 'package:get/get.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
  }
}
