import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/app.dart';
import 'package:food_hjoiopk/app/core/theme/theme_controller.dart';
import 'package:food_hjoiopk/l10n/Local_Controller/local_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put(LocaleController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  runApp(const MyApp());
}