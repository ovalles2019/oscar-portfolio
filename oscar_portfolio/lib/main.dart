import 'package:flutter/material.dart';
import 'ui/theme.dart';
import 'ui/pages/home_page.dart';
import 'services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize analytics
  await AnalyticsService().initialize();
  
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oscar Valles — Cloud Engineer',
      debugShowCheckedModeBanner: false,
      theme: appTheme(Brightness.light),
      darkTheme: appTheme(Brightness.dark),
      themeMode: ThemeMode.dark, // Changed to dark theme to showcase the dark aesthetic
      home: const HomePage(),
      navigatorObservers: [
        RouteObserver<Route<dynamic>>(),
      ],
    );
  }
}
