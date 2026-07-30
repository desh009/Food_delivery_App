// lib/app/core/nav_observer.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/widgets/nav_bar/controller/bottom_navigation_controller.dart';

class BottomNavObserver extends NavigatorObserver {
  void _syncIndex(Route<dynamic>? route) {
    final routeName = route?.settings.name;
    if (routeName != null && Get.isRegistered<BottomNavController>()) {
      BottomNavController.to.onRouteChanged(routeName);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // back চাপার পর যেই route এ ফেরত গেলাম সেটাই previousRoute
    _syncIndex(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _syncIndex(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _syncIndex(newRoute);
  }
}