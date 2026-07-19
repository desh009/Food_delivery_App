import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/controller/special_offer_controller.dart';
import 'package:get/get.dart';

class SpecialOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpecialOffersController>(() => SpecialOffersController());
  }
}