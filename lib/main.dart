import 'package:expensetracker/pages/metric_category_page.dart';
import 'package:expensetracker/pages/metric_graph_page.dart';
import 'package:expensetracker/pages/settings_page.dart';
import 'package:expensetracker/pages/navigation_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ExpenseTracker(),
    ),
  );
}

class ExpenseTracker extends StatelessWidget {
  const ExpenseTracker({super.key});

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
