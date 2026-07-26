// lib/app/core/modules/Screens/Notification_screen/binder/notification_binder.dart

import 'package:get/get.dart';
import '../controller/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );
  }
}