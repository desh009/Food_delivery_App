// lib/app/core/modules/Screens/voucher_screen/binder/voucher_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Voucher_screen/controller/voucher-screen_controller.dart';
import 'package:get/get.dart';

class VoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoucherController>(
      () => VoucherController(),
      fenix: true,
    );
  }
}