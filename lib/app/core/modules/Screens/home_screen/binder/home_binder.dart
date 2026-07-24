import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}