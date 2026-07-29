
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/binder/notification_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/view/notification_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/binder/order_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/view/order_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/About_app_screen/binder/about_app_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/About_app_screen/view/about_app_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/binder/security_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/view/security_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Track_order/binder/track_order_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Track_order/view/track_order_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Voucher_screen/binder/voucher_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Voucher_screen/view/voucher_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/binder/help_center_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/helpcenter_screen/view/helpcenter_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/binder/profile_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_screen/view/profile_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Register_screen/binder/register_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Register_screen/view/register_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Review_Screen/binder/Review_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Review_Screen/view/review_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/binder/special_offer_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/view/special_offer_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/binder/add_to_cart_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/add_to_cart/view/add_to_cart_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/binder/favourite_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/favourite_screen/view/favourite_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/binder/home_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/profile_edit_screen/binder/profile_edit_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/profile_edit_screen/view/profile_edit_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/view/home_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/binder/login_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/login_screen/view/login_sceen-view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/otp_screen/binder/otp_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/otp_screen/view/otp_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_1/binder/loading_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_1/view/loading_screen_1.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/splash_screen/loading_screen/loading_screen_3.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const TomatoSplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.INTRO,
      page: () => const IntroduceStepOneScreen(),
      // binding: IntroBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const Login1Screen(),
      binding: Login1Binding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),

    GetPage(
      name: _Paths.OTP,
      page: () => const VerificationScreen(),
      binding: OtpBinder(),
    ),

    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinder(),
    ),

    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListScreen(),
      binding: ProductListBinding(),
    ),

    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductListScreen(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: _Paths.SPECIAL_OFFER,
      page: () => const SpecialOffersScreen(),
      binding: SpecialOffersBinding(),
    ),
    GetPage(
      name: _Paths.CART_ITEM,
      page: () => const MyBasketScreen(),
      binding: AddToCartBinder(),
    ),
    GetPage(
      name: _Paths.REVIEW_ITEM,
      page: () => const ProductReviewsScreen(),
      binding: ProductReviewsBinding(),
    ),
    GetPage(
      name: _Paths.MY_ACCOUNT,
      page: () => const ProfileScreen(),
      binding: ProfileBinder(),
    ),
    GetPage(
      name: _Paths.HELP_CENTER,
      page: () => const HelpCenterScreen(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetailsScreen(),
      binding: OrderDetailsBinding(),
    ),
    GetPage(
      name: _Paths.LIKED_SCREEN,
      page: () => const LikedScreen(),
      binding: LikedBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_EDIT,
      page: () => const YourProfileScreen(),
      binding: YourProfileBinding(),
    ),
       GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
       GetPage(
      name: _Paths.TRACK_ORDER,
      page: () => const TrackOrderScreen(),
      binding: TrackOrderBinding(),
    ),
      GetPage(
      name: _Paths.SECURITY,
      page: () => const SecurityScreen(),
      binding: SecurityBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_APP,
      page: () => AboutAppScreen(),
      binding: AboutAppBinding(),
    ),

    GetPage(
      name: Routes.VOUCHER,
      page: () => const VoucherScreen(),
      binding: VoucherBinding(),
      transition: Transition.rightToLeft,
    ),

       GetPage(
      name: Routes.INVITE_FRIENDS,
      page: () => const VoucherScreen(),
      binding: VoucherBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
