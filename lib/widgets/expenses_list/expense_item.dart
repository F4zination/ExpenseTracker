import 'package:flutter/material.dart';

import 'package:expensetracker/models/expense.dart';
import 'package:flutter/services.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
      {super.key, required this.expense, required this.deleteExpense});

  final Expense expense;
  final Function deleteExpense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        HapticFeedback.lightImpact();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Expense?'),
              content:
                  const Text('Are you sure you want to delete this expense?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deleteExpense(expense);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
          child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(expense.icon),
            Text(expense.title, style: const TextStyle(fontSize: 16)),
            Text(expense.formattedDate),
            Text(
                '${expense.type == ExpenseType.income ? '+' : '-'} ${expense.amount.toStringAsFixed(2)}€',
                style: expense.type == ExpenseType.income
                    ? const TextStyle(color: Colors.green)
                    : const TextStyle(color: Colors.red)),
          ],
        ),
      )),
    );
  }
}
