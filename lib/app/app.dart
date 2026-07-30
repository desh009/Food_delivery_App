// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/app_bindings/app_bindings.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:food_hjoiopk/app/core/theme/app_theme.dart';
import 'package:food_hjoiopk/app/core/theme/theme_controller.dart';
import 'package:food_hjoiopk/l10n/Local_Controller/local_controller.dart';
import 'package:food_hjoiopk/l10n/app_localizations.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 ThemeController Initialize (যদি না থাকে)
    if (!Get.isRegistered<ThemeController>()) {
      Get.put(ThemeController(), permanent: true);
    }

    // 🔥 LocaleController Initialize (যদি না থাকে)
    if (!Get.isRegistered<LocaleController>()) {
      Get.put(LocaleController(), permanent: true);
    }

    final Locale currentLocale = LocaleController.to.currentLocale.value;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            initialBinding: AppBinding(),
            
            // 🔥 Theme
            themeMode: ThemeController.to.themeMode.value,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            
            // 🔥 Locale
            locale: currentLocale,
            fallbackLocale: const Locale('en'),
            
            // 🔥 Localization
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
            ],
            
            unknownRoute: GetPage(
              name: '/not-found',
              page: () => const Scaffold(
                body: Center(
                  child: Text('Page not found'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}