import 'package:expensetracker/pages/metric_category_page.dart';
import 'package:expensetracker/pages/metric_graph_page.dart';
import 'package:expensetracker/pages/settings_page.dart';
import 'package:expensetracker/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: darkTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(),
        '/settings': (context) => const SettingsPage(),
        '/metric/category': (context) => const MetricCategoryScreen(),
        '/metric/graph': (context) => const MetricGraphScreen(),
      },
    );
  }
}
