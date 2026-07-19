import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/binder/product_list_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Product_list_screen/view/product_list_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Register_screen/binder/register_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Register_screen/view/register_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/binder/special_offer_binder.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Special_offer_screen/view/special_offer_view.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/binder/home_binder.dart';
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
      page: () => const HomeScreen(),
      binding: HomeBinder(),
    ),


    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListScreen(),
      binding: ProductListBinding()
    ),

     GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductListScreen(),
      binding: ProductListBinding()
    ),
    GetPage(
      name: _Paths.SPECIAL_OFFER,
      page: () => const SpecialOffersScreen(),
      binding: SpecialOffersBinding()
    ),
    // GetPage(
    //   name: _Paths.SETTINGS,
    //   page: () => const SettingsView(),
    //   binding: SettingsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.MY_ACCOUNT,
    //   page: () => const MyAccountView(),
    //   binding: MyAccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CAR_BOOKING,
    //   page: () => const CarBookingView(),
    //   binding: CarBookingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CAR_RENTAL,
    //   page: () => const CarRentalView(),
    //   binding: CarRentalBinding(),
    // ),
    // GetPage(
    //   name: _Paths.ROUND_TRIP,
    //   page: () => const RoundTripView(),
    //   binding: RoundTripBinding(),
    // ),
    // GetPage(
    //   name: _Paths.HELICOPTER_BOOKING,
    //   page: () => const HelicopterBookingView(),
    //   binding: HelicopterBookingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.BOOKING_SYSTEM,
    //   page: () => const BookingSystemView(),
    //   binding: BookingSystemBinding(),
    // ),
    // GetPage(
    //   name: _Paths.TRIP_DETAILS,
    //   page: () => const TripDetailsView(),
    //   binding: TripDetailsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.EMAIL_VALIDATION,
    //   page: () => const EmailValidationView(),
    //   binding: EmailValidationBinding(),
    // ),
    // GetPage(
    //   name: _Paths.FORGOT_PASSWORD,
    //   page: () => ForgotPasswordView(),
    //   binding: ForgotPasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.CHANGE_PASSWORD,
    //   page: () => ChangePasswordView(),
    //   binding: ChangePasswordBinding(),
    // ),
  ];
}
