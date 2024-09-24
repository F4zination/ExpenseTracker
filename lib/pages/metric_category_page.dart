import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
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
  List<List<Expense>> expensesByType = [];

  void loadExpenses() async {
    DatabaseController databaseController = DatabaseController();
    for (ExpenseType type in ref.read(expenseTypesProvider).expenseTypes) {
      await databaseController.loadExpenseByType(type).then((value) {
        expensesByType.add(value);
      });
    }
    setState(() {});
  }

  String get dateFormated {
    DateTime now = DateTime.now();
    return DateFormat('MMMM-yy').format(now);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Metrics $dateFormated'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: expensesByType.length,
              itemBuilder: (context, index) {
                ExpenseType type = expensesByType[index].first.type;
                List<Expense> expenses = expensesByType[index]
                    .where((element) => element.type == type)
                    .toList();
                String typeString = type.toString().split('.').last;
                String typeFormatedString = typeString[0].toUpperCase() +
                    typeString.substring(1).replaceAll('_', ' ');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(typeFormatedString,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          )),
                    ),
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // to disable scrolling inside nested ListView
                      shrinkWrap: true, // necessary to display all children
                      itemCount: expenses.length,
                      itemBuilder: (context, expenseIndex) {
                        Expense expense = expenses[expenseIndex];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.black12)),
                          title: Text(expense.title,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.black38)),
                          trailing:
                              Text('€${expense.amount.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '€${expensesByType.expand((element) => element).fold(0.0, (previousValue, element) => previousValue + element.amount).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
