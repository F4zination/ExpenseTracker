import 'package:expensetracker/pages/metric_category_page.dart';
import 'package:expensetracker/pages/metric_graph_page.dart';
import 'package:expensetracker/pages/metric_total_expensed_page.dart';
import 'package:expensetracker/pages/settings_page.dart';
import 'package:expensetracker/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//in main.dart write this:

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // check if the user has a theme on the device

    return MaterialApp(
      title: 'Expense Tracker',
      theme: lightTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const Main(),
        '/settings': (context) => const SettingsPage(),
        '/metric/category': (context) => const MetricCategoryPage(),
        '/metric/graph': (context) => const MetricGraphScreen(),
        '/metric/total': (context) => const MetricTotalScreen(),
      },
    );
  }
}
