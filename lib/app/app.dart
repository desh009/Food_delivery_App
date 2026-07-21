import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
import 'package:get/get.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: GetPage(name: '/not-found', page: () => const Scaffold(
        body: Center(
          child: Text('Page not found'),
        ),
      )),
    );
  }
}