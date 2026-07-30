import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_hjoiopk/app/app.dart';
import 'package:food_hjoiopk/app/core/theme/app_theme.dart';
import 'package:food_hjoiopk/app/core/theme/theme_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    Get.reset();
  });

  testWidgets('app uses the light theme by default', (tester) async {
    Get.put(ThemeController(), permanent: true);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MaterialApp).first);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppTheme.lightTheme.scaffoldBackgroundColor,
    );
  });

  testWidgets('app switches to the dark theme when the controller toggles it', (
    tester,
  ) async {
    final themeController = Get.put(ThemeController(), permanent: true);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await themeController.toggleTheme();
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(MaterialApp).first);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppTheme.darkTheme.scaffoldBackgroundColor,
    );
  });
}
