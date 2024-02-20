import 'package:expensetracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expense, required this.deleteExpense});

  final List<Expense> expense;
  final Function deleteExpense;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: expense.length,
        itemBuilder: (context, index) {
          return ExpenseItem(
              expense: expense[index], deleteExpense: deleteExpense);
        },
      ),
    );
  }
}
