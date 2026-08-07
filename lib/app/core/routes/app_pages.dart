import 'package:food_hjoiopk/app/core/models/product%20model/product_model.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/Code_verify/binder/code_verify_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/Code_verify/view/code_verify_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/binder/forgot_password_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Forget_Password_screen/view/forget_password_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/binder/notification_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Notification_screen/view/notification_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/binder/order_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Order_screen/view/order_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/Massage_Screen/binder/massage_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/Massage_Screen/view/massage_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/binder/product_details_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_details_screen/view/product_details_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/About_app_screen/binder/about_app_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/About_app_screen/view/about_app_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Invite_Friends_Screen/binder/invite_friends_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Invite_Friends_Screen/view/invite_friends-view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Privacy_and_policy/binder/privacy_policy_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Privacy_and_policy/view/privacy_policy_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/binder/security_screen_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Security_Screen/view/security_screen_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Terms_and_service/binder/terms_and_service_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Profile_items_screens/Terms_and_service/view/terms_and_service_view.dart';
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

    GetPage(name: _Paths.HOME, page: () => HomeScreen(), binding: HomeBinder()),

    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListScreen(),
      binding: ProductListBinding(),
    ),

    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () {
        final args = Get.arguments;
        ProductModel product;

        if (args is Map<String, dynamic>) {
          product = ProductModel.fromJson(args);
        } else if (args is ProductModel) {
          product = args;
        } else {
          product = ProductModel(
            id: '',
            name: '',
            category: '',
            imageUrl: '',
            rating: 0.0,
            price: 0.0,
            description: '', image: '', title: '',
          );
        }

        return ProductDetailsScreen(product: product);
      },
      binding: ProductDetailsBinding(),
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
      page: () => const InviteFriendScreen(),
      binding: InviteFriendBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.MESSAGE,
      page: () => const MessageScreen(),
      binding: MessageBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.TERMS_AND_SERVICES,
      page: () => const TermsAndServicesScreen(),
      binding: TermsAndServicesBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Routes.PRIVACY_AND_POLICY,
      page: () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.FORGET_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.CODE_VERIFY,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
