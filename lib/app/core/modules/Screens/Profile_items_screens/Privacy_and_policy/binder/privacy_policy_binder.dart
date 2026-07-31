// lib/app/core/modules/Screens/Profile_items_screens/Privacy_Policy_Screen/binder/privacy_policy_binder.dart

import 'package:get/get.dart';
import '../controller/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(),
      fenix: true,
    );
  }
}