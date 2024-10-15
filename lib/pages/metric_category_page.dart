import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:expensetracker/provider/month_provider.dart';
import 'package:expensetracker/widgets/display_expenses_category.dart';
import 'package:expensetracker/widgets/month_dropdown_button.dart';
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
  DatabaseController databaseController = DatabaseController();

  void loadExpenses() async {
    Map<ExpenseType, List<Expense>> tempLIst = {};
    for (ExpenseType type in ref.read(expenseTypesProvider).expenseTypes) {
      await databaseController
          .loadExpensesByTypeAndMonth(type, ref.read(monthProvider).getMonth())
          .then((value) {
        debugPrint(value.toString());
        tempLIst[type] = value;
      });
    }
    setState(() {
      expensesByType = tempLIst;
    });
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text('Categories',
                  style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 10),
              MonthDropdownButton(ref: ref),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...expensesByType.keys
                    .map((type) => DisplayExpensesCategory(
                          expenseType: type,
                          expenses: expensesByType[type]!,
                          height: MediaQuery.of(context).size.height * 0.35,
                        ))
                    .toList(),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
