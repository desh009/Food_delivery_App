import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/controller/helpcenter-controller.dart';
import 'package:get/get.dart';

class HelpCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpCenterController>(
      () => HelpCenterController(),
    );
  }
}