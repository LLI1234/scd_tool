import "package:flutter/material.dart";
import "package:scd_tool/pages/login_page.dart";
import "package:scd_tool/pages/main_page.dart";
import "package:scd_tool/pages/match_page.dart";
import "package:scd_tool/pages/profile_page.dart";
import "package:scd_tool/pages/saved_page.dart";
import "package:scd_tool/pages/calendar_page.dart";

class RouteManager {
  static const String login = "/login";
  static const String main = "/main";
  static const String match = "/match";
  static const String profile = "/profile";
  static const String saved = "/saved";
  static const String calendar = "/calendar";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case main:
        return MaterialPageRoute(builder: (context) => const MainPage());
      case match:
        return MaterialPageRoute(builder: (context) => const MatchPage());
      case profile:
        return MaterialPageRoute(builder: (context) => const ProfilePage());
      case saved:
        return MaterialPageRoute(builder: (context) => const SavedPage());
      case calendar:
        return MaterialPageRoute(builder: (context) => const CalendarPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
