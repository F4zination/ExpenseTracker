import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/widgets/expenses_list/expense_list.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/controller/database_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final DatabaseController _databaseController;
  List<Expense> test = [];

  @override
  void initState() {
    super.initState();
    _databaseController = DatabaseController();
    _databaseController.loadExpenses().then((value) {
      setState(() {
        test = value;
      });
    });
  }

  void deleteExpense(Expense expense) {
    setState(() {
      test.remove(expense);
    });
    _databaseController.deleteExpense(expense.id);
    print('Deleted: $expense');
  }

  List<PieChartSectionData> collectData() {
    // remove all items with category income and store them in a variable
    return test.where((element) => element.type != ExpenseType.income).map((e) {
      return PieChartSectionData(
        value: e.amount,
        color: categoryColors[e.type],
        showTitle: true,
        title: e.title,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: collectData(),
              centerSpaceRadius: 40,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 50),
        ExpenseList(expense: test, deleteExpense: deleteExpense),
      ],
    );
  }
}
