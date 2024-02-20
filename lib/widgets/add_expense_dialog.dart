import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:sqflite/sqflite.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key, required this.addExpense});

  final void Function(Expense) addExpense;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  ExpenseType selectedType = ExpenseType.food;
  late final Database db;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    openDatabase('expenses.db').then((value) {
      db = value;
    });
  }

  double get amount {
    final amountText = amountController.text;
    String amount_withoutComma = amountText.replaceAll(',', '.');
    // round the amount to 2 decimal places
    return double.tryParse(amount_withoutComma) ?? 0;
  }

  void submitExpense() {
    String title = titleController.text.trim();
    double amount = this.amount;

    final type = selectedType;

    if (title.isEmpty) {
      title = type.name;
    }

    if (amount <= 0) {
      amountController.clear();
      return;
    }

    final newExpense = Expense(
      title: title,
      amount: amount,
      date: DateTime.now(),
      type: type,
    );

    widget.addExpense(newExpense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Add Expense',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextField(
            autocorrect: true,
            controller: titleController,
            maxLength: 50,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration:
                const InputDecoration(labelText: 'Amount', prefixText: '€ '),
          ),
          const SizedBox(height: 32),
          DropdownButton(
            value: selectedType,
            icon: const Icon(Icons.arrow_drop_down),
            items: ExpenseType.values
                .map((e) => DropdownMenuItem(
                    value: e, child: Text(e.name.toUpperCase())))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                selectedType = value;
              });
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  submitExpense();
                },
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
