// lib/app/core/modules/Screens/Profile_items_screens/Terms_and_Services_Screen/binder/terms_and_services_binder.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Terms_and_service/controller/terms_and_service_controller.dart';
import 'package:get/get.dart';

class TermsAndServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndServicesController>(
      () => TermsAndServicesController(),
      fenix: true,
    );
  }
}