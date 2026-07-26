import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/controller/profile_controller.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/animated_favourite_button/favourite_service/favourite_screen_service.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BottomNavController>(BottomNavController(), permanent: true);
    Get.put<FavoriteService>(FavoriteService(), permanent: true);  // ← এটা গুরুত্বপূর্ণ

    Get.put<ProfileController>(ProfileController(), permanent: true);



    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut<HomeController>(() => HomeController());
    }
  }
}
