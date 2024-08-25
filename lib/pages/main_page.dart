import 'package:expensetracker/models/expense.dart';
import 'package:expensetracker/provider/user_provider.dart';
import 'package:expensetracker/widgets/add_expense_dialog.dart';
import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:expensetracker/widgets/metric_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expensetracker/widgets/add_expense_button.dart';
import 'package:intl/intl.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(expenseListProvider.notifier).addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Row(
                  children: [
                    Text('Welcome, ${ref.watch(userProvider).getUsername}!',
                        style: const TextStyle(
                            fontSize: 30, color: Colors.black38)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/settings');
                        },
                        icon: const Icon(Icons.settings_outlined,
                            color: Colors.black, size: 30))
                  ],
                ),
                const SizedBox(height: 50),
                const Text('Total Expenses',
                    style: TextStyle(
                      fontSize: 35,
                    )),
                Text('For the month of $dateFormated',
                    style: const TextStyle(
                      fontSize: 12,
                    )),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '${ref.watch(expenseListProvider.notifier).totalExpenses.toStringAsFixed(2)} €',
                        style: const TextStyle(
                            fontSize: 35, color: Color(0xFF5D9FAE))),
                  ),
                ),
                const SizedBox(height: 50),
                const Text('Add Expenses',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                const SizedBox(height: 20),
                Row(children: [
                  AddExpenseButton(
                      icon: 'assets/icons/fast-food.png',
                      text: 'Food',
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => const AddExpenseDialog(
                                  expenseType: ExpenseType.food,
                                ));
                      }),
                  AddExpenseButton(
                      icon: 'assets/icons/public-transport.png',
                      text: 'Transport',
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => const AddExpenseDialog(
                                  expenseType: ExpenseType.transport,
                                ));
                      }),
                  AddExpenseButton(
                      icon: 'assets/icons/lifestyle.png',
                      text: 'Fun',
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => const AddExpenseDialog(
                                  expenseType: ExpenseType.fun,
                                ));
                      }),
                  AddExpenseButton(
                      icon: 'assets/icons/more.png',
                      text: 'More',
                      passthrough: true,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: SizedBox(
                                height: 130,
                                width: 300,
                                child: Card(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AddExpenseButton(
                                          icon:
                                              'assets/icons/shopping-cart.png',
                                          text: 'Shopping',
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const AddExpenseDialog(
                                                      expenseType:
                                                          ExpenseType.shopping,
                                                    ));
                                          }),
                                      AddExpenseButton(
                                          icon: 'assets/icons/rent.png',
                                          text: 'Rent',
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const AddExpenseDialog(
                                                      expenseType:
                                                          ExpenseType.rent,
                                                    ));
                                          }),
                                      AddExpenseButton(
                                          icon: 'assets/icons/more.png',
                                          text: 'Others',
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const AddExpenseDialog(
                                                      expenseType:
                                                          ExpenseType.others,
                                                    ));
                                          }),
                                    ],
                                  ),
                                ),
                              ));
                            });
                      }),
                ]),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: const Color(0xFFC4D5E8)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      const SizedBox(height: 20),
                      const Text('Recently Added',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              ref.watch(expenseListProvider).expenses.length,
                          itemBuilder: (context, index) {
                            List<Expense> sortedExpenses =
                                ref.watch(expenseListProvider).expenses;
                            sortedExpenses
                                .sort((a, b) => b.date.compareTo(a.date));

                            final expense = sortedExpenses[index];
                            return ListTile(
                              tileColor: Colors.white30,
                              title: Text(expense.title),
                              subtitle: Text('${expense.amount} €'),
                              leading: Icon(expense.icon),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Expense'),
                                        content: Text(
                                            'Are you sure you want to delete ${expense.title}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ref
                                                  .watch(expenseListProvider)
                                                  .removeExpense(expense);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: VerticalDivider(
                      color: Colors.black45,
                      thickness: 1,
                      width: 1,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text("Metrics",
                            style: TextStyle(
                              fontSize: 20,
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                MetricButton(
                                    title: "Category",
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/metric/category');
                                    }),
                                const SizedBox(height: 20),
                                MetricButton(
                                    title: "Graph-View",
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/metric/graph');
                                    }),
                                const SizedBox(height: 20),
                                MetricButton(
                                    title: "Total Expenses",
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/metric/total');
                                    }),
                                const SizedBox(height: 20),
                                Text('More metrics coming soon!',
                                    style: const TextStyle(
                                      fontSize: 15,
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String get dateFormated {
    DateTime now = DateTime.now();
    return DateFormat('MMMM-yyyy').format(now);
  }
}
