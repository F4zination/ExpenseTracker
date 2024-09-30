import 'package:expensetracker/models/expense.dart';
import 'package:flutter/material.dart';

class DisplayExpensesCategory extends StatelessWidget {
  const DisplayExpensesCategory(
      {super.key,
      required this.category,
      required this.expenses,
      required this.height});
  final String category;
  final List<Expense> expenses;
  final double height;

  @override
  Widget build(BuildContext context) {
    return expenses.isEmpty
        ? Container()
        : SizedBox(
            height: height,
            child: Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 75, 75, 75),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 30,
                    child: Center(
                      child: Text(
                        category,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                expenses.isEmpty
                    ? const Text(
                        'No expenses in this category',
                        style: TextStyle(color: Colors.white),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              expenses[index].title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              expenses[index].amount.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
  }
}
