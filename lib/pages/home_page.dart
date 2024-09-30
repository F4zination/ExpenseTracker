import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:expensetracker/provider/expense_types_provider.dart';
import 'package:expensetracker/provider/month_provider.dart';
import 'package:expensetracker/widgets/add_expense_button.dart';
import 'package:expensetracker/widgets/add_expense_dialog.dart';
import 'package:expensetracker/widgets/add_expense_type_button.dart';
import 'package:expensetracker/widgets/add_expense_type_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String currentMonat = DateFormat('MMMM').format(DateTime.now());

  String get dateFormated {
    DateTime now = DateTime.now();
    return DateFormat('MMMM-yyyy').format(now);
  }

  String numberFormated(double number) {
    // Create a NumberFormat instance with two decimal places
    final formatter = NumberFormat('#,##0.00', 'de_DE');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text('Total Expenses',
                  style: TextStyle(fontSize: 32, color: Colors.white)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButton(
                    isDense: false,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color.fromARGB(255, 110, 110, 110)),
                    underline: Container(),
                    dropdownColor: const Color.fromARGB(255, 60, 60, 60),
                    style: const TextStyle(color: Colors.white),
                    items: ref.watch(monthProvider).existingMonths.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(DateFormat('MMMM-yyyy').format(e),
                            style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentMonat = DateFormat('MMMM').format(value!);
                        ref
                            .read(monthProvider)
                            .setMonth(DateFormat('MMMM').format(value));
                      });
                    },
                    hint: Text(currentMonat,
                        style: const TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('max. 600 €',
                          style: TextStyle(
                            color: Colors.white60,
                          )),
                      Text(
                          '${numberFormated(ref.watch(expenseListProvider.notifier).totalExpenses)} €',
                          style: const TextStyle(
                              fontSize: 35, color: Color(0xFF59EE57))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AddExpenseTypeButton(
                    text: 'add category',
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25.0),
                                      topRight: Radius.circular(25.0),
                                    ),
                                  ),
                                  child: const AddExpenseTypeDialog())));
                    }),
                ...ref
                    .watch(expenseTypesProvider)
                    .expenseTypes
                    .map((expenseType) {
                  return AddExpenseButton(
                    expenseType: expenseType,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: AddExpenseDialog(
                              expenseType: expenseType,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: Column(children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: ref.watch(expenseListProvider).expenses.length,
                itemBuilder: (context, index) {
                  List<Expense> sortedExpenses =
                      ref.watch(expenseListProvider).expenses;
                  sortedExpenses.sort((a, b) => b.date.compareTo(a.date));

                  final expense = sortedExpenses[index];
                  final isExpense = expense.type.isExpense;
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            color: Color.fromARGB(82, 255, 255, 255),
                            thickness: 0.5,
                          ),
                        ),
                        InkWell(
                          onLongPress: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(250, 43, 43, 43),
                                  title: const Text('Delete Expense',
                                      style: TextStyle(color: Colors.white)),
                                  content: Text(
                                      'Are you sure you want to delete ${expense.title}?',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .watch(expenseListProvider)
                                            .removeExpense(expense);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              }),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth / 4,
                                  child: CircleAvatar(
                                    backgroundColor: expense.type.color,
                                    radius: 10,
                                  ),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth / 4,
                                  child: Text(expense.title,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth / 4,
                                  child: Text(
                                      DateFormat('dd.MM.yyyy')
                                          .format(expense.date),
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ),
                                SizedBox(
                                  width: constraints.maxWidth / 4,
                                  child: Text(
                                      '${expense.amount.toStringAsFixed(2).replaceAll('.', ',')} €',
                                      style: TextStyle(
                                          color: isExpense
                                              ? Colors.red
                                              : Colors.green)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
