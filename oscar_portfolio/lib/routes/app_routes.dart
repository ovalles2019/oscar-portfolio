import 'package:flutter/material.dart';
import '../ui/pages/home_page.dart';
import '../ui/pages/projects_page.dart';
import '../ui/pages/skills_page.dart';
import '../ui/pages/contact_page.dart';
import '../ui/pages/interactive_features_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/';
  static const String projects = '/projects';
  static const String skills = '/skills';
  static const String contact = '/contact';
  static const String interactive = '/interactive';

  static Map<String, WidgetBuilder> get routes => {};

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case home:
        page = const HomePage();
        break;
      case projects:
        page = const ProjectsPage();
        break;
      case skills:
        page = const SkillsPage();
        break;
      case contact:
        page = const ContactPage();
        break;
      case interactive:
        page = const InteractiveFeaturesPage();
        break;
      default:
        page = const HomePage();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
