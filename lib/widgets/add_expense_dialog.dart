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
      decoration: const BoxDecoration(
        color: Color.fromARGB(243, 55, 55, 55),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Add ${widget.expenseType.name.replaceFirst(widget.expenseType.name[0], widget.expenseType.name[0].toUpperCase())} Expense',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
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
              ),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration:
                  const InputDecoration(labelText: 'Amount', prefixText: '€ '),
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
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(40, 34, 255, 0)),
                  onPressed: () {
                    debugPrint('Adding expense');
                    submitExpense();
                  },
                  child: const Text('Add Expense',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
