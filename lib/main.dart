// lib/main.dart

import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/app.dart';
import 'package:food_hjoiopk/app/core/theme/theme_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/Voice_controller/voice_controller.dart';
import 'package:food_hjoiopk/l10n/Local_Controller/local_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  Get.put(LocaleController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  
  Get.put(VoiceActionController(), permanent: true);

  await requestPermissions();

  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  try {
    var micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      micStatus = await Permission.microphone.request();
    }
    print("📱 Microphone Permission: ${micStatus.isGranted}");

    // Location Permission
    var locStatus = await Permission.location.status;
    if (!locStatus.isGranted) {
      locStatus = await Permission.location.request();
    }
    print("📱 Location Permission: ${locStatus.isGranted}");
  } catch (e) {
    print("❌ Permission Error: $e");
  }
}