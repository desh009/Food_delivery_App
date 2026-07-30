// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ফুড ডেলিভারি';

  @override
  String get home => 'হোম';

  @override
  String get orders => 'অর্ডার';

  @override
  String get favorites => 'পছন্দের';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String welcomeMessage(Object userName) {
    return 'স্বাগতম, $userName!';
  }

  @override
  String get addToCart => 'কার্টে যোগ করুন';

  @override
  String get checkout => 'চেকআউট';

  @override
  String get sendMessage => 'মেসেজ পাঠান';

  @override
  String get typeMessage => 'আপনার মেসেজ লিখুন...';

  @override
  String get logout => 'লগ আউট';

  @override
  String get cancel => 'বাতিল';

  @override
  String get confirm => 'নিশ্চিত করুন';

  @override
  String get language => 'ভাষা';

  @override
  String get trackOrder => 'অর্ডার ট্র্যাক করুন';

  @override
  String get orderHistory => 'অর্ডারের ইতিহাস';

  @override
  String get addressBook => 'ঠিকানার তালিকা';

  @override
  String get paymentMethods => 'পেমেন্ট পদ্ধতি';

  @override
  String get myFavorites => 'আমার পছন্দের';

  @override
  String get loyaltyPoints => 'লয়্যালটি পয়েন্ট';

  @override
  String get vouchers => 'ভাউচার';

  @override
  String get messages => 'মেসেজ';

  @override
  String get inviteFriends => 'বন্ধুদের আমন্ত্রণ করুন';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get helpCenter => 'সহায়তা কেন্দ্র';

  @override
  String get pushNotification => 'পুশ নোটিফিকেশন';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get sound => 'সাউন্ড';

  @override
  String get automaticallyUpdated => 'স্বয়ংক্রিয় আপডেট';

  @override
  String get termOfService => 'সেবার শর্তাবলী';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get aboutApp => 'অ্যাপ সম্পর্কে';

  @override
  String get logoutConfirm => 'আপনি কি নিশ্চিত যে লগ আউট করতে চান?';

  @override
  String get logoutSuccess => 'সফলভাবে লগ আউট হয়েছে।';

  @override
  String get logoutFailed => 'লগ আউট ব্যর্থ হয়েছে।';

  @override
  String get success => 'সফল';

  @override
  String get error => 'ত্রুটি';
}
