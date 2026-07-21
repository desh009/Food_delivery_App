import 'package:food_hjoiopk/app/core/modules/Screens/Review_Screen/controller/review-screen_controller.dart';
import 'package:get/get.dart';

class ProductReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductReviewsController>(
      () => ProductReviewsController(),
    );
  }
}