import 'package:expensetracker/pages/settings_page.dart';
import 'package:expensetracker/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          cardTheme: const CardTheme().copyWith(
            color: kColorScheme.surface,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kColorScheme.onSecondary),
              )),
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
