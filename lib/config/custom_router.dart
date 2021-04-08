import 'package:flutter/material.dart';
import 'package:flutter_gram/screens/signup/signup_screen.dart';
import '../screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong'),
        ),
      ),
    );
  }
}
