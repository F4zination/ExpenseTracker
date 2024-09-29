import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:expensetracker/widgets/display_expenses_category.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/controller/database_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MetricCategoryScreen extends ConsumerStatefulWidget {
  const MetricCategoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MetricCategoryScreen> createState() =>
      _MetricCategoryScreenState();
}

class _MetricCategoryScreenState extends ConsumerState<MetricCategoryScreen> {
  Map<ExpenseType, List<Expense>> expensesByType = {};

  void loadExpenses() async {
    DatabaseController databaseController = DatabaseController();
    for (ExpenseType type in ref.read(expenseTypesProvider).expenseTypes) {
      await databaseController.loadExpenseByType(type).then((value) {
        expensesByType[type] = value;
      });
    }
    setState(() {});
  }

  String get dateFormated {
    DateTime now = DateTime.now();
    return DateFormat('MMMM-yy').format(now);
  }

  double get totalExpenses {
    double total = 0.0;
    for (ExpenseType type in expensesByType.keys) {
      total += expensesByType[type]!.fold(
          0.0, (previousValue, element) => previousValue + element.amount);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormated,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Column(
              children: expensesByType.keys
                  .map((type) => DisplayExpensesCategory(
                        category: type.name,
                        expenses: expensesByType[type]!,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '€${totalExpenses.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
