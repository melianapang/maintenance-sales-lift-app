import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void popAllAndNavigateTo(
    String route, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  void replaceAndNavigateTo(
    String routeName, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.popAndPushNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateTo(
    String routeName, {
    Object? arguments,
    bool removeAll = false,
  }) async {
    if (removeAll) {
      return await navigatorKey.currentState?.pushNamedAndRemoveUntil(
        routeName,
        (Route<dynamic> route) =>
            !(route.isCurrent && route.settings.name == routeName),
        arguments: arguments,
      );
    }
    return await navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop() {
    navigatorKey.currentState?.pop();
  }
}
