import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/controller/order-screen_controller.dart';
import 'package:get/get.dart';

class OrderDetailsBinding extends Bindings {
  final String? orderId;
  
  OrderDetailsBinding({this.orderId});
  
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailsController>(
      () => OrderDetailsController(
        orderId: orderId,
      ),
      fenix: true, // Keeps controller alive even when not in use
    );
  }
}