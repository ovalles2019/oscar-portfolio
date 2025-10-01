import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/theme.dart';
import 'ui/pages/home_page.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'Oscar Valles — Cloud Engineer',
            debugShowCheckedModeBanner: false,
            theme: appTheme(Brightness.light),
            darkTheme: appTheme(Brightness.dark),
            themeMode: themeService.themeMode,
            home: const HomePage(),
            navigatorObservers: [
              RouteObserver<Route<dynamic>>(),
            ],
          );
        },
      ),
    );
  }
}
