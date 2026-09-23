import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? get navigator => navigatorKey.currentState;

  static void goBack() {
    navigator?.pop();
  }

  static Future<void> navigateTo(String routeName, {Object? arguments}) async {
    await navigator?.pushNamed(routeName, arguments: arguments);
  }

  static Future<void> navigateReplace(String routeName,
      {Object? arguments}) async {
    await navigator?.pushReplacementNamed(routeName, arguments: arguments);
  }
}
