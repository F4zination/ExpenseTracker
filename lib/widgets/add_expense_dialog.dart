import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key, required this.expenseType});

  final ExpenseType expenseType;

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpenseDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  late final ExpenseListProvider _expenseListProvider;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expenseListProvider = ref.watch(expenseListProvider);
    });
  }

  double get amount {
    final amountText = amountController.text;
    String amountWithoutComma = amountText.replaceAll(',', '.');
    // round the amount to 2 decimal places
    return double.tryParse(amountWithoutComma) ?? 0;
  }

  void submitExpense() {
    String title = titleController.text.trim();
    double amount = this.amount;

    final type = widget.expenseType;

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
      type: widget.expenseType,
    );

    _expenseListProvider.addExpense(newExpense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Color.fromARGB(243, 55, 55, 55),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Add ${widget.expenseType.name.replaceFirst(widget.expenseType.name[0], widget.expenseType.name[0].toUpperCase())} Expense',
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextField(
            autocorrect: true,
            controller: titleController,
            maxLength: 50,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Title',
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              floatingLabelStyle: TextStyle(color: Colors.white),
              counterStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '€ ',
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              floatingLabelStyle: TextStyle(color: Colors.white),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(40, 147, 53, 53)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(40, 34, 255, 0)),
                onPressed: () {
                  debugPrint('Adding expense');
                  submitExpense();
                },
                child: const Text('Add Expense',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
