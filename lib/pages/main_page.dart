import 'package:expensetracker/pages/home_page.dart';
import 'package:expensetracker/widgets/add_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/pages/metrics_page.dart';
import 'package:expensetracker/controller/database_controller.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  List<Widget> pages = [const Home(), const Metrics()];
  int pageIndex = 0;
  late final DatabaseController _databaseController;

  @override
  void initState() {
    super.initState();
    _databaseController = DatabaseController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgroundApp.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(162, 255, 255, 255),
            title: const Center(child: Text('Expense Tracker')),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/settings');
                },
                icon: const Icon(Icons.settings, color: Colors.black),
              ),
            ],
          ),
          body: pages[pageIndex],
          bottomNavigationBar: BottomAppBar(
            color: const Color.fromARGB(162, 255, 255, 255),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () => pageIndex = 1,
                    );
                  },
                  icon: Icon(Icons.bar_chart,
                      color: Theme.of(context).colorScheme.primary),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () => pageIndex = 0,
                    );
                  },
                  icon: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.primary),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return AddExpense(
                          addExpense: _databaseController.addExpense,
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          )),
    );
  }
}
