import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/controller/product_list_controller.dart';
import 'package:get/get.dart';

class ProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductListController>(() => ProductListController());
  }
}