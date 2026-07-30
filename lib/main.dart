import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/app.dart';
import 'package:food_hjoiopk/l10n/Local_Controller/local_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(); // 🔥 language persist করার জন্য দরকার

  // 🔥 runApp() এর আগেই LocaleController put করতে হবে,
  // কারণ MyApp build হওয়ার সময় LocaleController.to লাগবে
  Get.put(LocaleController(), permanent: true);

  runApp(const MyApp());
}