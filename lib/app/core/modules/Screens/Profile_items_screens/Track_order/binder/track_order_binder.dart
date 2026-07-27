// lib/app/core/modules/Screens/track_order_screen/binder/track_order_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Track_order/controller/track_order_controller.dart';
import 'package:get/get.dart';

class TrackOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrackOrderController>(
      () => TrackOrderController(),
    );
  }
}