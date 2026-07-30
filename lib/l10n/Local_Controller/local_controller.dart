import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  static LocaleController get to => Get.find();

  final GetStorage _box = GetStorage();
  static const String _storageKey = 'app_language_code';

  final Rx<Locale> currentLocale = const Locale('en').obs;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'bn', 'name': 'বাংলা'},
  ];

  @override
  void onInit() {
    super.onInit();
    final savedCode = _box.read<String>(_storageKey);
    if (savedCode != null) {
      currentLocale.value = Locale(savedCode);
    }
  }

  void changeLanguage(String languageCode) {
    currentLocale.value = Locale(languageCode);
    _box.write(_storageKey, languageCode);
    Get.updateLocale(Locale(languageCode));
  }

  bool isSelected(String code) => currentLocale.value.languageCode == code;
}