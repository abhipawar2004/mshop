import 'package:flutter/material.dart';

class GlobalKeys {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static Uri? initialDeepLink;
  static String? initialPath;
}