// lib/app/core/modules/Screens/invite_friend/binding/invite_friend_binding.dart

import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Invite_Friends_Screen/controller/invite_friends_controller.dart';
import 'package:get/get.dart';

class InviteFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteFriendController>(
      () => InviteFriendController(),
      fenix: true, // Controller টি memory তে থাকবে
    );
  }
}