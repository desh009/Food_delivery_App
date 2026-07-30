// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Food Delivery';

  @override
  String get home => 'Home';

  @override
  String get orders => 'Orders';

  @override
  String get favorites => 'Favorites';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String welcomeMessage(Object userName) {
    return 'Welcome, $userName!';
  }

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get typeMessage => 'Type your message...';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get language => 'Language';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get orderHistory => 'Order History';

  @override
  String get addressBook => 'Address Book';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get loyaltyPoints => 'Loyalty Points';

  @override
  String get vouchers => 'Vouchers';

  @override
  String get messages => 'Messages';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get security => 'Security';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get pushNotification => 'Push Notification';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get sound => 'Sound';

  @override
  String get automaticallyUpdated => 'Automatically Updated';

  @override
  String get termOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get aboutApp => 'About App';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get logoutSuccess => 'Logged out successfully.';

  @override
  String get logoutFailed => 'Logout failed.';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';
}
