import 'package:expensetracker/controller/database_controller.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';

class MetricTotalScreen extends StatefulWidget {
  const MetricTotalScreen({super.key});

  @override
  State<MetricTotalScreen> createState() => _MetricTotalScreenState();
}

class _MetricTotalScreenState extends State<MetricTotalScreen> {
  List<List<Expense>> expensesByType = [];

  void loadExpenses() async {
    DatabaseController databaseController = DatabaseController();
    for (ExpenseType type in ExpenseType.values) {
      await databaseController
          .loadExpensesByTypeAndMonth(
              type, DateTime.now().month.toString().padLeft(2, '0'))
          .then((value) {
        expensesByType.add(value);
      });
    }
    setState(() {});
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
        title: const Text('All Time Expenses'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: expensesByType.length,
              itemBuilder: (context, index) {
                ExpenseType type = ExpenseType.values[index];
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
          const Spacer(),
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
