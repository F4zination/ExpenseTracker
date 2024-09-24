import 'package:expensetracker/provider/expense_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/expense.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart' hide serializeIcon;
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
  Icon? _icon;

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

  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      iconPackModes: const [
        IconPack.fontAwesomeIcons,
        IconPack.allMaterial,
        IconPack.lineAwesomeIcons
      ],
      noResultsText: 'No results found',
      searchHintText: 'Search Icon for ${widget.expenseType.name}',
    );
    if (icon == null) return;
    _icon = Icon(icon!.data);
    setState(() {});

    debugPrint('Picked Icon:  ${icon.data}');
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
          Text(
            'Add ${widget.expenseType.name.replaceFirst(widget.expenseType.name[0], widget.expenseType.name[0].toUpperCase())} Expense',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextField(
            autocorrect: true,
            controller: titleController,
            maxLength: 50,
            scrollPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration:
                const InputDecoration(labelText: 'Title', hintText: 'Title'),
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
          Row(
            children: [
              ElevatedButton(
                  onPressed: _pickIcon, child: const Text('Open IconPicker')),
              const SizedBox(width: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _icon ?? Container(),
              )
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
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
        ],
      ),
    ));
  }
}
