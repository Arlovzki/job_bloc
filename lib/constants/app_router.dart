import 'package:flutter/material.dart';
import 'package:jobs_bloc/screens/add_screen/add_screen.dart';
import 'package:jobs_bloc/screens/home_screen/home_screen.dart';
import 'package:page_transition/page_transition.dart';

class AppRouter {
  static const String homeScreen = '/homeScreen';
  static const String addScreen = '/addScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return PageTransition(
          type: PageTransitionType.fade,
          child: HomeScreen(),
          curve: Curves.ease,
        );
      case addScreen:
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AddScreen(
            arguments: settings.arguments,
          ),
          curve: Curves.ease,
        );

      default:
        return PageTransition(
          child: Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          type: PageTransitionType.fade,
        );
    }
  }
}
