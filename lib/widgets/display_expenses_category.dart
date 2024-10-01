import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:expensetracker/widgets/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DisplayExpensesCategory extends ConsumerWidget {
  const DisplayExpensesCategory(
      {super.key,
      required this.expenseType,
      required this.expenses,
      required this.height});
  final ExpenseType expenseType;
  final List<Expense> expenses;
  final double height;

  String numberFormated(double number) {
    // Create a NumberFormat instance with two decimal places
    final formatter = NumberFormat('#,##0.00', 'de_DE');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Expense> expensesOfType =
        ref.watch(expenseListProvider).getExpensesByType(expenseType);
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
        child: SizedBox(
          height: height,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Card(
            color: const Color.fromARGB(255, 75, 75, 75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.75,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(children: [
                          CircleIcon(
                            icon: expenseType.icon,
                            color: expenseType.color,
                            width: 65,
                            height: 65,
                            iconSize: 35,
                          ),
                          const SizedBox(width: 32),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                expenseType.name.replaceFirst(
                                    expenseType.name[0],
                                    expenseType.name[0].toUpperCase()),
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                expenseType.isExpense ? 'Expense' : 'Income',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ]),
                      ),
                      expensesOfType.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Text(
                                'No expenses yet in this category',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: expensesOfType.length,
                                itemBuilder: (context, index) {
                                  expensesOfType
                                      .sort((a, b) => b.date.compareTo(a.date));

                                  final expense = expensesOfType[index];
                                  return LayoutBuilder(
                                      builder: (context, constraints) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: constraints.maxWidth / 4,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      expense.type.color,
                                                  radius: 10,
                                                ),
                                              ),
                                              SizedBox(
                                                width: constraints.maxWidth / 4,
                                                child: Text(expense.title,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              SizedBox(
                                                width: constraints.maxWidth / 4,
                                                child: Text(
                                                    DateFormat('dd.MM.yyyy')
                                                        .format(expense.date),
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                              SizedBox(
                                                width: constraints.maxWidth / 4,
                                                child: Text(
                                                    numberFormated(
                                                        expense.amount),
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Divider(
                                            color: Color.fromARGB(
                                                82, 255, 255, 255),
                                            thickness: 0.5,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              ),
                            ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(
                    color: Color.fromARGB(103, 255, 255, 255),
                    thickness: 2,
                  ),
                ),
                expensesOfType.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 25, bottom: 10),
                            child: Text(
                              numberFormated(expensesOfType.fold(
                                  0.0,
                                  (previousValue, element) =>
                                      previousValue +
                                      (element.type.isExpense
                                          ? element.amount
                                          : 0.0))),
                              style: TextStyle(
                                  color: expenseType.isExpense
                                      ? Colors.red
                                      : Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
